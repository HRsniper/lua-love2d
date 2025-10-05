function colidiu(a, b)
    return a.x < b.x + b.largura and
        b.x < a.x + a.largura and
        a.y < b.y + b.altura and
        b.y < a.y + a.altura
end

function love.load()
    -- Configurações da tela
    love.window.setTitle("Esquiva e Coleta")

    -- Jogador
    jogador = {
        x = 50,
        y = 200,
        largura = 30,
        altura = 30,
        velocidade = 200,
        vidas = 3,
        pontuacao = 0
    }

    -- Obstáculos móveis
    obstaculos = {}
    for i = 1, 3 do
        table.insert(obstaculos, {
            x = 300 + i * 150,
            y = 100 + i * 50,
            largura = 40,
            altura = 40,
            velocidade = 100 + i * 20,
            direcao = (i % 2 == 0) and 1 or -1
        })
    end

    -- Itens coletáveis
    itens = {}
    for i = 1, 5 do
        table.insert(itens, {
            x = math.random(200, 700),
            y = math.random(50, 350),
            largura = 15,
            altura = 15,
            coletado = false,
            valor = 5
        })
    end

    gameOver = false
    vitoria = false
    tempo = 0
end

function love.update(dt)
    if gameOver or vitoria then return end

    tempo = tempo + dt

    -- Movimento do jogador
    if love.keyboard.isDown("up") then
        jogador.y = jogador.y - jogador.velocidade * dt
    end
    if love.keyboard.isDown("down") then
        jogador.y = jogador.y + jogador.velocidade * dt
    end
    if love.keyboard.isDown("left") then
        jogador.x = jogador.x - jogador.velocidade * dt
    end
    if love.keyboard.isDown("right") then
        jogador.x = jogador.x + jogador.velocidade * dt
    end

    -- Limitar jogador na tela
    jogador.x = math.max(0, math.min(love.graphics.getWidth() - jogador.largura, jogador.x))
    jogador.y = math.max(0, math.min(love.graphics.getHeight() - jogador.altura, jogador.y))

    -- Movimento dos obstáculos
    for i, obstaculo in ipairs(obstaculos) do
        obstaculo.y = obstaculo.y + obstaculo.velocidade * obstaculo.direcao * dt

        -- Inverter direção nas bordas
        if obstaculo.y <= 0 or obstaculo.y + obstaculo.altura >= love.graphics.getHeight() then
            obstaculo.direcao = -obstaculo.direcao
        end

        -- Verificar colisão com jogador
        if colidiu(jogador, obstaculo) then
            jogador.vidas = jogador.vidas - 1
            -- Afastar jogador
            jogador.x = math.max(0, jogador.x - 30)

            if jogador.vidas <= 0 then
                gameOver = true
            end
        end
    end

    -- Coleta de itens
    local itensRestantes = 0
    for i, item in ipairs(itens) do
        if not item.coletado then
            itensRestantes = itensRestantes + 1

            if colidiu(jogador, item) then
                item.coletado = true
                jogador.pontuacao = jogador.pontuacao + item.valor
            end
        end
    end

    -- Verificar vitória
    if itensRestantes == 0 then
        vitoria = true
    end
end

function love.draw()
    -- Fundo
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    if gameOver then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("GAME OVER!", 300, 200, 0, 2, 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Pontuação final: " .. jogador.pontuacao, 280, 250)
        love.graphics.print("Pressione R para reiniciar", 270, 280)
        return
    end

    if vitoria then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("VITÓRIA!", 320, 200, 0, 2, 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Pontuação final: " .. jogador.pontuacao, 280, 250)
        love.graphics.print("Tempo: " .. string.format("%.1f", tempo) .. "s", 310, 270)
        love.graphics.print("Pressione R para jogar novamente", 250, 300)
        return
    end

    -- Desenhar jogador
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Desenhar obstáculos
    love.graphics.setColor(1, 0, 0)
    for i, obstaculo in ipairs(obstaculos) do
        love.graphics.rectangle("fill", obstaculo.x, obstaculo.y, obstaculo.largura, obstaculo
            .altura)
    end

    -- Desenhar itens
    love.graphics.setColor(1, 1, 0)
    for i, item in ipairs(itens) do
        if not item.coletado then
            love.graphics.rectangle("fill", item.x, item.y, item.largura, item.altura)
        end
    end

    -- Interface
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Vidas: " .. jogador.vidas, 10, 10)
    love.graphics.print("Pontuação: " .. jogador.pontuacao, 10, 30)
    love.graphics.print("Tempo: " .. string.format("%.1f", tempo), 10, 50)

    -- Instruções
    love.graphics.print("Use as setas para mover", 10, 100)
    love.graphics.print("Evite os quadrados vermelhos", 10, 120)
    love.graphics.print("Colete todos os quadrados amarelos", 10, 140)
    love.graphics.print("Esc para sair", 10, 160)
end

function love.keypressed(tecla)
    if tecla == "r" and (gameOver or vitoria) then
        love.load() -- Reiniciar o jogo
    end
    if tecla == "escape" then
        love.event.quit()
    end
end
