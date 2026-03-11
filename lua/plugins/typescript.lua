-- Configuración para TypeScript con auto imports mejorados
-- Nota: El extra de TypeScript ya se importa en lazy.lua
return {
  -- Extender configuración de tsserver con auto imports mejorados
  -- El extra de LazyVim ya configura typescript.nvim, solo extendemos las opciones
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- Extender la configuración existente de tsserver
      local tsserver_opts = opts.servers.tsserver or {}
      tsserver_opts.settings = vim.tbl_deep_extend("force", tsserver_opts.settings or {}, {
        typescript = {
          -- Habilitar auto imports
          suggest = {
            autoImports = true,
          },
          -- Configuraciones adicionales para mejor experiencia
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          suggest = {
            autoImports = true,
          },
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      })
      opts.servers.tsserver = tsserver_opts
      return opts
    end,
  },

  -- Configurar keymaps para comandos de TypeScript (solo si typescript.nvim está disponible)
  {
    "jose-elias-alvarez/typescript.nvim",
    keys = {
      {
        "<leader>co",
        function()
          if pcall(require, "typescript") then
            vim.cmd("TypescriptOrganizeImports")
          end
        end,
        desc = "Organize Imports (TS)",
        mode = { "n", "v" },
      },
      {
        "<leader>cR",
        function()
          if pcall(require, "typescript") then
            vim.cmd("TypescriptRenameFile")
          end
        end,
        desc = "Rename File (TS)",
      },
      {
        "<leader>ci",
        function()
          if pcall(require, "typescript") then
            vim.cmd("TypescriptAddMissingImports")
          end
        end,
        desc = "Add Missing Imports (TS)",
      },
      {
        "<leader>cF",
        function()
          if pcall(require, "typescript") then
            vim.cmd("TypescriptFixAll")
          end
        end,
        desc = "Fix All (TS)",
      },
    },
  },

  -- Nota: blink.cmp se configura automáticamente por LazyVim
  -- Los auto imports funcionarán a través de la fuente LSP de blink.cmp
}

