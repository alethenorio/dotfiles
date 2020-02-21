#!/bin/bash

if [ $# -ne 3 ]
then
	echo "Usage: script sleepTime script1 script2"
	exit 1
fi

MOUSEPOS="$(xdotool getmouselocation)"

$2
sleep $1
# After a certain delay, if mouse position has changed return 1 otherwise 0

NEWMOUSEPOS="$(xdotool getmouselocation)"
if [[ "$MOUSEPOS" != "$NEWMOUSEPOS" ]]; then
	exit 0
fi

$3
