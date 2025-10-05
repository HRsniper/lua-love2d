local player = require("player")

local bullet = {
    img = love.graphics.newImage("assets/bullet.png"),
    list = {},

    types = {
        normal = {
            speed = 500,
            damage = 1,
            color = { 1, 0, 0, 0.3 },
        },
        rapid = {
            speed = 700,
            damage = 1,
            color = { 0, 1, 0, 0.3 },
        },
        heavy = {
            speed = 300,
            damage = 3,
            color = { 0, 0, 1, 0.3 },
        }
    }
}

bullet.imgWidth = bullet.img:getWidth()
bullet.imgHeight = bullet.img:getHeight()

function bullet.spawn(x, y, bulletType)
    bulletType = bulletType or "normal"
    local typeData = bullet.types[bulletType]
    local center = (bullet.imgWidth - player.width) / 2 -- Centralizar
    table.insert(bullet.list,
        {
            x = x - center,
            y = y,
            speed = typeData.speed,
            damage = typeData.damage,
            color = typeData.color,
            width = bullet.imgWidth,
            height = bullet.imgWidth
        })
end

function bullet.update(dt)
    for i = #bullet.list, 1, -1 do
        local b = bullet.list[i]
        b.y = b.y - b.speed * dt

        -- Remover se saiu da tela
        if b.y < -bullet.imgHeight then
            table.remove(bullet.list, i)
        end
    end
end

function bullet.draw()
    for _, b in ipairs(bullet.list) do
        love.graphics.setColor(1, 1, 1) -- reset
        love.graphics.draw(bullet.img, b.x, b.y)

        love.graphics.setColor(b.color)
        love.graphics.rectangle("fill", b.x, b.y, b.width, b.height) -- cor do tipo
    end

    love.graphics.setColor(1, 1, 1) -- reset
end

function bullet.remove(index)
    table.remove(bullet.list, index)
end

function bullet.clear()
    bullet.list = {}
end

return bullet
