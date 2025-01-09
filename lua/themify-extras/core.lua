local M = {}

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
