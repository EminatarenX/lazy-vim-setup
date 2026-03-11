-- Configuración para neo-tree (file explorer) con iconos mejorados
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- Asegurar que los iconos estén habilitados y se muestren correctamente
      opts.default_component_configs = opts.default_component_configs or {}
      
      -- Configurar iconos de carpetas y archivos
      opts.default_component_configs.icon = vim.tbl_deep_extend("force", opts.default_component_configs.icon or {}, {
        folder_closed = "📁",
        folder_open = "📂",
        folder_empty = "📁",
        folder_empty_open = "📂",
        default = "📄",
        -- Los iconos de archivos específicos se manejan automáticamente por nvim-web-devicons
      })
      
      -- Asegurar que nvim-web-devicons esté habilitado para los iconos de archivos
      opts.default_component_configs.name = opts.default_component_configs.name or {}
      
      -- Configuración de la ventana para mejor visualización
      opts.window = opts.window or {}
      opts.window.width = opts.window.width or 35
      
      -- Asegurar que los iconos se muestren en todos los componentes
      opts.filesystem = opts.filesystem or {}
      opts.filesystem.use_libuv_file_watcher = true -- Para mejor rendimiento
      
      return opts
    end,
  },
  
  -- Configurar nvim-web-devicons para iconos de archivos
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      -- Los iconos por defecto están bien, pero podemos personalizarlos si queremos
      -- override = {
      --   java = {
      --     icon = "☕",
      --     color = "#f89820",
      --     name = "Java",
      --   },
      -- },
    },
  },
}
