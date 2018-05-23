#!/bin/bash

# Take a screenshot, blur it and lock screen with it
i3lock -i <(import -silent -window root png:- | mogrify -blur 0x8 png:-)

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off