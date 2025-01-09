local Themify = require("themify.api")
local Manager = Themify.Manager

local M = {}

local themify_daylight_cache = vim.fn.stdpath("data")
    .. "/themify_daylight_cache"

--- Retrieve available colorschemes.
--- @return table A list of available colorschemes.
local function get_available_colorschemes()
    return Manager.colorschemes
end

--- Get the background type (light/dark) for a specific theme.
--- @param theme_id string The ID of the theme.
--- @return string The background type ("light" or "dark").
local function get_theme_background(theme_id)
    local themes = Manager.get(theme_id).themes

    for _, theme in pairs(themes) do
        Themify.set_current(theme_id, theme)
        return vim.o.background
    end

    return vim.o.background
end

--- Write theme classifications to the cache file.
--- @param classifications table Theme classifications to write.
local function write_cache(classifications)
    local json_content = vim.fn.json_encode(classifications)
    vim.fn.writefile({ json_content }, themify_daylight_cache)
end

local function read_cache()
    if vim.fn.filereadable(themify_daylight_cache) == 1 then
        local content = vim.fn.readfile(themify_daylight_cache)
        return vim.fn.json_decode(content[1])
    end
    return nil
end

--- Compile a classification of themes into "light" or "dark".
--- Caches the results to avoid redundant computation.
--- @return table<string, string> A table mapping theme names to their background type.
function M.compile_theme_background()
    local cached = read_cache()
    if cached then
        return cached
    end

    local themes = get_available_colorschemes()
    local results = {}
    for _, theme in pairs(themes) do
        results[theme] = get_theme_background(theme)
    end

    write_cache(results)
    return results
end

--- Set the appropriate theme based on the current time.
local function set_theme_by_time(opts)
    local hour = tonumber(os.date("%H"))
    local classifications = M.compile_theme_background()

    for theme, background in pairs(classifications) do
        if
            hour >= opts.day_start
            and hour < opts.night_start
            and background == "dark"
        then
            vim.notify("Day! switch to: " .. theme)
            Themify.set_current(theme, Manager.get(theme).themes[1])
            return
        elseif
            (hour >= opts.night_start or hour < opts.day_start)
            and background == "light"
        then
            vim.notify("Night! switch to: " .. theme)
            Themify.set_current(theme, Manager.get(theme).themes[1])
            return
        end
    end
end

function M.enable_daylight_timer(opts)
    if M.timer then
        M.timer:stop()
    else
        M.timer = vim.uv.new_timer()
    end
    M.timer:start(
        0,
        3600000, -- Check every hour
        vim.schedule_wrap(function()
            set_theme_by_time(opts)
        end)
    )
end

---@param opts ThemifyExtras.daylight.Config
function M.setup(opts)
    vim.api.nvim_create_user_command("ThemifyExtrasRecompile", function()
        M.enable_daylight_timer(opts)
    end, {})
end

return M
