local enemy = {
    img = love.graphics.newImage("assets/enemy.png"),
    list = {},
    quads = {},
    frameAtual = 0,
    velocidadeAnimacao = 0.2,
    tempoFrame = 0,
    height = 50,
    width = 50,
    spawnTimer = 0,
    spawnRate = 2.0,

    types = {
        basic = {
            speed = 100,
            health = 1,
            points = 10,
            color = { 1, 0, 0, 0.03 },
        },
        fast = {
            speed = 200,
            health = 1,
            points = 20,
            color = { 0, 1, 0, 0.03 },
        },
        tank = {
            speed = 50,
            health = 3,
            points = 50,
            color = { 0, 0, 1, 0.03 },
        }
    }
}

-- Criar quads para cada frame da animação (4 frames de 50x50)
for i = 0, 3 do
    enemy.quads[i] = love.graphics.newQuad(i * enemy.width, 0, enemy.width, enemy.height,
        enemy.img:getDimensions())
end

function enemy.spawn(enemyType)
    enemyType = enemyType or "basic"
    local typeData = enemy.types[enemyType]
    local x = math.random(0, love.graphics.getWidth() - enemy.width)
    table.insert(enemy.list,
        {
            x = x,
            y = -enemy.height,
            speed = typeData.speed + math.random(-20, 20), --Variação na velocidade
            health = typeData.health,
            maxHealth = typeData.health,
            points = typeData.points,
            color = typeData.color,
            width = enemy.width,
            height = enemy.height,
            type = enemyType
        })
end

function enemy.spawnRandom()
    local rand = math.random()
    if rand < 0.6 then
        enemy.spawn("basic")
    elseif rand < 0.85 then
        enemy.spawn("fast")
    else
        enemy.spawn("tank")
    end
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
        love.graphics.setColor(e.color)
        love.graphics.rectangle("fill", e.x, e.y, e.width, e.height) -- cor do tipo

        love.graphics.setColor(1, 1, 1)                              -- reset
        love.graphics.draw(enemy.img, enemy.quads[enemy.frameAtual], e.x, e.y)

        -- Barra de vida para inimigos com mais de 1 HP
        if e.maxHealth > 1 then
            local barWidth = e.width
            local barHeight = 5
            local healthPercent = e.health / e.maxHealth

            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", e.x, e.y - 10, barWidth, barHeight)
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", e.x, e.y - 10, barWidth * healthPercent, barHeight)
        end
    end

    love.graphics.setColor(1, 1, 1) -- reset
end

function enemy.takeDamage(index, damage)
    if enemy.list[index] then
        enemy.list[index].health = enemy.list[index].health - damage
        return enemy.list[index].health <= 0, enemy.list[index].points
    end
    return false, 0
end

function enemy.remove(index)
    table.remove(enemy.list, index)
end

function enemy.clear()
    enemy.list = {}
end

return enemy
