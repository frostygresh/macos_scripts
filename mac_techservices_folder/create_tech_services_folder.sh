#!/bin/bash

jha_app_dir="$HOME/Desktop/Tech Services"
supportFilesPath="//svc-lanrev-CIFS-R@mmocoabmgt01/PackageSource"
supportMountPoint="$HOME/tmpmnt"
#app_list_file="./applist.txt"
app_list_file="$supportMountPoint/techservices_utils/applist.txt"
declare -a current_directory
declare -a incoming_alias

# Function create_alias
#
# create an alias for the file passed as argument 1 to the location
# passed as argument 2
create_alias () {
  # Extract the filename without extension
  file_alias=$(basename -- "$1")
  file_alias="${file_alias%.*}"
  # Check to see if alias file exists already and if not, create it.
  if [ ! -f "$jha_app_dir/$file_alias" ]; then
    echo "Creating alias for $1 at $2"
    osascript <<END_SCRIPT
      tell application "Finder"
        make new alias to file (posix file "$1") at posix file "$2"
      end tell
END_SCRIPT
  fi
}

remove_old_aliases () {
  for old_item in "${current_directory[@]}"
  do
    echo "Testing $old_item against ${incoming_alias[@]}"
    if [[ "${incoming_alias[@]}" =~ "$old_item"  ]]; then
      echo "$old_item still there"
    else
      echo "$old_item not there"
      rm "$jha_app_dir/$old_item"
    fi
  done    
}

# Function process_app_list
process_app_list () {
  awk '{ sub("\r$", ""); print }' $app_list_file > /tmp/applist.txt
  while read app_item ; do
    echo "Item is $app_item"
    create_alias "$app_item" "$jha_app_dir"
    alias_name=$(basename "$app_item")
    alias_name=${alias_name%.*}
    incoming_alias+=("$alias_name")
  done < /tmp/applist.txt
  md5 -q $supportMountPoint/techservices_utils/applist.txt > "$jha_app_dir/md5sum.txt"
  chflags hidden "$jha_app_dir/md5sum.txt"
}

# Function to mount smb file system
mount_smbfs_share () {
  if [ ! -d $2 ]; then
    mkdir $2
  fi
  mount_smbfs $1 $2 << PWDEOF
S?4H*P5v5v=f
PWDEOF
}

# unmount the file system at the mount point provided.
umount_filesystem () {
  umount $1
  rmdir $1
}

# Function to inventory the current content of the Tech Services folder
inventory_folder () {
  for my_file in "$1"/*; do
    my_file=$(basename "$my_file")
    my_file=${my_file%.*}
    if [ "$my_file" != "Icon"$'\r' ] && [ "$my_file" != "md5sum" ]; then
      current_directory+=("$my_file")
    fi
  done
}

# Main script
mount_smbfs_share $supportFilesPath $supportMountPoint
if [ ! -d "$jha_app_dir" ]; then
  mkdir "$jha_app_dir"
  $supportMountPoint/techservices_utils/SetFileIcon -image $supportMountPoint/techservices_utils/Tech_Services.jpg -file "$jha_app_dir"
  process_app_list
else
  if [ -f "$jha_app_dir/md5sum.txt" ]; then
    read localCheckSum < "$jha_app_dir/md5sum.txt"
    remoteCheckSum=$(md5 -q $supportMountPoint/techservices_utils/applist.txt)
    if [ $localCheckSum != $remoteCheckSum ]; then
      inventory_folder "$jha_app_dir"
      process_app_list
      remove_old_aliases
    else
      echo "No changes."
    fi
  fi
fi
umount_filesystem $supportMountPoint
#chmod -w "$jha_app_dir"
