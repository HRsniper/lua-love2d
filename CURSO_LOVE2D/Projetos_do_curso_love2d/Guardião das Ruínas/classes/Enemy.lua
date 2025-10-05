local class = require("libs.middleclass")
local anim8 = require("libs.anim8")

local Enemy = class("Enemy")

function Enemy:initialize(world, x, y)
    self.width = 50
    self.height = 50

    self.collider = world:newRectangleCollider(x, y, self.width, self.height,
    { collision_class = "Enemy" })
    self.collider:setFixedRotation(true)

    self.image = love.graphics.newImage("assets/sprites/enemy_walk.png")
    local grid = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(grid('1-4', 1), 0.2)

    self.speed = 100
    self.dano = 10
    self.vida = 50
end

function Enemy:update(dt, playerX, playerY)
    local ex, ey = self.collider:getPosition()
    local dx, dy = playerX - ex, playerY - ey
    local distancia = math.sqrt(dx * dx + dy * dy)

    if distancia < 300 then
        local dirX, dirY = dx / distancia, dy / distancia
        self.collider:setLinearVelocity(dirX * self.speed, dirY * self.speed)
    else
        self.collider:setLinearVelocity(0, 0)
    end

    self.animation:update(dt)
end

function Enemy:draw()
    local ex, ey = self.collider:getPosition()
    self.animation:draw(self.image, ex - 16, ey - 16)
end

function Enemy:checkCollisionWithPlayer(player)
    local px, py = player.collider:getPosition()
    local ex, ey = self.collider:getPosition()
    local dx, dy = px - ex, py - ey
    local distancia = math.sqrt(dx * dx + dy * dy)

    if distancia < 28 then
        player.vida = player.vida - self.dano
        return true
    end
    return false
end

return Enemy
