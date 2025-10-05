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

    obstaculos = {
        { x = 200, y = 100, largura = 60, altura = 60 },
        { x = 400, y = 150, largura = 80, altura = 40 },
        { x = 300, y = 300, largura = 50, altura = 100 },
        { x = 500, y = 200, largura = 40, altura = 80 }
    }

    colidindo = false
end

function love.update(dt)
    local novoX = jogador.x
    local novoY = jogador.y

    -- Calcular nova posição baseada na entrada
    if love.keyboard.isDown("right") then novoX = novoX + jogador.velocidade * dt end
    if love.keyboard.isDown("left") then novoX = novoX - jogador.velocidade * dt end
    if love.keyboard.isDown("up") then novoY = novoY - jogador.velocidade * dt end
    if love.keyboard.isDown("down") then novoY = novoY + jogador.velocidade * dt end

    -- Criar objeto temporário com nova posição
    local futuro = {
        x = novoX,
        y = novoY,
        largura = jogador.largura,
        altura = jogador.altura
    }

    -- Verificar colisão com todos os obstáculos
    local podeMove = true
    for i, obstaculo in ipairs(obstaculos) do
        if colidiu(futuro, obstaculo) then
            podeMove = false
            colidindo = true
            print("Colidiu com obstáculo " .. i)
            break -- Sair do loop na primeira colisão
        end
        colidindo = false
    end

    -- Só move se não colidir com nada
    if podeMove then
        jogador.x = novoX
        jogador.y = novoY
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

    -- Obstáculos (vermelho)
    love.graphics.setColor(1, 0, 0)
    for i, obstaculo in ipairs(obstaculos) do
        love.graphics.rectangle("fill", obstaculo.x, obstaculo.y, obstaculo.largura, obstaculo
            .altura)
    end

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
