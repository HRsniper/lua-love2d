function love.load()
    mensagem = "Bem-vindo ao LÖVE2D!"
end

function love.update(dt)
    -- Aqui poderíamos atualizar posições, verificar colisões etc.
end

function love.draw()
    love.graphics.print(mensagem, 300, 250)
end
