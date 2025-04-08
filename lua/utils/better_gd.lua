local M = {}

M.better_gd = function()
    -- Call the built-in definition behavior
    vim.lsp.buf.definition()

    -- Wait a brief moment for the quickfix list to populate
    vim.defer_fn(function()
        -- Get the quickfix list
        local qf_items = vim.fn.getqflist()

        if #qf_items == 0 then
            -- Nothing to filter if empty
            return
        end

        -- Filter out redundant line entries
        local filtered_items = {}
        local seen_lines = {}

        for _, item in ipairs(qf_items) do
            local key = item.bufnr .. ':' .. item.lnum
            if not seen_lines[key] then
                seen_lines[key] = true
                table.insert(filtered_items, item)
            end
        end

        -- Replace the quickfix list with filtered results
        vim.fn.setqflist(filtered_items)

        -- If there's exactly one result, jump directly to it and close
        if #filtered_items == 1 then
            vim.cmd('cfirst')
            vim.cmd('cclose')
            return
        end

        -- Find the quickfix window if it's open
        local qf_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
            if buf_type == 'quickfix' then
                qf_win = win
                break
            end
        end

        -- If quickfix window is open, set up keymapping directly
        if qf_win then
            local qf_buf = vim.api.nvim_win_get_buf(qf_win)
            vim.api.nvim_buf_set_keymap(qf_buf, 'n', '<CR>',
                '<CR>:cclose<CR>', { noremap = true, silent = true })

            -- Also set up autocommand for the specific buffer
            vim.cmd([[
        augroup QuickFixClose
          autocmd!
          autocmd BufWinEnter quickfix nnoremap <buffer> <CR> <CR>:cclose<CR>
        augroup END
      ]])
        end
    end, 50) -- 50ms delay to ensure quickfix is populated
end

M.gd_handler = function(_, result, ctx, _)
    if not result or vim.tbl_isempty(result) then
        vim.notify("No definition found", vim.log.levels.WARN)
        return
    end

    -- Convert to a standard format that we can work with
    local locations = vim.lsp.util.locations_to_items(result, ctx.bufnr)

    if #locations == 1 then
        -- If there's only one result, jump directly to it
        local location = result[1]
        vim.cmd(string.format("edit +call cursor(%d,%d) %s",
            location.range.start.line + 1,
            location.range.start.character + 1,
            vim.uri_to_fname(location.uri)))
    else
        -- Format options for selection
        local options = {}
        for i, loc in ipairs(locations) do
            local filename = vim.fn.fnamemodify(loc.filename, ":~:.")
            table.insert(options, {
                text = string.format("%s:%d:%d - %s", filename, loc.lnum, loc.col, loc.text or ""),
                location = result[i]
            })
        end

        -- Show vim.ui.select with options
        vim.ui.select(options, {
            prompt = "Select definition",
            format_item = function(item)
                return item.text
            end
        }, function(choice)
            if not choice then
                return
            end

            -- Jump to the selected location
            local location = choice.location
            vim.cmd(string.format("edit +call cursor(%d,%d) %s",
                location.range.start.line + 1,
                location.range.start.character + 1,
                vim.uri_to_fname(location.uri)))
        end)
    end
end

return M
