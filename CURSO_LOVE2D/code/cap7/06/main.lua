function love.load()
    player = {
        width = 50,
        height = 50
    }
    spriteSheet = love.graphics.newImage("player.png")

    quads = {}

    -- Criar quads para cada frame da animação (4 frames de 50x50)
    for i = 0, 3 do
        quads[i] = love.graphics.newQuad(i * player.width, 0, player.width, player.height,
            spriteSheet:getDimensions())
    end

    frameAtual = 0
    tempoFrame = 0
    velocidadeAnimacao = 0.2
end

function love.update(dt)
    tempoFrame = tempoFrame + dt

    if tempoFrame >= velocidadeAnimacao then
        frameAtual = (frameAtual + 1) % 4
        tempoFrame = 0
    end
end

function love.draw()
    -- Cor #282A36
    love.graphics.setBackgroundColor(40 / 255, 42 / 255, 54 / 255)

    love.graphics.draw(spriteSheet, quads[frameAtual], 100, 100)
end
