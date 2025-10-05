function love.load()
    player = {
        width = 50,
        height = 50
    }

    spriteSheet = love.graphics.newImage("player.png")
    quad = love.graphics.newQuad(0, 0, player.width, player.height, spriteSheet:getDimensions())
    -- Parâmetros: x, y, largura, altura, largura_total, altura_total
end

function love.draw()
    -- Cor #282A36
    love.graphics.setBackgroundColor(40 / 255, 42 / 255, 54 / 255)

    love.graphics.draw(spriteSheet, quad, 100, 100)
end
