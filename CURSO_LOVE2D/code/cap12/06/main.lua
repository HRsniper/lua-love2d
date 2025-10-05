function love.load()
    canvas = love.graphics.newCanvas(800, 600)

    -- Desenha algo no canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0) -- Transparente

    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", 200, 200, 100)

    love.graphics.setColor(0, 1, 1)
    love.graphics.rectangle("fill", 400, 300, 100, 100)

    love.graphics.setCanvas() -- Volta ao canvas principal
end

function love.draw()
    -- Desenha o canvas com transparência
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.draw(canvas, 0, 0)

    -- Desenha elementos normais por cima passando com o mouse
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", love.mouse.getX(), love.mouse.getY(), 20)

    love.graphics.setColor(1, 1, 1)
end
