local enemy = {
    img = love.graphics.newImage("assets/enemy.png"),
    list = {},
    spawnTimer = 0,
    quads = {},
    frameAtual = 0,
    velocidadeAnimacao = 0.2,
    tempoFrame = 0,
    height = 50,
    width = 50,
    health = 1,
    speed = 100,
    spawnRate = 2.0
}

-- Criar quads para cada frame da animação (4 frames de 50x50)
for i = 0, 3 do
    enemy.quads[i] = love.graphics.newQuad(i * enemy.width, 0, enemy.width, enemy.height,
        enemy.img:getDimensions())
end

function enemy.spawn()
    local x = math.random(0, 750)
    table.insert(enemy.list,
        {
            x = x,
            y = -enemy.height,
            speed = enemy.speed + math.random(-20, 20), --Variação na velocidade
            health = enemy.health
        })
end

function enemy.update(dt)
    enemy.spawnTimer = enemy.spawnTimer + dt
    if enemy.spawnTimer > enemy.spawnRate then
        enemy.spawn()
        enemy.spawnTimer = 0
        -- Aumentar dificuldade gradualmente
        enemy.spawnRate = math.max(0.5, enemy.spawnRate - 0.01)
    end

    for i = #enemy.list, 1, -1 do
        local e = enemy.list[i]
        e.y = e.y + e.speed * dt

        -- Remover se saiu da tela
        if e.y > love.graphics.getHeight() then
            table.remove(enemy.list, i)
        end
    end

    enemy.tempoFrame = enemy.tempoFrame + dt
    if enemy.tempoFrame >= enemy.velocidadeAnimacao then
        enemy.frameAtual = (enemy.frameAtual + 1) % 4
        enemy.tempoFrame = 0
    end
end

function enemy.draw()
    for _, e in ipairs(enemy.list) do
        love.graphics.draw(enemy.img, enemy.quads[enemy.frameAtual], e.x, e.y)
    end
end

function enemy.remove(index)
    table.remove(enemy.list, index)
end

function enemy.clear()
    enemy.list = {}
end

return enemy
