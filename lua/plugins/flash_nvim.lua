return {
    'folke/flash.nvim',
    version = 'v2.*',
    event = 'VeryLazy',
    keys = {
        { 'zk', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,       desc = 'Flash' },
        { 'Zk', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
}
