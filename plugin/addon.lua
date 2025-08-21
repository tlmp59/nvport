vim.pack.add { 'https://github.com/echasnovski/mini.icons' }

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
    once = true,
    callback = function()
        vim.pack.add({
            'https://github.com/echasnovski/mini.pairs',
            'https://github.com/echasnovski/mini.ai',
            'https://github.com/echasnovski/mini.surround',
        }, { confirm = false })

        require('mini.pairs').setup()
        require('mini.ai').setup()
        require('mini.surround').setup()
    end,
})

vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = function()
        vim.pack.add { 'https://github.com/echasnovski/mini.clue' }

        local clue = require 'mini.clue'
        clue.setup {
            triggers = {
                -- Leader triggers
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },

                -- Built-in completion
                { mode = 'i', keys = '<C-x>' },

                -- `g` key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },

                -- Marks
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },

                -- Registers
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },

                -- Window commands
                { mode = 'n', keys = '<C-w>' },

                -- `z` key
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },
            },

            clues = {
                clue.gen_clues.builtin_completion(),
                clue.gen_clues.g(),
                clue.gen_clues.marks(),
                clue.gen_clues.registers(),
                clue.gen_clues.windows(),
                clue.gen_clues.z(),
            },

            window = {
                config = {
                    width = vim.api.nvim_win_get_width(0),
                    height = 10,
                },
                delay = 0,
            },
        }
    end,
})

vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        vim.pack.add({
            'https://github.com/mikavilpas/yazi.nvim',
            'https://github.com/nvim-lua/plenary.nvim',
        }, { confirm = false })

        require('yazi').setup {
            open_for_directories = true,
            floating_window_scaling_factor = 1,
            yazi_floating_window_border = 'none',
        }

        vim.keymap.set({ 'n', 'v' }, '-', '<cmd>Yazi<cr>', { desc = 'Open file explorer' })
        vim.keymap.set({ 'n', 'v' }, '_', '<cmd>Yazi cwd<cr>', { desc = 'Open file explorer in current directory' })
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    once = true,
    callback = function()
        vim.pack.add({ 'https://github.com/gbprod/yanky.nvim' }, { confirm = false })

        require('yanky').setup {
            ring = { history_length = 20 },
            highlight = { timer = 250 },
        }

        for _, k in ipairs {
            { { 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)', { desc = 'Put yanked text after cursor' } },
            { { 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)', { desc = 'Put yanked text before cursor' } },
            { 'n', '=p', '<Plug>(YankyPutAfterLinewise)', { desc = 'Put yanked text in line below' } },
            { 'n', '=P', '<Plug>(YankyPutBeforeLinewise)', { desc = 'Put yanked text in line above' } },
            { 'n', '[y', '<Plug>(YankyCycleForward)', { desc = 'Cycle forward through yank history' } },
            { 'n', ']y', '<Plug>(YankyCycleBackward)', { desc = 'Cycle backward through yank history' } },
            { { 'n', 'x' }, 'y', '<Plug>(YankyYank)', { desc = 'Yanky yank' } },
        } do
            vim.keymap.set(k[1], k[2], k[3], k[4] or {})
        end
    end,
})
