local camera = {
    x = 0,
    y = 0,
    scale = 1,
    rotation = 0
}

function camera:apply()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scale, 1 / self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function camera:clear()
    love.graphics.pop()
end

function camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function camera:lookAt(x, y)
    self.x = x - love.graphics.getWidth() / 2
    self.y = y - love.graphics.getHeight() / 2
end

function camera:zoom(factor)
    self.scale = self.scale * factor
end

-- Exemplo de uso seguindo o jogador
local jogador = { x = 400, y = 300, speed = 200 }

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

    -- Câmera segue o jogador suavemente
    local targetX = jogador.x - love.graphics.getWidth() / 2
    local targetY = jogador.y - love.graphics.getHeight() / 2

    camera.x = camera.x + (targetX - camera.x) * dt * 2
    camera.y = camera.y + (targetY - camera.y) * dt * 2
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
