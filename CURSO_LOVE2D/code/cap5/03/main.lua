function love.load()
    balas = {}
end

function love.keypressed(tecla)
    if tecla == "space" then
        table.insert(balas, { x = 400, y = 300, velocidade = 300 })
    end
end

function love.update(dt)
    for i, bala in ipairs(balas) do
        bala.y = bala.y - bala.velocidade * dt
    end
end

function love.draw()
    love.graphics.print("aperta espaço para disparar balas")
    for i, bala in ipairs(balas) do
        love.graphics.circle("fill", bala.x, bala.y, 5)
    end
end
