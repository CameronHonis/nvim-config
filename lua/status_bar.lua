-- Credit: glepnir & shadmansaleh
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = '#202834',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Update interval in seconds
local GIT_UPDATE_INTERVAL_SECS = 30

-- Add this near the top of your file, after your colors table
local git_cache = {
    ahead = 0,
    behind = 0,
    last_update = nil,
    branch = nil
}


local function update_git_status()
    if not conditions.check_git_workspace() then
        return
    end
    -- sync from remote
    vim.fn.system('git fetch --quiet')

    -- get current branch
    local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null'):gsub('\n', '')
    if vim.v.shell_error ~= 0 then return end

    git_cache.branch = branch

    -- count commits ahead/behind
    local ahead = vim.fn.system('git rev-list --count origin/' .. branch .. '..' .. branch .. ' 2>/dev/null'):gsub('\n',
        '')
    local behind = vim.fn.system('git rev-list --count ' .. branch .. '..origin/' .. branch .. ' 2>/dev/null'):gsub('\n',
        '')

    if vim.v.shell_error == 0 then
        git_cache.ahead = tonumber(ahead) or 0
        git_cache.behind = tonumber(behind) or 0
    end

    git_cache.last_update = os.time()
end

local function git_ahead_behind()
    if not conditions.check_git_workspace() then
        return ''
    end

    -- Check if we need to update the cache
    local current_time = os.time()
    if current_time - git_cache.last_update > GIT_UPDATE_INTERVAL_SECS then
        update_git_status()
    end

    local status = ''
    if git_cache.ahead > 0 then status = status .. '↑' .. git_cache.ahead .. ' ' end
    if git_cache.behind > 0 then status = status .. '↓' .. git_cache.behind end

    return status
end

-- Then add an autocmd to update the git status when needed
--vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
    --pattern = '*',
    --callback = function()
        --update_git_status()
    --end,
--})


-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

--ins_left {
--function()
--return '▊'
--end,
--color = { fg = colors.blue },    -- Sets highlighting of component
--padding = { left = 0, right = 1 }, -- We don't need space before this
--}

ins_left {
    'diff',
    -- Is it me or the symbol for modified us really weird
    symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
}


ins_left {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
        error = { fg = colors.red },
        warn = { fg = colors.yellow },
        info = { fg = colors.cyan },
    },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
    function()
        return '%='
    end,
}

ins_left {
    -- Lsp server name .
    function()
        local msg = 'no lsp'
        local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = ' ',
    color = { fg = '#ffffff', gui = 'bold' },
}

-- Add components to right sections
ins_right {
    'o:encoding',       -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = 'bold' },
}

ins_right {
    'fileformat',
    fmt = string.upper,
    icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
    color = { fg = colors.green, gui = 'bold' },
}

ins_right {
    'branch',
    icon = '',
    color = { fg = colors.violet, gui = 'bold' },
}

-- Then add this to your configuration after your 'branch' component
ins_right {
    git_ahead_behind,
    color = { fg = colors.blue, gui = 'bold' },
    cond = conditions.check_git_workspace,
}


--ins_right {
--function()
--return '▊'
--end,
--color = { fg = colors.blue },
--padding = { left = 1 },
--}

-- Now don't forget to initialize lualine
lualine.setup(config)
