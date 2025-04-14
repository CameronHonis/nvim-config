local MAX_PAGE_N = 10
local M = {
    bufns = {},
    buf_idx = -1,
    winn = nil,
    vtxt = {
        ns_id = vim.api.nvim_create_namespace('fixed_top_right_corner'),
        last = {
            nbufs = 1,
            buf_idx = 1,
            t = 0,
        }

    }
}

M.set_page_idx = function(idx)
    M.buf_idx = idx
    local bufn = M.bufns[M.buf_idx]
    vim.api.nvim_win_set_buf(M.winn, bufn)
    M.draw_vtxt()

    return bufn
end

M.new_page = function()
    if #M.bufns == MAX_PAGE_N then
        print('cannot create new terminal page, would exceed max limit')
        return
    end

    local bufn = vim.api.nvim_create_buf(false, true)
    M.bufns[#M.bufns + 1] = bufn

    -- change buffer to terminal type
    vim.api.nvim_buf_call(bufn, function()
        vim.fn.termopen(vim.o.shell)
    end)

    -- set keymaps to this buffer
    vim.keymap.set({ 't', 'n', 'i' }, '<C-t>', M.new_page,
        { noremap = true, desc = 'add new terminal page', buffer = bufn })
    vim.keymap.set({ 't', 'n', 'i' }, '<C-w>', M.remove_current_page,
        { noremap = true, desc = 'remove current terminal page', buffer = bufn, nowait = true })
    vim.keymap.set({ 't', 'n', 'i' }, '<C-h>', M.goto_prev_page,
        { noremap = true, desc = 'goto prev terminal page', buffer = bufn })
    vim.keymap.set({ 't', 'n', 'i' }, '<C-l>', M.goto_next_page,
        { noremap = true, desc = 'goto next terminal page', buffer = bufn })

    M.set_page_idx(#M.bufns)

    -- enter terminal (insert) mode
    vim.api.nvim_set_current_buf(bufn)
    vim.cmd('startinsert')

    return bufn
end

M.remove_current_page = function()
    return M.remove_page(M.buf_idx)
end

M.remove_page = function(idx)
    local del_bufn = M.bufns[idx]
    if #M.bufns == 1 then
        M.close()
    elseif idx == M.buf_idx then
        M.goto_prev_page()
    end

    table.remove(M.bufns, idx)
    vim.api.nvim_buf_delete(del_bufn, { force = true })
    M.draw_vtxt()
end

M.is_visible = function()
    return M.winn and vim.api.nvim_win_is_valid(M.winn)
end

M.draw_vtxt = function()
    if M.vtxt.last.nbufs == #M.bufns and M.vtxt.last.buf_idx == M.buf_idx then
        return
    end
    M.vtxt.last.nbufs = #M.bufns
    M.vtxt.last.buf_idx = M.buf_idx
    M.vtxt.last.t = vim.uv.now()

    local function vtxt()
        local rtn = {}
        for i = 1, #M.bufns do
            if i == M.buf_idx then
                --table.insert(rtn, '')
                table.insert(rtn, ' ')
            else
                --table.insert(rtn, '')
                table.insert(rtn, ' ')
            end
        end
        return table.concat(rtn) .. '    '
    end

    local bufn = vim.api.nvim_get_current_buf()

    local function draw(is_visible)
        vim.api.nvim_buf_clear_namespace(bufn, M.vtxt.ns_id, 0, -1)
        local top_line = vim.fn.line('w0') - 1
        vim.api.nvim_buf_set_extmark(bufn, M.vtxt.ns_id, top_line, 0, {
            virt_text = { { is_visible and vtxt() or '' } },
            virt_text_pos = 'right_align',
        })
    end

    draw(true)

    -- create new autocmd to anchor position when scrolling
    local autocmd_id = vim.api.nvim_create_autocmd({ 'WinScrolled', 'VimResized' }, {
        buffer = bufn,
        callback = draw
    })

    vim.defer_fn(function()
        pcall(function() vim.api.nvim_del_autocmd(autocmd_id) end)
        local dt = vim.uv.now() - M.vtxt.last.t
        if dt > 1950 then
            draw(false)
        end
    end, 2000)
end

M.resize_window = function(winn, opts)
    if not vim.api.nvim_win_is_valid(winn) then
        return
    end

    local config = vim.api.nvim_win_get_config(winn)
    config.width = opts.width or math.floor(vim.o.columns * 0.9)
    config.height = opts.height or math.floor(vim.o.lines * 0.9)
    config.col = math.floor((vim.o.columns - config.width) / 2)
    config.row = math.floor((vim.o.lines - config.height - 3) / 2)
    vim.api.nvim_win_set_config(winn, config)
end

M.open = function(opts)
    if M.is_visible() then
        return
    end

    opts = opts or {}

    -- reset vtxt cache
    M.vtxt.last.buf_idx = 1
    M.vtxt.last.nbufs = 1

    -- apply colors
    local bg_color = opts.bg_color or '#101214'
    vim.cmd(string.format('highlight FloatermBorder guifg=%s guibg=%s', bg_color, bg_color))
    vim.cmd(string.format('highlight FloatermNormal guibg=%s', bg_color))


    local win_config = {
        relative = 'editor',
        row = 0,
        col = 0,
        width = 1,
        height = 1,
        style = 'minimal',
        border = opts.border or 'single',
    }

    local tmp_bufn = vim.api.nvim_create_buf(false, true)
    M.winn = vim.api.nvim_open_win(tmp_bufn, true, win_config)
    vim.wo[M.winn].winhighlight = 'Normal:FloatermNormal,FloatBorder:FloatermBorder'

    local bufn
    if #M.bufns == 0 then
        bufn = M.new_page()
    elseif M.bufns[M.buf_idx] == nil then
        bufn = M.set_page_idx(1)
    else
        bufn = M.set_page_idx(M.buf_idx)
    end

    -- cleanup temp buf
    vim.api.nvim_buf_delete(tmp_bufn, { force = true })

    -- hack to force insert mode after temp buffer deleted
    vim.api.nvim_set_current_buf(bufn)
    vim.cmd('startinsert')

    -- dynamically resize to maintain screen proportions
    local autocmd_id = vim.api.nvim_create_autocmd('WinResized', {
        pattern = '*',
        desc = 'reposition floaterminal window',
        callback = function()
            vim.schedule(function() M.resize_window(M.winn, opts) end)
        end,
    })

    M.resize_window(M.winn, opts)

    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(M.winn),
        once = true,
        desc = 'clean up auto-resize floaterminal window',
        callback = function()
            pcall(vim.api.nvim_del_autocmd, autocmd_id)
        end,
    })

    return {
        bufn = bufn,
        winn = M.winn
    }
end

M.close = function()
    if not M.is_visible() then
        return
    end

    vim.api.nvim_win_close(M.winn, false)
    M.winn = nil
end

M.goto_prev_page = function()
    -- cycle back one idx
    local idx = (M.buf_idx + #M.bufns - 2) % #M.bufns + 1
    M.set_page_idx(idx)
end

M.goto_next_page = function()
    -- cycle forward one idx
    local idx = M.buf_idx % #M.bufns + 1
    M.set_page_idx(idx)
end

M.toggle = function()
    if M.is_visible() then
        M.close()
    else
        M.open()
    end
end

M.setup = function(opts)
    opts = opts or {}
    vim.api.nvim_create_user_command('FloaterminalToggle', M.toggle, {})
end

return M
