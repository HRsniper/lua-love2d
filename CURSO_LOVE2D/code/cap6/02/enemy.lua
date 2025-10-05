local Inimigo = {}
Inimigo.__index = Inimigo

function Inimigo:new(x, y, tipo)
    local objeto = {
        x = x,
        y = y,
        largura = 30,
        altura = 30,
        velocidade = math.random(50, 150),
        vida = (tipo or 1) * 2,
        tipo = tipo or 1,
        direcao = math.random() * math.pi * 2 -- direção aleatória
    }

    -- Propriedades baseadas no tipo
    if objeto.tipo == 1 then
        objeto.cor = { 1, 0, 0 }   -- vermelho
    elseif objeto.tipo == 2 then
        objeto.cor = { 1, 0.5, 0 } -- laranja
        objeto.velocidade = objeto.velocidade * 1.5
    else
        objeto.cor = { 0.5, 0, 0.5 } -- roxo
        objeto.largura = 40
        objeto.altura = 40
        objeto.vida = objeto.vida * 2
    end

    setmetatable(objeto, Inimigo)
    return objeto
end

function Inimigo:update(dt)
    -- Movimento baseado no tipo
    if self.tipo == 1 then
        -- Movimento linear
        self.x = self.x + math.cos(self.direcao) * self.velocidade * dt
        self.y = self.y + math.sin(self.direcao) * self.velocidade * dt
    elseif self.tipo == 2 then
        -- Movimento em espiral
        self.direcao = self.direcao + dt
        self.x = self.x + math.cos(self.direcao) * self.velocidade * dt
        self.y = self.y + math.sin(self.direcao) * self.velocidade * dt
    else
        -- Movimento lento e direto
        self.y = self.y + self.velocidade * 0.5 * dt
    end
end

function Inimigo:draw()
    love.graphics.setColor(self.cor)
    love.graphics.rectangle("fill", self.x, self.y, self.largura, self.altura)

    -- Indicador de tipo
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.tipo, self.x + 5, self.y + 5)
end

function Inimigo:estaForaDaTela()
    return self.x < -50 or self.x > love.graphics.getWidth() + 50 or
        self.y < -50 or self.y > love.graphics.getHeight() + 50
end

return Inimigo
