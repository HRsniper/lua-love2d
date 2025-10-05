local class = require("libs.middleclass")
local Gamestate = require("libs.hump.gamestate")
local State = require("states.State")

local EndState = class("EndState", State)

function EndState:initialize(vitoria)
    self.vitoria = vitoria or false
    self.uiFont = love.graphics.newFont(28)
end

function EndState:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setFont(self.uiFont)
    local msg = self.vitoria and "Você venceu!" or "Game Over"
    love.graphics.printf(msg, 0, h * 0.4, w, "center")
    love.graphics.printf("Pressione ENTER para voltar ao menu", 0, h * 0.55, w, "center")
end

function EndState:keypressed(key)
    if key == "return" or key == "kpenter" then
        local MenuState = require("states.menu")
        Gamestate.switch(MenuState())
    end
end

return EndState
