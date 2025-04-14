return {
    'williamboman/mason-lspconfig.nvim',
    version = 'v1.*',
    dependencies = {
        'williamboman/mason.nvim',
    },
    config = function()
        require('mason-lspconfig').setup({
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,
            },
        })

        vim.api.nvim_create_user_command('LspList', function()
            local clients = vim.lsp.get_clients()
            if #clients == 0 then
                print('No active LSP clients.')
            else
                for i, client in ipairs(clients) do
                    print(string.format('%d. %s (id: %d)', i, client.name, client.id))
                end
            end
        end, {})
    end
}
