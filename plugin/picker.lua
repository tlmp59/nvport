vim.pack.add({
    'https://github.com/echasnovski/mini.pick',
    'https://github.com/echasnovski/mini.extra',
    'https://github.com/echasnovski/mini.bufremove',
}, { confirm = false })

require('mini.pick').setup()
require('mini.extra').setup()
