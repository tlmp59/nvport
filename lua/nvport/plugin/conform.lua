vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
    once = true,
    callback = function()
        vim.pack.add({ 'https://github.com/stevearc/conform.nvim' }, { confirm = false })

        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

        require('conform').setup {
            notify_on_error = false,

            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,

            formatters = {
                dprint = {
                    command = 'dprint',
                    args = {
                        'fmt',
                        '--stdin',
                        '$FILENAME',
                        '--config',
                        vim.api.nvim_get_runtime_file('.dprint.jsonc', true)[1],
                    },
                    stdin = true,
                },
            },

            formatters_by_ft = vim.tbl_deep_extend('force', vimrc.fmt_sources, {
                -- For filetypes without a formatter
                ['_'] = { 'trim_whitespace', 'trim_newlines' },
            }),
        }
    end,
})
