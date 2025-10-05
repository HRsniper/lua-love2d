local blur = require("blur")

local lighting = {}

function love.load()
    lighting.glowCanvas = love.graphics.newCanvas()
    blur.load()
end

function love.update(dt)
end

function love.draw()
    love.graphics.setCanvas(lighting.glowCanvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 400, 300, 100)
    love.graphics.setCanvas()

    local blurred = blur.apply(lighting.glowCanvas, 0.005)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(blurred, 0, 0)
end
