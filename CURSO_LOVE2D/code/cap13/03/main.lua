function salvarPontuacao(pontos)
    local sucesso, mensagem = love.filesystem.write("pontuacao.txt", tostring(pontos))

    if sucesso then
        print("Pontuação salva: " .. pontos)
    else
        print("Erro ao salvar: " .. mensagem)
    end

    return sucesso
end

function salvarTexto(arquivo, conteudo)
    return love.filesystem.write(arquivo, conteudo)
end

function salvarConfiguracoes(volume, resolucao)
    local config = volume .. "\n" .. resolucao
    love.filesystem.write("config.txt", config)
end

local pontos = 110
salvarPontuacao(pontos)

salvarTexto("meuArquivo.txt", "Olá, mundo!")

local volume = 0.5
local resolucao = "1920x1080"
salvarConfiguracoes(volume, resolucao)

print("Diretório de save: " .. love.filesystem.getSaveDirectory())
