function love.load()
    x = 100
    velocidade = 200 -- pixels por segundo
end

function love.update(dt)
    x = x + velocidade * dt
end

function love.draw()
    love.graphics.circle("fill", x, 300, 30)
end
