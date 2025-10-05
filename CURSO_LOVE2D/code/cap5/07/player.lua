local player = {x = 100, y = 100, velocidade = 200}

function player.update(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + player.velocidade * dt
    end
end

function player.draw()
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)
end

return player
