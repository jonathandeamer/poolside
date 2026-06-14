local settings = require "settings"

-- Search: type a bare query to search with DuckDuckGo,
-- or prefix with "g " for Google, "gh " for GitHub.
settings.window.search_engines = {
    d  = "https://duckduckgo.com/?q=%s",
    g  = "https://www.google.com/search?q=%s",
    gh = "https://github.com/search?q=%s",
}
settings.window.default_search_engine = "d"

settings.window.home_page    = "luakit://newtab/"
settings.window.new_tab_page = "luakit://newtab/"

settings.webview.enable_smooth_scrolling = true
