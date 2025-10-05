player = require("player")

function love.update(dt)
    player.update(dt)
end

function love.draw()
    love.graphics.print("setinha para mover")
    player.draw()
end
