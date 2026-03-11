-- Deshabilitar formateo automático en todos los tipos de archivo.
-- El desactivado global está en lua/config/options.lua: vim.g.autoformat = false
-- Aquí se refuerza en conform.nvim y en LSPs que formatean al guardar.

return {
  -- Conform: sin formateo al guardar (para todos los filetypes)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.format_on_save = false
      return opts
    end,
  },

  -- Terraform LSP: sin formateo automático
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.terraformls = opts.servers.terraformls or {}
      opts.servers.terraformls.settings = opts.servers.terraformls.settings or {}
      opts.servers.terraformls.settings.terraform = opts.servers.terraformls.settings.terraform or {}
      opts.servers.terraformls.settings.terraform.format = { enable = false }
      return opts
    end,
  },
}
