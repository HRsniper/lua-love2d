local class = require("libs.middleclass")
local anim8 = require("libs.anim8")

local Player = class("Player")

function Player:initialize(world, x, y)
    self.width = 50
    self.height = 50

    self.collider = world:newRectangleCollider(x, y, self.width, self.height,
        { collision_class = "Player" })
    self.collider:setFixedRotation(true)

    self.image = love.graphics.newImage("assets/sprites/player_run.png")
    local grid = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
    self.animation = anim8.newAnimation(grid('1-4', 1), 0.1)

    self.speed = 200
    self.vida = 100
    self.pontuacao = 0
    self.artefatos = 0
end

function Player:update(dt)
    local vx, vy = 0, 0
    if love.keyboard.isDown("left") then vx = -self.speed end
    if love.keyboard.isDown("right") then vx = self.speed end
    if love.keyboard.isDown("up") then vy = -self.speed end
    if love.keyboard.isDown("down") then vy = self.speed end

    self.collider:setLinearVelocity(vx, vy)
    self.animation:update(dt)
end

function Player:draw()
    local px, py = self.collider:getPosition()
    self.animation:draw(self.image, px - 16, py - 24)
end

return Player
