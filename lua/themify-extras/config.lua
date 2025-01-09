local M = {}

---@type ThemifyExtrasConfig
M.defaults = {
    randomize = {
        enable = false,
        daily = false,
    },
}

---@type ThemifyExtrasConfig
M.options = {}

--- Merge defaults with user opts
---
---@param user_opts? ThemifyExtrasConfig
M.setup = function(user_opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
end

return M
