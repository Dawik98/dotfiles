local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad


local naughty = require("naughty")
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
                            local matcher = function (c)
                               return awful.rules.match(c, {class = 'Spotify'})
                             end
                            awful.client.run_or_raise("spotify", matcher)
                            -- awful.spawn.raise_or_spawn("spotify", { }, matcher)
                            sidebar.visible = false
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
    forced_height = beautiful.progressbar_height,
    forced_width = beautiful.progressbar_width,
    bar_shape = gears.shape.rounded_bar,
    opacity = 0,
    handle_border_width = 0,
    widget = wibox.widget.slider
}

local volume_bar_progressbar = wibox.widget{
    min_value = 0,
    max_value = 100,
    value = 50,
    forced_height = beautiful.progressbar_height,
    forced_width = beautiful.progressbar_width,
    bar_shape = gears.shape.rounded_bar,
    shape = gears.shape.rounded_bar,
    color = beautiful.volume_bar_fg_color,
    background_color = beautiful.volume_bar_bg_color,
    widget = wibox.widget.progressbar
}

local volume_bar = wibox.widget{
    nil,
    {
        volume_bar_slider,
        volume_bar_progressbar,
        layout = wibox.layout.stack
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}


local volume_icon = wibox.widget{
  image = beautiful.volume_icon,
  align = "center",
  valign = "center",
  resize = true,
  forced_width = beautiful.volume_icon_size,
  forced_height = beautiful.volume_icon_size,
  widget = wibox.widget.imagebox
}


volume_icon:buttons(gears.table.join(
                        awful.button({ }, 1, function ()
                            local matcher = function (c)
                               return awful.rules.match(c, {class = 'Pavucontrol'})
                             end
                            awful.client.run_or_raise("pavucontrol", matcher)
                            sidebar.visible = false
                        end)
                    ))

-- Split string on new line \n
local function parse(s)
    local t = {};
    for chunk in string.gmatch(s, "[^\n]+") do
        t[#t+1] = chunk;
    end;
    return t;
end;



chosen_sink = 1 -- the last sink is choosen as default

-- update volume, slider and progressbar when slider value changes
local function update_volume_slider()
    local value = volume_bar_slider.value
    -- naughty.notify {text = tostring(value)}
    volume_bar_progressbar.value = value

    -- Uses a lot of cpu after a while :
    awful.spawn("pactl set-sink-volume 0 " .. tostring(value) .. "%")
end

volume_bar_slider:connect_signal("widget::redraw_needed", update_volume_slider)

-- update progressbar based on volume, mute ...
local function update_volume_bar_progressbar()
    -- naughty.notify {text = "updateting bar"}
    volume_bar_progressbar.value = tonumber(all_sinks[chosen_sink].volume)
    if all_sinks[chosen_sink].mute == "yes" then
        volume_bar_progressbar.color = beautiful.volume_bar_muted_color
        volume_bar_progressbar.background_color = beautiful.volume_bar_muted_color
    else
        volume_bar_progressbar.color = beautiful.volume_bar_fg_color
        volume_bar_progressbar.background_color = beautiful.volume_bar_bg_color
    end
end

-- Get sinks info
local function update_volume()
    all_sinks = {}
    awful.spawn.easy_async({"bash", "-c", "pactl list sinks"}, function(stdout) -- list all sinks info
        i = 1
        while stdout:len() > 30 do

            local sink = string.match(stdout, "Sink.-pcm")
            stdout = string.gsub(stdout, "Sink.-pcm", "", 1)

            all_sinks[i] = {name = sink:match("Sink.-\n"):gsub("\n", "")}
            all_sinks[i].mute = sink:match("Mute: (%a*)")
            all_sinks[i].state = sink:match("State: (%a*)")
            all_sinks[i].volume = sink:match("Volume.-\n"):match("(%d-)%%")
            all_sinks[i].device = sink:match("icon_name.-\n"):match('"(.*)"')

            i = i + 1
        end
        update_volume_bar_progressbar()
    end)

end

update_volume()

-- wait until it has been added/removed sinks
local change_in_module_scrip = [[
                              bash -c '
                              pactl subscribe | grep --line-buffered "module"
                              ']]

awful.spawn.with_line_callback(change_in_module_scrip,
                                    {
                                        stdout = function(line)
                                            update_volume()
                                        end
                                    })

-- wait until pactl detects an event 
local change_in_sink_scrip = [[
                              bash -c '
                              pactl subscribe | grep --line-buffered "sink #0"
                              ']]

awful.spawn.with_line_callback(change_in_sink_scrip,
                                    {
                                        stdout = function(line)
                                            update_volume()
                                        end
                                    })




-- TODO
-- menu dropdown to choose sink
-- make chosen sink glodal so it kan be used in keys.lua
-- 
-- other muet color?
-- sync progressbar and slider - DOME but have a bit lag 


local volume = wibox.widget{
  nil,
  {
    volume_icon,
    pad(1),
    pad(1),
    volume_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}


-------------------------------------------------------------------
-- Brightness widget

local brightness_bar_slider = wibox.widget{
    maximum = 100,
    minimum = 4,
    value = 50,
    forced_height = beautiful.progressbar_height,
    forced_width = beautiful.progressbar_width,
    bar_shape = gears.shape.rounded_bar,
    opacity = 0,
    handle_border_width = 0,
    widget = wibox.widget.slider
}

local brightness_bar_progressbar = wibox.widget{
    min_value = 4,
    max_value = 100,
    value = 50,
    forced_height = beautiful.progressbar_height,
    forced_width = beautiful.progressbar_width,
    bar_shape = gears.shape.rounded_bar,
    shape = gears.shape.rounded_bar,
    color = beautiful.brightness_bar_fg_color,
    background_color = beautiful.brightness_bar_bg_color,
    widget = wibox.widget.progressbar
}

local brightness_bar = wibox.widget{
    nil,
    {
        brightness_bar_slider,
        brightness_bar_progressbar,
        layout = wibox.layout.stack
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

local brightness_icon = wibox.widget{
  image = beautiful.brightness_icon,
  align = "center",
  valign = "center",
  resize = true,
  forced_width = beautiful.brightness_icon_size,
  forced_height = beautiful.brightness_icon_size,
  widget = wibox.widget.imagebox
}

-- get brightness and update value
local function update_brightness_bar_progressbar()
    awful.spawn.easy_async_with_shell("light -G", function(out)
        brightness_bar_progressbar.value = tonumber(out)
    end)

end

-- set brightness to chosen value and update progressbar
local function update_brightness_slider()
    local value = brightness_bar_slider.value
    -- naughty.notify {text = tostring(value)}
    brightness_bar_progressbar.value = value
    awful.spawn("light -S " .. tostring(value))
end

update_brightness_bar_progressbar()

awesome.connect_signal("brightness_changed", function ()
    update_brightness_bar_progressbar()
end)

brightness_bar_slider:connect_signal("widget::redraw_needed", update_brightness_slider)

local brightness = wibox.widget{
  nil,
  {
    brightness_icon,
    pad(1),
    pad(1),
    brightness_bar,
    pad(1),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}


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
    brightness,
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




