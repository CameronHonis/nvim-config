return {
    dir = vim.fn.stdpath('config') .. '/lua/notorious',
    config = function()
        require('notorious').setup()
    end
}
