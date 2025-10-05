function love.load()
    jogador = {
        x = 300,
        y = 300,
        velocidade = 200,
        largura = 50,
        altura = 50
    }

    mundo = {
        largura = love.graphics.getWidth(),
        altura = love.graphics.getHeight(),
    }
end

function love.update(dt)
    local diagonalX, diagonalY = 0, 0

    -- Capturar direções
    if love.keyboard.isDown("up") then
        diagonalY = diagonalY - 1
    end
    if love.keyboard.isDown("down") then
        diagonalY = diagonalY + 1
    end
    if love.keyboard.isDown("left") then
        diagonalX = diagonalX - 1
    end
    if love.keyboard.isDown("right") then
        diagonalX = diagonalX + 1
    end


    -- Normalizar movimento diagonal
    if diagonalX ~= 0 or diagonalY ~= 0 then
        local length = math.sqrt(diagonalX * diagonalX + diagonalY * diagonalY)
        diagonalX = diagonalX / length
        diagonalY = diagonalY / length

        jogador.x = jogador.x + diagonalX * jogador.velocidade * dt
        jogador.y = jogador.y + diagonalY * jogador.velocidade * dt
    end

    -- Limitar às bordas da tela
    jogador.x = math.max(0, math.min(mundo.largura - jogador.largura, jogador.x))
    jogador.y = math.max(0, math.min(mundo.altura - jogador.altura, jogador.y))
end

function love.draw()
    love.graphics.print("setinhas para mover", 10, 10)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)
end
