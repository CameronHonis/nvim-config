return {
    'williamboman/mason.nvim',
    version = 'v1.*',
    config = function()
        require('mason').setup({})

        local mason_registry = require("mason-registry")

        local function ensure_installed(package_name)
            local package = mason_registry.get_package(package_name)
                if not package:is_installed() then
                package:install()
            end
        end

        local packages = {
            --LSPs
            'bash-language-server',
            'clangd',
            'css-lsp',
            'html-lsp',
            'jdtls', -- java
            'json-lsp',
            'lemminx', -- xml
            'lua-language-server',
            'markdown-oxide',
            'pyright',
            'sqlls',
            'tailwindcss-language-server',
            'typescript-language-server',
            'zls', -- zig

            -- DAPs
            'delve',    -- golang
            'debugpy',  -- python
            'codelldb', -- c/c++/rust
            'js-debug-adapter',
        }

        mason_registry.refresh(function()
            for _, package_name in ipairs(packages) do
                ensure_installed(package_name)
            end
        end)
    end
}
