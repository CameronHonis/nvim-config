local M = {}

---@param opts? {
--- file_path?: string
--- verbose?: boolean
---}
---@return boolean
M.load_dotenv = function(opts)
    opts = opts or {}
    file_path = opts.file_path or '.env'
    verbose = opts.verbose or false

    local file = io.open(file_path, "r")
    if not file then return false end

    for line in file:lines() do
        -- Skip comments and empty lines
        if line:match("^%s*#") or not line:match("%S") then
            goto continue
        end

        -- Extract key-value pair
        local key, value = line:match("^%s*(%S+)%s*=%s*(.+)%s*$")
        if key and value then
            -- Remove quotes if present
            value = value:gsub("^[\"'](.+)[\"']$", "%1")
            -- Set environment variable
            if verbose then
                print(key, value)
            end
            vim.fn.setenv(key, value)
        end

        ::continue::
    end
    file:close()
    return true
end

return M
