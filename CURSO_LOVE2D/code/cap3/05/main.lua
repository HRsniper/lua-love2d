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

-- love.keypressed() - para ações únicas
function love.keypressed(tecla)
    if tecla == "space" then
        print("Pulo!")
    end
    if tecla == "escape" then
        love.event.quit()
    end
end

-- love.update() - para ações contínuas
function love.update(dt)
    if love.keyboard.isDown("right") then
        -- LÓGICA: Atualize posições, colisões, etc.
        jogador.x = jogador.x + jogador.velocidade * dt
    end
    if love.keyboard.isDown("left") then
        jogador.x = jogador.x - jogador.velocidade * dt
    end
    -- Manter o jogador na tela
    if jogador.x > love.graphics.getWidth() then
        jogador.x = -jogador.largura
        print(jogador.largura)
    elseif jogador.x + jogador.largura < 0 then
        jogador.x = love.graphics.getWidth()
    end
end

function love.draw()
    -- RENDERIZAÇÃO: Desenhe tudo na tela
    love.graphics.print("<esc> para sair, setinhas para mover, <espaco> pula", 10, 10)
    love.graphics.setColor(jogador.cor)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Reset da cor para branco
    love.graphics.setColor(1, 1, 1)
end
