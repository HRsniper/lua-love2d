local class = require("libs.middleclass")

local State = class("State")

function State:initialize() end

function State:enter(prev, ...) end

function State:leave() end

function State:resume() end

function State:update(dt) end

function State:draw() end

function State:keypressed(key) end

function State:keyreleased(key) end

function State:mousepressed(x, y, button) end

function State:mousereleased(x, y, button) end

return State
