return {
    "sphamba/smear-cursor.nvim",
    version = 'v0.*',
    config = function()
        require('smear_cursor').setup({
            enabled = true,
            cursor_color = '#aaaaaa',
        })
    end
}
