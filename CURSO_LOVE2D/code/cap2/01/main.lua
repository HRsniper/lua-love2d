InimigosDerrotados = 0
SpacePressed = false
Dano = 0

function calcularDano(forca)
    return forca * 10
end

function love.keypressed(tecla)
    if tecla == "space" then
        InimigosDerrotados = InimigosDerrotados + 1
        SpacePressed = true
        Dano = calcularDano(3)
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Pressione Espaço para derrotar um inimigo!", 300, 280)
    love.graphics.print("Inimigos derrotados: " .. InimigosDerrotados, 300, 300)

    if SpacePressed == true then
        love.graphics.setColor(1, 0, 0) -- vermelho
        love.graphics.print("Dano causado: " .. Dano, 300, 320)
    end
end
