local M = {}

M.nvchad_ui = {
    "nvim-lua/plenary.nvim",

    {
        "nvchad/base46",
        build = function()
            require("base46").load_all_highlights()
        end,
    },

    {
        "nvchad/ui",
        lazy = false,
        config = function()
            require "nvchad"
        end,
    },

    "nvzone/volt",
    "nvzone/menu",
    { "nvzone/minty", cmd = { "Huefy", "Shades" } },
}

M.nvport_core = {
    { -- Syntax highlighting and text objects
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        opts = function()
            return require "nvport.config.treesitter"
        end,
    },

    { -- Auto completion engine
        "saghen/blink.cmp",
        event = "InsertEnter",
        version = "*",
        dependencies = vim.tbl_extend("force", {
            "folke/lazydev.nvim",
            {
                "L3MON4D3/LuaSnip",
                version = "2.*",
                build = (function()
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
                opts = {},
            },
        }, require("nvconf").sources.cmp.dependencies),
        opts = function()
            -- Extend neovim's client capabilities with the completion ones
            vim.lsp.config("*", {
                capabilities = require("blink-cmp").get_lsp_capabilities(nil, true),
            })
            return require "nvport.config.blink"
        end,
    },

    { -- File formatting
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        opts = function()
            return require "nvport.config.conform"
        end,
    },
}

M.nvport_addon = {
    {
        "MagicDuck/grug-far.nvim",
        opts = { headerMaxWidth = 80 },
        cmd = "GrugFar",
        keys = {
            {
                "<leader>sr",
                function()
                    local grug = require "grug-far"
                    local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
                    grug.open {
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    }
                end,
                mode = { "n", "v" },
                desc = "Search and Replace",
            },
        },
    },

    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        dependencies = { "folke/snacks.nvim", "nvim-lua/plenary.nvim" },
        keys = {
            { "-", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
            { "<leader>e", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
        },
        opts = {
            open_for_directories = true,
            floating_window_scaling_factor = 1,
            yazi_floating_window_border = "none",
        },
    },

    {
        "gbprod/yanky.nvim",
        event = "VeryLazy",
        opts = {
            ring = { history_length = 20 },
            highlight = { timer = 250 },
        },
        keys = {
            { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
            { "=p", "<Plug>(YankyPutAfterLinewise)", desc = "Put yanked text in line below" },
            { "=P", "<Plug>(YankyPutBeforeLinewise)", desc = "Put yanked text in line above" },
            { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
            { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yanky yank" },
        },
    },
}

local nvtbl = {}
for _, v in pairs(M) do
    table.insert(nvtbl, v)
end

return nvtbl
