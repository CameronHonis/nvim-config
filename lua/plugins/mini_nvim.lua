return {
    'echasnovski/mini.nvim',
    version = 'v0.*',
    config = function()
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
    end
}
