#!/bin/bash

sleep 2 && \
(openbox &) && \
sleep 2 && \
(wine cmd /c echo foo &) && \
sleep 12 && \
echo pressing enter && \
xdotool key KP_Enter && \
sleep 12 && \
echo pressing enter for gecko && \
xdotool key KP_Enter && \
sleep 12
