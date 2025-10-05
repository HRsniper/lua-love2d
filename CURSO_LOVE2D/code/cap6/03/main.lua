package.path = "../../middleclass.lua"
Class = require("middleclass")

Player = Class("Player")

function Player:initialize(x, y, color)
    self.x = x
    self.y = y
    self.speed = 200
    self.color = color or { 0, 1, 0 } -- verde
end

function Player:update(dt)
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    end
end

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, 50, 50)
end

Inimigo = Class("Inimigo", Player)

function Inimigo:update(dt)
    self.x = self.x + self.speed * dt -- movimento automático
end

function love.load()
    jogador = Player:new(100, 100)
    inimigo = Inimigo:new(200, 200, { 1, 0, 0 }) -- vermelho
end

function love.update(dt)
    jogador:update(dt)
    inimigo:update(dt)
end

function love.draw()
    jogador:draw()
    inimigo:draw()
end
