package.path = '../../middleclass.lua'
Class = require('middleclass')

local Entidade = Class("Entidade")

function Entidade:initialize(x, y, largura, altura)
    self.x = x or 0
    self.y = y or 0
    self.largura = largura or 20
    self.altura = altura or 20
    self.velocidadeX = 0
    self.velocidadeY = 0
    self.ativo = true
    self.cor = { 1, 1, 1 }
end

function Entidade:update(dt)
    if not self.ativo then return end

    self.x = self.x + self.velocidadeX * dt
    self.y = self.y + self.velocidadeY * dt
end

function Entidade:draw()
    if not self.ativo then return end

    love.graphics.setColor(self.cor)
    love.graphics.rectangle("fill", self.x, self.y, self.largura, self.altura)
end

function Entidade:colideCom(outra)
    if not self.ativo or not outra.ativo then return false end

    return self.x < outra.x + outra.largura and
        outra.x < self.x + self.largura and
        self.y < outra.y + outra.altura and
        outra.y < self.y + self.altura
end

function Entidade:getCenter()
    return self.x + self.largura / 2, self.y + self.altura / 2
end

function Entidade:destruir()
    self.ativo = false
end

return Entidade
