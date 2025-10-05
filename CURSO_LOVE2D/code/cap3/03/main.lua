-- Variáveis globais (ou melhor ainda, locais)
local jogador = {}

function love.load()
    -- INICIALIZAÇÃO: Configure valores iniciais
    jogador = {
        x = 100,
        y = 100,
        velocidade = 150,
        largura = 50,
        altura = 50,
        cor = { 1, 0, 0 } -- vermelho
    }

    -- Configurações da tela
    love.window.setTitle("Meu Primeiro Jogo")
end

function love.update(dt)
    -- LÓGICA: Atualize posições, colisões, etc.
    jogador.x = jogador.x + jogador.velocidade * dt

    -- Manter o jogador na tela
    if jogador.x > love.graphics.getWidth() then
        jogador.x = -jogador.largura
    end
end

function love.draw()
    -- RENDERIZAÇÃO: Desenhe tudo na tela
    love.graphics.setColor(jogador.cor)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Reset da cor para branco
    love.graphics.setColor(1, 1, 1)
end
