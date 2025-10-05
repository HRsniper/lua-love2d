local player = {
    img = love.graphics.newImage("assets/player.png"),
    x = 400,
    y = 500,
    speed = 300,
    quads = {},
    frameAtual = 0,
    velocidadeAnimacao = 0.2,
    tempoFrame = 0,
    height = 50,
    width = 50
}

-- Criar quads para cada frame da animação (4 frames de 50x50)
for i = 0, 3 do
    player.quads[i] = love.graphics.newQuad(i * player.width, 0, player.width, player.height,
        player.img:getDimensions())
end

function player.update(dt)
    if love.keyboard.isDown("a", "left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("d", "right") then
        player.x = player.x + player.speed * dt
    end

    player.tempoFrame = player.tempoFrame + dt
    if player.tempoFrame >= player.velocidadeAnimacao then
        player.frameAtual = (player.frameAtual + 1) % 4
        player.tempoFrame = 0
    end

    -- Manter dentro da tela
    player.x = math.max(0, math.min(love.graphics.getWidth() - player.width, player.x))
end

function player.draw()
    love.graphics.draw(player.img, player.quads[player.frameAtual], player.x, player.y)
end

return player
