function love.load()
    img = love.graphics.newImage("player.png")
    angulo = 0
    x = 300
    y = 300
end

function love.update(dt)
    angulo = angulo + dt -- rotaciona 1 radiano por segundo
end

function love.draw()
    -- Cor #282A36
    love.graphics.setBackgroundColor(40 / 255, 42 / 255, 54 / 255)

    love.graphics.draw(img, x, y, angulo, 1, 1, img:getWidth() / 2, img:getHeight() / 2)
    -- Parâmetros: imagem, x, y, rotação, escalaX, escalaY, origemX, origemY
end
