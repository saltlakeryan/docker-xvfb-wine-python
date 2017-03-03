#!/bin/bash

rm -f /tmp/.X0-lock
rm -rf /tmp/.wine-1000
/usr/local/bin/run
sleep 2
exec "$@"
