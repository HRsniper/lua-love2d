local class = require("libs.middleclass")

local HUD = class("HUD")

function HUD:initialize(player)
    self.player = player
end

function HUD:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, self.player.vida * 2, 20)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Vida: " .. self.player.vida, 10, 35)
    love.graphics.print("Pontuação: " .. self.player.pontuacao, 10, 60)
    love.graphics.print("Artefatos: " .. self.player.artefatos, 10, 85)
end

return HUD
