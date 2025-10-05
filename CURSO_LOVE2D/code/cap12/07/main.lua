-- main.lua
local lighting = require("lighting")

function love.load()
    lighting.load()
end

function love.update(dt)
    lighting.update(dt)
end

function love.draw()
    lighting.draw()
end
