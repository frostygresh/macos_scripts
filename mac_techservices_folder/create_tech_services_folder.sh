#!/bin/bash

jha_app_dir="$HOME/Desktop/Tech Services"
supportFilesPath="//mmocoabmgt01/PackageSource"
supportMountPoint="$HOME/tmpmnt"
#app_list_file="./applist.txt"
app_list_file="$supportMountPoint/techservices_utils/applist.txt"

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

# Function process_app_list
process_app_list () {
  awk '{ sub("\r$", ""); print }' $app_list_file > /tmp/applist.txt
  while read app_item ; do
    echo "Item is $app_item"
    create_alias "$app_item" "$jha_app_dir"
  done < /tmp/applist.txt
  md5 -q $supportMountPoint/techservices_utils/applist.txt > "$jha_app_dir/md5sum.txt"
  chflags hidden "$jha_app_dir/md5sum.txt"
}

# Function to mount smb file system
mount_smbfs_share () {
  if [ ! -d $2 ]; then
    mkdir $2
  fi
  mount_smbfs $1 $2
}

# unmount the file system at the mount point provided.
umount_filesystem () {
  umount $1
  rmdir $1
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
      process_app_list
    else
      echo "No changes."
    fi
  fi
fi
umount_filesystem $supportMountPoint
#chmod -w "$jha_app_dir"
