function love.draw()
    love.graphics.setColor(1, 0, 0) -- vermelho
    love.graphics.rectangle("fill", 100, 100, 200, 100)

    love.graphics.setColor(0, 0, 1) -- azul
    love.graphics.circle("fill", 400, 300, 50)

    love.graphics.setColor(1, 1, 1) -- branco
    love.graphics.print("Formas desenhadas!", 250, 450)

    love.graphics.setColor(255 / 255, 165 / 255, 20 / 255) -- laranja
    love.graphics.circle("fill", 200, 300, 30)
end
