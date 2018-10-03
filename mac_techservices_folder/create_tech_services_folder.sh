#!/bin/bash

jha_app_dir="$HOME/Desktop/Tech Services"
supportFilesPath="//username:password@mmoabmgt01/PackageSource"
supportMountPoint="$HOME/tmpmnt"
#app_list_file="./applist.txt"
app_list_file="$supportMountPoint/techservices_utils/Aliases.txt"

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
  cp -f $mountPoint/techservices_utils/md5sum.txt $jha_app_dir/md5sum.txt
  chflags hidden $jha_app_dir/md5sum.txt
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
mount_smbfs_share $supportFilesPath $supportMountPoint
if [ ! -d "$jha_app_dir" ]; then
  mkdir "$jha_app_dir"
  $mountPoint/techservices_utils/SetFileIcon -image $mountPoint/techservices_utils/Tech_Services.jpg -file "$jha_app_dir"
  process_app_list
else
  if [ -f "$jha_app_dir/md5sum.txt" ]; then
    read localCheckSum < $jha_app_dir/md5sum.txt
    remoteCheckSum=$(md5 -q $mountPoint/techservices_utils/applist.txt)
    if [ localCheckSum != remoteCheckSum ]; then
      process_app_list
    fi
  fi
fi
umount_filesystem $supportMountPoint
#chmod -w "$jha_app_dir"