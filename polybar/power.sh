#!/bin/sh

POWER="\tLog Out\n\tPower Off\n\tReboot\n\tSleep"
ROFI=`echo -e $POWER | rofi -dmenu -lines 5 -columns 1 -p Power -width 25 -hide-scrollbar | awk '{print $1}'`

if [ ${#ROFI} -gt 0 ]
then
    case $ROFI in
    Log)
        MESG="Quitting BSPWM..."
        CMD="bspc quit"
        ;;
    Power)
        MESG="Powering off..."
        CMD="poweroff"
        ;;
    Reboot)
        MESG="Rebooting..."
        CMD="reboot"
        ;;
    Sleep)
        MESG="Entering sleep mode..."
        CMD="systemctl suspend"
        ;;
    esac
fi

$CMD
