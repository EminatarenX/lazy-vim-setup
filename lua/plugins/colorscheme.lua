-- Configuración de temas (colorschemes)
return {
  -- Temas ya instalados en LazyVim (asegurar que se carguen)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      transparent_background = true, -- Fondo transparente
    },
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    lazy = false,
    opts = {
      transparent = true, -- Fondo transparente
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- Temas adicionales
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    lazy = false,
    opts = {
      transparent_mode = true, -- Fondo transparente
    },
  },
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    priority = 1000,
    lazy = false,
  },
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    priority = 1000,
    lazy = false,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = false,
    opts = {
      disable_background = true, -- Fondo transparente
    },
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    lazy = false,
    opts = {
      transparent = true, -- Fondo transparente
    },
  },
    
  -- Configurar tema por defecto
    {
      "LazyVim/LazyVim",
      opts = {
      colorscheme = "catppuccin", -- Cambia por el que prefieras
      },
    },
  }

