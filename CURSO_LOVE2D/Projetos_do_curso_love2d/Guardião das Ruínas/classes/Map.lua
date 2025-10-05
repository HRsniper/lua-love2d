local class = require("libs.middleclass")
local sti = require("libs.sti")

local Map = class("Map")

function Map:initialize(world, mapPath)
    -- Carrega o mapa sem plugins
    self.map = sti(mapPath)
    print("Tileset image path:", self.map.tilesets[1].image)


    -- Cria colisores a partir da camada "colisao"
    local collisionLayer = self.map.layers["colisao"]
    if collisionLayer and collisionLayer.objects then
        for _, obj in ipairs(collisionLayer.objects) do
            if obj.shape == "rectangle" then
                local cx = obj.x + obj.width / 2
                local cy = obj.y + obj.height / 2
                local collider = world:newRectangleCollider(cx, cy, obj.width, obj.height)
                collider:setType("static")
                collider:setCollisionClass("Obstacle")
            end
        end
    end
end

function Map:update(dt)
    self.map:update(dt)
end

function Map:draw()
    self.map:draw()
end

return Map
