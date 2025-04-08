local diagnostics = require('utils.diagnostics')
local toggle_terminal = require('utils.toggle_terminal').toggle_terminal

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

require('lazy').setup({
    { 'folke/tokyonight.nvim' },
    { 'VonHeikemen/lsp-zero.nvim',              branch = 'v3.x' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        }
    },
    { 'preservim/nerdcommenter' },
    { 'mfussenegger/nvim-dap' },
    { 'rcarriga/nvim-dap-ui',                                         dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } },
    { 'ya2s/nvim-cursorline' },
    { dir = vim.fn.stdpath('config') .. '/lua/indent-blankline.nvim', main = 'ibl' },
    { 'f-person/git-blame.nvim' },
    { 'echasnovski/mini.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' }, },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'kevinhwang91/nvim-ufo',                     dependencies = { 'kevinhwang91/promise-async' }, },
    { 'nvim-lualine/lualine.nvim',                 dependencies = { 'nvim-tree/nvim-web-devicons' }, },
})

vim.cmd.colorscheme('habamax')

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.cursorline = true
vim.opt.paste = false
vim.opt.ignorecase = true
vim.opt.swapfile = true
vim.opt.directory = '.'

vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd('hi Normal guibg=NONE ctermbg=NONE')


vim.diagnostic.config({
    severity_sort = true,     -- Sort diagnostics by severity (errors first)
    float = {
        severity_sort = true, -- Sort errors first in floating windows too
    },
    signs = true,
})

-- Set diagnostic underline colors based on severity
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = '#ff0000' }) -- Red for errors
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = '#ffcc00' })  -- Yellow for warnings
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = '#0099ff' })  -- Blue for info
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = '#00cc99' })  -- Green for hints

-- nops
vim.api.nvim_set_keymap('n', '<C-S-O>', '<Nop>', { noremap = true, silent = true })

-- reload nvim config
vim.api.nvim_set_keymap('n', '<C-r>', '<cmd>luafile $MYVIMRC<CR>', { noremap = true, silent = true })

-- fuzzy find file by name
vim.api.nvim_set_keymap('n', '<C-P>', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })

-- fuzzy find file contents (ripgrep)
vim.api.nvim_set_keymap('n', 'rg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })

-- document symbol jumps
vim.api.nvim_set_keymap('n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })

-- forward/back nav
vim.api.nvim_set_keymap('n', 'H', '<C-o>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'L', '<C-i>', { noremap = true, silent = true })

-- more fine grained undo/redo
vim.keymap.set("i", "<space>", "<space><c-g>u", { noremap = true })
vim.keymap.set("i", ".", ".<c-g>u", { noremap = true })
vim.keymap.set("i", ",", ",<c-g>u", { noremap = true })
vim.keymap.set("i", ";", ";<c-g>u", { noremap = true })
vim.keymap.set("i", "<CR>", "<CR><c-g>u", { noremap = true })

vim.api.nvim_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', { noremap = true, silent = true })

-- jump to diagnostics
vim.keymap.set('n', '<C-A-j>', diagnostics.jump_to_next_diagnostic, { noremap = true, silent = true })
vim.keymap.set('n', '<C-A-k>', diagnostics.jump_to_prev_diagnostic, { noremap = true, silent = true })

-- lsp/linter shorts
vim.api.nvim_set_keymap('n', '<M-C-P>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-C-R>', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-CR>', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-A-,>', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-,>', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

-- block comment toggle
vim.api.nvim_set_keymap('v', '?', '<plug>NERDCommenterToggle', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-/>', '<plug>NERDCommenterToggle', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '', '<plug>NERDCommenterToggle', { noremap = true, silent = true }) -- tmux specific

-- debug controls
vim.api.nvim_set_keymap('n', '<M-C-B>', '<cmd>lua require"dap".toggle_breakpoint()<CR>',
    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-C-C>', '<cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-C-L>', '<cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-NL>', '<cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-C-Space>', '<cmd>lua require"dap".repl.open()<CR>', { noremap = true, silent = true })

-- terminal toggle
vim.keymap.set('n', '<M-C-Y>', toggle_terminal, { noremap = true, silent = true })
vim.keymap.set('t', '<M-C-Y>', toggle_terminal, { noremap = true, silent = true })

-- terminal navigation toggle
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- switch to editing this config file
vim.api.nvim_set_keymap('n', '<M-C-A>', '<cmd>e $MYVIMRC<CR>', { noremap = true, silent = true })

-- jump up code block
vim.keymap.set('n', '<space>', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local config = require('ibl.config').get_config(bufnr)
    local scope = require('ibl.scope').get(bufnr, config, {})
    if scope then
        local row, column = scope:start()
        vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row + 1, column })
    end
end)

vim.api.nvim_set_keymap('n', 'c', '<cmd>Telescope git_commits<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'o', '<cmd>GitBlameOpenCommitURL<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<F5>', '<cmd>LspRestart<CR>', { noremap = true, silent = true })

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

vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope file_browser path=%:p:h select_buffer=true<CR>',
    { noremap = true, silent = true })
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Go to definition' })
vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'Go to definition' })
vim.keymap.set('n', 'gt', require('telescope.builtin').lsp_type_definitions, { desc = 'Go to definition' })

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' [%d] '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end,
    fold_virt_text_handler = handler
})

require('nvim-cursorline').setup {
    cursorline = {
        enable = true,
        timeout = 1000,
        number = false,
    },
    cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
    }
}

local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

--require('tabnine').setup({
--disable_auto_comment = true,
--accept_keymap = '',
----dismiss_keymap = '',
--debounce_ms = 800,
--suggestion_color = { gui = '#808080', cterm = 244 },
--exclude_filetypes = { 'TelescopePrompt', 'NvimTree' },
--})

require('ibl').setup()

require('gitblame').setup({
    enabled = true,
})

-- Function to rename the current file
vim.api.nvim_create_user_command('Rename', function(opts)
    local new_name = opts.args
    if new_name == '' then
        new_name = vim.fn.input('New name: ', vim.fn.expand('%'), 'file')
    end

    if new_name ~= '' and new_name ~= vim.fn.expand('%') then
        -- Save current file
        vim.cmd('write')

        -- Rename the file
        local ok, err = os.rename(vim.fn.expand('%:p'), vim.fn.fnamemodify(new_name, ':p'))

        if not ok then
            vim.notify('Error renaming file: ' .. err, vim.log.levels.ERROR)
            return
        end

        -- Open the new file
        vim.cmd('edit ' .. new_name)
    end
end, { nargs = '?', complete = 'file' })

local fb_actions = require 'telescope'.extensions.file_browser.actions
require('telescope').setup {
    defaults = {
        initial_mode = "normal",
    },
    pickers = {
        find_files = {
            hidden = true,
            initial_mode = "insert",
        },
        live_grep = {
            hidden = true,
            initial_mode = "insert",
        },
        lsp_document_symbols = {
            initial_mode = "insert",
        },
    },
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown()
        },
        file_browser = {
            hidden = true,
            mappings = {
                ['n'] = {
                    ['H'] = fb_actions.goto_parent_dir,
                }
            }
        }
    }
}
require('telescope').load_extension 'ui-select'
require('telescope').load_extension 'file_browser'

local make_openrouter_adapter = function(model)
    return function()
        local openrouter_key = os.getenv("OPENROUTER_API_KEY")
        print("openrouter key = " .. openrouter_key)
        return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
                url = "https://openrouter.ai/api",
                api_key = openrouter_key,
                chat_url = "/v1/chat/completions",
            },
            schema = {
                model = {
                    default = model,
                },
            },
        })
    end
end

require("codecompanion").setup({
    display = {
        action_palette = {
            opts = {
                show_default_actions = true,
                show_default_prompt_library = true,
            }
        }
    },
    adapters = {
        ["gemini 2.5 pro (free)"] = make_openrouter_adapter("google/gemini-2.5-pro-exp-03-25:free"),
        ["deepseek v3 (free)"] = make_openrouter_adapter("deepseek/deepseek-chat-v3-0324:free"),
        ["llama 4 scout (free)"] = make_openrouter_adapter("meta-llama/llama-4-scout:free"),
    },
    strategies = {
        chat = {
            adapter = "gemini 2.5 pro (free)",
        },
        inline = {
            adapter = "anthropic",
        },
    },
})

vim.keymap.set('n', '<M-;>', function()
    require("codecompanion").toggle()
end, { desc = "Toggle CodeCompanion chat window" })

require('mini.diff').setup({
    -- Options for how hunks are visualized
    view = {
        -- Visualization style. Possible values are 'sign' and 'number'.
        -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
        style = vim.go.number and 'number' or 'sign',

        -- Signs used for hunks with 'sign' view
        signs = { add = '▒', change = '▒', delete = '▒' },

        -- Priority of used visualization extmarks
        priority = 199,
    },

    -- Source(s) for how reference text is computed/updated/etc
    -- s content from Git index by default
    source = nil,

    -- Delays (in ms) defining asynchronous processes
    delay = {
        -- How much to wait before update following every text change
        text_change = 200,
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
        -- Apply hunks inside a visual/operator region
        apply = '<C-a>h',

        -- Reset hunks inside a visual/operator region
        reset = '<C-x>h',

        -- Hunk range textobject to be used inside operator
        -- Works also in Visual mode if mapping differs from apply and reset
        textobject = '',

        -- Go to hunk range in corresponding direction
        goto_first = '',
        goto_prev = 'gH',
        goto_next = 'gh',
        goto_last = '',
    },

    -- Various options
    options = {
        -- Diff algorithm. See `:h vim.diff()`.
        algorithm = 'histogram',

        -- Whether to use "indent heuristic". See `:h vim.diff()`.
        indent_heuristic = true,

        -- The amount of second-stage diff to align lines (in Neovim>=0.9)
        linematch = 60,

        -- Whether to wrap around edges during hunk navigation
        wrap_goto = false,
    },
})

local is_diff_on = false
vim.keymap.set('n', '<C-A-d>', function()
    require('mini.diff').toggle_overlay()
    is_diff_on = not is_diff_on
    if is_diff_on then
        print("diff mode: ON")
    else
        print("diff mode: OFF")
    end
end, { desc = 'toggle minidiff overlay' })

require("evil_lualine")

-- TODO:
-- diff
-- show current file changes compared to last commit
-- show current file changes compared to HEAD

-- debug
-- debug/run shortcuts
