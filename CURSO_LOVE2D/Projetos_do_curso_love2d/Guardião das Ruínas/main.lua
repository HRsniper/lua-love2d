local Gamestate = require("libs.hump.gamestate")
local MenuState = require("states.menu")

function love.load()
    love.window.setTitle("Guardião das Ruínas")
    love.graphics.setDefaultFilter("nearest", "nearest")

    Gamestate.registerEvents()
    Gamestate.switch(MenuState())
end
