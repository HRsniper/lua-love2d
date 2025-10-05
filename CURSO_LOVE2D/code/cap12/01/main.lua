function love.load()
    -- Cria um mundo físico com gravidade (x=0, y=500)
    mundo = love.physics.newWorld(0, 500, true)

    -- Cria uma caixa dinâmica
    corpo = love.physics.newBody(mundo, 400, 100, "dynamic")
    forma = love.physics.newRectangleShape(50, 50)
    fixture = love.physics.newFixture(corpo, forma)
end

function love.update(dt)
    mundo:update(dt)
end

function love.draw()
    love.graphics.rectangle("line", corpo:getX(), corpo:getY(), 50, 50)
end
