pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
              require("awful.autofocus")

local beautiful = require("beautiful")

require("errors")

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/theme.lua")

require("settings")
