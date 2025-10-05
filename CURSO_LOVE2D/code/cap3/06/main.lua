function love.load()
    jogador = { x = 300, y = 300, velocidade = 200, largura = 50, altura = 50 }
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        jogador.y = jogador.y - jogador.velocidade * dt
    end
    if love.keyboard.isDown("down") then
        jogador.y = jogador.y + jogador.velocidade * dt
    end
    if love.keyboard.isDown("left") then
        jogador.x = jogador.x - jogador.velocidade * dt
    end
    if love.keyboard.isDown("right") then
        jogador.x = jogador.x + jogador.velocidade * dt
    end

    -- Manter o jogador na tela
    if jogador.x > love.graphics.getWidth() then
        jogador.x = -jogador.largura
        print(jogador.largura)
    elseif jogador.x + jogador.largura < 0 then
        jogador.x = love.graphics.getWidth()
    elseif jogador.y > love.graphics.getHeight() then
        jogador.y = -jogador.altura
    elseif jogador.y + jogador.altura < 0 then
        jogador.y = love.graphics.getHeight()
    end
end

function love.draw()
    love.graphics.print("setinhas para mover", 10, 10)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)
end
