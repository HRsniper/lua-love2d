local animation = require('animation')

function love.load()
    player = animation:new("assets/player.png")
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw(100, 100)
end
