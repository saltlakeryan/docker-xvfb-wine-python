#!/bin/bash

# Xvfb :0 -screen 0 1024x768x16 2> /tmp/xvfb.log  > /tmp/xvfb.log &
# x11vnc -display :0 -passwd nort 2> /tmp/x11.log  > /tmp/x11.log &

sudo rm -rf /tmp/.wine-1000
Xvfb :0 -screen 0 1024x768x16  &
x11vnc -display :0 -passwd nort  &
sleep 2
openbox &
