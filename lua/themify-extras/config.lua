local M = {}

---@type ThemifyExtrasConfig
M.defaults = {
    randomize = {
        enable = false,
        daily = false,
    },
    daylight = {
        enable = false,
        day_start = 8,
        night_start = 16,
    },
}

---@type ThemifyExtrasConfig
M.options = {}

--- Merge defaults with user opts
---
---@param user_opts? ThemifyExtrasConfig
M.setup = function(user_opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, user_opts or {})

    if M.options.randomize.enable then
        require("themify-extras.modules.randomize").setup(M.options.randomize)
    end
    if M.options.daylight.enable then
        require("themify-extras.modules.daylight").setup(M.options.daylight)
    end
end

return M
