local enemy = {}

function enemy.new(x, y, tipo)
    tipo = tipo or 1

    local inimigo = {
        x = x,
        y = y,
        largura = 30,
        altura = 30,
        velocidade = math.random(50, 120),
        vida = tipo * 2,
        tipo = tipo,
        direcao = math.random() > 0.5 and 1 or -1
    }

    -- Propriedades baseadas no tipo
    if tipo == 1 then
        inimigo.cor = {1, 0, 0}      -- vermelho - básico
    elseif tipo == 2 then
        inimigo.cor = {1, 0.5, 0}    -- laranja - rápido
        inimigo.velocidade = inimigo.velocidade * 1.5
    else
        inimigo.cor = {0.5, 0, 0.5}  -- roxo - tanque
        inimigo.vida = inimigo.vida * 2
        inimigo.largura = 40
        inimigo.altura = 40
    end

    return inimigo
end

function enemy.update(inimigo, dt)
    if inimigo.tipo == 1 then
        -- Movimento linear simples
        inimigo.y = inimigo.y + inimigo.velocidade * dt
    elseif inimigo.tipo == 2 then
        -- Movimento em zigue-zague
        inimigo.y = inimigo.y + inimigo.velocidade * dt
        inimigo.x = inimigo.x + math.sin(love.timer.getTime() * 3) * 100 * dt
    else
        -- Movimento lento mas direcionado ao jogador (simplificado)
        inimigo.y = inimigo.y + inimigo.velocidade * 0.7 * dt
    end
end

function enemy.draw(inimigo)
    love.graphics.setColor(inimigo.cor)
    love.graphics.rectangle("fill", inimigo.x, inimigo.y, inimigo.largura, inimigo.altura)

    -- Indicador de vida para tipos mais fortes
    if inimigo.tipo > 1 then
        local vidaMax = inimigo.tipo == 2 and 4 or 12
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.rectangle("line", inimigo.x, inimigo.y - 5, inimigo.largura, 3)
        love.graphics.setColor(1, 0, 0, 0.8)
        love.graphics.rectangle("fill", inimigo.x, inimigo.y - 5, inimigo.largura * (inimigo.vida / vidaMax), 3)
    end
end

function enemy.isOffScreen(inimigo)
    return inimigo.y > love.graphics.getHeight() + 50 or
           inimigo.x < -50 or
           inimigo.x > love.graphics.getWidth() + 50
end

return enemy
