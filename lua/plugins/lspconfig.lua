return {
    'neovim/nvim-lspconfig',
    version = 'v1.*',
    config = function()
        vim.keymap.set({ 'n', 'i' }, '<F5>', '<cmd>LspRestart<CR>', { noremap = true, silent = true })
        vim.keymap.set({ 'n', 'i' }, '<C-A-P>', vim.lsp.buf.signature_help, { noremap = true, silent = true })
        vim.keymap.set({ 'n', 'i' }, '<C-A-R>', vim.lsp.buf.rename, { noremap = true, silent = true })
        vim.keymap.set({ 'n', 'i' }, '<M-CR>', vim.lsp.buf.code_action, { noremap = true, silent = true })
        vim.keymap.set({ 'n', 'i' }, '<M-,>', vim.lsp.buf.format, { noremap = true, silent = true })
    end
}
