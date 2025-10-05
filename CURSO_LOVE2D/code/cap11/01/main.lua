function love.load()
    player = love.graphics.newImage("assets/player.png")
    quads = {}
    player = {
        width = 50,
        height = 50,
    }


    -- Cria os quads para cada frame da animação
    for i = 0, 3 do
        quads[i + 1] = love.graphics.newQuad(
            i * player.width, 0,         -- posição x, y na spritesheet
            player.width, player.height, -- largura e altura do frame
            player:getDimensions()
        )
    end

    frameAtual = 1
    tempo = 0
end

function love.update(dt)
    tempo = tempo + dt

    -- Troca de frame a cada 0.15 segundos
    if tempo > 0.15 then
        frameAtual = frameAtual % 4 + 1
        tempo = 0
    end
end

function love.draw()
    love.graphics.draw(player, quads[frameAtual], 100, 100)
end
