#!/bin/bash

jha_app_dir="$HOME/Desktop/Standard Apps"
#app_list_file="./applist.txt"
app_list_file="smb://mmocoabmgt01.jhacorp.com/PackageSource/TechServe/Aliases.txt"

# Function process_app_list
process_app_list () {
  while read app_item ; do
    echo $app_item
  #  create_alias "$app_item" "$jha_app_dir"
  done < $app_list_file
}

# main script

process_app_list