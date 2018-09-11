#!/bin/bash

jha_app_dir="$HOME/Desktop/Standard Apps"

# Function create_alias
#
# create an alias for the file passed as argument 1 to the location
# passed as argument 2

create_alias () {
  file_alias=$(basename -- "$1")
  file_alias="${file_alias%.*}"
  echo $file_alias
  ls -la "$jha_app_dir/$file_alias"
  if [ ! -f "$jha_app_dir/$file_alias" ]; then
    echo "Creating alias for $1 at $2"
    osascript <<END_SCRIPT
      tell application "Finder"
        make new alias to file (posix file "$1") at posix file "$2"
      end tell
END_SCRIPT
  fi
}

if [ ! -d "$jha_app_dir" ]; then
  mkdir "$jha_app_dir"
fi

create_alias "/Applications/Chess.app" "$jha_app_dir"
create_alias "/Applications/Google Chrome.app" "$jha_app_dir"

  #chmod -w "$jha_app_dir"