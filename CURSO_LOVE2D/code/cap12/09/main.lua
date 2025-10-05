function love.load()
    thread = love.thread.newThread("worker.lua")
    channel = love.thread.getChannel("resultado")

    thread:start()
    resultado = nil
end

function love.update(dt)
    -- Verifica se há resultado da thread
    local msg = channel:pop()
    if msg then
        resultado = msg
    end
end

function love.draw()
    if resultado then
        love.graphics.print("Resultado da thread: " .. resultado, 100, 100)
    else
        love.graphics.print("Processando...", 100, 100)
    end
end
