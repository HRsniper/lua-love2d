local mensagem = "Pressione uma tecla..."

function love.keypressed(tecla)
    mensagem = "Você pressionou: " .. tecla
end

function love.draw()
    love.graphics.print(mensagem, 300, 300)
end
