return {
  { "projekt0n/github-nvim-theme" }, -- Theme inspired by Github
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "warmer",
      lualine = {
        transparent = true, -- lualine center bar transparency
      },
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "github_light_default",
      colorscheme = "onedark",
    },
  },
}
