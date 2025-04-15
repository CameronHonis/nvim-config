local diagnostics = require('utils.diagnostics')

require('utils.dotenv').load_dotenv({ file_path = vim.fn.stdpath('config') .. '/.env' })

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
    print('Installing lazy.nvim....')
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
    print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
    defaults = {
        lazy = false,
    }
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.paste = false
vim.opt.ignorecase = true
vim.opt.swapfile = true
vim.opt.directory = '.'
vim.opt.laststatus = 3
vim.opt.signcolumn = 'auto:2'

vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false  -- Optional: start with folds closed
vim.opt.foldlevelstart = 99 -- Optional: start with folds open

vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd('hi Normal guibg=NONE ctermbg=NONE')


vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,     -- Sort diagnostics by severity (errors first)
    float = {
        severity_sort = true, -- Sort errors first in floating windows too
    },
    signs = true,
})

-- Set diagnostic underline colors based on severity
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { underline = false, bg = '#dd0000' }) -- Red for errors
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { underline = false, bg = '#dd6600' })  -- Yellow for warnings
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { underline = false, bg = '#0066dd' })  -- Blue for info
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { underline = false, bg = '#00dd66' })  -- Green for hints


-- nops
vim.api.nvim_set_keymap('n', '<C-S-O>', '<Nop>', { noremap = true, silent = true })

-- forward/back nav
vim.api.nvim_set_keymap('n', 'H', '<C-o>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'L', '<C-i>', { noremap = true, silent = true })

-- more fine grained undo/redo
vim.keymap.set("i", "<space>", "<space><c-g>u", { noremap = true })
vim.keymap.set("i", ".", ".<c-g>u", { noremap = true })
vim.keymap.set("i", ",", ",<c-g>u", { noremap = true })
vim.keymap.set("i", ";", ";<c-g>u", { noremap = true })
vim.keymap.set("i", "<CR>", "<CR><c-g>u", { noremap = true })

-- jump to diagnostics
vim.keymap.set('n', '<C-j>', diagnostics.jump_to_next_diagnostic, { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', diagnostics.jump_to_prev_diagnostic, { noremap = true, silent = true })

-- switch to editing this config file
vim.api.nvim_set_keymap('n', '<C-A-A>', '<cmd>e $MYVIMRC<CR>', { noremap = true, silent = true })

vim.api.nvim_create_user_command('Rename', require('utils.rename_file'), { nargs = '?', complete = 'file' })

-- terminal navigation toggle
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- TODO:
-- picker for mini.diff source origin (default git index)
-- create snippets
-- create debug/run configs
--
-- Plugins to try:
-- obsidian.nvim
-- conform.nvim
