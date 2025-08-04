---@brief
---
--- https://github.com/automattic/harper
---
--- The language server for Harper, the slim, clean language checker for developers.
---
--- See our [documentation](https://writewithharper.com/docs/integrations/neovim) for more information on settings.
---
--- In short, they should look something like this:
--- ```lua
--- vim.lsp.config('harper_ls', {
---   settings = {
---     ["harper-ls"] = {
---       userDictPath = "~/dict.txt"
---     }
---   },
--- })
--- ```
return {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = {
        'html',
        'toml',
        'typst',
        'markdown',
    },
    root_markers = { '.git' },
}
