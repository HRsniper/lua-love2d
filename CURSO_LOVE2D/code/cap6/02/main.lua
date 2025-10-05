local Jogador = require("player")
local Inimigo = require("02.enemy")

function love.load()
    jogador = Jogador:new(100, 100, 250)
    inimigo = Inimigo:new(150, 150, 3)
end

function love.update(dt)
    jogador:update(dt)

    inimigo:update(dt)

    if inimigo:estaForaDaTela() then
        print("Inimigo fora da tela!")
    end
end

function love.draw()
    jogador:draw()
    inimigo:draw()

    -- Informações na tela
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Vida: " .. jogador.vida, 10, 10)
    local x, y = jogador:getPosicao()
    love.graphics.print("Posição: (" .. math.floor(x) .. ", " .. math.floor(y) .. ")", 10, 30)
end
