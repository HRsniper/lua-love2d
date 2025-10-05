function love.load()
    -- Cria um mundo físico com gravidade (x=0, y=500)
    mundo = love.physics.newWorld(0, 500, true)

    -- Cria uma caixa dinâmica
    caixaCorpo = love.physics.newBody(mundo, 400, 100, "dynamic")
    caixaForma = love.physics.newRectangleShape(50, 50)
    caixaFixture = love.physics.newFixture(caixaCorpo, caixaForma)
    caixaFixture:setRestitution(0.8) -- Elasticidade (quique)

    -- Cria o chão estático
    chaoCorpo = love.physics.newBody(mundo, 400, 550, "static")
    chaoForma = love.physics.newRectangleShape(800, 50)
    chaoFixture = love.physics.newFixture(chaoCorpo, chaoForma)
end

function love.update(dt)
    mundo:update(dt)
end

function love.draw()
    -- Desenha a caixa
    love.graphics.push()
    love.graphics.translate(caixaCorpo:getX(), caixaCorpo:getY())
    love.graphics.rotate(caixaCorpo:getAngle())
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.rectangle("fill", -25, -25, 50, 50)
    love.graphics.pop()

    -- Desenha o chão
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill",
        chaoCorpo:getX() - 400, chaoCorpo:getY() - 25,
        800, 50
    )

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Pressione o mouse para aplicar impulso", 0, 0)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- Aplica impulso na direção do mouse
        local impulseX = (x - caixaCorpo:getX()) * 10
        local impulseY = (y - caixaCorpo:getY()) * 10
        caixaCorpo:applyLinearImpulse(impulseX, impulseY)
    end
end
