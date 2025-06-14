return {
    notify_on_error = false,

    format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
        else
            return {
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        end
    end,

    formatters = {
        dprint = {
            command = "dprint",
            args = {
                "fmt",
                "--stdin",
                "$FILENAME",
                "--config",
                vim.api.nvim_get_runtime_file(".dprint.jsonc", true)[1],
            },
            stdin = true,
        },
    },

    formatters_by_ft = vim.tbl_deep_extend("force", {
        -- NvPort default formatters
        lua = { "stylua" },
        nix = { "alejandra" },
        python = { "dprint", "isort", "black", stop_after_first = true },
        markdown = { "dprint" },

        -- For filetypes without a formatter
        ["_"] = { "trim_whitespace", "trim_newlines" },
    }, require("nvconf").sources.fmt),
}
