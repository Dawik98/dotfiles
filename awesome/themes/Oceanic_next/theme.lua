
local theme_name = "Oceanic next"

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local awful = require("awful")

local icon_path = "~/.config/awesome/themes/Oceanic_next/icons/"

local theme = {}

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Set wallpaper
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/themes/Oceanic_next/wallpaper.jpg"

-- Set font
theme.font = "pango:noto 11"

-- Define colors
theme.xbg = xrdb.background 
theme.xfg = xrdb.foreground 
theme.xblack = xrdb.color0 
theme.xred = xrdb.color1 
theme.xgreen = xrdb.color2 
theme.xyellow = xrdb.color3 
theme.xblue = xrdb.color4 
theme.xmagenta = xrdb.color5 
theme.xcyan = xrdb.color6 
theme.xwhite = xrdb.color7 
theme.xblack_light = xrdb.color8 
theme.xcolor9 = xrdb.color9 
theme.xcolor10 = xrdb.color10 
theme.xorange = xrdb.color11 
theme.xcolor12 = xrdb.color12 
theme.xcolor13 = xrdb.color13 
theme.xcolor14 = xrdb.color14 
theme.xwhite_light = xrdb.color15 

-------------------------------------------------------------------
-- Gaps
theme.useless_gap   = dpi(5)
theme.screen_margin = dpi(3)

-------------------------------------------------------------------
-- Borders
theme.border_width  = dpi(0)
theme.border_color = theme.xblack
theme.border_normal = theme.xblack
theme.border_focus  = theme.xgreen

-- Rounded corners
theme.border_radius = dpi(5)

-------------------------------------------------------------------
-- Titlebars
theme.titlebars_enabled = true
theme.titlebar_size = 45
theme.titlebar_title_enabled = true
theme.titlebar_font = theme.font
-- Window title alignment: left, right, center
theme.titlebar_title_align = "center"
-- Titlebar position: top, bottom, left, right
theme.titlebar_position = "top"
--theme.titlebar_bg = theme.xbg
theme.titlebar_bg_focus = theme.xgreen
theme.titlebar_bg_normal = theme.xwhite
theme.titlebar_fg_focus = theme.xblack
theme.titlebar_fg_normal = theme.xblack
--theme.titlebar_fg = theme.xcolor7

-------------------------------------------------------------------
-- Wibar(s)
theme.wibar_position = "top"
theme.wibar_detached = false
theme.wibar_height = 26
theme.wibar_fg = theme.xfg
theme.wibar_bg = theme.xbg .. "00"
--theme.wibar_opacity = 0.7
theme.wibar_border_color = theme.xbg
theme.wibar_border_width = dpi(0)
theme.wibar_border_radius = dpi(0)
theme.wibar_border_radius = theme.border_radius
--theme.wibar_width = screen_width - theme.screen_margin * 4 -theme.wibar_border_width * 2
--theme.wibar_width = dpi(565)
--theme.wibar_x = screen_width / 2 - theme.wibar_width - theme.screen_margin * 2
--theme.wibar_x = theme.screen_margin * 2
--theme.wibar_x = screen_width - theme.wibar_width - theme.wibar_border_width * 2 - theme.screen_margin * 2
--theme.wibar_y = theme.screen_margin * 2


-------------------------------------------------------------------
-- Sidebar


theme.sidebar_bg = theme.xbg
theme.sidebar_fg = theme.xfg
theme.sidebar_y = 0--theme.wibar_height
theme.sidebar_x = 0
theme.sidebar_opacity = 1
theme.sidebar_width = 500
theme.sidebar_height = screen_height --- theme.wibar_height
theme.sidebar_border_radius = dpi(0)
theme.sidebar_hide_on_mouse_leave = true







-------------------------------------------------------------------
-- Icons - wibar
theme.awesome_icon = icon_path .. "apps.png"
theme.arch_icon = icon_path .. "arch.png"
theme.arch_active_icon = icon_path .. "arch_active.png"
theme.search_icon = icon_path .. "search.png"

theme.play_icon = icon_path .. "play.png"
theme.pause_icon = icon_path .. "pause.png"
theme.next_icon = icon_path .. "next.png"
theme.previous_icon = icon_path .. "previous.png"



















return theme


