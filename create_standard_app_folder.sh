#!/bin/bash
if [ ! -d "$HOME/Desktop/Standard Apps" ]; then
  mkdir "$HOME/Desktop/Standard Apps"

  osascript <<END_SCRIPT
    tell application "Finder"
      make new alias to file (posix file "/Applications/Chess.app") at posix file "$HOME/Desktop/Standard Apps"
      make new alias to file (posix file "/Applications/Google Chrome.app") at posix file "$HOME/Desktop/Standard Apps"
  end tell
END_SCRIPT
fi

