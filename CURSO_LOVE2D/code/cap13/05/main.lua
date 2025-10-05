function arquivoExiste(nome)
    return love.filesystem.getInfo(nome) ~= nil
end

function carregarPontuacao()
    if arquivoExiste("pontuacao.txt") then
        local conteudo = love.filesystem.read("pontuacao.txt")
        local pontos = tonumber(conteudo)

        if pontos then
            return pontos
        else
            print("Erro: arquivo de pontuação corrompido")
            return 0
        end
    else
        print("Nenhuma pontuação salva encontrada")
        return 0
    end
end

carregarPontuacao()
