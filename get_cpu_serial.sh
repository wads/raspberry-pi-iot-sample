#! /bin/bash

cat /proc/cpuinfo | grep Serial | sed -r 's/Serial\s+:\s*([0-9a-zA-Z]+)/\1/'
