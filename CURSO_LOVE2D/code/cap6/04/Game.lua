package.path = '../../middleclass.lua'
Class = require('middleclass')

local Player = require("Player")
local Inimigo = require("Inimigo")
local Projetil = require("Projetil")

-- local Timer = require("Timer")

local Game = Class("Game")

function Game:initialize()
    self.player = Player:new(400, 500)
    self.inimigos = {}
    self.projeteis = {}

    self.tempoSpawn = 0
    self.intervaloSpawn = 1.5
    self.pontuacao = 0
    self.wave = 1
    self.inimigosPorWave = 5
    self.inimigosSpawnados = 0

    self.estado = "jogando" -- "jogando", "pausado", "gameover", "reiniciar"

    -- self.gameTimer = Timer:new()
end

function Game:update(dt)
    if self.estado ~= "jogando" then return end

    -- Atualizar player
    self.player:update(dt)

    -- Sistema de spawn
    self.tempoSpawn = self.tempoSpawn + dt
    if self.tempoSpawn >= self.intervaloSpawn and self.inimigosSpawnados < self.inimigosPorWave then
        self:spawnInimigo()
        self.tempoSpawn = 0
        self.inimigosSpawnados = self.inimigosSpawnados + 1
    end

    -- Atualizar inimigos
    local jogadorX, jogadorY = self.player:getCenter()
    for i = #self.inimigos, 1, -1 do
        local inimigo = self.inimigos[i]
        inimigo:update(dt, jogadorX, jogadorY)

        if not inimigo.ativo then
            table.remove(self.inimigos, i)
        elseif inimigo:colideCom(self.player) then
            if self.player:receberDano(20) then
                self.estado = "gameover"
            end
            inimigo:destruir()
            table.remove(self.inimigos, i)
        end
    end

    -- Atualizar projéteis
    for i = #self.projeteis, 1, -1 do
        local projetil = self.projeteis[i]
        projetil:update(dt)

        if not projetil.ativo then
            table.remove(self.projeteis, i)
        else
            -- Verificar colisão com inimigos
            for j = #self.inimigos, 1, -1 do
                local inimigo = self.inimigos[j]
                if projetil:colideCom(inimigo) then
                    local morreu, pontos = inimigo:receberDano(projetil.dano)

                    if morreu then
                        self.pontuacao = self.pontuacao + pontos
                        table.remove(self.inimigos, j)
                    end

                    projetil:destruir()
                    table.remove(self.projeteis, i)
                    break
                end
            end
        end
    end

    -- Verificar próxima wave
    if #self.inimigos == 0 and self.inimigosSpawnados >= self.inimigosPorWave then
        self:proximaWave()
    end

    -- self.gameTimer:update(dt)
end

function Game:draw()
    if self.estado == "gameover" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("GAME OVER", 300, 250, 0, 2, 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Pontuação Final: " .. self.pontuacao, 300, 300)
        love.graphics.print("Wave Alcançada: " .. self.wave, 300, 320)
        love.graphics.print("R - Resetar", 300, 340)
        return
    end

    -- Desenhar todos os objetos
    self.player:draw()

    for _, inimigo in ipairs(self.inimigos) do
        inimigo:draw()
    end

    for _, projetil in ipairs(self.projeteis) do
        projetil:draw()
    end

    -- Interface
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Vida: " .. self.player.vida, 10, 10)
    love.graphics.print("Pontuação: " .. self.pontuacao, 10, 30)
    love.graphics.print("Wave: " .. self.wave, 10, 50)
    love.graphics.print("Inimigos: " .. #self.inimigos, 10, 70)
    love.graphics.print("WASD ou Setas - Mover", 10, 90)
    love.graphics.print("ESC - Sair", 10, 110)
end

function Game:spawnInimigo()
    local x = math.random(0, love.graphics.getWidth() - 40)
    local tipo = math.random(1, math.min(3, self.wave))
    table.insert(self.inimigos, Inimigo:new(x, -50, tipo))
end

function Game:atirar()
    if self.estado ~= "jogando" then return end

    local playerX, playerY = self.player:getCenter()
    table.insert(self.projeteis, Projetil:new(playerX, playerY, 0, -1, 400))
end

function Game:proximaWave()
    self.wave = self.wave + 1
    self.inimigosPorWave = self.inimigosPorWave + 2
    self.inimigosSpawnados = 0
    self.intervaloSpawn = math.max(0.3, self.intervaloSpawn - 0.1)

    -- Curar player um pouco
    self.player:curar(25)
end

function Game:keypressed(key)
    if key == "space" then
        self:atirar()
    elseif key == "r" and self.estado == "gameover" then
        self.estado = "reiniciar"
    elseif key == "escape" then
        print("Jogo fechado pelo usuário")
        love.event.quit()
    end
end

return Game
