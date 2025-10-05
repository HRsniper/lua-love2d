local Player = require("player")
local Enemy = require("enemy")
local utils = require("utils")
local Bullet = require("bullet")

function love.load()
    jogador = Player.new(400, 500)
    inimigos = {}
    balas = {}

    tempoSpawn = 0
    intervaloSpawn = 1.5
    pontuacao = 0
    gameOver = false
end

function love.update(dt)
    if gameOver then return end

    -- Atualizar jogador
    Player.update(jogador, dt)

    -- Sistema de spawn de inimigos
    tempoSpawn = tempoSpawn + dt
    if tempoSpawn >= intervaloSpawn then
        local tipo = math.random(1, 3)
        table.insert(inimigos, Enemy.new(math.random(0, love.graphics.getWidth() - 40), -50, tipo))
        tempoSpawn = 0

        -- Aumentar dificuldade
        intervaloSpawn = math.max(0.3, intervaloSpawn - 0.02)
    end

    -- Atualizar inimigos
    for i = #inimigos, 1, -1 do
        local inimigo = inimigos[i]
        Enemy.update(inimigo, dt)

        -- Verificar colisão com jogador
        if utils.collision(jogador, inimigo) then
            if Player.takeDamage(jogador, 20) then
                gameOver = true
            end
            table.remove(inimigos, i)
        elseif Enemy.isOffScreen(inimigo) then
            table.remove(inimigos, i)
        end
    end

    -- Criar balas e Atualizar balas
    pontuacao = Bullet.update(jogador, balas, inimigos, pontuacao, dt)
end

function love.draw()
    if gameOver then
        love.graphics.print("GAME OVER!", 300, 250, 0, 2, 2)
        love.graphics.print("Pontuação: " .. pontuacao, 320, 300)
        love.graphics.print("Pressione R para reiniciar", 280, 330)
        return
    end

    -- Desenhar jogador
    Player.draw(jogador)

    -- Desenhar inimigos
    for _, inimigo in ipairs(inimigos) do
        Enemy.draw(inimigo)
    end

    -- Desenhar balas
    Bullet.draw(balas)

    -- Interface
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Vida: " .. jogador.vida, 10, 10)
    love.graphics.print("Pontuação: " .. pontuacao, 10, 30)
    love.graphics.print("Inimigos: " .. #inimigos, 10, 50)
end

function love.keypressed(tecla)
    if tecla == "r" and gameOver then
        love.load()
    end
end
