#!/bin/bash

# Take a screenshot, blur it and lock screen with it
import -silent -window root png:- | mogrify -blur 0x10 png:- > /tmp/lock.png && i3lock -i /tmp/lock.png
