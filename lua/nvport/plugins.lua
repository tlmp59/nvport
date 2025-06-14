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
    { -- Support Neovim APIs
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

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
        }, require("portrc").sources.cmp.dependencies),
        opts = function()
            -- Extend Neovim's client capabilities with the completion ones
            vim.lsp.config("*", {
                capabilities = require("blink-cmp").get_lsp_capabilities(nil, true),
            })
            return require "nvport.config.blink"
        end,
    },

    { -- Copilot integration
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

    { -- File linting
    },

    { -- Debugger
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
        event = "VimEnter",
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

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = require("nvport.config.snacks").setup,
        keys = require("nvport.config.snacks").keys,
    },

    {
        "echasnovski/mini.clue",
        version = false,
        event = "VeryLazy",
        opts = function()
            return require "nvport.config.miniclue"
        end,
    },

    {
        "echasnovski/mini.pairs",
        version = false,
        event = "InsertEnter",
        opts = {},
    },

    {
        "echasnovski/mini.ai",
        version = false,
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
        opts = function()
            local miniai = require "mini.ai"

            return {
                n_lines = 300,
                custom_textobjects = {
                    f = miniai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    g = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line "$",
                            col = math.max(vim.fn.getline("$"):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
                },
                silent = true,
                search_method = "cover",
                mappings = {
                    around_next = "",
                    inside_next = "",
                    around_last = "",
                    inside_last = "",
                },
            }
        end,
    },

    {
        "echasnovski/mini.hipatterns",
        version = false,
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            local hipatterns = require "mini.hipatterns"
            return {
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }
        end,
    },

    {
        "echasnovski/mini.surround",
        version = false,
        opts = {},
    },

    {
        "nmac427/guess-indent.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },

    -- TODO: add only plugins that i found should be standard on neovim
    {},
}

local nvtbl = {}
for _, v in pairs(M) do
    table.insert(nvtbl, v)
end

return nvtbl
