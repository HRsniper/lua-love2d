local fisica = {}

function fisica.load()
    fisica.mundo = love.physics.newWorld(0, 800, true)
    fisica.objetos = {}

    -- Chão
    fisica.criarChao(400, 550, 800, 50)

    -- Plataformas
    fisica.criarPlataforma(200, 400, 150, 20)
    fisica.criarPlataforma(600, 300, 150, 20)
end

function fisica.criarCaixa(x, y, largura, altura)
    local obj = {}
    obj.corpo = love.physics.newBody(fisica.mundo, x, y, "dynamic")
    obj.forma = love.physics.newRectangleShape(largura, altura)
    obj.fixture = love.physics.newFixture(obj.corpo, obj.forma)
    obj.fixture:setRestitution(0.3)
    obj.fixture:setFriction(0.7)
    obj.largura = largura
    obj.altura = altura
    obj.tipo = "caixa"

    table.insert(fisica.objetos, obj)
    return obj
end

function fisica.criarBola(x, y, raio)
    local obj = {}
    obj.corpo = love.physics.newBody(fisica.mundo, x, y, "dynamic")
    obj.forma = love.physics.newCircleShape(raio)
    obj.fixture = love.physics.newFixture(obj.corpo, obj.forma)
    obj.fixture:setRestitution(0.8)
    obj.raio = raio
    obj.tipo = "bola"

    table.insert(fisica.objetos, obj)
    return obj
end

function fisica.criarChao(x, y, largura, altura)
    local obj = {}
    obj.corpo = love.physics.newBody(fisica.mundo, x, y, "static")
    obj.forma = love.physics.newRectangleShape(largura, altura)
    obj.fixture = love.physics.newFixture(obj.corpo, obj.forma)
    obj.largura = largura
    obj.altura = altura
    obj.tipo = "chao"

    table.insert(fisica.objetos, obj)
    return obj
end

function fisica.criarPlataforma(x, y, largura, altura)
    return fisica.criarChao(x, y, largura, altura)
end

function fisica.update(dt)
    fisica.mundo:update(dt)
end

function fisica.draw()
    for _, obj in ipairs(fisica.objetos) do
        love.graphics.push()
        love.graphics.translate(obj.corpo:getX(), obj.corpo:getY())
        love.graphics.rotate(obj.corpo:getAngle())

        if obj.tipo == "caixa" or obj.tipo == "chao" then
            love.graphics.setColor(0.8, 0.8, 0.8)
            if obj.tipo == "caixa" then
                love.graphics.setColor(1, 0.6, 0.6)
            end
            love.graphics.rectangle("fill",
                -obj.largura / 2, -obj.altura / 2,
                obj.largura, obj.altura
            )
        elseif obj.tipo == "bola" then
            love.graphics.setColor(0.6, 0.6, 1)
            love.graphics.circle("fill", 0, 0, obj.raio)
        end

        love.graphics.pop()
    end
    love.graphics.setColor(1, 1, 1)
end

-- Uso do sistema
function love.load()
    fisica.load()
end

function love.update(dt)
    fisica.update(dt)
end

function love.draw()
    fisica.draw()

    love.graphics.print("Clique para criar caixa, Espaço para bola", 10, 10)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        fisica.criarCaixa(x, y, 40, 40)
    end
end

function love.keypressed(key)
    if key == "space" then
        local x = love.math.random(100, 700)
        fisica.criarBola(x, 50, 20)
    end
end
