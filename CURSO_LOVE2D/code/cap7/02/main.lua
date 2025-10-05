function love.load()
    jogadorImg = love.graphics.newImage("player.png")
    jogadorX = 100
    jogadorY = 100
    velocidade = 200
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        jogadorX = jogadorX + velocidade * dt
    end
    if love.keyboard.isDown("left") then
        jogadorX = jogadorX - velocidade * dt
    end
    if love.keyboard.isDown("up") then
        jogadorY = jogadorY - velocidade * dt
    end
    if love.keyboard.isDown("down") then
        jogadorY = jogadorY + velocidade * dt
    end
end

function love.draw()
    -- Cor #282A36
    love.graphics.setBackgroundColor(40 / 255, 42 / 255, 54 / 255)

    love.graphics.draw(jogadorImg, jogadorX, jogadorY)
end
