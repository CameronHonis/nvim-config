---@diagnostic disable: missing-fields

--[[
NOTE: Set the config path to enable the copilot adapter to work.
It will search the following paths for a token:
  - "$CODECOMPANION_TOKEN_PATH/github-copilot/hosts.json"
  - "$CODECOMPANION_TOKEN_PATH/github-copilot/apps.json"
--]]
vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")

local function load_dotenv(opts)
    opts = opts or {}
    local file_path = opts.file_path or '.env'
    local verbose = opts.verbose or false

    local file = io.open(file_path, "r")
    if not file then return false end

    for line in file:lines() do
        -- Skip comments and empty lines
        if line:match("^%s*#") or not line:match("%S") then
            goto continue
        end

        -- Extract key-value pair
        local key, value = line:match("^%s*(%S+)%s*=%s*(.+)%s*$")
        if key and value then
            -- Remove quotes if present
            value = value:gsub("^[\"'](.+)[\"']$", "%1")
            -- Set environment variable
            if verbose then
                print(key, value)
            end
            vim.fn.setenv(key, value)
        end

        ::continue::
    end
    file:close()
    return true
end

load_dotenv({ file_path = vim.fn.stdpath('config') .. '/.env' })

vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

-- Your CodeCompanion setup
local plugins = {
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require 'cmp'
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })
        end
    },
    {
        'olimorris/codecompanion.nvim',
        version = 'v14.*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            local make_openrouter_adapter = function(model)
                return function()
                    local openrouter_key = os.getenv('OPENROUTER_API_KEY')
                    print('openrouter key = ' .. openrouter_key)
                    return require('codecompanion.adapters').extend('openai_compatible', {
                        env = {
                            url = 'https://openrouter.ai/api',
                            api_key = openrouter_key,
                            chat_url = '/v1/chat/completions',
                        },
                        schema = {
                            model = {
                                default = model,
                            },
                        },
                    })
                end
            end

            require('codecompanion').setup({
                display = {
                    action_palette = {
                        opts = {
                            show_default_actions = true,
                            show_default_prompt_library = true,
                        }
                    }
                },
                adapters = {
                    ['gemini 2.5 pro (free)'] = make_openrouter_adapter('google/gemini-2.5-pro-exp-03-25:free'),
                    ['deepseek v3 (free)'] = make_openrouter_adapter('deepseek/deepseek-chat-v3-0324:free'),
                    ['llama 4 scout (free)'] = make_openrouter_adapter('meta-llama/llama-4-scout:free'),
                },
                strategies = {
                    chat = {
                        adapter = 'gemini 2.5 pro (free)',
                    },
                    inline = {
                        adapter = 'anthropic',
                    },
                },
            })

            vim.keymap.set('n', '<M-;>', function()
                require('codecompanion').toggle()
            end, { desc = 'Toggle CodeCompanion chat window' })
        end
    }
}

require("lazy.minit").repro({ spec = plugins })

-- Setup Tree-sitter
local ts_status, treesitter = pcall(require, "nvim-treesitter.configs")
if ts_status then
    treesitter.setup({
        ensure_installed = { "lua", "markdown", "markdown_inline", "yaml" },
        highlight = { enable = true },
    })
end

-- Setup nvim-cmp
local cmp_status, cmp = pcall(require, "cmp")
if cmp_status then
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
    })
else
    print("failed to require cmp")
end
