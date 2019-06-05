
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")


local titlebars = {}

-- Titlebar buttons:

titlebars.buttons = gears.table.join(
     awful.button({ }, 1, function()                                   
         local c = mouse.object_under_pointer()
         client.focus = c
         c:raise()
         awful.mouse.client.move(c)
     end),

     awful.button({ }, 3, function()
         local c = mouse.object_under_pointer()
         client.focus = c
         c:raise()
         awful.mouse.client.resize(c)
     end)
)

-- Disable popup tooltip on titlebar button hover
awful.titlebar.enable_tooltip = false

client.connect_signal("request::titlebars", function(c)

    local buttons = titlebars.buttons

    awful.titlebar(c) : setup {
        { -- Left
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                buttons = buttons,
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.minimizebutton(c),
            -- awful.titlebar.widget.closebutton(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


return titlebars
