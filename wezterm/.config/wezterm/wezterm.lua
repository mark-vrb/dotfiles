-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 18.0
config.color_scheme = 'Tokyo Night'

-- and finally, return the configuration to wezterm
return config
