function colidiu(a, b)
    return a.x < b.x + b.largura and
        b.x < a.x + a.largura and
        a.y < b.y + b.altura and
        b.y < a.y + a.altura
end

function love.load()
    jogador = { x = 100, y = 300, largura = 40, altura = 40, vidas = 3 }

    inimigos = {
        { x = 400, y = 100, largura = 30, altura = 30, velocidade = 100, direcao = 1 },
        { x = 600, y = 200, largura = 30, altura = 30, velocidade = 80,  direcao = -1 }
    }

    gameOver = false
end

function love.update(dt)
    if gameOver then return end

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

    -- Movimento dos inimigos
    for i, inimigo in ipairs(inimigos) do
        inimigo.x = inimigo.x + inimigo.velocidade * inimigo.direcao * dt

        -- Inverter direção nas bordas
        if inimigo.x <= 0 or inimigo.x + inimigo.largura >= love.graphics.getWidth() then
            inimigo.direcao = -inimigo.direcao
        end

        -- Verificar colisão com jogador
        if colidiu(jogador, inimigo) then
            jogador.vidas = jogador.vidas - 1
            print("Vida perdida! Vidas restantes: " .. jogador.vidas)

            -- Afastar jogador do inimigo
            jogador.x = jogador.x - 50 * inimigo.direcao

            if jogador.vidas <= 0 then
                gameOver = true
            end
        end
    end
end

function love.draw()
    if gameOver then
        love.graphics.print("GAME OVER!", 300, 300)
        love.graphics.print("Pressione R para reiniciar", 250, 320)
        return
    end

    -- Desenhar jogador
    love.graphics.setColor(0, 1, 0) -- verde
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Desenhar inimigos
    love.graphics.setColor(1, 0, 0) -- vermelho
    for i, inimigo in ipairs(inimigos) do
        love.graphics.rectangle("fill", inimigo.x, inimigo.y, inimigo.largura, inimigo.altura)
    end

    -- Reset cor
    love.graphics.setColor(1, 1, 1)

    -- Interface
    love.graphics.print("Vidas: " .. jogador.vidas, 10, 10)
    love.graphics.print("Use as setas para mover", 10, 30)
end

function love.keypressed(tecla)
    if tecla == "r" and gameOver then
        -- Reiniciar jogo
        jogador.vidas = 3
        jogador.x = 100
        jogador.y = 300
        gameOver = false
    end
end
