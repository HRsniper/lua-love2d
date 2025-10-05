function colidiu(a, b)
    return a.x < b.x + b.largura and
        b.x < a.x + a.largura and
        a.y < b.y + b.altura and
        b.y < a.y + a.altura
end

function love.load()
    jogador = { x = 100, y = 100, largura = 50, altura = 50, cor = { 0, 1, 0 } }
    obstaculo = { x = 200, y = 100, largura = 80, altura = 80, cor = { 1, 0, 0 } }
    colidindo = false
end

function love.update(dt)
    -- Salvar posição anterior
    local antiga_x = jogador.x
    local antiga_y = jogador.y

    -- Aplicar movimento
    if love.keyboard.isDown("right") then
        jogador.x = jogador.x + 150 * dt
    end
    if love.keyboard.isDown("left") then
        jogador.x = jogador.x - 150 * dt
    end
    if love.keyboard.isDown("up") then
        jogador.y = jogador.y - 150 * dt
    end
    if love.keyboard.isDown("down") then
        jogador.y = jogador.y + 150 * dt
    end

    -- Se colidiu, voltar à posição anterior
    if colidiu(jogador, obstaculo) then
        jogador.x = antiga_x
        jogador.y = antiga_y
        colidindo = true
    else
        colidindo = false
    end
end

function love.draw()
    love.graphics.print("setinhas para mover", 10, 10)

    -- Desenhar jogador (verde ou amarelo se colidindo)
    if colidindo then
        love.graphics.setColor(1, 1, 0) -- amarelo
    else
        love.graphics.setColor(jogador.cor)
    end
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Desenhar obstáculo
    love.graphics.setColor(obstaculo.cor)
    love.graphics.rectangle("line", obstaculo.x, obstaculo.y, obstaculo.largura, obstaculo.altura)

    -- Reset cor
    love.graphics.setColor(1, 1, 1)

    -- Informações na tela
    if colidindo then
        love.graphics.print("COLISÃO!", 30, 30)
    end
end
