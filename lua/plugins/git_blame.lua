return {
    'f-person/git-blame.nvim',
    config = function()
        require('gitblame').setup({
            enabled = true,
        })

        vim.api.nvim_set_keymap('n', 'o', '<cmd>GitBlameOpenCommitURL<CR>', { noremap = true, silent = true })
    end
}
