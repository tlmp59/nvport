local M = {}

M.setup = function(opts)
    _G.vimrc = opts

    local opt = vim.opt
    local g = vim.g

    g.mapleader = ' '
    g.maplocalleader = '\\'
    g.have_nerd_font = true

    --- Theme cache ---
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
end

local cache = vim.g.theme_cache

---@param tbl table[table] Highlight table
local tblToStr = function(tbl)
    local result = ''

    for hlgroupName, v in pairs(tbl) do
        local hlname = "'" .. hlgroupName .. "',"
        local hlopts = ''

        for optName, optVal in pairs(v) do
            local valueInStr = ((type(optVal)) == 'boolean' or type(optVal) == 'number') and tostring(optVal)
                or '"' .. optVal .. '"'
            hlopts = hlopts .. optName .. '=' .. valueInStr .. ','
        end

        result = result .. 'vim.api.nvim_set_hl(0,' .. hlname .. '{' .. hlopts .. '})\n'
    end

    return result

    -- Expected output: convert highlight table into executable string
    -- { Normal = {fg = "...", bg = "..."} }
    -- into "vim.api.nvim_set_hl(0,'Normal',{fg="...",bg="...",})"
end

---@param filename string
---@param str string
local strToCache = function(filename, str)
    local lines = 'return string.dump(function()' .. str .. 'end, true)'
    local file, err = io.open(cache .. filename, 'wb')

    if not file or err then
        vim.notify('Error writing ' .. file .. ':\n' .. err, vim.log.levels.ERROR)
        return
    end

    file:write(loadstring(lines)())
    file:close()

    -- Expected output: compile highlight commands into bytecode using `string.dump`
end

local compile = function(groups)
    if not vim.uv.fs_stat(cache) then
        vim.fn.mkdir(cache, 'p')
    end

    strToCache(vimrc.theme.name, tblToStr(groups))
end

---@param groups table[table] Highlight table
local fallback = function(groups)
    for k, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, k, opts)
    end
end

---@param scheme table[table] colorscheme with base0X to base1X
M.create = function(scheme)
    local file = cache .. vimrc.theme.name
    local exist, load = pcall(require, 'theme')

    if not exist then
        vim.notify("Directory 'theme/group' not found ...", vim.log.levels.WARN)
        return
    end

    local groups = load(scheme)
    compile(groups)

    local ok, _ = pcall(dofile, file)

    if not ok then
        vim.notify('Unable to load cache. Falling back to manual load ...', vim.log.levels.WARN)
        fallback(groups)
    end
end

return M
