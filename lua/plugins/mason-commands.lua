-- Keymaps y comandos personalizados para Mason y LSP
return {
  -- Agregar comandos personalizados para Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Asegurar que las herramientas necesarias estén instaladas
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "jdtls", -- Java Language Server
          "terraform-ls", -- Terraform Language Server
          "yaml-language-server", -- YAML Language Server
          "dockerfile-language-server", -- Docker Language Server
          "json-lsp", -- JSON Language Server
        })
      end
      return opts
    end,
  },
}

