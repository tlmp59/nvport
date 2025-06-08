local M = {}

M.base46 = {
    theme = "onedark",
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = false,
    theme_toggle = { "onedark", "one_light" },
}

M.sources = {
    trs = {},
    fmt = {},
    cmp = {
        dependencies = {},
        providers = {},
        per_filetype = {},
    },
    dap = {},
}

local ok, portrc = pcall(require, "portrc")
return vim.tbl_deep_extend("force", M, ok and portrc or {})
