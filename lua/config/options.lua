-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Deshabilitar formateo automático en TODOS los tipos de archivo (formateo manual para evitar ruido en PRs)
vim.g.autoformat = false

-- Asegurar que el PATH incluya /opt/homebrew/bin para macOS (donde se instala ripgrep)
if vim.fn.has("mac") == 1 then
  local homebrew_bin = "/opt/homebrew/bin"
  local current_path = vim.env.PATH or ""
  if not string.find(current_path, homebrew_bin, 1, true) then
    vim.env.PATH = homebrew_bin .. ":" .. current_path
  end
end

-- Configuración para transparencia (Ghostty y otros terminales)
vim.opt.termguicolors = true -- Necesario para transparencia en terminales modernos

-- Función para aplicar transparencia
local function apply_transparency()
  -- Hacer el fondo transparente
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
end

-- Aplicar transparencia después de cargar el tema
local transparency_group = vim.api.nvim_create_augroup("Transparency", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = transparency_group,
  pattern = "*",
  callback = apply_transparency,
  desc = "Apply transparency after colorscheme loads",
})

-- Aplicar también al iniciar
vim.api.nvim_create_autocmd("VimEnter", {
  group = transparency_group,
  callback = function()
    vim.schedule(apply_transparency)
  end,
  desc = "Apply transparency on startup",
})

-- Configurar log level del LSP para evitar logs gigantes
vim.lsp.set_log_level("WARN") -- o "ERROR" para menos verbosidad

-- Configuración de tabs e indentación
vim.opt.tabstop = 4        -- Número de espacios que representa un tab
vim.opt.shiftwidth = 4     -- Número de espacios para indentación automática
vim.opt.softtabstop = 4    -- Número de espacios insertados al presionar Tab
vim.opt.expandtab = true   -- Convertir tabs en espacios (recomendado)
vim.opt.smartindent = true -- Indentación inteligente
vim.opt.autoindent = true  -- Mantener indentación de la línea anterior
