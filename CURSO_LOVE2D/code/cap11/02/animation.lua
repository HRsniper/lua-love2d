local Animacao = {
    spritesheet = nil,
    quads = {},
    frame = 1,
    tempo = 0,
    intervalo = 0.1,
    spritesheetWH = {
        width = 50,
        height = 50,
    }
}
Animacao.__index = Animacao

function Animacao:new(img)
    local self = setmetatable({}, Animacao)
    self.spritesheet = love.graphics.newImage(img)

    local sheetWidth = self.spritesheet:getWidth()
    local frameCount = sheetWidth / self.spritesheetWH.width
    -- Inserir quads aqui
    for i = 0, frameCount - 1 do
        table.insert(self.quads,
            love.graphics.newQuad(i * self.spritesheetWH.width, 0,
                self.spritesheetWH.width, self.spritesheetWH.height,
                self.spritesheet:getDimensions()))
    end
    return self
end

function Animacao:update(dt)
    self.tempo = self.tempo + dt
    if self.tempo > self.intervalo then
        self.frame = self.frame % #self.quads + 1
        self.tempo = 0
    end
end

function Animacao:draw(x, y)
    love.graphics.draw(self.spritesheet, self.quads[self.frame], x, y)
end

return Animacao
