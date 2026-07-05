return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        lazy = false,
        opts = {
            -- flavour = 'mocha',
            transparent_background = true, -- Enabled transparency here
            term_colors = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                mason = true,
            },
        },
        config = function(_, opts)
            require('catppuccin').setup(opts)
        end,
    },
}
