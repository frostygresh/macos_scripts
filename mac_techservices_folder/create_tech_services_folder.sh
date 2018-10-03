#!/bin/bash

jha_app_dir="$HOME/Desktop/Tech Services"
app_list_file="./applist.txt"
#app_list_file="smb://mmocoabmgt01.jhacorp.com/PackageSource/TechServe/Aliases.txt"
supportFilesPath="//username:password@mmoabmgt01/PackageSource"
supportMountPoint="$HOME/tmpmnt"

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
  while read app_item ; do
    create_alias "$app_item" "$jha_app_dir"
  done < $app_list_file
}
# Function to mount smb file system
mount_smbfs_share ($path, $mountPoint) {
  if [ -d $mountPoint ]; then
    mkdir $mountPoint
  fi
  mount_smbfs $path $mountPoint
}

# unmount the file system at the mount point provided.
umount_filesystem ($mountPoint) {
  umount $mountPoint
  rmdir $mountPoint
}

# Main script
if [ ! -d "$jha_app_dir" ]; then
  mount_smbfs_share $supportFilesPath $supportMountPoint
  mkdir "$jha_app_dir"
  $mountPoint/techservices_utils/SetFileIcon -image $mountPoint/techservices_utils/Tech_Services.jpg -file "$jha_app_dir"
  umount_filesystem $supportMountPoint
fi

process_app_list

#chmod -w "$jha_app_dir"