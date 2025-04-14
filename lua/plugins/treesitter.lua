return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
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
        })
    end
}
