-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Autosave configuration
local autosave_group = vim.api.nvim_create_augroup("autosave", { clear = true })

-- Timer para guardar después de inactividad
local autosave_timer = nil
local uv = vim.uv or vim.loop

-- Función para guardar el buffer actual si tiene cambios
local function save_buffer()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified and vim.bo[buf].buftype == "" and vim.fn.expand("%") ~= "" then
    vim.cmd("silent! write")
  end
end

-- Guardar al salir del modo insertar
vim.api.nvim_create_autocmd("InsertLeave", {
  group = autosave_group,
  pattern = "*",
  callback = function()
    save_buffer()
  end,
  desc = "Autosave on insert leave",
})

-- Guardar al perder el foco de la ventana
vim.api.nvim_create_autocmd("FocusLost", {
  group = autosave_group,
  pattern = "*",
  callback = function()
    save_buffer()
  end,
  desc = "Autosave on focus lost",
})

-- Guardar después de un tiempo de inactividad (debounce)
vim.api.nvim_create_autocmd("TextChanged", {
  group = autosave_group,
  pattern = "*",
  callback = function()
    -- Cancelar el timer anterior si existe
    if autosave_timer then
      autosave_timer:stop()
      autosave_timer:close()
    end

    -- Crear un nuevo timer que guardará después de 1 segundo de inactividad
    autosave_timer = uv.new_timer()
    autosave_timer:start(1000, 0, function()
      vim.schedule(function()
        save_buffer()
      end)
    end)
  end,
  desc = "Autosave after inactivity",
})

-- Limpiar el timer al salir
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = autosave_group,
  pattern = "*",
  callback = function()
    if autosave_timer then
      autosave_timer:stop()
      autosave_timer:close()
    end
  end,
  desc = "Cleanup autosave timer",
})

-- NOTA: Configuración personalizada de Java ELIMINADA
-- LazyVim extra ya maneja la detección de root del proyecto Java
-- Si intentamos hacerlo aquí, puede causar conflictos con nvim-jdtls
