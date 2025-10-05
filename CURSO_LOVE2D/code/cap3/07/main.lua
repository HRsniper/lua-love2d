local jogador = {}

function love.load()
    jogador = {
        x = 400,
        y = 300,
        velocidade = 200,
        largura = 40,
        altura = 40
    }
end

function love.update(dt)
    -- Movimento horizontal
    if love.keyboard.isDown("right", "d") then
        jogador.x = jogador.x + jogador.velocidade * dt
    end
    if love.keyboard.isDown("left", "a") then
        jogador.x = jogador.x - jogador.velocidade * dt
    end

    -- Movimento vertical
    if love.keyboard.isDown("up", "w") then
        jogador.y = jogador.y - jogador.velocidade * dt
    end
    if love.keyboard.isDown("down", "s") then
        jogador.y = jogador.y + jogador.velocidade * dt
    end

    -- Limites da tela
    jogador.x = math.max(0, math.min(love.graphics.getWidth() - jogador.largura, jogador.x))
    jogador.y = math.max(0, math.min(love.graphics.getHeight() - jogador.altura, jogador.y))
end

function love.draw()
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Instruções na tela
    love.graphics.print("Use WASD ou setas para mover", 10, 10)
    love.graphics.print("ESC para sair", 10, 30)
end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    end
end
