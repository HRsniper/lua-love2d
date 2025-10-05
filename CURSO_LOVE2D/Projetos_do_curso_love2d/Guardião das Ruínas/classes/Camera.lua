local class = require("libs.middleclass")
local HumpCamera = require("libs.hump.camera")

local Camera = class("Camera")

function Camera:initialize(x, y)
    self.cam = HumpCamera(x, y)
    self.suavizacao = 5
    self.zoom = 1
end

function Camera:update(dt, targetX, targetY, mapWidth, mapHeight)
    -- Posição atual da câmera
    local camX, camY = self.cam:position()

    -- Suavização de movimento
    local nx = camX + (targetX - camX) * math.min(dt * self.suavizacao, 1)
    local ny = camY + (targetY - camY) * math.min(dt * self.suavizacao, 1)

    -- Metade da tela (considerando zoom)
    local halfW = (love.graphics.getWidth() / 2) / self.zoom
    local halfH = (love.graphics.getHeight() / 2) / self.zoom

    -- Limites para não sair do mapa
    nx = math.max(halfW, math.min(nx, mapWidth - halfW))
    ny = math.max(halfH, math.min(ny, mapHeight - halfH))

    -- Atualiza posição
    self.cam:lookAt(nx, ny)
end

function Camera:setZoom(z)
    self.zoom = z
    self.cam:zoomTo(z)
end

function Camera:attach()
    self.cam:attach()
end

function Camera:detach()
    self.cam:detach()
end

return Camera
