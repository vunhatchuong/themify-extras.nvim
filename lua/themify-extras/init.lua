---@class ThemifyExtras
local M = {}

---@param user_opts? ThemifyExtrasConfig
function M.setup(user_opts)
    local Core = require("themify-extras.core")
    Core.setup()

    local Config = require("themify-extras.config")
    Config.setup(user_opts)

    if Config.options.randomize.enable then
        local Randomize = require("themify-extras.modules.randomize")
        Randomize.setup(Config.options.randomize)
    end
    local Daylight = require("themify-extras.modules.daylight")
    Daylight.setup(Config.options.daylight)
end

return M
