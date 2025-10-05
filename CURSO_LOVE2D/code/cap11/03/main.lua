local sti = require("lib.sti")

function love.load()
    mapa = sti("maps/meu_mapa.lua")
end

function love.update(dt)
    mapa:update(dt)
end

function love.draw()
    mapa:draw()
end
