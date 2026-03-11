-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Comando de diagnóstico para jdtls
vim.api.nvim_create_user_command("JdtlsDiagnostic", function()
  local clients = vim.lsp.get_active_clients({ name = "jdtls" })
  
  if #clients == 0 then
    vim.notify("❌ jdtls NO está activo", vim.log.levels.ERROR)
    vim.notify("Intentando iniciar jdtls...", vim.log.levels.INFO)
    
    -- Verificar si hay un archivo Java abierto
    if vim.bo.filetype == "java" then
      vim.notify("Archivo Java detectado. Ejecuta :LspStart jdtls para iniciar manualmente", vim.log.levels.INFO)
    else
      vim.notify("No hay archivo Java abierto. Abre un archivo .java primero", vim.log.levels.WARN)
    end
  else
    vim.notify("✅ jdtls está activo (" .. #clients .. " cliente(s))", vim.log.levels.INFO)
    for _, client in ipairs(clients) do
      vim.notify("  - Workspace: " .. (client.config.root_dir or "N/A"), vim.log.levels.INFO)
      vim.notify("  - Estado: " .. (client.status or "unknown"), vim.log.levels.INFO)
    end
    
    -- Verificar autocompletado
    local blink_cmp_ok, _ = pcall(require, "blink.cmp")
    if blink_cmp_ok then
      vim.notify("✅ blink.cmp está cargado", vim.log.levels.INFO)
    else
      vim.notify("⚠️  blink.cmp NO está cargado", vim.log.levels.WARN)
    end
    
    -- Verificar que el LSP esté disponible como fuente
    local lsp_ok, _ = pcall(require, "blink.cmp.sources.lsp")
    if lsp_ok then
      vim.notify("✅ Fuente LSP disponible para blink.cmp", vim.log.levels.INFO)
    else
      vim.notify("⚠️  Fuente LSP NO disponible para blink.cmp", vim.log.levels.WARN)
    end
  end
  
  -- Verificar JAVA_HOME
  local java_home = vim.env.JAVA_HOME
  if java_home then
    vim.notify("✅ JAVA_HOME: " .. java_home, vim.log.levels.INFO)
  else
    vim.notify("⚠️  JAVA_HOME no está configurado", vim.log.levels.WARN)
  end
  
  -- Verificar pom.xml
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/pom.xml") == 1 then
    vim.notify("✅ pom.xml encontrado en: " .. cwd, vim.log.levels.INFO)
  else
    vim.notify("⚠️  pom.xml NO encontrado en: " .. cwd, vim.log.levels.WARN)
  end
  
  -- Sugerencia para probar autocompletado
  if #clients > 0 and vim.bo.filetype == "java" then
    vim.notify("💡 Prueba escribir 'Math.' y presiona Ctrl+Space para forzar autocompletado", vim.log.levels.INFO)
  end
end, { desc = "Diagnóstico de jdtls" })

-- Comandos personalizados para Mason y LSP (alias más simples)
vim.api.nvim_create_user_command("MasonInstall", function(args)
  if args.args and args.args ~= "" then
    -- Instalar un paquete específico
    local mason_registry = require("mason-registry")
    local package = mason_registry.get_package(args.args)
    if package then
      package:install()
      vim.notify("Instalando " .. args.args .. "...", vim.log.levels.INFO)
    else
      vim.notify("Paquete no encontrado: " .. args.args, vim.log.levels.ERROR)
    end
  else
    -- Abrir la UI de Mason
    require("mason.ui").open()
  end
end, { nargs = "?", desc = "Install Mason package or open Mason UI" })

-- Alias para LspInfo (el comando real en LazyVim)
vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd("lua vim.diagnostic.open_float()")
  -- También mostrar información del LSP
  local clients = vim.lsp.get_active_clients()
  if #clients > 0 then
    local info = {}
    for _, client in ipairs(clients) do
      table.insert(info, string.format("LSP: %s (id: %d)", client.name, client.id))
    end
    vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
  else
    vim.notify("No hay servidores LSP activos", vim.log.levels.WARN)
  end
end, { desc = "Show LSP information" })

-- Comando de prueba para auto imports en Java
vim.api.nvim_create_user_command("TestJavaAutoImports", function()
  -- Verificar que jdtls esté activo
  local clients = vim.lsp.get_active_clients({ name = "jdtls", bufnr = 0 })
  
  if #clients == 0 then
    vim.notify("❌ jdtls NO está activo. Abre un archivo .java primero.", vim.log.levels.ERROR)
    return
  end
  
  vim.notify("✅ jdtls está activo", vim.log.levels.INFO)
  
  -- Verificar configuración de auto imports
  local client = clients[1]
  if client and client.config and client.config.settings then
    local java_settings = client.config.settings.java
    if java_settings and java_settings.completion then
      local completion_enabled = java_settings.completion.enabled
      vim.notify("📋 Completado habilitado: " .. tostring(completion_enabled), vim.log.levels.INFO)
    end
  end
  
  -- Crear un archivo de prueba temporal
  local test_file = vim.fn.tempname() .. ".java"
  local test_content = [[
public class TestAutoImports {
    public static void main(String[] args) {
        // Prueba 1: Escribe "List" y presiona Ctrl+Space
        // Deberías ver sugerencias con auto import de java.util.List
        
        // Prueba 2: Escribe "ArrayList" y presiona Ctrl+Space
        // Deberías ver sugerencias con auto import de java.util.ArrayList
        
        // Prueba 3: Escribe "System.out.println" y presiona Enter
        // Debería agregar automáticamente "import java.lang.System;" si es necesario
        
        // Prueba 4: Escribe "Math.max" y presiona Enter
        // Debería agregar automáticamente "import java.lang.Math;" si es necesario
    }
}
]]
  
  vim.notify("📝 Cómo probar auto imports:", vim.log.levels.INFO)
  vim.notify("1. Abre un archivo .java en un proyecto Java (Maven/Gradle)", vim.log.levels.INFO)
  vim.notify("2. Escribe código sin imports, por ejemplo:", vim.log.levels.INFO)
  vim.notify("   - List<String> lista = new ArrayList<>();", vim.log.levels.INFO)
  vim.notify("   - System.out.println(\"test\");", vim.log.levels.INFO)
  vim.notify("3. Al escribir, el completado debería sugerir automáticamente los imports", vim.log.levels.INFO)
  vim.notify("4. Presiona Enter o Tab para aceptar la sugerencia", vim.log.levels.INFO)
  vim.notify("5. El import se agregará automáticamente al inicio del archivo", vim.log.levels.INFO)
  vim.notify("", vim.log.levels.INFO)
  vim.notify("💡 También puedes usar: <leader>co para organizar imports existentes", vim.log.levels.INFO)
end, { desc = "Probar auto imports en Java" })

-- Comando personalizado para abrir/cerrar la terminal
vim.api.nvim_create_user_command("Terminal", function()
  -- LazyVim usa toggleterm por defecto
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm")
  if toggleterm_ok then
    toggleterm.toggle()
  else
    -- Fallback: usar el terminal integrado de Neovim
    vim.cmd("terminal")
  end
end, { desc = "Abrir/cerrar terminal" })

-- Keymap adicional para terminal (si no está configurado)
-- LazyVim ya tiene <leader>ft por defecto, pero agregamos otro acceso rápido
vim.keymap.set("n", "<leader>tt", function()
  local toggleterm_ok, toggleterm = pcall(require, "toggleterm")
  if toggleterm_ok then
    toggleterm.toggle()
  else
    vim.cmd("terminal")
  end
end, { desc = "Toggle terminal" })

-- Comando para abrir terminal
vim.api.nvim_create_user_command("Term", function(args)
  local direction = args.args or "horizontal"
  
  if direction == "horizontal" or direction == "h" or direction == "" then
    -- Terminal horizontal (abajo)
    vim.cmd("split")
    vim.cmd("terminal")
    vim.cmd("resize 10")
  elseif direction == "vertical" or direction == "v" then
    -- Terminal vertical (derecha)
    vim.cmd("vsplit")
    vim.cmd("terminal")
    vim.cmd("vertical resize 80")
  elseif direction == "tab" or direction == "t" then
    -- Terminal en nueva pestaña
    vim.cmd("tabnew")
    vim.cmd("terminal")
  else
    vim.notify("Uso: :Term [horizontal|vertical|tab]", vim.log.levels.ERROR)
  end
end, { nargs = "?", desc = "Abrir terminal (horizontal/vertical/tab)" })

-- Selector de temas
vim.keymap.set("n", "<leader>ct", function()
  -- Lista de temas disponibles (nombres exactos como se cargan)
  local themes = {
    "tokyonight",
    "tokyonight-day",
    "tokyonight-night",
    "tokyonight-storm",
    "catppuccin",
    "catppuccin-latte",
    "catppuccin-frappe",
    "catppuccin-macchiato",
    "catppuccin-mocha",
    "gruvbox",
    "nord",
    "onedark",
    "onedark_dark",
    "onedark_vivid",
    "dracula",
    "rose-pine",
    "rose-pine-dawn",
    "rose-pine-moon",
    "kanagawa",
    "kanagawa-wave",
    "kanagawa-dragon",
    "kanagawa-lotus",
  }

  vim.ui.select(themes, {
    prompt = "Selecciona un tema:",
    format_item = function(item)
      return "🎨 " .. item
    end,
  }, function(choice)
    if choice then
      local ok, _ = pcall(vim.cmd, "colorscheme " .. choice)
      if ok then
        vim.notify("Tema cambiado a: " .. choice, vim.log.levels.INFO)
      else
        vim.notify("Error: No se pudo cargar el tema " .. choice, vim.log.levels.ERROR)
      end
    end
  end)
end, { desc = "Change colorscheme" })