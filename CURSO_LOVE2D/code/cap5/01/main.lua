function love.load()
    inimigos = {
        {x = 100, y = 100, largura = 40, altura = 40, vida = 3},
        {x = 200, y = 150, largura = 40, altura = 40, vida = 3},
        {x = 300, y = 200, largura = 40, altura = 40, vida = 3}
    }
end

function love.draw()
    love.graphics.setColor(1, 0, 0)  -- vermelho
    for i, inimigo in ipairs(inimigos) do
        love.graphics.rectangle("fill", inimigo.x, inimigo.y, inimigo.largura, inimigo.altura)
    end
    love.graphics.setColor(1, 1, 1)  -- reset para branco
end
