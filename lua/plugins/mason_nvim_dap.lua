return {
    'jay-babu/mason-nvim-dap.nvim',
    version = 'v2.*',
    dependencies = {
        'williamboman/mason.nvim',
        'mfussenegger/nvim-dap',
    },
    ensure_installed = {
        'python',
        'delve',
        'bash',
        'cppdbg',
        'js',
    },
    config = function()
        require('mason-nvim-dap').setup()
    end
}
