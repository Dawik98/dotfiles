#!/bin/sh

POWER="\t\t WiFi\n\t\tBluetooth\n\t_\tAudio"
ROFI=`echo -e $POWER | rofi -dmenu -lines 4 -columns 1 -location 7 -yoffset -45 -p "      SETTINGS" -width 25 -hide-scrollbar | awk '{print $1}'`

if [ ${#ROFI} -gt 0 ]
then
    case $ROFI in
    )
        CMD="connman-gtk"
        ;;
    )
        CMD="blueberry"
        ;;
    _)
        CMD="pavucontrol"
        ;;
    esac
fi

$CMD

# add font settings ?
