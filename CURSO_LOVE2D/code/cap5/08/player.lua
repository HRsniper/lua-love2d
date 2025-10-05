local player = {}

function player.new(x, y)
    return {
        x = x or 100,
        y = y or 100,
        largura = 40,
        altura = 40,
        velocidade = 200,
        vida = 100,
        cor = { 0, 1, 0 }, -- verde
        ultimoTiro = nil
    }
end

function player.update(p, dt)
    -- Movimento
    if love.keyboard.isDown("up", "w") then
        p.y = p.y - p.velocidade * dt
    end
    if love.keyboard.isDown("down", "s") then
        p.y = p.y + p.velocidade * dt
    end
    if love.keyboard.isDown("left", "a") then
        p.x = p.x - p.velocidade * dt
    end
    if love.keyboard.isDown("right", "d") then
        p.x = p.x + p.velocidade * dt
    end

    -- Limitar às bordas da tela
    p.x = math.max(0, math.min(love.graphics.getWidth() - p.largura, p.x))
    p.y = math.max(0, math.min(love.graphics.getHeight() - p.altura, p.y))
end

function player.draw(p)
    love.graphics.setColor(p.cor)
    love.graphics.rectangle("fill", p.x, p.y, p.largura, p.altura)

    -- Barra de vida
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", p.x, p.y - 10, p.largura, 5)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", p.x, p.y - 10, p.largura * (p.vida / 100), 5)
end

function player.takeDamage(p, damage)
    p.vida = p.vida - damage
    return p.vida <= 0
end

return player
