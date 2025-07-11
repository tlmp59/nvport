return {
    cmdline = { enabled = false },
    keymap = {
        ["<CR>"] = { "accept", "fallback" },
        ["<C-\\>"] = { "hide", "fallback" },
        ["<C-n>"] = { "select_next", "show" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-p>"] = { "select_prev" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    appearance = {
        -- kind_icons = require("nvport.icon").symbol_kinds,
        nerd_font_variant = "mono",
    },
    completion = {
        keyword = { range = "prefix" },
        list = {
            selection = { preselect = false, auto_insert = false },
            max_items = 10,
        },
        menu = {
            auto_show = true,
            draw = {
                columns = {
                    { "label", "label_description", gap = 1 },
                    { "kind_icon", "source_name", gap = 1 },
                },
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            treesitter_highlighting = true,
        },
        ghost_text = { enabled = true },
    },
    sources = {
        default = { "lsp", "path", "snippets" },

        providers = vim.tbl_deep_extend("force", {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
            },
        }, require("portal").sources.blink.providers),

        per_filetype = vim.tbl_deep_extend("force", {
            lua = { inherit_defaults = true, "lazydev" },
            markdown = { inherit_defaults = true, "latex" },
        }, require("portal").sources.blink.per_filetype),
    },

    snippets = { preset = "luasnip" },
    signature = { enabled = true },

    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
}
