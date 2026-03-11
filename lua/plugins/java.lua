-- Configuración de Java - Versión simplificada (LazyVim way)
-- IMPORTANTE: LazyVim extra ya maneja nvim-jdtls completamente
-- Solo configuramos cosas que NO interfieren con LazyVim

return {
  -- Configurar formateo de Java (esto SÍ es seguro agregar)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.java = { "google-java-format" }

      -- Configurar google-java-format
      opts.formatters = opts.formatters or {}
      opts.formatters["google-java-format"] = {
        command = "google-java-format",
        args = { "-" },
        stdin = true,
      }

      -- Alternativa: usar clang-format si google-java-format no está disponible
      opts.formatters["clang-format-java"] = {
        command = "clang-format",
        args = { "--assume-filename=file.java" },
        stdin = true,
      }

      return opts
    end,
  },

  -- Agregar parser de treesitter para java (esto también es seguro)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "java" })
      end
      return opts
    end,
  },

  -- NOTA: NO configuramos nvim-jdtls manualmente
  -- LazyVim extra (lazyvim.plugins.extras.lang.java) ya lo hace todo:
  -- - Configura nvim-jdtls
  -- - Detecta root del proyecto
  -- - Configura workspace
  -- - Maneja JAVA_HOME
  -- - Configura capabilities
  --
  -- Si intentamos configurarlo aquí, lo rompemos.
}
