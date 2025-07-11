local M = {}

M.base46 = {
    theme = "default-dark", -- default theme
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = false,
    theme_toggle = { "default-dark", "default-light" },
}

M.sources = {
    parser = {},
    server = {},
    formatter = {},
    completion = {
        dependencies = {},
        providers = {},
        per_filetype = {},
    },
    debugger = {},
    linter = {},
}

local ok, portrc = pcall(require, "portrc")
return vim.tbl_deep_extend("force", M, ok and portrc or {})
