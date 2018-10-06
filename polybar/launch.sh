#!/usr/bin/env sh

# Terminate allerady running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
polybar laptop_screen_bar &
polybar extra_screen_bar &
polybar workspaces_laptop_screen &
polybar workspaces_extra_screen &
