-- Configuración para arreglar grep y búsqueda
return {
  -- Configurar grug-far.nvim (ya instalado)
  {
    "grug-far.nvim",
    opts = function(_, opts)
      opts = opts or {}
      -- Asegurar que grug-far use ripgrep si está disponible, sino grep
      if vim.fn.executable("rg") == 1 then
        opts.grep_command = "rg"
        opts.grep_args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
      elseif vim.fn.executable("grep") == 1 then
        opts.grep_command = "grep"
        opts.grep_args = { "--color=never", "-rnH", "." }
      end
      return opts
    end,
  },

  -- Configurar telescope para búsqueda con grep
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      
      -- Asegurar que telescope use ripgrep si está disponible, sino grep
      if vim.fn.executable("rg") == 1 then
        opts.defaults.vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        }
      elseif vim.fn.executable("grep") == 1 then
        -- Fallback a grep si ripgrep no está disponible
        -- Usar formato compatible con telescope
        opts.defaults.vimgrep_arguments = {
          "grep",
          "--color=never",
          "-rnH",
          ".",
        }
        -- Configurar el formato de salida para que telescope lo entienda
        opts.defaults.pickers = opts.defaults.pickers or {}
        opts.defaults.pickers.grep_string = opts.defaults.pickers.grep_string or {}
        opts.defaults.pickers.grep_string.only_sort_text = true
      end
      return opts
    end,
  },
}

