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
  widget = wibox.widget.textbox
}

local artist = wibox.widget{
  text = "---------",
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox
}

local play_button = wibox.widget{
  image = beautiful.play_icon,
  align = "center",
  valign = "center",
  resize = true,
  forced_width = 40,
  forced_height = 40,
  widget = wibox.widget.imagebox
}

local next_button = wibox.widget{
  image = beautiful.next_icon,
  align = "center",
  valign = "center",
  resize = true,
  forced_width = 50,
  forced_height = 50,
  widget = wibox.widget.imagebox
}

local previous_button = wibox.widget{
  image = beautiful.previous_icon,
  align = "center",
  valign = "center",
  resize = true,
  forced_width = 50,
  forced_height = 50,
  widget = wibox.widget.imagebox
}

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
    title,
    artist,
    pad(1),
    music_buttons,
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




