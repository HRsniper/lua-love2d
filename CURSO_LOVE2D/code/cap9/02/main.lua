local player = require("player")
local bullet = require("bullet")
local enemy = require("enemy")
local collision = require("collision")

-- Variáveis do jogo
local gameState = "playing" -- "playing", "paused", "gameover"
local score = 0
local highScore = 0

-- Som
local shootSound = love.audio.newSource("assets/shoot.ogg", "static")
local hitSound = love.audio.newSource("assets/hitsound.ogg", "static")

-- Configurações
local config = {
    fireRate = 0.15,
    lastShot = 0
}

local backgroundImg = love.graphics.newImage("assets/background.png")

function love.load()
    love.window.setTitle("Shoot the Enemy")

    -- Carregar fonte
    local font = love.graphics.newFont(20)
    love.graphics.setFont(font)

    -- Carregar high score
    local file = io.open("highscore.txt", "r")
    if file then
        local content = file:read("*a")
        file:close()
        highScore = tonumber(content) or 0
    end
end

function love.update(dt)
    if gameState == "playing" then
        -- Atualizar rate de tiro
        config.lastShot = config.lastShot + dt

        -- Atualizar jogador
        player.update(dt)

        -- Verificar se jogador morreu
        if player.isDead() then
            gameState = "gameover"
            -- Salvar high score
            if score > highScore then
                highScore = score
                local file = io.open("highscore.txt", "w")
                if file then
                    file:write(tostring(highScore))
                    file:close()
                end
            end
            return
        end

        -- Atualizar projéteis e inimigos
        bullet.update(dt)
        enemy.update(dt)

        -- Verificar colisões entre projéteis e inimigos
        for bulletIndex = #bullet.list, 1, -1 do
            local bulletType = bullet.list[bulletIndex]
            local bulletBounds = {
                x = bulletType.x,
                y = bulletType.y,
                width = bulletType.width,
                height = bulletType.height
            }

            for enemyIndex = #enemy.list, 1, -1 do
                local enemyType = enemy.list[enemyIndex]
                local enemyBounds = {
                    x = enemyType.x,
                    y = enemyType.y,
                    width = enemyType.width,
                    height = enemyType.height
                }

                if collision.check(bulletBounds, enemyBounds) then
                    -- Aplicar dano ao inimigo
                    local died, points = enemy.takeDamage(enemyIndex, bulletType.damage or 1)
                    if died then
                        score = score + points
                        enemy.remove(enemyIndex)
                    end

                    bullet.remove(bulletIndex)
                    hitSound:play()
                    break
                end
            end
        end

        -- Verificar colisões entre jogador e inimigos
        local playerBounds = {
            x = player.x,
            y = player.y,
            width = player.width,
            height = player
                .height
        }
        for enemyIndex = #enemy.list, 1, -1 do
            local enemyType = enemy.list[enemyIndex]
            local enemyBounds = {
                x = enemyType.x,
                y = enemyType.y,
                width = enemyType.width,
                height = enemyType.height
            }

            if collision.check(playerBounds, enemyBounds) then
                if player.takeDamage() then
                    enemy.remove(enemyIndex)
                    hitSound:play()
                end
            end
        end
    elseif gameState == "paused" then
        -- Jogo pausado, não atualizar nada
    end
end

function love.draw()
    love.graphics.draw(backgroundImg, 0, 0)

    -- love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 100)

    if gameState == "playing" or gameState == "paused" then
        player.draw()
        bullet.draw()
        enemy.draw()

        -- Interface
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score, 10, 10)
        love.graphics.print("High Score: " .. highScore, 10, 35)
        love.graphics.print("Health: " .. player.health, 10, 60)

        -- Indicador de pausa
        if gameState == "paused" then
            love.graphics.setColor(0, 0, 0, 0.7)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("PAUSED", 0, love.graphics.getHeight() / 2 - 10,
                love.graphics.getWidth(), "center")
            love.graphics.printf("Press P to continue", 0, love.graphics.getHeight() / 2 + 20,
                love.graphics.getWidth(), "center")
        end
    elseif gameState == "gameover" then
        -- Tela de game over
        love.graphics.setColor(1, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("GAME OVER", 0, love.graphics.getHeight() / 2 - 60,
            love.graphics.getWidth(), "center")
        love.graphics.printf("Final Score: " .. score, 0, love.graphics.getHeight() / 2 - 30,
            love.graphics.getWidth(), "center")
        love.graphics.printf("High Score: " .. highScore, 0, love.graphics.getHeight() / 2,
            love.graphics.getWidth(), "center")
        love.graphics.printf("Press R to restart", 0, love.graphics.getHeight() / 2 + 40,
            love.graphics.getWidth(), "center")
        love.graphics.printf("Press ESC to quit", 0, love.graphics.getHeight() / 2 + 70,
            love.graphics.getWidth(), "center")
    end

    -- Instruções
    if gameState == "playing" then
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.print("A/D or Arrows: Move | Click/Space: Shoot | P: Pause", 10,
            love.graphics.getHeight() - 25)
    end
end

function love.mousepressed(x, y, button)
    -- Disparar projétil quando o botão esquerdo for pressionado
    if button == 1 then tryToShoot() end
end

function love.keypressed(key)
    if gameState == "playing" then
        if key == "space" then
            tryToShoot()
        elseif key == "p" then
            gameState = "paused"
        end
    elseif gameState == "paused" then
        if key == "p" then
            gameState = "playing"
        end
    elseif gameState == "gameover" then
        if key == "r" then
            restartGame()
        elseif key == "escape" then
            love.event.quit()
        end
    end
end

function tryToShoot()
    if config.lastShot >= config.fireRate then
        bullet.spawn(player.x, player.y)
        config.lastShot = 0
        shootSound:play()
    end
end

function restartGame()
    -- Resetar variáveis do jogo
    gameState = "playing"
    score = 0
    config.lastShot = 0

    -- Resetar jogador
    player.x = love.graphics.getWidth() / 2 - player.width / 2
    player.y = 500
    player.health = player.maxHealth
    player.invulnerable = false
    player.invulnerableTime = 0

    -- Limpar listas
    bullet.clear()
    enemy.clear()

    -- Resetar spawn rate dos inimigos
    enemy.spawnTimer = 0
    enemy.spawnRate = 2.0
end
