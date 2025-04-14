local function display_fixed_top_right_text(text, highlight_group)
    local bufnr = vim.api.nvim_get_current_buf()
    local ns_id = vim.api.nvim_create_namespace('fixed_top_right_corner')

    -- Function to update the position when scrolling
    local function update_position()
        vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
        local top_line = vim.fn.line('w0') - 1
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, top_line, 0, {
            virt_text = { { text, highlight_group or "Normal" } },
            virt_text_pos = 'right_align',
        })
    end

    -- Initial position
    update_position()

    -- Create autocommands to update when scrolling
    vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized" }, {
        buffer = bufnr,
        callback = update_position
    })
end

--display_fixed_top_right_text("Hello, top right!")
--vim.defer_fn(function()
--display_fixed_top_right_text("")
--end, 2000)
--
--local a = vim.uv.now()
--vim.defer_fn(function()
--local b = vim.uv.now()
--print(b - a)
----print((b - a) / 1000000)
--end, 2000)
--

-- Create a sample array
--local myArray = {10, 20, 30, 40, 50, 60}

---- Print the original array
--print("Original array:")
--for i, value in ipairs(myArray) do
--print(i, value)
--end

---- Remove element at index 3 (value 30 in this example)
--local indexToRemove = 3
--table.remove(myArray, indexToRemove)

---- Print the modified array
--print("\nArray after removing element at index " .. indexToRemove .. ":")
--for i, value in ipairs(myArray) do
--print(i, value)
--ends
--

local new_page = function()
    local bufn = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_call(bufn, function()
        vim.fn.termopen(vim.o.shell)
    end)

    -- set keymaps to this buffer
    vim.keymap.set({ 't', 'i' }, '<C-t>', function() print("hello") end, { noremap = true, desc = 'Add new terminal page', buffer = bufn })

    return bufn
end

local open = function(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.9)
    local height = opts.height or math.floor(vim.o.lines * 0.9)
    local start_x = math.floor((vim.o.columns - width) / 2)
    local start_y = math.floor((vim.o.lines - height) / 2)

    local bufn = new_page()
    -- apply colors
    local bg_color = opts.bg_color or '#202428'
    vim.cmd(string.format("highlight FloatermBorder guifg=%s guibg=%s", bg_color, bg_color))
    vim.cmd(string.format("highlight FloatermNormal guibg=%s", bg_color))


    local win_config = {
        relative = 'editor',
        width = width,
        height = height,
        col = start_x,
        row = start_y,
        style = 'minimal',
        border = opts.border or 'single',
    }

    local winn = vim.api.nvim_open_win(bufn, true, win_config)
    vim.wo[winn].winhighlight = 'Normal:FloatermNormal,FloatBorder:FloatermBorder'

    vim.cmd('startinsert')
end

local input = vim.fn.input('does this thing work? (type y/n): ', 'y')
if input == 'y' then
    print('awesome')
else
    print('oops! you said '..input)
end
