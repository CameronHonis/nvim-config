return {
    'rcarriga/nvim-dap-ui',
    version = 'v4.*',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = {
        { '<M-C-Space>', mode = { 'n', 'i' }, function() pcall(require('dapui').toggle) end, desc = 'close debug ui' },
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        dapui.setup({
            controls = {
                element = "repl",
                enabled = true,
                icons = {
                    disconnect = "",
                    pause = "",
                    play = "",
                    run_last = "",
                    step_back = "",
                    step_into = "",
                    step_out = "",
                    step_over = "",
                    terminate = ""
                }
            },
            element_mappings = {},
            expand_lines = true,
            floating = {
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" }
                }
            },
            force_buffers = true,
            icons = {
                collapsed = "",
                current_frame = "",
                expanded = ""
            },
            layouts = { {
                elements = {
                    { id = "watches", size = 0.2 },
                    { id = "scopes",  size = 0.55 },
                    { id = "stacks",  size = 0.25 },
                },
                position = "left",
                size = 40
            }, {
                elements = {
                    { id = "console", size = 1 }
                },
                position = "bottom",
                size = 10
            } },
            mappings = {
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "g",
                remove = "d",
                repl = "r",
                toggle = "t"
            },
            render = {
                indent = 1,
                max_value_lines = 100
            }
        })

        -- Auto open/close dap-ui based on events
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end
}
