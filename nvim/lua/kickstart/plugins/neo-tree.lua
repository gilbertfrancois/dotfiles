-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '<leader>fe',
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
    -- { '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (root dir)', remap = true },
  },
  -- keys = {
  --   { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  -- },
  -- opts = {
  --   filesystem = {
  --     window = {
  --       mappings = {
  --         ['\\'] = 'close_window',
  --       },
  --     },
  --   },
  -- },
}
