local OPENROUTER_ADAPTERS = {
    ['gemini 2.5 pro (free)'] = { tag = 'google/gemini-2.5-pro-exp-03-25:free' },
    ['deepseek v3 (free)'] = { tag = 'deepseek/deepseek-chat-v3-0324:free' },
    ['llama 4 scout (free)'] = { tag = 'meta-llama/llama-4-scout:free' },
}

local DEFAULT_ADAPTER = 'gemini 2.5 pro (free)'

return {
    'olimorris/codecompanion.nvim',
    version = 'v14.*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'j-hui/fidget.nvim',
        'Davidyz/VectorCode',
    },
    config = function()
        local make_openrouter_adapter = function(model)
            return function()
                local openrouter_key = os.getenv('OPENROUTER_API_KEY')
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

        local or_adapters = {}
        for key, value in pairs(OPENROUTER_ADAPTERS) do
            or_adapters[key] = make_openrouter_adapter(value.tag)
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
            adapters = or_adapters,
            strategies = {
                chat = {
                    adapter = DEFAULT_ADAPTER,
                    slash_commands = {
                        -- add the vectorcode command here.
                        codebase = require('vectorcode.integrations').codecompanion.chat.make_slash_command(),
                    },
                    tools = {
                        vectorcode = {
                            description = "run vectorcode to retrieve the project context",
                            callback = require('vectorcode.integrations').codecompanion.chat.make_tool(),
                        }
                    },
                },
                inline = {
                    adapter = DEFAULT_ADAPTER,
                },
            },
            chat = {
                window = {
                    layout = 'float',
                    border = 'single',
                },
            },
        })

        vim.keymap.set('n', '<M-;>', function()
            require('codecompanion').toggle()
        end, { desc = 'Toggle CodeCompanion chat window' })
    end,
    init = function()
        require('plugins.lualine.codecompanion_fidget'):init()
    end
}
