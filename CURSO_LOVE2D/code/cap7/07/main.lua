function love.load()
    -- Carregamento de recursos
    jogadorImg = love.graphics.newImage("player.png")
    fonte = love.graphics.newFont(24)
    love.graphics.setFont(fonte)

    -- Variáveis do jogador
    jogador = {
        x = 400,
        y = 300,
        angulo = 0,
        velocidade = 200,
        width = 50,
        height = 50
    }

    -- Variáveis do jogo
    pontuacao = 0
    tempo = 0

    quads = {}
    -- Criar quads para cada frame da animação (4 frames de 50x50)
    for i = 0, 3 do
        quads[i] = love.graphics.newQuad(i * jogador.width, 0, jogador.width, jogador.height,
            jogadorImg:getDimensions())
    end

    frameAtual = 0
    velocidadeAnimacao = 0.2
    tempoFrame = 0
end

function love.update(dt)
    -- Movimentação do jogador
    if love.keyboard.isDown("right", "d") then
        jogador.x = jogador.x + jogador.velocidade * dt
    end
    if love.keyboard.isDown("left", "a") then
        jogador.x = jogador.x - jogador.velocidade * dt
    end
    if love.keyboard.isDown("up", "w") then
        jogador.y = jogador.y - jogador.velocidade * dt
    end
    if love.keyboard.isDown("down", "s") then
        jogador.y = jogador.y + jogador.velocidade * dt
    end

    -- Rotação lenta
    jogador.angulo = jogador.angulo + dt * 0.5

    -- Sistema de pontuação baseado no tempo
    tempo          = tempo + dt
    pontuacao      = math.floor(tempo * 10)

    -- Manter jogador na tela
    local top      = jogadorImg:getHeight() - jogador.height
    local left     = jogadorImg:getWidth() - (jogador.width * 4)
    local bottom   = love.graphics.getHeight() - jogadorImg:getHeight()
    local right    = love.graphics.getWidth() - (jogadorImg:getWidth() - (jogador.width * 3))
    jogador.x      = math.max(left, math.min(right, jogador.x))
    jogador.y      = math.max(top, math.min(bottom, jogador.y))


    tempoFrame = tempoFrame + dt
    if tempoFrame >= velocidadeAnimacao then
        frameAtual = (frameAtual + 1) % 4
        tempoFrame = 0
    end
end

function love.draw()
    -- Fundo
    -- Cor #282A36
    love.graphics.setBackgroundColor(40 / 255, 42 / 255, 54 / 255)

    -- Jogador
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        jogadorImg,
        quads[frameAtual],
        jogador.x,
        jogador.y
    )

    -- Interface
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Pontuação: " .. pontuacao, 10, 10)
    love.graphics.print("Tempo: " .. math.floor(tempo) .. "s", 10, 40)

    -- Instruções
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Use WASD ou setas para mover", 10, love.graphics.getHeight() - 30)
end
