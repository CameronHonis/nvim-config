return {
    'Davidyz/VectorCode',
    version = 'v0.*', -- optional, depending on whether you're on nightly or release
    build = 'pipx upgrade vectorcode',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Default configuration
        require('vectorcode').setup({
            async_opts = {
                debounce = 10,
                events = { 'BufWritePost', 'InsertEnter', 'BufReadPost' },
                exclude_this = true,
                n_query = 1,
                notify = false,
                query_cb = require('vectorcode.utils').make_surrounding_lines_cb(-1),
                run_on_register = false,
            },
            async_backend = 'default', -- or 'lsp'
            exclude_this = true,
            n_query = 3,
            notify = true,
            timeout_ms = 5000,
            on_setup = {
                update = false, -- set to true to enable update when `setup` is called.
                lsp = false,
            }
        })
    end
}
