return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp', -- Optional for better regex support
    dependencies = 'rafamadriz/friendly-snippets',
    config = function()
        local luasnip = require 'luasnip'

        -- Set up LuaSnip options
        luasnip.setup {
            history = true,
            delete_check_events = 'TextChanged',
            updateevents = 'TextChanged,TextChangedI',
        }

        -- Load VSCode-style snippets from friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        vim.keymap.set({ 'i', 's' }, '<C-k>', function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end, { desc = 'Expand or jump in snippet' })

        vim.keymap.set({ 'i', 's' }, '<C-j>', function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { desc = 'Jump backwards in snippet' })
    end,
}
