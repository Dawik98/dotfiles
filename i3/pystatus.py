from i3pystatus import Status

status = Status()

#COLORS:
background = "#141e23"
foreground = "#95A5A6"
red = "#E74C3C"
green = "#2ECC71"
yellow = "#F39C12"
blue = "#6BB9F0"
magenta = "#C8438C"
cyan = "#07c5ac"


# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
        format="    %a %d %b %Y    ",
        color = background,
        hints = {"background":magenta,
                 })

status.register("clock",
        format = "    %H:%M    ",
        color = background,
        hints = {"background":cyan,
                 })

status.register("battery",
        format = "    {percentage:.0f}%    ",
        color = background,
        charging_color = background,
        critical_color = background,
        hints = {"background":green,
                })

status.run()
