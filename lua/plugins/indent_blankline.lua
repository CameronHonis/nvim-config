return {
    dir = vim.fn.stdpath('config') .. '/lua/indent-blankline.nvim',
    main = 'ibl',
    config = function()
        require('ibl').setup()
        -- jump up code block
        vim.keymap.set('n', 'K', function()
            local bufnr = vim.api.nvim_get_current_buf()
            local config = require('ibl.config').get_config(bufnr)
            local scope = require('ibl.scope').get(bufnr, config, {})
            if scope then
                local row, column = scope:start()
                vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row + 1, column })
            end
        end)
    end
}
