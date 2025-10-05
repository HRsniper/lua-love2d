function love.load()
    fonte_pequena = love.graphics.newFont(16)
    fonte_grande = love.graphics.newFont(32)
    fonte_titulo = love.graphics.newFont(48)
end

function love.draw()
    -- Fundo escuro
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Retângulo vermelho
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 100, 100, 200, 100)

    -- Círculo azul
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle("fill", 300, 300, 50)

    -- Linha verde
    love.graphics.setColor(0, 1, 0)
    love.graphics.line(100, 100, 400, 400)

    love.graphics.setColor(1, 1, 1) -- branco
    love.graphics.print("Pontuação: 100", 10, 10)
    -- Parâmetros: texto, x, y

    -- Título
    love.graphics.setFont(fonte_titulo)
    love.graphics.setColor(1, 1, 0) -- amarelo
    love.graphics.print("MEU JOGO", 300, 50)

    -- Informações do jogo
    love.graphics.setFont(fonte_pequena)
    love.graphics.setColor(1, 1, 1) -- branco
    love.graphics.print("Pontuação: 1500", 10, 10)
    love.graphics.print("Vidas: 3", 10, 30)
    love.graphics.print("Nível: 2", 10, 50)

    local texto = "GAME OVER"
    local fonte = love.graphics.getFont()
    local largura = fonte:getWidth(texto)
    local altura = fonte:getHeight()

    local x = (love.graphics.getWidth() - largura) / 2
    local y = (love.graphics.getHeight() - altura) / 2

    love.graphics.setColor(1, 0, 0)
    love.graphics.print(texto, x, y)
end
