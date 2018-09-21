#!/bin/bash

jha_app_dir="$HOME/Desktop/Standard Apps"
#app_list_file="./applist.txt"
app_list_file="smb://mmocoabmgt01.jhacorp.com/PackageSource/TechServe/Aliases.txt"

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

# main script
if [ ! -d "$jha_app_dir" ]; then
  mkdir "$jha_app_dir"
fi

process_app_list

#chmod -w "$jha_app_dir"