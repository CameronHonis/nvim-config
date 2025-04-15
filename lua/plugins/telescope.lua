return {
    'nvim-telescope/telescope.nvim',
    version = 'v2.*',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    keys = {
        { '<C-P>', mode = { 'n', 'x', 'o' }, '<cmd>Telescope find_files<CR>',                             desc = 'open file search by name' },
        { 'rg',    mode = { 'n', 'x', 'o' }, '<cmd>Telescope live_grep<CR>',                              desc = 'open project rip grep' },
        { 'gs',    mode = { 'n', 'x', 'o' }, '<cmd>Telescope lsp_document_symbols<CR>',                   desc = 'open document symbol search' },
        { 'c',    mode = { 'n', 'x', 'o' }, '<cmd>Telescope git_commits<CR>',                            desc = 'open git commits explorer' },
        { 'o',    mode = { 'n', 'x', 'o' }, '<cmd>GitBlameOpenCommitURL<CR>',                            desc = 'open git blame commit in browser' },
        { '<C-f>', mode = { 'n', 'x', 'o' }, ':Telescope file_browser path=%:p:h select_buffer=true<CR>', desc = 'open file browser' },
        { 'gr',    mode = { 'n', 'x', 'o' }, require('telescope.builtin').lsp_references,                 desc = 'Go to reference(s)' },
        { 'gi',    mode = { 'n', 'x', 'o' }, require('telescope.builtin').lsp_implementations,            desc = 'Go to implementation(s)' },
        { 'gt',    mode = { 'n', 'x', 'o' }, require('telescope.builtin').lsp_type_definitions,           desc = 'Go to type definition(s)' },
    },
    config = function()
        local fb_actions = require 'telescope'.extensions.file_browser.actions
        require('telescope').setup {
            defaults = {
                initial_mode = "normal",
            },
            pickers = {
                find_files = {
                    hidden = true,
                    initial_mode = "insert",
                    find_command = {
                        "rg",
                        "--files",
                        "--glob",
                        "!.git/*",
                        "--path-separator",
                        "/",
                    },

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
                            ['<BS>'] = function() end,
                        },
                        ['i'] = {
                            ['<BS>'] = function() end,
                        }
                    }
                }
            }
        }
        require('telescope').load_extension 'ui-select'
        require('telescope').load_extension 'file_browser'


        local function search_backlinks()
            local search_txt = '[[' .. vim.fn.expand("%:t") .. ']]'
            require('telescope.builtin').live_grep({
                default_text = search_txt,
                prompt_title = "Find Backlinks",
                initial_mode = 'normal',
                additional_args = function()
                    return { "--no-ignore", "--fixed-strings" }
                end
            })
        end

        local function override_live_grep()
            vim.keymap.set({ 'n', 'i' }, 'rg', search_backlinks, {desc = 'live grep (backlinks)'})
        end

        -- autocommand that executes action when new buffer is opened
        vim.api.nvim_create_autocmd('BufReadPost', {
            callback = function()
                local file_name = vim.fn.expand("%:t")
                local is_markdown = file_name:match('.md' .. '$') ~= nil
                if is_markdown then
                    override_live_grep()
                end
            end,
        })
    end
}
