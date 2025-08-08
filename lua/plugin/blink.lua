-- blink.cmp configuration
return {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '*',
    dependencies = {
        'L3MON4D3/LuaSnip',
        'folke/lazydev.nvim',
    },
    opts = {
        snippets = {
            preset = 'luasnip',
        },
        keymap = { preset = 'default' },
        cmdline = { enabled = false },
        signature = { enabled = true },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
            ghost_text = { enabled = false },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                lazydev = {
                    module = 'lazydev.integrations.blink',
                    score_offset = 100,
                },
            },
            per_filetype = {
                lua = { 'lazydev', inherit_defaults = true },
            },
        },
    },
}
