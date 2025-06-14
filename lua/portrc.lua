local M = {}

M.sources = {
    trs = {},
    fmt = {},
    cmp = {
        dependencies = {},
        providers = {},
        per_filetype = {},
    },
    dap = {},
    lnt = {},
}

local ok, portrc = pcall(require, "portrc")
return vim.tbl_deep_extend("force", M, ok and portrc or {})
