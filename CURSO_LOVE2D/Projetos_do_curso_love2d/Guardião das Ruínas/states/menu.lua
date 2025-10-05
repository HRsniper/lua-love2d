local class = require("libs.middleclass")
local Gamestate = require("libs.hump.gamestate")
local State = require("states.State")

local MenuState = class("MenuState", State)

function MenuState:initialize()
    self.titleFont = love.graphics.newFont(24)
    self.uiFont = love.graphics.newFont(24)
end

function MenuState:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setFont(self.titleFont)
    love.graphics.printf("GUARDIÃO DAS RUÍNAS", 0, h * 0.3, w, "center")
    love.graphics.setFont(self.uiFont)
    love.graphics.printf("Pressione ENTER para começar", 0, h * 0.5, w, "center")
end

function MenuState:keypressed(key)
    if key == "return" or key == "kpenter" then
        -- Require só aqui, no momento da troca
        local GameState = require("states.jogo")
        Gamestate.switch(GameState())
    end
end

return MenuState
