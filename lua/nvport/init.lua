local M = {}

M.setup = function(opts)
    _G.vimrc = opts

    local opt = vim.opt
    local g = vim.g

    g.mapleader = ' '
    g.maplocalleader = '\\'
    g.have_nerd_font = true
    g.theme_cache = vim.fn.stdpath 'cache' .. '/theme/'

    --- Backup ---
    opt.swapfile = false
    opt.backup = false
    opt.undofile = true
    opt.undodir = vim.fn.stdpath 'cache' .. '/undodir'
    opt.confirm = true -- prompt for save

    --- Search ---
    opt.ignorecase = true
    opt.smartcase = true
    opt.incsearch = true
    opt.hlsearch = true

    --- Indentation ---
    opt.tabstop = 4
    opt.shiftwidth = 4
    opt.softtabstop = 4
    opt.expandtab = true

    opt.smartindent = true
    opt.autoindent = true

    --- Slide boundary ---
    opt.scrolloff = 8
    opt.sidescrolloff = 8

    --- File encoding ---
    opt.encoding = 'utf-8'
    opt.fileencoding = 'utf-8'

    --- Split ---
    opt.splitright = true
    opt.splitbelow = true

    --- Main UI ---
    opt.number = true
    opt.relativenumber = true
    opt.wrap = false
    opt.linebreak = true
    opt.colorcolumn = '80'

    opt.cursorline = true
    opt.showmode = false
    opt.showtabline = 0
    opt.laststatus = 3
    opt.winborder = 'none' -- default float border
    opt.cmdheight = 1

    opt.guicursor = '' -- solid block
    opt.signcolumn = 'yes'

    opt.title = true
    opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

    opt.termguicolors = true

    --- Popup menu ---
    opt.completeopt = 'menuone,noselect,noinsert'
    opt.pumheight = 10
    opt.pumblend = 10

    --- Misc ---
    opt.mouse = 'n' -- allow mouse in normal
    opt.lazyredraw = true -- delay redraw during macros
    opt.inccommand = 'split' -- preview substitutions live
    opt.shortmess:append { w = true, s = true }

    vim.schedule(function()
        opt.clipboard = 'unnamedplus'
    end)

    --- Disable builtin plugins & providers ---
    for _, plugin in pairs {
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'gzip',
        'zip',
        'zipPlugin',
        'tar',
        'tarPlugin',
        'getscript',
        'getscriptPlugin',
        'vimball',
        'vimballPlugin',
        '2html_plugin',
        'logipat',
        'rrhelper',
        'spellfile_plugin',
        'matchit',
        'python3_provider',
        'ruby_provider',
        'perl_provider',
        'node_provider',
    } do
        g['loaded_' .. plugin] = 1
    end

    --- Set default colorshceme ---
    vim.cmd.colorscheme(vimrc.theme)

    --- Inject plugins into nvim ---
    require 'nvport.plugin'
end

---@param luapath string
M.collect = function(luapath)
    local path = 'lua/' .. luapath:gsub('[.]', '/') .. '/*.lua'
    local stat, plugins = pcall(vim.api.nvim_get_runtime_file, path, true)
    assert(stat, 'Path invalid or not exist:' .. luapath)

    local failed = {}
    vim.iter(plugins):each(function(p)
        local name = vim.fn.fnamemodify(p, ':t:r')
        if name ~= 'init' then
            local ok, rt = pcall(require, luapath .. '.' .. name)
            if not ok then
                table.insert(failed, name)
            end
        end
    end)

    if not vim.tbl_isempty(failed) then
        --stylua: ignore
        local msg = string.format(
            "Unable to load these files under '%s': %s",
            luapath,
            table.concat(failed, ', ')
        )

        vim.notify(msg, vim.log.levels.WARN)
    end
end

M.flavour = function()
    local file = vim.g.theme_cache .. vimrc.theme.name
    local theme = require 'nvport.theme'
end

return M
