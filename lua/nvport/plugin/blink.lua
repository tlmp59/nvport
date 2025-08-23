vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = function()
        vim.pack.add({
            'https://github.com/saghen/blink.cmp',
            'https://github.com/echasnovski/mini.snippets',
            'https://github.com/rafamadriz/friendly-snippets',
        }, { confirm = false })

        local snippet = require 'mini.snippets'
        snippet.setup {
            snippets = { snippet.gen_loader.from_lang() },
        }

        require('blink.cmp').setup {
            snippets = { preset = 'mini_snippets' },
            cmdline = { enabled = false },
            signature = { enabled = true },
            completion = {
                menu = { auto_show = true },
                ghost_text = { enabled = false },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                providers = {},
                per_filetype = {},
            },
            fuzzy = { implementation = 'lua' },
        }
    end,
})
