function colidiu(a, b)
    -- Verificar se os objetos existem
    if not a or not b then
        return false
    end

    -- Verificar se têm as propriedades necessárias
    if not (a.x and a.y and a.largura and a.altura and
            b.x and b.y and b.largura and b.altura) then
        return false
    end

    return a.x < b.x + b.largura and -- a está à esquerda da borda direita de b
        b.x < a.x + a.largura and    -- b está à esquerda da borda direita de a
        a.y < b.y + b.altura and     -- a está acima da borda inferior de b
        b.y < a.y + a.altura         -- b está acima da borda inferior de a
end

function love.load()
    jogador = {
        x = 100,
        y = 100,
        largura = 50,
        altura = 50,
        velocidade = 200
    }

    obstaculo = {
        x = 300,
        y = 100,
        largura = 50,
        altura = 50
    }

    colidindo = false
end

function love.update(dt)
    -- Movimento básico
    if love.keyboard.isDown("right") then
        jogador.x = jogador.x + jogador.velocidade * dt
    end
    if love.keyboard.isDown("left") then
        jogador.x = jogador.x - jogador.velocidade * dt
    end
    if love.keyboard.isDown("up") then
        jogador.y = jogador.y - jogador.velocidade * dt
    end
    if love.keyboard.isDown("down") then
        jogador.y = jogador.y + jogador.velocidade * dt
    end

    -- Verificar colisão
    colidindo = colidiu(jogador, obstaculo)

    if colidindo then
        print("Colisão detectada!")
    end
end

function love.draw()
    -- Jogador (azul se colidindo, verde se não)
    if colidindo then
        love.graphics.setColor(0, 0, 1) -- azul
    else
        love.graphics.setColor(0, 1, 0) -- verde
    end
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Obstáculo (vermelho)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", obstaculo.x, obstaculo.y, obstaculo.largura, obstaculo.altura)

    -- Interface
    love.graphics.setColor(1, 1, 1)
    if colidindo then
        love.graphics.print("COLIDINDO!", 10, 10)
    else
        love.graphics.print("Livre", 10, 10)
    end

    -- Instruções
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Use setas para mover", 10, love.graphics.getHeight() - 30)
end
