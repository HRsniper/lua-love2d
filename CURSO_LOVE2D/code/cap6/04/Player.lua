package.path = '../../middleclass.lua'
Class = require('middleclass')

local Timer = require("Timer")
local Entidade = require("Entidade")

local Player = Class("Player", Entidade)

function Player:initialize(x, y, velocidade)
    Entidade.initialize(self, x, y, 50, 50)
    self.velocidade = velocidade or 200
    self.vida = 100
    self.maxVida = 100
    self.cor = { 0, 1, 0 }
    self.pontuacao = 0

    self.playerTimer = Timer:new()
end

function Player:update(dt)
    local dx, dy = 0, 0

    -- Capturar entrada
    if love.keyboard.isDown("up", "w") then dy = dy - 1 end
    if love.keyboard.isDown("down", "s") then dy = dy + 1 end
    if love.keyboard.isDown("left", "a") then dx = dx - 1 end
    if love.keyboard.isDown("right", "d") then dx = dx + 1 end

    -- Normalizar movimento diagonal
    if dx ~= 0 or dy ~= 0 then
        local length = math.sqrt(dx * dx + dy * dy)
        dx, dy = dx / length, dy / length

        self.x = self.x + dx * self.velocidade * dt
        self.y = self.y + dy * self.velocidade * dt
    end

    -- Limitar às bordas
    self.x = math.max(0, math.min(love.graphics.getWidth() - self.largura, self.x))
    self.y = math.max(0, math.min(love.graphics.getHeight() - self.altura, self.y))

    self.playerTimer:update(dt)
end

function Player:draw()
    -- Corpo do jogador
    love.graphics.setColor(self.cor)
    love.graphics.rectangle("fill", self.x, self.y, self.largura, self.altura)

    -- Barra de vida
    local barraLargura = self.largura
    local barraAltura = 6
    local barraY = self.y - 12

    love.graphics.setColor(0.2, 0.2, 0.2) -- fundo escuro
    love.graphics.rectangle("fill", self.x, barraY, barraLargura, barraAltura)

    love.graphics.setColor(1, 0, 0) -- vermelho
    love.graphics.rectangle("fill", self.x, barraY, barraLargura, barraAltura)

    love.graphics.setColor(0, 1, 0) -- verde
    local vidaPorcentagem = self.vida / self.maxVida
    love.graphics.rectangle("fill", self.x, barraY, barraLargura * vidaPorcentagem, barraAltura)
end

function Player:receberDano(quantidade)
    self.vida = math.max(0, self.vida - quantidade)

    -- Efeito visual de dano (piscar vermelho)
    self.cor = { 1, 0.3, 0.3 }
    self.playerTimer:setTimeout(0.1, function()
        self.cor = { 0, 1, 0 }
    end)

    return self.vida <= 0
end

function Player:curar(quantidade)
    self.vida = math.min(self.maxVida, self.vida + quantidade)
end

function Player:adicionarPontos(pontos)
    self.pontuacao = self.pontuacao + pontos
end

function Player:getCenter()
    return self.x + self.largura / 2, self.y + self.altura / 2
end

return Player
