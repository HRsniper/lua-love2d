-- Função para serializar tabelas em Lua
function tabelaParaString(tabela, indentacao)
    indentacao = indentacao or 0
    local espacos = string.rep("  ", indentacao)

    if type(tabela) ~= "table" then
        if type(tabela) == "string" then
            return '"' .. tabela:gsub('"', '\\"') .. '"'
        else
            return tostring(tabela)
        end
    end

    local resultado = "{\n"

    for chave, valor in pairs(tabela) do
        local chaveStr
        if type(chave) == "string" then
            chaveStr = '["' .. chave .. '"]'
        else
            chaveStr = "[" .. chave .. "]"
        end

        resultado = resultado .. espacos .. "  " .. chaveStr .. " = "
        resultado = resultado .. tabelaParaString(valor, indentacao + 1) .. ",\n"
    end

    resultado = resultado .. espacos .. "}"
    return resultado
end

function stringParaTabela(str)
    local env = {
        table = table
    }

    -- O uso de load("return " .. str) pode ser perigoso se você estiver lidando com dados externos ou modificáveis pelo usuário. Use bibliotecas seguras como Serpent ou JSON para serialização/desserialização sem execução de código.
    local func = load("return " .. str, "dados", "t", env)
    if func then
        return func()
    else
        return nil
    end
end

function arquivoExiste(nome)
    return love.filesystem.getInfo(nome) ~= nil
end

-- Sistema de save/load com serialização
function salvarDados(arquivo, dados)
    local str = tabelaParaString(dados)
    return love.filesystem.write(arquivo, str)
end

function carregarDados(arquivo, padrao)
    if arquivoExiste(arquivo) then
        local conteudo = love.filesystem.read(arquivo)
        local dados = stringParaTabela(conteudo)
        return dados or padrao
    else
        return padrao
    end
end

local jogador = {
    nome = "Carlos",
    nivel = 5,
    experiencia = 1200,
    inventario = {
        espada = true,
        pocao = 3,
        ouro = 250
    }
}
salvarDados("save.txt", jogador)

local dadosCarregados = carregarDados("save.txt")
for key, value in pairs(dadosCarregados) do
    print(key .. ": " .. tostring(value))
end
