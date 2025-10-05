function love.load()
    inimigos = {}

    -- Criar inimigos com diferentes comportamentos
    for i = 1, 5 do
        table.insert(inimigos, {
            x = math.random(0, 600),
            y = math.random(50, 200),
            largura = 30,
            altura = 30,
            velocidadeX = math.random(-100, 100),
            velocidadeY = math.random(20, 80),
            tipo = math.random(1, 3)
        })
    end
end

function love.update(dt)
    for i, inimigo in ipairs(inimigos) do
        -- Movimento baseado no tipo
        if inimigo.tipo == 1 then
            -- Movimento linear
            inimigo.x = inimigo.x + inimigo.velocidadeX * dt
            inimigo.y = inimigo.y + inimigo.velocidadeY * dt
        elseif inimigo.tipo == 2 then
            -- Movimento senoidal
            inimigo.x = inimigo.x + inimigo.velocidadeX * dt
            inimigo.y = inimigo.y + math.sin(love.timer.getTime() + i) * 50 * dt
        else
            -- Movimento circular
            local tempo = love.timer.getTime() + i
            inimigo.x = 400 + math.cos(tempo) * 100
            inimigo.y = 200 + math.sin(tempo) * 100
        end

        -- Reposicionar se sair da tela
        if inimigo.x < -50 then inimigo.x = love.graphics.getWidth() + 50 end
        if inimigo.x > love.graphics.getWidth() + 50 then inimigo.x = -50 end
        if inimigo.y > love.graphics.getHeight() + 50 then inimigo.y = -50 end
    end
end

function love.draw()
    for i, inimigo in ipairs(inimigos) do
        -- Cor diferente por tipo
        if inimigo.tipo == 1 then
            love.graphics.setColor(1, 0, 0) -- vermelho
        elseif inimigo.tipo == 2 then
            love.graphics.setColor(0, 1, 0) -- verde
        else
            love.graphics.setColor(0, 0, 1) -- azul
        end

        love.graphics.rectangle("fill", inimigo.x, inimigo.y, inimigo.largura, inimigo.altura)
    end
    love.graphics.setColor(1, 1, 1) -- reset
end
