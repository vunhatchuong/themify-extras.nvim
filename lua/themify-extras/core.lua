local M = {}

--- Clear the theme and set the background to the specified value.
---
--- @param background string (light/dark)
function M.clear_theme(background)
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end
    vim.o.background = background
end

function M.setup()
    local ok_themify, _ = pcall(require, "themify.api")
    if not ok_themify then
        vim.notify(
            "themify-extras requires themify.nvim (https://github.com/LmanTW/themify.nvim)",
            vim.log.levels.ERROR
        )
        return
    end
end

return M
