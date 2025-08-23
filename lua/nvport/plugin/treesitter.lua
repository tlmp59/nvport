vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' }, { confirm = false })

require('nvim-treesitter.configs').setup {
    ensure_installed = vimrc.parsers,
    auto_install = false,

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

    indent = { enable = true, disable = { 'yaml' } },
}

vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('user/nvim-treesitter-pack-changed-update-handler', { clear = true }),
    callback = function(e)
        if e.data.kind == 'update' then
            vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
            ---@diagnostic disable-next-line: param-type-mismatch
            local ok = pcall(vim.cmd, 'TSUpdate')
            if ok then
                vim.notify('TSUpdate completed!', vim.log.levels.INFO)
            else
                vim.notify('TSUpdate not found or failed, skipping update!', vim.log.levels.INFO)
            end
        end
    end,
})
