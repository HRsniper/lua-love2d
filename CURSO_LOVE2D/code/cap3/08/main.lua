local jogador = {}
local mundo = {}

function love.load()
    -- Inicializar jogador
    jogador = {
        x = 300,
        y = 300,
        velocidade = 200,
        largura = 50,
        altura = 50,
        cor = { 0, 1, 0 }, -- verde
        pontuacao = 0
    }

    -- Inicializar mundo
    mundo = {
        largura = love.graphics.getWidth(),
        altura = love.graphics.getHeight(),
        cor_fundo = { 0.1, 0.1, 0.2 } -- azul escuro
    }

    -- Configurações
    love.window.setTitle("Jogador Controlável")
end

function love.update(dt)
    -- Salvar posição anterior (para colisões futuras)
    local antiga_x = jogador.x
    local antiga_y = jogador.y

    -- Movimento do jogador
    local movendo = false

    if love.keyboard.isDown("up", "w") then
        jogador.y = jogador.y - jogador.velocidade * dt
        movendo = true
    end
    if love.keyboard.isDown("down", "s") then
        jogador.y = jogador.y + jogador.velocidade * dt
        movendo = true
    end
    if love.keyboard.isDown("left", "a") then
        jogador.x = jogador.x - jogador.velocidade * dt
        movendo = true
    end
    if love.keyboard.isDown("right", "d") then
        jogador.x = jogador.x + jogador.velocidade * dt
        movendo = true
    end

    -- Verificar limites da tela
    if jogador.x < 0 then
        jogador.x = 0
    elseif jogador.x + jogador.largura > mundo.largura then
        jogador.x = mundo.largura - jogador.largura
    end

    if jogador.y < 0 then
        jogador.y = 0
    elseif jogador.y + jogador.altura > mundo.altura then
        jogador.y = mundo.altura - jogador.altura
    end

    -- Adicionar pontos quando se move
    if movendo then
        jogador.pontuacao = jogador.pontuacao + 10 * dt
    end
end

function love.draw()
    -- Cor de fundo
    love.graphics.clear(mundo.cor_fundo)

    -- Desenhar jogador
    love.graphics.setColor(jogador.cor)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Interface do usuário
    love.graphics.setColor(1, 1, 1) -- branco
    love.graphics.print(
        "Posição: (" .. math.floor(jogador.x) .. ", " .. math.floor(jogador.y) .. ")", 10, 10)
    love.graphics.print("Pontuação: " .. math.floor(jogador.pontuacao), 10, 30)
    love.graphics.print("Velocidade: " .. jogador.velocidade, 10, 50)

    -- Instruções
    love.graphics.print("Controles:", 10, 100)
    love.graphics.print("WASD ou Setas - Mover", 10, 120)
    love.graphics.print("+ / - - Mudar velocidade", 10, 140)
    love.graphics.print("R - Resetar", 10, 160)
    love.graphics.print("ESC - Sair", 10, 180)

    -- Desenhar bordas da tela
    love.graphics.setColor(1, 1, 1, 0.3) -- branco semi-transparente
    love.graphics.rectangle("line", 0, 0, mundo.largura - 1, mundo.altura - 1)
end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "r" then
        -- Resetar jogador
        jogador.x = 300
        jogador.y = 300
        jogador.pontuacao = 0
        jogador.velocidade = 200
        print("Jogo resetado!")
    elseif tecla == "kp+" or tecla == "=" then
        -- Aumentar velocidade
        jogador.velocidade = jogador.velocidade + 50
        print("Velocidade: " .. jogador.velocidade)
    elseif tecla == "kp-" or tecla == "-" then
        -- Diminuir velocidade
        jogador.velocidade = math.max(50, jogador.velocidade - 50)
        print("Velocidade: " .. jogador.velocidade)
    end
end
