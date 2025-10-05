function love.load()
    balas = {}
    jogador = { x = 400, y = 500 }
end

function love.keypressed(tecla)
    if tecla == "space" then
        -- Criar nova bala na posição do jogador
        table.insert(balas, {
            x = jogador.x,
            y = jogador.y,
            velocidade = 400,
            largura = 5,
            altura = 10
        })
    end
end

function love.update(dt)
    -- Atualizar todas as balas
    for i, bala in ipairs(balas) do
        bala.y = bala.y - bala.velocidade * dt
    end

    -- Remover balas que saíram da tela
    for i = #balas, 1, -1 do -- loop reverso para remoção segura
        if balas[i].y < -10 then
            table.remove(balas, i)
        end
    end
end

function love.draw()
    -- Desenhar jogador
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", jogador.x, jogador.y, 40, 40)

    -- Desenhar balas
    love.graphics.setColor(1, 1, 0)
    for i, bala in ipairs(balas) do
        love.graphics.rectangle("fill", bala.x, bala.y, bala.largura, bala.altura)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Balas ativas: " .. #balas, 10, 10)
    love.graphics.print("Pressione SPACE para atirar", 10, 30)
end
