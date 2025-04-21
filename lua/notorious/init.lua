local M = {}

M.CreateConceptFile = function()
    local curr_file_name = vim.fn.expand('%:t')
    local to_link_input = vim.fn.input('Link from ' .. curr_file_name .. '? [y/n]')
    local to_link = to_link_input == 'y'

    local filename = vim.fn.input('Enter file name: ')
    if not filename:match('%.md$') then
        filename = filename .. '.md'
    end

    local template = '**date:** ' .. os.date('%d-%b-%Y')
    template = template .. '\n**type:** concept'
    if to_link then
        template = template .. '\n**origin:** [[' .. curr_file_name .. ']]'
    end
    template = template .. '\n\n'

    -- Create or open the file
    local file = io.open(filename, 'w')
    if file then
        file:write(template)
        file:close()
    end

    -- open file in the current buf
    vim.cmd('edit ' .. filename)

    -- move to bottom of file and enter insert mode
    local lines_cnt = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { lines_cnt, 0 })
    vim.cmd('startinsert')
end

M.setup = function(opts)
    opts = opts or {}

    vim.api.nvim_create_user_command('Concept', M.CreateConceptFile, {})
end

return M
