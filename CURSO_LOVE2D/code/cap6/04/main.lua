local Game = require("Game")

-- Instância global do jogo
local jogo = nil

function love.load()
    jogo = Game:new()
end

function love.update(dt)
    if jogo.estado == "reiniciar" then
        jogo = Game:new()
    else
        jogo:update(dt)
    end
end

function love.draw()
    jogo:draw()
end

function love.keypressed(key)
    jogo:keypressed(key)
end
