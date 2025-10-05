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
    jogador = { x = 100, y = 100, largura = 40, altura = 40, velocidade = 200 }

    moeda = {
        x = 300,
        y = 200,
        largura = 20,
        altura = 20,
        coletada = false
    }

    pontuacao = 0
end

function love.update(dt)
    -- Movimento do jogador
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

    -- Verificar coleta da moeda
    if not moeda.coletada and colidiu(jogador, moeda) then
        moeda.coletada = true
        pontuacao = pontuacao + 10
        print("Moeda coletada! Pontuação: " .. pontuacao)
    end
end

function love.draw()
    -- Jogador
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Moeda (só desenha se não foi coletada)
    if not moeda.coletada then
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", moeda.x + moeda.largura / 2, moeda.y + moeda.altura / 2,
            moeda.largura / 2)
    end

    -- Interface
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Pontuação: " .. pontuacao, 10, 10)
end
