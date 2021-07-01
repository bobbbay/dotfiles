local awful = require("awful")
local bling = require("modules.bling")

awful.screen.connect_for_each_screen(function(s)  -- that way the wallpaper is applied to every screen
    bling.module.tiled_wallpaper("λ", s, {        -- call the actual function ("λ" is the string that will be tiled)
        fg = "#ECEFF4",  -- define the foreground color
        bg = "#4C566A",  -- define the background color
        offset_y = 25,   -- set a y offset
        offset_x = 25,   -- set a x offset
        font = "PragmataPro Mono Liga",   -- set the font (without the size)
        font_size = 14,  -- set the font size
        padding = 100,   -- set padding (default is 100)
        zickzack = true  -- rectangular pattern or criss cross
    })
end)
