#!/bin/bash

app_list_share="//mmocoabmgt01.jhacorp.com/PackageSource"
app_list_mountpoint="$HOME/Techserve"
app_list_file="$app_list_mountpoint/TechServe/Aliases.txt"

# Function process_app_list
process_app_list () {
  mkdir $app_list_mountpoint
  mount -t smbfs $app_list_share $app_list_mountpoint
  while read app_item ; do
    echo $app_item
  done < $app_list_file
  umount $app_list_mountpoint
  rmdir $app_list_mountpoint
}

# main script

process_app_list