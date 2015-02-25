#!/bin/sh
#
# ~/.xinitrc

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then

    xmodmap $sysmodmap

fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then

    xmodmap "$usermodmap"

fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do

    [ -x "$f" ] && . "$f"

  done
  unset f

fi

xset +fp /usr/share/fonts/local
xset fp rehash

~/startscripts/dwm-statusbar.bash &
# ~/startscripts/startdwm
# ~/fehscrip
xrdb -merge ~/.Xresources
xrandr --output LVDS --off
xrandr --output VGA-0 --auto
xrandr --setprovideroutputsource 1 0
xrandr --output HDMI-1-0 --auto
xrandr --output HDMI-1-0 --left-of VGA-0

exec dwm
