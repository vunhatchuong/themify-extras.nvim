---@class ThemifyExtras
local M = {}

---@param user_opts? ThemifyExtrasConfig
function M.setup(user_opts)
    local Core = require("themify-extras.core")
    Core.setup()

    local Config = require("themify-extras.config")
    Config.setup(user_opts)
end

return M
