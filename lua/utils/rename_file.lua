return function(opts)
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
end
