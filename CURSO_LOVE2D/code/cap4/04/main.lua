function colidiu(a, b)
    return a.x < b.x + b.largura and
        b.x < a.x + a.largura and
        a.y < b.y + b.altura and
        b.y < a.y + a.altura
end

function love.load()
    jogador = { x = 100, y = 100, largura = 40, altura = 40 }

    moedas = {
        { x = 300, y = 100, largura = 20, altura = 20, coletada = false },
        { x = 500, y = 200, largura = 20, altura = 20, coletada = false },
        { x = 200, y = 300, largura = 20, altura = 20, coletada = false }
    }

    pontuacao = 0
    moedasColetadas = 0
end

function love.update(dt)
    -- Movimento do jogador
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

    -- Verificar coleta de moedas
    for i, moeda in ipairs(moedas) do
        if not moeda.coletada and colidiu(jogador, moeda) then
            moeda.coletada = true
            pontuacao = pontuacao + 10
            moedasColetadas = moedasColetadas + 1
            print("Moeda coletada! Pontuação: " .. pontuacao)
        end
    end
end

function love.draw()
    -- Desenhar jogador
    love.graphics.setColor(0, 0, 1) -- azul
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Desenhar moedas não coletadas
    love.graphics.setColor(1, 1, 0) -- amarelo
    for i, moeda in ipairs(moedas) do
        if not moeda.coletada then
            love.graphics.rectangle("fill", moeda.x, moeda.y, moeda.largura, moeda.altura)
        end
    end

    -- Reset cor
    love.graphics.setColor(1, 1, 1)

    -- Interface
    love.graphics.print("Pontuação: " .. pontuacao, 10, 10)
    love.graphics.print("Moedas: " .. moedasColetadas .. "/3", 10, 30)

    if moedasColetadas == 3 then
        love.graphics.print("PARABÉNS! Você coletou todas as moedas!", 200, 200)
    end
end
