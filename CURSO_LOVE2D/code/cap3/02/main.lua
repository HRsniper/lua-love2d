function love.load()
    jogador = { x = 100, y = 100, velocidade = 150 }
end

function love.update(dt)
    jogador.x = jogador.x + jogador.velocidade * dt
end

function love.draw()
    love.graphics.rectangle("fill", jogador.x, jogador.y, 50, 50)
end
