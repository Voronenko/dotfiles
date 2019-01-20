#!/bin/sh

BOX=${1:-thinkpad}

vnc://${BOX}:5900 -viewonly -fullscreen
