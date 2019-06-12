local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad


-------------------------------------------------------------------
                    -- CREATE WIDGETS --
-------------------------------------------------------------------


-------------------------------------------------------------------
-- Clock

local time = wibox.widget.textclock("%H:%M")
time.align = "center"
time.valign = "center"
time.font = "pango:noto 60"

local date = wibox.widget.textclock("%B %d")
-- local date = wibox.widget.textclock("%A, %B %d")
-- local date = wibox.widget.textclock("%A, %B %d, %Y")
date.align = "center"
date.valign = "center"
date.font = "pango:noto 15"

-------------------------------------------------------------------
-- Spotify widget

local title = wibox.widget{
    text = "---------",
    align = "center",
    valign = "center",
    font = "pango:noto 17",
    forced_height = 30,
    widget = wibox.widget.textbox
}

local artist = wibox.widget{
    text = "---------",
    align = "center",
    valign = "center",
    font = "pango:noto 13",
    forced_height = 50,
    widget = wibox.widget.textbox
}

local song = wibox.widget {
  title,
  artist,
  layout = wibox.layout.align.vertical
}

song:buttons(gears.table.join(
                        awful.button({ }, 1, function ()
                            awful.spawn.raise_or_spawn("spotify", {class = "Spotify"})
                        end)
))

local play_button = wibox.widget{
    image = beautiful.play_icon,
    align = "center",
    valign = "center",
    resize = true,
    forced_width = beautiful.play_icon_size,
    forced_height = beautiful.play_icon_size,
    widget = wibox.widget.imagebox
}

play_button:buttons(gears.table.join(
                        --Left click - Play/Pause
                        awful.button({ }, 1, function ()
                            awful.spawn.with_shell("playerctl play-pause")
                        end)
))


local next_button = wibox.widget{
  image = beautiful.next_icon,
  align = "center",
  valign = "center",
  resize = true,
  forced_width = beautiful.next_icon_size,
  forced_height = beautiful.next_icon_size,
  widget = wibox.widget.imagebox
}

next_button:buttons(gears.table.join(
                        --Left click - Next song
                        awful.button({ }, 1, function ()
                            awful.spawn.with_shell("playerctl next")
                        end)
))


local previous_button = wibox.widget{
  image = beautiful.previous_icon,
  align = "center",
  valign = "center",
  resize = true,
  forced_width = beautiful.previous_icon_size,
  forced_height = beautiful.previous_icon_size,
  widget = wibox.widget.imagebox
}

previous_button:buttons(gears.table.join(
                        --Left click - Previous song
                        awful.button({ }, 1, function ()
                            awful.spawn.with_shell("playerctl previous")
                        end)
))


local music_buttons = wibox.widget {
  nil,
  {
    previous_button,
    pad(2),
    play_button,
    pad(2),
    next_button,
    layout  = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal

}

-- update all widget info when song or status changes

local function update_title()
    awful.spawn.easy_async("playerctl metadata --format {{title}}", function(stdout)
        title.text = stdout
    end)
end

local function update_artist()
    awful.spawn.easy_async("playerctl metadata --format {{artist}}", function(stdout)
        artist.text = stdout
    end)
end

local function update_play_status()
    awful.spawn.easy_async("playerctl metadata --format {{status}}", function(stdout)
        if stdout == "Playing\n" then 
                play_button.image = beautiful.pause_icon
                play_button.forced_width = beautiful.pause_icon_size
                play_button.forced_height = beautiful.pause_icon_size
        elseif stdout == "Paused\n" then 
                play_button.image = beautiful.play_icon
                play_button.forced_width = beautiful.play_icon_size
                play_button.forced_height = beautiful.play_icon_size
        else -- if music player is not open
                play_button.image = beautiful.play_icon
                play_button.forced_width = beautiful.play_icon_size
                play_button.forced_height = beautiful.play_icon_size
                title.text = "---------"
                artist.text = "---------"
        end
    end)
end

awful.spawn.with_line_callback("playerctl metadata --format \"{{ status }} {{ title }}\" --follow",
                                    {
                                        stdout = function(line)
                                            update_title()
                                            update_artist()
                                            update_play_status()
                                        end
                                    })


-------------------------------------------------------------------
-- Volume widget

local volume_bar_slider = wibox.widget{
    maximum = 100,
    minimum = 0,
    value = 50,
    forced_height = 20,
    forced_width = 200,
    bar_shape = gears.shape.rounded_bar,
    opacity = 0,
    handle_border_width = 0,
    widget = wibox.widget.slider
}

local volume_bar_progressbar = wibox.widget{
    maximum = 100,
    minimum = 0,
    forced_height = 20,
    forced_width = 200,
    bar_shape = gears.shape.rounded_bar,
    color = beautiful.volume_bar_fg_color,
    background_color = beautiful.volume_bar_bg_color,
    value = 75,
    widget = wibox.widget.progressbar
}

local volume_bar = wibox.widget{
    volume_bar_slider,
    volume_bar_progressbar,
    layout = wibox.layout.stack
}

-- TODO
-- add icon
-- change value (remember cleanup)
-- sync progressbar and slider

local volume = wibox.widget{
  nil,
  {
    -- add icon here
    pad(1),
    volume_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}


-- USE: pactl list sinks | grep "sink" to check if headset is connected?

-------------------------------------------------------------------
                  -- Create the sidebar --
-------------------------------------------------------------------

sidebar = wibox({y = 0, x = 0, visible = false, ontop = true, type = "dock"})
sidebar.bg = beautiful.sidebar_bg or beautiful.wibar_bg or "#111111"
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg or "#FFFFFF"
sidebar.opacity = beautiful.sidebar_opacity or 1
sidebar.height = beautiful.sidebar_height or awful.screen.focused().geometry.height
sidebar.width = beautiful.sidebar_width or dpi(300)
local radius = beautiful.sidebar_border_radius or 0
sidebar.shape = helpers.rrect(radius)

sidebar.y = beautiful.sidebar_y
sidebar.x = beautiful.sidebar_x


-- Hide sidebar when mouse leaves
if beautiful.sidebar_hide_on_mouse_leave then
  sidebar:connect_signal("mouse::leave", function ()
                             sidebar.visible = false
                               end)
                               end



-------------------------------------------------------------------
-- Item placement

sidebar:setup {
  { ----------- TOP GROUP -----------
    pad(1),
    pad(1),
    time,
    date,
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  { ----------- MIDDLE GROUP -----------
    pad(1),
    pad(1),
    pad(1),
    music_buttons,
    pad(1),
    song,
    pad(1),
    pad(1),
    volume,
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  { ----------- BOTTOM GROUP -----------
    pad(1),
    layout = wibox.layout.align.vertical,
    -- expand = "none"
  },
  layout = wibox.layout.align.vertical
}

-- TODO:
-- change icon background ehn choosing menu




