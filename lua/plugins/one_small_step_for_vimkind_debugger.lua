local DAP_PORT = 8086

-- Instructions
-- [In DebuggEE Instance] execute user command 'LaunchNvimDebugger'
-- [In DebuggER Instance] set breakpoints
-- [In DebuggER Instance] run `require"dap".continue` (probably <M-c> (alt + c))
-- [In DebuggEE Instance *in separate window*] interact with neovim to trigger breakpoints
return {
    'jbyuki/one-small-step-for-vimkind',
    version = 'v*',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
        local dap = require "dap"
        dap.configurations.lua = {
            {
                type = 'nlua',
                request = 'attach',
                name = "Attach to running Neovim instance",
            }
        }

        dap.adapters.nlua = function(callback, config)
            callback({ type = 'server', host = config.host or "127.0.0.1", port = DAP_PORT })
        end

        vim.api.nvim_create_user_command('LaunchNvimDebugger', function()
            require('osv').launch({ port = DAP_PORT })
        end, { desc = 'launch the `one-small-step-for-vimkind` DAP server' })
    end
}
