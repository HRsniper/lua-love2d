local class = require("libs.middleclass")

local Artifact = class("Artifact")

function Artifact:initialize(world, x, y, imagePath)
    self.x = x
    self.y = y
    self.coletado = false
    self.image = love.graphics.newImage(imagePath)

    self.collider = world:newRectangleCollider(x, y, 18, 18, { collision_class = "Artifact" })
    self.collider:setType("static")
end

function Artifact:update(player)
    if not self.coletado then
        local px, py = player.collider:getPosition()
        if math.abs(px - self.x) < 20 and math.abs(py - self.y) < 20 then
            self.coletado = true
            player.artefatos = player.artefatos + 1
            player.pontuacao = player.pontuacao + 100
            self.collider:destroy()
        end
    end
end

function Artifact:draw()
    if not self.coletado then
        love.graphics.draw(self.image, self.x - 8, self.y - 8)
    end
end

return Artifact
