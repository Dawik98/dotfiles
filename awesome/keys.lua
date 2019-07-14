
local awful = require("awful")
local gears = require("gears")

local keys = {}


-------------------
-- KEY BINDINDGS --
-------------------

-- Default modkey.
modkey = "Mod4"

-- {{{ Mouse bindings

keys.desktopbuttons = gears.table.join(
    awful.button({ }, 1, function ()
        sidebar.visible = false end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)


keys.globalkeys = gears.table.join(

    -- Go through tags
    awful.key({ modkey, "Shift"}, "Tab",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),

    awful.key({ modkey          }, "Tab",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    -- Focus on client:
    awful.key({ modkey,           }, "Left",
        function ()
            awful.client.focus.global_bydirection("left")
        end,
        {description = "focus on window on the left", group = "client"}),

    awful.key({ modkey,           }, "Right",
        function ()
            awful.client.focus.global_bydirection("right")
        end,
        {description = "focus on window on the right", group = "client"}),

    awful.key({ modkey,           }, "Up",
        function ()
            awful.client.focus.global_bydirection("up")
        end,
        {description = "focus on window above", group = "client"}),

    awful.key({ modkey,           }, "Down",
        function ()
            awful.client.focus.global_bydirection("down")
        end,
        {description = "focus on window below", group = "client"}),

    -- Layout manipulation
    -- Swap clients with arrows:
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.bydirection("left")    end,
              {description = "swap with client on the left", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.bydirection("right")    end,
              {description = "swap with client on the right", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Up", function () awful.client.swap.bydirection("up")    end,
              {description = "swap with client above", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Down", function () awful.client.swap.bydirection("down")    end,
              {description = "swap with client below", group = "client"}),

    -- change layout:
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next layout", group = "layout"}),

    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous layout", group = "layout"}),


    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),


    -- Standard programs:
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey }, "d",
      function()
        awful.spawn.with_shell("rofi -show drun -show-icons")
      end,
      {description = "rofi launcher", group = "launcher"}),

    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    -- Media buttons
    -- Volume:
    awful.key( { }, "XF86AudioMute", function()
        awful.util.spawn("pactl set-sink-mute 0 toggle",false)
    end,
    {description = "(un)mute volume", group = "volume"}),

    awful.key( { }, "XF86AudioRaiseVolume", function()
        awful.util.spawn("pactl set-sink-volume 0 +5%",false)
    end,
    {description = "Volume up", group = "volume"}),

    awful.key( { }, "XF86AudioLowerVolume", function()
        awful.util.spawn("pactl set-sink-volume 0 -5%",false)
    end,
    {description = "Volume down", group = "volume"}),

    -- Audio player
    awful.key( { }, "XF86AudioPlay", function()
        awful.util.spawn("playerctl play-pause",false)
    end,
    {description = "Play audio", group = "volume"}),

    awful.key( { }, "XF86AudioNext", function()
        awful.util.spawn("playerctl next",false)
    end,
    {description = "Next song", group = "volume"}),

    awful.key( { }, "XF86AudioPrev", function()
        awful.util.spawn("playerctl previous",false)
    end,
    {description = "Previous song", group = "volume"}),

    -- Brightness:
    awful.key( { }, "XF86MonBrightnessUp", function()
        awful.spawn.easy_async_with_shell("light -A 5", function()
            awesome.emit_signal("brightness_changed")
        end)
    end,
    {description = "Brightness up", group = "Other"}),

    awful.key( { }, "XF86MonBrightnessDown", function()
        awful.spawn.easy_async_with_shell("light -U 5", function()
            awesome.emit_signal("brightness_changed")
        end)
    end,
    {description = "Brightness Down", group = "Other"}),


    -- Screenshot
    awful.key( { }, "Print", function()
        awful.util.spawn("deepin-screenshot",false)
    end,
    {description = "Screenshot", group = "Other"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end


keys.clientkeys = gears.table.join(
    awful.key({ modkey, "Shift"}, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey,           }, "m",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    awful.key({ modkey,           }, "f",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),

--    awful.key({ modkey, "Control" }, "m",
--        function (c)
--            c.maximized_vertical = not c.maximized_vertical
--            c:raise()
--        end ,
--        {description = "(un)maximize vertically", group = "client"}),
--    awful.key({ modkey, "Shift"   }, "m",
--        function (c)
--            c.maximized_horizontal = not c.maximized_horizontal
--            c:raise()
--        end ,
--        {description = "(un)maximize horizontally", group = "client"})

    -- Move client to next screen:
    awful.key({ modkey, "Shift"   }, "s", function (c) c:move_to_screen()    end,
              {description = "move to next screen", group = "client"})
)


clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        awful.mouse.client.resize(c)
    end)
)


-- Set keys
root.buttons(keys.desktopbuttons)
root.keys(keys.globalkeys)

return keys


-- TODO:
-- media buttons
-- resize client (mod4+r+direction)
-- resize with mouse
-- add new tags when needed insted of fixed num of tags
--


