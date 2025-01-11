local Themify = require("themify.api")
local Manager = Themify.Manager

---@class ThemifyExtras.randomize
local M = {}

local themify_last_change = vim.fn.stdpath("data") .. "/themify_last_change"

function M.randomize()
    local current_theme = Themify.get_current()
    if current_theme == nil then
        vim.notify("Please install themes through :Themify")
        return
    end

    local current_theme_id = current_theme.colorscheme_id
    local number_of_themes = #Manager.colorschemes

    math.randomseed(os.time())
    while true do
        local theme_id = Manager.colorschemes[math.random(number_of_themes)]

        if theme_id ~= current_theme_id then
            local theme = Themify.Manager.get(theme_id).themes
            local theme_name = theme[math.random(#theme)]

            Themify.set_current(theme_id, theme_name)
            vim.notify("Randomized theme: " .. theme_name)
            return
        end
    end
end

local function write_current_date()
    local today = os.date("%Y-%m-%d")
    vim.fn.writefile({ today }, themify_last_change)
end

local function get_last_change_date()
    return vim.fn.filereadable(themify_last_change) == 1
            and vim.fn.readfile(themify_last_change)[1]
        or nil
end
local function daily_randomize()
    local last_date = get_last_change_date()
    local today = os.date("%Y-%m-%d")

    if last_date ~= today then
        vim.notify("Randomize theme for today")
        M.randomize()
        write_current_date()
    end
end

---@param opts ThemifyExtras.randomize.Config
function M.setup(opts)
    if opts.daily then
        daily_randomize()
    end

    vim.api.nvim_create_user_command("RandomizeTheme", function()
        M.randomize()
    end, {})
end

return M
