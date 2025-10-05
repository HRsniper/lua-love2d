local Camera = require("camera")

local camera
local jogador

function love.load()
    camera = Camera:new()
    camera:setBounds(-1000, -1000, 1000, 1000) -- exemplo de limites do mundo

    -- Exemplo de uso seguindo o jogador
    jogador = { x = 400, y = 300, speed = 200 }
end

function love.update(dt)
    -- Movimento do jogador
    if love.keyboard.isDown("left") then
        jogador.x = jogador.x - jogador.speed * dt
    elseif love.keyboard.isDown("right") then
        jogador.x = jogador.x + jogador.speed * dt
    end

    if love.keyboard.isDown("up") then
        jogador.y = jogador.y - jogador.speed * dt
    elseif love.keyboard.isDown("down") then
        jogador.y = jogador.y + jogador.speed * dt
    end

    camera:follow(jogador, dt)
end

function love.draw()
    camera:apply()

    -- Desenha o mundo
    love.graphics.setColor(0.3, 0.7, 0.3)
    for i = -10, 10 do
        for j = -10, 10 do
            love.graphics.rectangle("line", i * 100, j * 100, 100, 100)
        end
    end

    -- Desenha o jogador
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", jogador.x - 16, jogador.y - 16, 32, 32)

    camera:clear()

    -- UI (não afetada pela câmera)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Use as setas para mover", 10, 10)
    love.graphics.print(string.format("Posição: %.1f, %.1f", jogador.x, jogador.y), 10, 25)
end
