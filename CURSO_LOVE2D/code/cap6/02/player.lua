-- Definindo a "classe" Jogador
local Jogador = {}
Jogador.__index = Jogador -- Permite herdar métodos

function Jogador:new(x, y, velocidade)
    local objeto = {
        x = x or 0,
        y = y or 0,
        velocidade = velocidade or 200,
        largura = 50,
        altura = 50,
        vida = 100,
        cor = { 0, 1, 0 } -- verde
    }
    setmetatable(objeto, Jogador)
    return objeto
end

function Jogador:update(dt)
    -- Movimento com teclado
    if love.keyboard.isDown("up", "w") then
        self.y = self.y - self.velocidade * dt
    end
    if love.keyboard.isDown("down", "s") then
        self.y = self.y + self.velocidade * dt
    end
    if love.keyboard.isDown("left", "a") then
        self.x = self.x - self.velocidade * dt
    end
    if love.keyboard.isDown("right", "d") then
        self.x = self.x + self.velocidade * dt
    end

    -- Limitar às bordas da tela
    self.x = math.max(0, math.min(love.graphics.getWidth() - self.largura, self.x))
    self.y = math.max(0, math.min(love.graphics.getHeight() - self.altura, self.y))
end

function Jogador:draw()
    love.graphics.setColor(self.cor)
    love.graphics.rectangle("fill", self.x, self.y, self.largura, self.altura)

    -- Barra de vida
    love.graphics.setColor(1, 0, 0) -- vermelho
    love.graphics.rectangle("fill", self.x, self.y - 10, self.largura, 5)
    love.graphics.setColor(0, 1, 0) -- verde
    love.graphics.rectangle("fill", self.x, self.y - 10, self.largura * (self.vida / 100), 5)
end

function Jogador:receberDano(dano)
    self.vida = self.vida - dano
    if self.vida < 0 then
        self.vida = 0
    end
    return self.vida <= 0 -- retorna true se morreu
end

function Jogador:getPosicao()
    return self.x, self.y
end

return Jogador
