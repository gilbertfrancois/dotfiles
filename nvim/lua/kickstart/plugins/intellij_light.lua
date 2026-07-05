-- return {
-- 'intellij_light',
-- dir = '~/Development/git/intellij_light.nvim',
-- config = function()
-- require('intellij_light').setup()
-- require('intellij_light').load()
-- end,
-- }
return {
    {
        'gilbertfrancois/intellij_light.nvim',
        priority = 1000,
        lazy = false,
        -- No config: colors/intellij_light.lua calls setup() when the colorscheme is loaded
    },
}
