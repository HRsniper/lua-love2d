local player = {
    img = love.graphics.newImage("assets/player.png"),
    x = 400,
    y = 500,
    speed = 300,
    quads = {},
    frameAtual = 0,
    velocidadeAnimacao = 0.2,
    tempoFrame = 0,
    height = 50,
    width = 50,

    -- Sistema de vida
    maxHealth = 3,
    invulnerable = false,
    invulnerableTime = 0,
    invulnerableDuration = 2.0
}

player.health = player.maxHealth

-- Criar quads para cada frame da animação (4 frames de 50x50)
for i = 0, 3 do
    player.quads[i] = love.graphics.newQuad(i * player.width, 0, player.width, player.height,
        player.img:getDimensions())
end

function player.update(dt)
    if love.keyboard.isDown("a", "left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("d", "right") then
        player.x = player.x + player.speed * dt
    end

    player.tempoFrame = player.tempoFrame + dt
    if player.tempoFrame >= player.velocidadeAnimacao then
        player.frameAtual = (player.frameAtual + 1) % 4
        player.tempoFrame = 0
    end

    -- Manter dentro da tela
    player.x = math.max(0, math.min(love.graphics.getWidth() - player.width, player.x))

    -- Invulnerabilidade
    if player.invulnerable then
        player.invulnerableTime = player.invulnerableTime - dt
        if player.invulnerableTime <= 0 then
            player.invulnerable = false
        end
    end
end

function player.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player.img, player.quads[player.frameAtual], player.x, player.y)

    -- Efeito de piscar quando invulnerável
    if player.invulnerable and math.floor(player.invulnerableTime * 10) % 2 == 0 then
        return -- Não desenhar (efeito piscante)
    end
end

function player.takeDamage()
    if not player.invulnerable then
        player.health = player.health - 1
        player.invulnerable = true
        player.invulnerableTime = player.invulnerableDuration
        return true -- Dano aplicado
    end
    return false    -- Sem dano (invulnerável)
end

function player.isDead()
    return player.health <= 0
end

return player
