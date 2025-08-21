require('nvport').setup {
    theme = 'habamax',

    parsers = {
        'bash',
        'lua',
        'luadoc',
        'printf',
        'vim',
        'vimdoc',
        'nix',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'json',
    },

    servers = {
        'lua_ls',
    },

    fmt_sources = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
        python = { 'dprint', 'isort', 'black', stop_after_first = true },
        markdown = { 'dprint' },
        html = { 'dprint' },
        css = { 'dprint' },
        javascript = { 'dprint' },
    },
}
