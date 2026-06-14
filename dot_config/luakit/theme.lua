local theme = {}

theme.font = "11px JetBrainsMono Nerd Font, monospace"
theme.fg   = "#23313a"
theme.bg   = "#f5f0e8"

theme.success_fg = "#5a8f66"
theme.loaded_fg  = "#3d7590"
theme.error_fg   = "#fcfaf6"
theme.error_bg   = "#c96244"

theme.warning_fg = "#c96244"
theme.warning_bg = "#f5f0e8"

theme.notif_fg = "#23313a"
theme.notif_bg = "#f5f0e8"

-- Menu (completion, bookmarks, history lists)
theme.menu_fg                 = "#23313a"
theme.menu_bg                 = "#fcfaf6"
theme.menu_selected_fg        = "#7d3c31"
theme.menu_selected_bg        = "#f4e3db"
theme.menu_title_bg           = "#f5f0e8"
theme.menu_primary_title_fg   = "#c96244"
theme.menu_secondary_title_fg = "#7c8e9a"
theme.menu_disabled_fg        = "#a8bac4"
theme.menu_disabled_bg        = "#fcfaf6"
theme.menu_enabled_fg         = "#23313a"
theme.menu_enabled_bg         = "#fcfaf6"
theme.menu_active_fg          = "#5a8f66"
theme.menu_active_bg          = "#fcfaf6"

theme.proxy_active_menu_fg    = "#23313a"
theme.proxy_active_menu_bg    = "#fcfaf6"
theme.proxy_inactive_menu_fg  = "#7c8e9a"
theme.proxy_inactive_menu_bg  = "#fcfaf6"

-- Status bar (bottom)
theme.sbar_fg       = "#fcfaf6"
theme.sbar_bg       = "#23313a"

-- Download bar
theme.dbar_fg       = "#fcfaf6"
theme.dbar_bg       = "#23313a"
theme.dbar_error_fg = "#c96244"

-- Input bar (`:` command line)
theme.ibar_fg = "#23313a"
theme.ibar_bg = "#f5f0e8"

-- Tabs
theme.tab_fg            = "#7c8e9a"
theme.tab_bg            = "#e8e3db"
theme.tab_hover_bg      = "#ddd8d0"
theme.tab_ntheme        = "#7c8e9a"
theme.selected_fg       = "#23313a"
theme.selected_bg       = "#fcfaf6"
theme.selected_ntheme   = "#c96244"
theme.loading_fg        = "#3d7590"
theme.loading_bg        = "#e8e3db"

theme.selected_private_tab_bg = "#2c1f47"
theme.private_tab_bg          = "#1a1d3a"

-- SSL indicator
theme.trust_fg   = "#5a8f66"
theme.notrust_fg = "#c96244"

-- Link hints (f key)
theme.hint_font                       = "bold 10px JetBrainsMono Nerd Font, monospace"
theme.hint_fg                         = "#fcfaf6"
theme.hint_bg                         = "#c96244"
theme.hint_border                     = "1px solid #7d3c31"
theme.hint_opacity                    = "0.9"
theme.hint_overlay_bg                 = "rgba(221, 236, 244, 0.4)"
theme.hint_overlay_border             = "1px dotted #7c8e9a"
theme.hint_overlay_selected_bg        = "rgba(90, 143, 102, 0.3)"
theme.hint_overlay_selected_border    = "1px dotted #7c8e9a"

theme.ok    = { fg = "#23313a", bg = "#fcfaf6" }
theme.warn  = { fg = "#c96244", bg = "#fcfaf6" }
theme.error = { fg = "#fcfaf6", bg = "#c96244" }

return theme
