--- User autocommand ---
local auto = vim.api.nvim_create_autocmd
---@param desc string
local augroup = function(desc)
    return vim.api.nvim_create_augroup('user/' .. desc, { clear = true })
end

-- source: unknown
auto('BufHidden', {
    group = augroup 'delete_no_name',
    desc = 'Delete [No Name] buffers',
    callback = function(args)
        if args.file == '' and vim.bo[args.buf].buftype == '' and not vim.bo[args.buf].modified then
            vim.schedule(function()
                pcall(vim.api.nvim_buf_delete, args.buf, {})
            end)
        end
    end,
})

-- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua#L29
auto('FileType', {
    group = augroup 'close_with_q',
    desc = 'Close with <q>',
    pattern = {
        'git',
        'help',
        'man',
        'qf',
        'scratch',
        'grug-far',
        'terminal',
    },
    callback = function(args)
        vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
    end,
})

-- source: unknown
auto('BufReadPost', {
    group = augroup 'last_location',
    desc = 'Go to the last location when opening a buffer',
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd 'normal! g`"zz'
        end
    end,
})

-- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua#L118C1-L125C3
auto('TextYankPost', {
    group = augroup 'hl_on_yank',
    desc = 'Highlight on yank',
    callback = function()
        -- Setting a priority higher than the LSP references one.
        vim.hl.on_yank { higroup = 'Visual', priority = 250 }
    end,
})

--- User keymap ---
for _, v in ipairs {
    { { 'n', 'v' }, ' ', '<nop>', { silent = true } },

    -- Disable mouse and arrow movement
    { 'n', '<left>', '<cmd>echo "Use h to move!!"<CR>' },
    { 'n', '<right>', '<cmd>echo "Use l to move!!"<CR>' },
    { 'n', '<up>', '<cmd>echo "Use k to move!!"<CR>' },
    { 'n', '<down>', '<cmd>echo "Use j to move!!"<CR>' },

    -- Remove highlight after search
    { 'n', '<Esc>', '<cmd>nohlsearch<CR>' },

    -- Keep screen centered when moving around
    { 'n', '*', '*zzzv' },
    { 'n', '#', '#zzzv' },
    { 'n', ',', ',zzzv' },
    { 'n', ';', ';zzzv' },
    { 'n', 'n', 'nzzzv' },
    { 'n', 'N', 'Nzzzv' },

    -- Keep selected after moving with < and >
    { 'v', '<', '<gv' },
    { 'v', '>', '>gv' },

    -- Yank without replace register
    { 'x', '<M-p>', [["_dP]] },

    -- Seamlessly navigate between split windows
    { 'n', '<C-h>', ':wincmd h<cr>', { desc = 'Move focus to the left window', silent = true } },
    { 'n', '<C-l>', ':wincmd l<cr>', { desc = 'Move focus to the right window', silent = true } },
    { 'n', '<C-j>', ':wincmd j<cr>', { desc = 'Move focus to the lower window', silent = true } },
    { 'n', '<C-k>', ':wincmd k<cr>', { desc = 'Move focus to the upper window', silent = true } },

    -- Better vertical movement with word wrap
    { 'n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
    { 'n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },

    -- Windows size adjustment
    { 'n', '<C-Left>', ':vertical resize +10<CR>', { silent = true } },
    { 'n', '<C-Right>', ':vertical resize -10<CR>', { silent = true } },
    { 'n', '<C-Up>', ':resize +10<CR>', { silent = true } },
    { 'n', '<C-Down>', ':resize -10<CR>', { silent = true } },

    -- Navigate in quick-fix & location list
    { 'n', '<M-k>', '<cmd>cnext<cr>zz', { silent = true } },
    { 'n', '<M-j>', '<cmd>cprev<cr>zz', { silent = true } },
    { 'n', '<M-l>', '<cmd>lnext<cr>zz', { silent = true } },
    { 'n', '<M-h>', '<cmd>lprev<cr>zz', { silent = true } },
} do
    vim.keymap.set(v[1], v[2], v[3], v[4] or {})
end

--- External plugins ---
require('nvport').collect 'nvport.plugin'
