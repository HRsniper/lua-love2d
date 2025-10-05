package.path = '../../middleclass.lua'
Class = require('middleclass')

local Entidade = require("Entidade")

local Projetil = Class("Projetil", Entidade)

function Projetil:initialize(x, y, direcaoX, direcaoY, velocidade)
    Entidade.initialize(self, x, y, 6, 10)

    self.velocidadeX = direcaoX * velocidade
    self.velocidadeY = direcaoY * velocidade
    self.cor = { 1, 1, 0 } -- amarelo
    self.dano = 10
    self.tempoVida = 3   -- segundos
    self.idade = 0
end

function Projetil:update(dt)
    Entidade.update(self, dt)

    self.idade = self.idade + dt

    -- Destruir se muito antigo ou fora da tela
    if self.idade > self.tempoVida or self:foradaTela() then
        self:destruir()
    end
end

function Projetil:foradaTela()
    return self.x < -10 or self.x > love.graphics.getWidth() + 10 or
        self.y < -10 or self.y > love.graphics.getHeight() + 10
end

return Projetil
