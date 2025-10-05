-- package.path = "?.lua;assets/?.png"
player = require("player")
bullet = require("bullet")
enemy = require("enemy")

pontuacao = 0
somTiro = love.audio.newSource("assets/shoot.ogg", "static")

function colidiu(a, b)
    return a.x < b.x + b.width and
        b.x < a.x + a.width and
        a.y < b.y + b.height and
        b.y < a.y + a.height
end

function love.load()
    love.window.setTitle("Shoot the Enemy")
end

function love.update(dt)
    player.update(dt)
    bullet.update(dt)
    enemy.update(dt)

    for i = #bullet.list, 1, -1 do
        local b = bullet.list[i]
        for j = #enemy.list, 1, -1 do
            local e = enemy.list[j]
            if colidiu({ x = b.x, y = b.y, width = 10, height = 10 }, { x = e.x, y = e.y, width = 50, height = 50 }) then
                table.remove(bullet.list, i)
                table.remove(enemy.list, j)
                pontuacao = pontuacao + 1
                break
            end
        end
    end
end

function love.draw()
    -- Cor #282A36
    love.graphics.setBackgroundColor(40 / 255, 42 / 255, 54 / 255)

    player.draw()
    bullet.draw()
    enemy.draw()
    love.graphics.print("Pontuação: " .. pontuacao, 10, 10)

    -- Instruções
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Use A D | < > para mover, espaço | click esquerdo para disparar", 10,
        love.graphics.getHeight() - 30)
end

function love.mousepressed(x, y, button)
    -- Disparar projétil quando o botão esquerdo for pressionado
    if button == 1 then
        bullet.spawn(player.x + player.width / 2, player.y)
        somTiro:play()
    end
end

function love.keypressed(key)
    if key == "space" then
        bullet.spawn(player.x + player.width / 2, player.y)
        somTiro:play()
    end
end
