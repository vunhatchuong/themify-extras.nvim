local Themify = require("themify.api")
local Manager = Themify.Manager

local Core = require("themify-extras.core")

local M = {}

local themify_daylight_cache = vim.fn.stdpath("data")
    .. "/themify_daylight_cache"

--- Get the background type (light/dark) for a specific theme.
---
--- @param theme_id string The ID of the theme.
--- @return table<string,string> The background type ("light" or "dark").
local function get_background(theme_id)
    local themes = Manager.get(theme_id).themes

    local backgrounds = {}
    for _, theme in pairs(themes) do
        Themify.set_current(theme_id, theme)
        backgrounds[theme] = vim.o.background
    end

    return backgrounds
end

--- Write theme classifications to cache.
---
--- @param classifications table Theme classifications to write.
local function write_cache(classifications)
    local json_content = vim.fn.json_encode(classifications)
    vim.fn.writefile({ json_content }, themify_daylight_cache)
end

--- read theme classifications from cache.
---
--- @return table<string,table<string,string>>? Theme classifications cache.
local function read_cache()
    if vim.fn.filereadable(themify_daylight_cache) == 1 then
        local content = vim.fn.readfile(themify_daylight_cache)
        return vim.fn.json_decode(content[1])
    end
    return nil
end

--- Compile a classification of themes into "light" or "dark".
--- Caches the results.
---
--- @return table<string, table<string,string>> A table mapping theme names to their background type.
function M.compile_background()
    local cached = read_cache()
    if cached then
        return cached
    end

    local themes = Manager.colorschemes
    local results = {}

    for _, theme in pairs(themes) do
        local background = get_background(theme)
        results[theme] = background
    end

    vim.notify(
        "Compiles for the first time, please re-open nvim",
        vim.log.levels.INFO
    )

    write_cache(results)
    return results
end

--- Set the theme based on the current time.
---
---@param opts ThemifyExtras.daylight.Config
local function set_by_time(opts)
    local hour = tonumber(os.date("%H"))
    local classifications = M.compile_background()

    for theme_id, theme in pairs(classifications) do
        for sub_theme, background in pairs(theme) do
            if
                (hour >= opts.day_start and hour < opts.night_start)
                and vim.o.background == "dark"
                and background == "light"
            then
                Core.clear_theme("light")
                vim.notify("Daytime! switch to: " .. theme_id)
                Themify.set_current(theme_id, sub_theme)
                return
            elseif
                (hour >= opts.night_start or hour < opts.day_start)
                and vim.o.background == "light"
                and background == "dark"
            then
                Core.clear_theme("dark")
                vim.notify("Nighttime! switch to: " .. theme_id)
                Themify.set_current(theme_id, sub_theme)
                return
            end
        end
    end
end

--- Main timer that monitors when to change themes.
---
---@param opts ThemifyExtras.daylight.Config
function M.daylight_timer(opts)
    if M.timer then
        M.timer:stop()
    else
        M.timer = vim.uv.new_timer()
    end
    M.timer:start(
        0,
        3600000, -- Check every hour
        vim.schedule_wrap(function()
            set_by_time(opts)
        end)
    )
end

---@param opts ThemifyExtras.daylight.Config
function M.setup(opts)
    M.daylight_timer(opts)

    vim.api.nvim_create_user_command("ThemifyExtrasDaylightCompile", function()
        M.daylight_timer(opts)
    end, {})
end

return M
