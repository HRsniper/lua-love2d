function love.load()
    jogador = { x = 100, y = 100, velocidade = 150 }
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        jogador.x = jogador.x + jogador.velocidade * dt
    elseif love.keyboard.isDown("left") then
        jogador.x = jogador.x - jogador.velocidade * dt
    end
end

function love.draw()
    love.graphics.print("mova com seta para direita e esquerda", 10, 10)
    love.graphics.rectangle("fill", jogador.x, jogador.y, 50, 50)
end
