-- lighting.lua
local lighting = {}

function lighting.load()
    lighting.lightCanvas = love.graphics.newCanvas()
    lighting.shadowCanvas = love.graphics.newCanvas()
    lighting.lights = {}
    lighting.obstacles = {}

    -- Adiciona algumas luzes
    lighting.addLight(400, 300, 200, { 1, 1, 0.8 })
    lighting.addLight(100, 100, 150, { 0.8, 0.8, 1 })

    -- Adiciona obstáculos
    lighting.addObstacle(300, 250, 100, 20)
    lighting.addObstacle(500, 400, 80, 80)
end

function lighting.addLight(x, y, radius, color)
    table.insert(lighting.lights, {
        x = x,
        y = y,
        radius = radius,
        color = color or { 1, 1, 1 }
    })
end

function lighting.addObstacle(x, y, width, height)
    table.insert(lighting.obstacles, {
        x = x,
        y = y,
        width = width,
        height = height
    })
end

function lighting.draw()
    -- Desenha as sombras no canvas de sombras
    love.graphics.setCanvas(lighting.shadowCanvas)
    love.graphics.clear(0, 0, 0, 1) -- Preto opaco

    -- Remove áreas iluminadas (desenha em branco)
    love.graphics.setBlendMode("subtract")
    love.graphics.setColor(1, 1, 1)

    for _, light in ipairs(lighting.lights) do
        love.graphics.circle("fill", light.x, light.y, light.radius)
    end

    love.graphics.setBlendMode("alpha")
    love.graphics.setCanvas()

    -- Desenha o mundo normal
    love.graphics.setColor(0.7, 0.7, 0.7)
    for _, obs in ipairs(lighting.obstacles) do
        love.graphics.rectangle("fill", obs.x, obs.y, obs.width, obs.height)
    end

    -- Aplica as sombras
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.draw(lighting.shadowCanvas, 0, 0)

    -- Desenha as luzes como pontos brilhantes
    love.graphics.setBlendMode("add")
    for _, light in ipairs(lighting.lights) do
        love.graphics.setColor(light.color[1], light.color[2], light.color[3], 0.3)
        love.graphics.circle("fill", light.x, light.y, 30)
    end
    love.graphics.setBlendMode("alpha")

    love.graphics.setColor(1, 1, 1)
end

function lighting.update(dt)
    -- Move a primeira luz com o mouse
    if #lighting.lights > 0 then
        lighting.lights[1].x = love.mouse.getX()
        lighting.lights[1].y = love.mouse.getY()
    end
end

return lighting
