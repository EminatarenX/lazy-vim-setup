-- Configuración para REST Client (APIs)
-- Deshabilitado temporalmente porque rest.nvim requiere luarocks/hererocks
-- que está causando problemas de instalación
-- Puedes usar curl directamente o instalar rest.nvim manualmente más adelante
return {
  {
    "rest-nvim/rest.nvim",
    enabled = false, -- Deshabilitado porque requiere luarocks/hererocks
  },
}

