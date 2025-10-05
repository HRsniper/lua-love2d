function arquivoExiste(nomeArquivo)
    local info = love.filesystem.getInfo(nomeArquivo)
    return info ~= nil and info.type == "file"
end

function diretorioExiste(nomeDiretorio)
    local info = love.filesystem.getInfo(nomeDiretorio)
    return info ~= nil and info.type == "directory"
end

-- Exemplo de uso
if arquivoExiste("config.txt") then
    print("Arquivo de configuração encontrado!")
else
    print("Criando arquivo de configuração...")
end

print("Arquivo criado com sucesso!")
