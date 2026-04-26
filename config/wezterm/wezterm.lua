local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_decorations = "RESIZE"

-- color scheme
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

-- font
config.font = wezterm.font("HackGen35 Console NF", { style = "Normal" })
config.font_size = 14

-- window padding
config.window_padding = {
  left = 5,
  right = 5,
  top = 10,
  bottom = 10,
}

-- tab bar
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false

config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#585b70"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#cba6f7"
    foreground = "#11111b"
  end
  local edge_foreground = background
  local title = "    " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "     "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
  }
end)

-- keybindings (tab management + utilities only, pane ops moved to zellij)
local act = wezterm.action
config.keys = {
  -- new tab
  { key = 'd', mods = 'SHIFT|CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  -- word navigation
  { key = "LeftArrow", mods = "SHIFT", action = act.SendKey { key = "b", mods = "META" } },
  { key = "RightArrow", mods = "SHIFT", action = act.SendKey { key = "f", mods = "META" } },
  -- delete previous word
  { key = "Backspace", mods = "SHIFT", action = act.SendKey { key = "w", mods = "CTRL" } },
  -- font size
  { key = '+', mods = 'SHIFT|CMD', action = act.IncreaseFontSize },
  { key = '_', mods = 'SHIFT|CMD', action = act.DecreaseFontSize },
}

return config
