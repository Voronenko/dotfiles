#!/bin/sh

SIZE=${1:-1920}
INNERDISPLAY=${2:-2}

if [ "$SIZE" = "1920" ]
then
xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --addmode VIRTUAL1 1920x1080_60.00
fi


if [ "$SIZE" = "1368" ]
then
xrandr --newmode "1368x768_60.00"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
xrandr --addmode VIRTUAL1 "1368x768_60.00"
fi

if [ "$SIZE" = "1024" ]
then
xrandr --newmode "1024x768_60.00"   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync
xrandr --addmode VIRTUAL1 "1024x768_60.00"
fi

x11vnc -display :0 -clip xinerama${INNERDISPLAY} -xauth /var/lib/gdb/:0.Xauth -xrandr -forever -nonc -noxdamage -repeat



