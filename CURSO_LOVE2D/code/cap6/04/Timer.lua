package.path = '../../middleclass.lua'
Class = require('middleclass')

local Timer = Class("Timer")

function Timer:initialize()
    self.timeouts = {}
end

function Timer:setTimeout(delay, callback)
    table.insert(self.timeouts, {
        tempoRestante = delay,
        callback = callback
    })
end

function Timer:update(dt)
    for index = #self.timeouts, 1, -1 do
        local time = self.timeouts[index]
        time.tempoRestante = time.tempoRestante - dt
        if time.tempoRestante <= 0 then
            time.callback()
            table.remove(self.timeouts, index)
        end
    end
end

return Timer

--[[ USO
local Timer = require("Timer")

Em: function <class>:initialize(...)
    ...codico...
    self.meuTimer = Timer:new()
end

Em: function <class>:update(dt, ...)
    ...codico...
    self.meuTimer:update(dt)
end

Em qual função que precisa de temporizador:
function <function>(...)
    self.meuTimer:setTimeout(0.1, function()
        ...codico...
    end)
end
]]
