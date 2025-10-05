local tempo = 0

function love.update(dt)
    tempo = tempo + dt
end

function love.draw()
    love.graphics.print("Tempo: " .. math.floor(tempo), 10, 10)
end
