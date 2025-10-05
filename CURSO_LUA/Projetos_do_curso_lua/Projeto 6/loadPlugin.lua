--[[ Sistema de Plugins em Sandbox ]]

-- Função para carregar plugin em sandbox
local function loadPlugin(path, allowed)
    local env = {}
    for k in pairs(allowed) do
        env[k] = _G[k] -- env.print = _G.print
    end

    local chunk, err = loadfile(path, "t", env)
    if not chunk then error(err) end
    return chunk()
end

-- API mínima exposta ao plugin
local allowed = { print = true, math = true, pairs = true }

-- Plugin de exemplo (arquivo plugin.lua):
-- return {
--   name = "Teste",
--   action = function() print("Plugin executado!") end
-- }

local function validatePlugin(plugin)
    local ok, err = pcall(function()
        assert(type(plugin) == "table", "O plugin deve retornar uma tabela")
        assert(type(plugin.name) == "string", "O plugin deve conter um campo 'name' do tipo string")
        assert(type(plugin.action) == "function", "O plugin deve conter uma função 'action'")
    end)
    return ok, err
end


-- Uso do sistema
local plugin = loadPlugin("plugin.lua", allowed)

local valid, err = validatePlugin(plugin)
if not valid then
    print("Erro ao validar o plugin: " .. err)
    return
end

print("Carregado:", plugin.name)
plugin.action()
