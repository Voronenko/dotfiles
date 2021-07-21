#!/bin/bash
head -n 1 /sys/class/thermal/thermal_zone0/temp | xargs -I{} awk "BEGIN {printf \"%.2f\n\", {}/1000}"
