function love.load()
    mensagem = "Pressione a barra de espaço ou clique com o botão esquerdo para ver a mensagem!"
end

function love.keypressed(tecla)
    if tecla == "space" then
        mensagem = "Você pressionou a barra de espaço! "
        print("Você pressionou a barra de espaço!")
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        mensagem = "Você clicou no botão esquerdo do mouse em (" .. x .. ", " .. y .. ")"
        print("Você clicou no botão esquerdo do mouse em (" .. x .. ", " .. y .. ")")
    end
end

function love.draw()
    love.graphics.print(mensagem, 200, 300)
end
