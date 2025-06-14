pcall(function()
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
end)

return {
    ensure_installed = vim.tbl_extend("force", {
        "lua",
        "luadoc",
        "printf",
        "vim",
        "vimdoc",
    }, require("portrc").sources.trs),

    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,

        -- Disable on large file
        disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100Kb
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },

    indent = { enable = true, disable = { "yaml" } },
}
