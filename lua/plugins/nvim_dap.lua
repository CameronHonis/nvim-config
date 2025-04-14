return {
    'mfussenegger/nvim-dap',
    version = 'v0.*',
    dependencies = { 'williamboman/mason.nvim', 'rcarriga/nvim-dap-ui' },
    keys = {
        { '<M-b>',       mode = { 'n', 'i' }, '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = 'toggle breakpoint for line' },
        { '<M-c>',       mode = { 'n', 'i' }, '<cmd>lua require"dap".continue()<CR>',          desc = 'continue [debug]' },
        { '<M-j>',       mode = { 'n', 'i' }, '<cmd>lua require"dap".step_over()<CR>',         desc = 'step over [debug]' },
        { '<M-l>',       mode = { 'n', 'i' }, '<cmd>lua require"dap".step_into()<CR>',         desc = 'step into [debug]' },
        { '<M-h>',       mode = { 'n', 'i' }, '<cmd>lua require"dap".step_out()<CR>',         desc = 'step out [debug]' },
        { '<M-s>',       mode = { 'n', 'i' }, '<cmd>lua require"dap".close()<CR>',         desc = 'stop [debug]' },
    },
    config = function()
        local dap = require('dap')
        local mreg = require('mason-registry')
        mreg.refresh(function()
            local function dap_path(name)
                local pkg = mreg.get_package(name)
                if not pkg then return nil end
                return pkg:get_install_path()
            end

            local debugpy_path = dap_path('debugpy')
            if debugpy_path then
                local python_executable = debugpy_path .. '/venv/bin/python' -- Standard path in mason package
                if vim.fn.executable(python_executable) then
                    dap.adapters.python = {
                        type = 'executable',
                        command = python_executable,
                        args = { '-m', 'debugpy.adapter' },
                    }
                else
                    vim.notify("nvim-dap: Could not find python executable for debugpy in Mason package.",
                        vim.log.levels.WARN)
                end
            end
        end)

        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',     -- Debug the currently open file
                --pythonPath = function()
                ---- Function to optionally determine the python path, e.g., check for virtualenvs
                ---- If mason-nvim-dap installs debugpy, it often handles this.
                ---- You might need to customize this based on your project structure.
                ---- Example: Check for a venv activate script
                --local venv = vim.fn.findfile('pyproject.toml', vim.fn.getcwd() .. ';')
                --if venv ~= '' then
                --local venv_path = vim.fn.fnamemodify(venv, ':h') .. '/.venv/bin/python'
                --if vim.fn.executable(venv_path) == 1 then
                --return venv_path
                --end
                --end
                ---- Fallback or default python
                --return '/usr/bin/python3' -- Adjust if needed
                --end,
            },
        }

    end,
}
