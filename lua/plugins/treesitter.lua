return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        vim.api.nvim_create_autocmd('ColorScheme', {
            callback = function()
            end
        })

        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "csv",
                "cuda",
                "dockerfile",
                "go",
                "html",
                "java",
                "javascript",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "rust",
                "sql",
                "toml",
                "tsv",
                "typescript",
                "xml",
                "yaml",
                "zig",
            },
            fold = {
                enable = true,
            },
            highlight = {
                enable = true,
            },
            -- Add other modules as needed, e.g., indent, matchup
            -- indent = { enable = true },
            -- matchup = { enable = true },
        })

        vim.api.nvim_set_hl(0, '@markup.strong.markdown_inline', { fg = '#FFAAFF', bold = true })

        -- NOTE: You also need to set these global options
        -- Best placed in your main Neovim options file (e.g., options.lua or init.lua)
        -- or an ftplugin
        -- vim.opt.foldmethod = "expr"
        -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        -- vim.opt.foldenable = false -- Optional: start with folds closed
        -- vim.opt.foldlevelstart = 99 -- Optional: start with folds open
    end,
}
