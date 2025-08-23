local methods = vim.lsp.protocol.Methods

---@param client vim.lsp.Client
---@param bufnr integer
local on_attach = function(client, bufnr)
    -- Keymap
    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    map('[d', function()
        vim.diagnostic.jump { count = -1 }
    end, 'Previous diagnostic')
    map(']d', function()
        vim.diagnostic.jump { count = 1 }
    end, 'Next diagnostic')
    map('[e', function()
        vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
    end, 'Previous error')
    map(']e', function()
        vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
    end, 'Next error')

    -- Features: Highlight word under cursor
    -- source: https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/lspconfig.lua#L125
    if client:supports_method(methods.textDocument_documentHighlight, bufnr) then
        local highlight_augroup = vim.api.nvim_create_augroup('user/lsp_highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('user/lsp_detach', { clear = true }),
            callback = function(_args)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = _args.buf }
            end,
        })
    end

    -- Features: Adding inlay-hints if supported (remember to enable feature in server config)
    -- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/commands.lua#L6C1-L12C49
    if client:supports_method(methods.textDocument_inlayHint, bufnr) then
        vim.api.nvim_create_user_command('ToggleInlayHints', function()
            local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
            vim.lsp.inlay_hint.enable(not enabled)

            vim.notify(string.format('%s inlay-hints', enabled and 'Disable' or 'Enable'), vim.log.levels.INFO)
        end, { desc = 'Toggle inlay hints', nargs = 0 })
    end
end

-- Define the diagnostic signs.
-- See :help vim.diagnostic.Opts for more details
vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'none', source = 'if_many' },
}

-- Update features when registering dynamic capabilities
-- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua#L216
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
        return
    end

    on_attach(client, vim.api.nvim_get_current_buf())
    return register_capability(err, res, ctx)
end

-- Lsp features on-attach caller
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user/lsp_attach', { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if not client then
            return
        end
        on_attach(client, args.buf)
    end,
})

-- Enable support servers in pre-defined server list
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' }, { confirm = false })
vim.lsp.enable(vimrc.servers)
