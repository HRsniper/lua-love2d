-- Verifica se o nome do arquivo foi passado
local input_path = arg[1]
if not input_path then
    io.stderr:write("❌ Uso: lua sub_aspas.lua <arquivo>\n")
    os.exit(1)
end

-- Tenta abrir o arquivo para leitura
local file, err = io.open(input_path, "r")
if not file then
    io.stderr:write("❌ Erro ao abrir arquivo: " .. err .. "\n")
    os.exit(1)
end

local content = file:read("*a")
file:close()

-- Função que substitui aspas dentro de R"( ... )"
local function substituir_aspas(str)
    return (str:gsub('R"%((.-)%)"', function(inner)
        inner = inner:gsub('"', "'")
        return 'R"(' .. inner .. ')"'
    end))
end

-- Gera o nome do backup (funciona para qualquer extensão)
local backup_path = input_path:gsub("(%.[^%.]+)$", "_backup%1")
if backup_path == input_path then
    -- se não tinha extensão, adiciona _backup no final
    backup_path = input_path .. "_backup"
end

-- Salva o backup
local backup = assert(io.open(backup_path, "w"))
backup:write(content)
backup:close()

-- Aplica a substituição
local result = substituir_aspas(content)

-- Sobrescreve o arquivo original
local out = assert(io.open(input_path, "w"))
out:write(result)
out:close()

print(("✅ Substituição concluída em '%s'\n💾 Backup salvo em '%s'"):format(input_path, backup_path))
