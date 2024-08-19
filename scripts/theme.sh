#!/bin/bash

export DARK_MODE
DARK_MODE=$(osascript -e 'tell application "System Events" 
get dark mode of appearance preferences 
end tell')

if [[ "${DARK_MODE}" == "true" ]] ; then
  kitty +kitten themes Solarized\ Dark
else
  kitty +kitten themes Solarized\ Light
fi

