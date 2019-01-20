0. Prepare dimensions for all remote devices you gonna to use as a remote display



# cvt 1920 1080
# 1920x1080 59.96 Hz (CVT 2.07M9) hsync: 67.16 kHz; pclk: 173.00 MHz
Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync

# cvt 1368 768
# 1368x768 59.88 Hz (CVT) hsync: 47.79 kHz; pclk: 85.25 MHz
Modeline "1368x768_60.00"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync

# 1024x768 59.92 Hz (CVT 0.79M3) hsync: 47.82 kHz; pclk: 63.50 MHz
Modeline "1024x768_60.00"   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync


1. Initialize remote display in /etc/X11/xorg.conf.d/20-intel.conf once

Watch out for drivers to match your notebook

```

Section "Device"
        Identifier      "Configured Video Device"
    Driver "intel"         #CHANGE THIS
    Option "TearLess"   "1"
EndSection

Section "Monitor"
        Identifier      "Configured Monitor"
EndSection

Section "Screen"
        Identifier      "Default Screen"
        Monitor         "Configured Monitor"
        Device          "Configured Video Device"
EndSection


```

2. When needed initialize VIRTUALDISPLAY1

using remote display suggested resolution


```
xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --addmode VIRTUAL1 1920x1080_60.00

xrandr --newmode "1368x768_60.00"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
xrandr --addmode VIRTUAL1 "1368x768_60.00"

xrandr --newmode "1024x768_60.00"   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync
xrandr --addmode VIRTUAL1 "1024x768_60.00"
```


3.Initiate x11vnc remote display vor f0rtual display 2 (xineraa2)

x11vnc -display :0 -clip xinerama2 -xauth /var/lib/gdb/:0.Xauth -xrandr -forever -nonc -noxdamage -repeat


4. Use vncviewer on remote computer to initialize " remote display "
