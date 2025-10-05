-- Variáveis globais do jogo
local pontuacao = 0
local vidas = 3
local jogador = {
    x = 400,
    y = 300,
    nome = "Herói"
}

-- Função para adicionar pontos
function adicionarPontos(valor)
    pontuacao = pontuacao + valor
    print("Pontuação atual: " .. pontuacao)
end

-- Função para perder vida
function perderVida()
    if vidas > 0 then
        vidas = vidas - 1
        print("Vidas restantes: " .. vidas)
    end

    if vidas == 0 then
        print("Game Over!")
    end
end

function love.keypressed(tecla)
    if tecla == "space" then
        adicionarPontos(10)
    elseif tecla == "x" then
        perderVida()
    end
end

function love.draw()
    -- Interface do jogo
    love.graphics.print("Jogador: " .. jogador.nome, 10, 10)
    love.graphics.print("Pontuação: " .. pontuacao, 10, 30)
    love.graphics.print("Vidas: " .. vidas, 10, 50)

    -- Instruções
    love.graphics.print("SPACE - ganhar pontos", 10, 100)
    love.graphics.print("X - perder vida", 10, 120)

    -- Status do jogo
    if vidas == 0 then
        love.graphics.print("GAME OVER!", 300, 300)
    end
end
