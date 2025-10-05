package.path = '../../middleclass.lua'
Class = require('middleclass')

local Entidade = require("Entidade")

local Timer = require("Timer")

local Inimigo = Class("Inimigo", Entidade)

function Inimigo:initialize(x, y, tipo)
    Entidade.initialize(self, x, y, 30, 30)

    self.tipo = tipo or 1
    self.vida = self.tipo * 20
    self.maxVida = self.vida
    self.velocidade = math.random(50, 120)
    self.pontos = self.tipo * 10

    -- Propriedades específicas por tipo
    if self.tipo == 1 then
        self.cor = { 1, 0, 0 } -- vermelho - básico
        self.comportamento = "linear"
    elseif self.tipo == 2 then
        self.cor = { 1, 0.5, 0 } -- laranja - rápido
        self.velocidade = self.velocidade * 1.5
        self.comportamento = "zigzag"
    else
        self.cor = { 0.8, 0, 0.8 } -- roxo - tanque
        self.largura, self.altura = 40, 40
        self.vida = self.vida * 2
        self.maxVida = self.vida
        self.comportamento = "perseguir"
    end

    self.tempoMovimento = math.random() * 10 -- para variação

    self.inimigoTimer = Timer:new()
end

function Inimigo:update(dt, jogadorX, jogadorY)
    if not self.ativo then return end

    self.tempoMovimento = self.tempoMovimento + dt

    -- Comportamento baseado no tipo
    if self.comportamento == "linear" then
        self.velocidadeY = self.velocidade
    elseif self.comportamento == "zigzag" then
        self.velocidadeX = math.sin(self.tempoMovimento * 3) * self.velocidade * 0.5
        self.velocidadeY = self.velocidade * 0.7
    elseif self.comportamento == "perseguir" and jogadorX and jogadorY then
        local dx = jogadorX - self.x
        local dy = jogadorY - self.y
        local distancia = math.sqrt(dx * dx + dy * dy)

        if distancia > 0 then
            self.velocidadeX = (dx / distancia) * self.velocidade * 0.5
            self.velocidadeY = (dy / distancia) * self.velocidade * 0.5
        end
    end

    Entidade.update(self, dt)

    -- Destruir se saiu da tela
    if self.y > love.graphics.getHeight() + 50 then
        self:destruir()
    end

    self.inimigoTimer:update(dt)
end

function Inimigo:draw()
    if not self.ativo then return end

    Entidade.draw(self)

    -- Barra de vida para tipos mais fortes
    if self.tipo > 1 then
        local barraY = self.y - 8
        local vidaPorcentagem = self.vida / self.maxVida

        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", self.x, barraY, self.largura, 4)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", self.x, barraY, self.largura * vidaPorcentagem, 4)
    end

    -- Indicador de tipo
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.tipo, self.x + 2, self.y + 2)
end

function Inimigo:receberDano(quantidade)
    self.vida = self.vida - quantidade

    -- Efeito visual de dano
    local corOriginal = self.cor
    self.cor = { 1, 1, 1 } -- branco
    self.inimigoTimer:setTimeout(0.1, function()
        if self.ativo then
            self.cor = corOriginal
        end
    end)

    if self.vida <= 0 then
        self:destruir()
        return true, self.pontos
    end

    return false, 0
end

return Inimigo
