local bullet = {
    img = love.graphics.newImage("assets/bullet.png"),
    list = {},
    speed = 500,
}

bullet.imgWidth = bullet.img:getWidth()
bullet.imgHeight = bullet.img:getHeight()

function bullet.spawn(x, y)
    local center = bullet.imgWidth / 2 -- Centralizar
    table.insert(bullet.list, { x = x - center, y = y, speed = bullet.speed })
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
        love.graphics.draw(bullet.img, b.x, b.y)
    end
end

function bullet.remove(index)
    table.remove(bullet.list, index)
end

function bullet.clear()
    bullet.list = {}
end

return bullet
