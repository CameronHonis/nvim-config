local M = {}

local has_error_diag = function()
    return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0
end

local has_warning_diag = function()
    return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0
end

local has_info_diag = function()
    return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) > 0
end

local has_hint_diag = function()
    return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) > 0
end

M.jump_to_next_diagnostic = function()
    if has_error_diag() then
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    elseif has_warning_diag() then
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
    elseif has_info_diag() then
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.INFO })
    elseif has_hint_diag() then
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.HINT })
    else
        print("no diagnostics :)")
    end
end

M.jump_to_prev_diagnostic = function()
    if has_error_diag() then
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    elseif has_warning_diag() then
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
    elseif has_info_diag() then
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.INFO })
    elseif has_hint_diag() then
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.HINT })
    else
        print("no diagnostics :)")
    end
end

return M
