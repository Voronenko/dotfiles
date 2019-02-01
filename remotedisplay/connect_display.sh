#!/bin/sh

BOX=${1:-thinkpad}

ssvnc -viewonly -fullscreen vnc://${BOX}:5900
