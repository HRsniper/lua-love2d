Jogador = {}
Jogador.__index = Jogador

function Jogador:new(x, y)
    local obj = {
        x = x,
        y = y,
        velocidade = 200
    }
    setmetatable(obj, Jogador)
    return obj
end

function Jogador:update(dt)
    if love.keyboard.isDown("right") then
        self.x = self.x + self.velocidade * dt
    end
end

function Jogador:draw()
    love.graphics.rectangle("fill", self.x, self.y, 50, 50)
end

function love.load()
    jogador = Jogador:new(100, 100)
end

function love.update(dt)
    jogador:update(dt)
end

function love.draw()
    jogador:draw()
end
