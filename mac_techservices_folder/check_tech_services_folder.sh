#!/bin/bash

jha_app_dir="$HOME/Desktop/Tech Services"
supportFilesPath="//mmocoabmgt01/PackageSource"
supportMountPoint="$HOME/tmpmnt"
app_list_file="$supportMountPoint/techservices_utils/applist.txt"

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
  echo "SyncNeeded"
else
  if [ -f "$jha_app_dir/md5sum.txt" ]; then
    read localCheckSum < "$jha_app_dir/md5sum.txt"
    remoteCheckSum=$(md5 -q $app_list_file)
    if [ $localCheckSum != $remoteCheckSum ]; then
      echo "SyncNeeded"
    else
      echo "InSync"
    fi
  fi
fi
umount_filesystem $supportMountPoint
