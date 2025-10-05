local Camera = {}
Camera.__index = Camera

function Camera:new(x, y)
    local cam = {
        x = x or 0,
        y = y or 0,
        scaleX = 1,
        scaleY = 1,
        rotation = 0,
        -- Limites do mundo
        bounds = {
            minX = nil,
            maxX = nil,
            minY = nil,
            maxY = nil
        },
        -- Zona morta (área onde o jogador pode se mover sem mover a câmera)
        deadzone = {
            x = 50,
            y = 50,
            width = 100,
            height = 100
        }
    }
    setmetatable(cam, Camera)
    return cam
end

function Camera:setBounds(minX, minY, maxX, maxY)
    self.bounds.minX = minX
    self.bounds.minY = minY
    self.bounds.maxX = maxX
    self.bounds.maxY = maxY
end

function Camera:follow(target, dt)
    local lerpSpeed = dt * 3

    -- Calcula posição alvo da câmera
    local targetX = target.x - love.graphics.getWidth() / 2
    local targetY = target.y - love.graphics.getHeight() / 2

    -- Sistema de deadzone
    local screenW, screenH = love.graphics.getDimensions()
    local centerX = self.x + screenW / 2
    local centerY = self.y + screenH / 2

    local dx = target.x - centerX
    local dy = target.y - centerY

    if math.abs(dx) > self.deadzone.width / 2 then
        targetX = self.x + (dx - self.deadzone.width / 2 * (dx > 0 and 1 or -1))
    else
        targetX = self.x
    end

    if math.abs(dy) > self.deadzone.height / 2 then
        targetY = self.y + (dy - self.deadzone.height / 2 * (dy > 0 and 1 or -1))
    else
        targetY = self.y
    end

    -- Interpola suavemente
    self.x = self.x + (targetX - self.x) * lerpSpeed
    self.y = self.y + (targetY - self.y) * lerpSpeed

    -- Aplica limites
    if self.bounds.minX and self.bounds.maxX then
        self.x = math.max(self.bounds.minX,
            math.min(self.x, self.bounds.maxX - screenW))
    end

    if self.bounds.minY and self.bounds.maxY then
        self.y = math.max(self.bounds.minY,
            math.min(self.y, self.bounds.maxY - screenH))
    end
end

function Camera:apply()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
    love.graphics.pop()
end

function Camera:worldToScreen(x, y)
    return (x - self.x) / self.scaleX, (y - self.y) / self.scaleY
end

function Camera:screenToWorld(x, y)
    return x * self.scaleX + self.x, y * self.scaleY + self.y
end

return Camera
