--INITIALIZE STUFF --


-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- import hotkeys:
local keys = require("keys")
-- import helpers
local helpers = require("helpers")

-- define theme:
beautiful.init("~/.config/awesome/themes/Oceanic_next/theme.lua")

-- -- -- WIDGETS -- -- --

-- Create padding
pad = wibox.widget.textbox(" ")

-- Create a launcher widget and a main menu
myawesomemenu = awful.menu{items={
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}}

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu=myawesomemenu})

-- Create Start Menu
start_menu_widget = wibox.widget.imagebox(beautiful.arch_icon)
start_menu_widget:buttons(gears.table.join(
            -- Left click
            awful.button({ }, 1, function()
                sidebar.screen = awful.screen.focused(mouse)
                sidebar.visible = not sidebar.visible 
            end)
))

-- Create Rofi-widget (app launcher)
rofi_widget = wibox.widget.imagebox(beautiful.search_icon)
rofi_widget:buttons(gears.table.join(
            --Left click
            awful.button({ }, 1, function()
                awful.spawn.with_shell("rofi -show drun -show-icons ")
            end)
))

-- TASKLIST WIDGETS:

local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              c:emit_signal(
                                                  "request::activate",
                                                  "tasklist",
                                                  {raise = true})
                                          end))


-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.selected, -- show only current tag
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.minimizedcurrenttags,
        buttons = tasklist_buttons
    }

 -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            pad, start_menu_widget,
            pad, rofi_widget,
            pad, mylauncher,
            pad, s.mytaglist
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
        },
    }
end)

























