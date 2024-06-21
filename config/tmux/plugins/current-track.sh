#!/usr/bin/env bash

CURRENT_TRACK=$(osascript <<EOF

global songName
global artistName

set songName to ""
set artistName to ""

if appIsRunning("Music") then
	tell application "Music"
		if player state is playing then
			set songName to the name of the current track
			set artistName to the artist of the current track
      return songName & " - " & artistName
		end if
	end tell
end if

if appIsRunning("Spotify") then
	tell application "Spotify"
		if player state is playing then
			set songName to the name of the current track
			set artistName to the artist of the current track
      return songName & " - " & artistName
		end if
	end tell
end if

on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning

EOF
)


if [[ $(uname -s) != Darwin ]]
then
    CURRENT_TRACK=$(playerctl metadata --player spotify,vlc --format '{{artist}} - {{title}}')
fi

if test "x$CURRENT_TRACK" != "x"; then
  echo $CURRENT_TRACK | cut -b1-45
fi
