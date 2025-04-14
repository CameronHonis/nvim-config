return {
    'preservim/nerdcommenter',
    version = 'v2.*',
    config = function()
        -- block comment toggle
        vim.api.nvim_set_keymap('v', '?', '<plug>NERDCommenterToggle', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '<C-/>', '<plug>NERDCommenterToggle', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '', '<plug>NERDCommenterToggle', { noremap = true, silent = true }) -- tmux specific
    end
}
