-- Configuración para formateo de Terraform
return {
  -- Configurar conform.nvim para Terraform
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.terraform = { "terraform_fmt" }
      opts.formatters_by_ft["terraform-vars"] = { "terraform_fmt" }
      opts.formatters_by_ft.hcl = { "terraform_fmt" }

      -- Configurar el formateador de terraform
      opts.formatters = opts.formatters or {}
      opts.formatters.terraform_fmt = {
        command = "terraform",
        args = { "fmt", "-" },
        stdin = true,
      }

      return opts
    end,
  },

  -- Configurar terraform-ls como LSP server
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.terraformls = {
        settings = {
          terraform = {
            format = {
              enable = false, -- Deshabilitado: formateo automático causa problemas en PRs
            },
          },
        },
      }
      return opts
    end,
  },

  -- Agregar parser de treesitter para terraform
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "terraform", "hcl" })
      end
      return opts
    end,
  },

  -- Asegurar que terraform-ls esté disponible (se instala a través de mason-lspconfig)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "terraform-ls" })
      end
      return opts
    end,
  },
}

