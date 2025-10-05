function love.load()
    inimigos = {}
    tempoUltimoInimigo = 0
    intervaloSpawn = 1.0 -- segundos entre spawns
end

function love.update(dt)
    -- Sistema de spawn temporizado
    tempoUltimoInimigo = tempoUltimoInimigo + dt

    if tempoUltimoInimigo >= intervaloSpawn then
        -- Criar novo inimigo
        table.insert(inimigos, {
            x = math.random(0, love.graphics.getWidth() - 30),
            y = -30, -- começar acima da tela
            largura = 30,
            altura = 30,
            velocidade = math.random(50, 150),
            vida = math.random(1, 3)
        })

        tempoUltimoInimigo = 0

        -- Aumentar dificuldade gradualmente
        intervaloSpawn = math.max(0.2, intervaloSpawn - 0.01)
    end

    -- Atualizar inimigos
    for i, inimigo in ipairs(inimigos) do
        inimigo.y = inimigo.y + inimigo.velocidade * dt
    end

    -- Remover inimigos que saíram da tela
    for i = #inimigos, 1, -1 do
        if inimigos[i].y > love.graphics.getHeight() + 50 then
            table.remove(inimigos, i)
        end
    end
end

function love.draw()
    for i, inimigo in ipairs(inimigos) do
        -- Cor baseada na vida
        local intensidade = inimigo.vida / 3
        love.graphics.setColor(1, 1 - intensidade, 1 - intensidade)
        love.graphics.rectangle("fill", inimigo.x, inimigo.y, inimigo.largura, inimigo.altura)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Inimigos ativos: " .. #inimigos, 10, 10)
    love.graphics.print("Intervalo de spawn: " .. string.format("%.2f", intervaloSpawn), 10, 30)
end
