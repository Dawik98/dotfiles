#! /bin/bash

direction=$1

current_monitor=$(bspc query -M -n)
monitor_to_swap=$(bspc query -M -n $direction)

#echo $direction
#echo $current_monitor
#echo $monitor_to_swap

if [[ "$current_monitor" -eq "$monitor_to_swap" ]]
then
    bspc node -s $direction --follow
#    echo "equal"
elif [[ "$current_monitor" -ne "$monitor_to_swap" ]]
then
    bspc node -m $monitor_to_swap --follow
#    echo "not equal"
fi
