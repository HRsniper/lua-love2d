function colidiu(a, b)
    -- Verificar se os objetos existem
    if not a or not b then
        return false
    end

    -- Verificar se têm as propriedades necessárias
    if not (a.x and a.y and a.largura and a.altura and
            b.x and b.y and b.largura and b.altura) then
        return false
    end

    return a.x < b.x + b.largura and -- a está à esquerda da borda direita de b
        b.x < a.x + a.largura and    -- b está à esquerda da borda direita de a
        a.y < b.y + b.altura and     -- a está acima da borda inferior de b
        b.y < a.y + a.altura         -- b está acima da borda inferior de a
end

function love.load()
    -- Configurações da tela
    love.window.setTitle("Jogo de Coleta - Colisões AABB")

    -- Jogador
    jogador = {
        x = 50,
        y = 50,
        largura = 30,
        altura = 30,
        velocidade = 180,
        cor = { 80 / 255, 250 / 255, 123 / 255 } -- Cor #50FA7B
    }

    -- Obstáculos (paredes)
    obstaculos = {
        { x = 200, y = 50,  largura = 20,  altura = 200 },
        { x = 400, y = 100, largura = 20,  altura = 150 },
        { x = 100, y = 300, largura = 200, altura = 20 },
        { x = 350, y = 350, largura = 150, altura = 20 },
        { x = 550, y = 200, largura = 20,  altura = 200 }
    }

    -- Moedas
    moedas = {
        { x = 150, y = 100, largura = 15, altura = 15, coletada = false, valor = 10 },
        { x = 300, y = 80,  largura = 15, altura = 15, coletada = false, valor = 10 },
        { x = 450, y = 200, largura = 15, altura = 15, coletada = false, valor = 10 },
        { x = 250, y = 250, largura = 15, altura = 15, coletada = false, valor = 10 },
        { x = 500, y = 300, largura = 15, altura = 15, coletada = false, valor = 10 },
        { x = 80,  y = 400, largura = 15, altura = 15, coletada = false, valor = 10 },
        { x = 350, y = 450, largura = 15, altura = 15, coletada = false, valor = 20 }, -- Moeda especial
        { x = 600, y = 100, largura = 15, altura = 15, coletada = false, valor = 10 }
    }

    -- Sistema de jogo
    pontuacao = 0
    moedasColetadas = 0
    totalMoedas = #moedas
    jogoGanho = false
    tempo = 0

    -- Interface
    fonte = love.graphics.newFont(20)
    love.graphics.setFont(fonte)
end

function love.update(dt)
    if jogoGanho then
        return -- Para o jogo se ganhou
    end

    tempo = tempo + dt

    -- Movimento do jogador
    local novoX = jogador.x
    local novoY = jogador.y

    if love.keyboard.isDown("right", "d") then
        novoX = novoX + jogador.velocidade * dt
    end
    if love.keyboard.isDown("left", "a") then
        novoX = novoX - jogador.velocidade * dt
    end
    if love.keyboard.isDown("up", "w") then
        novoY = novoY - jogador.velocidade * dt
    end
    if love.keyboard.isDown("down", "s") then
        novoY = novoY + jogador.velocidade * dt
    end

    -- Verificar colisão com obstáculos antes de mover
    local futuro = {
        x = novoX,
        y = novoY,
        largura = jogador.largura,
        altura = jogador.altura
    }

    local podeMove = true
    for i, obstaculo in ipairs(obstaculos) do
        if colidiu(futuro, obstaculo) then
            podeMove = false
            break
        end
    end

    -- Manter dentro da tela
    if novoX < 0 or novoX + jogador.largura > love.graphics.getWidth() or
        novoY < 0 or novoY + jogador.altura > love.graphics.getHeight() then
        podeMove = false
    end

    -- Aplicar movimento se possível
    if podeMove then
        jogador.x = novoX
        jogador.y = novoY
    end

    -- Verificar coleta de moedas
    for i, moeda in ipairs(moedas) do
        if not moeda.coletada and colidiu(jogador, moeda) then
            moeda.coletada = true
            pontuacao = pontuacao + moeda.valor
            moedasColetadas = moedasColetadas + 1

            -- Som de coleta (simulado com print)
            if moeda.valor > 10 then
                print("Moeda especial coletada! +" .. moeda.valor .. " pontos!")
            else
                print("Moeda coletada! +" .. moeda.valor .. " pontos")
            end

            -- Verificar vitória
            if moedasColetadas >= totalMoedas then
                jogoGanho = true
                print("Parabéns! Jogo completado em " .. math.floor(tempo) .. " segundos!")
            end
        end
    end
end

function love.draw()
    -- Fundo
    love.graphics.setColor(40 / 255, 42 / 255, 54 / 255) -- Cor #282A36
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Obstáculos
    love.graphics.setColor(255 / 255, 85 / 255, 85 / 255) -- Cor #FF5555
    for i, obstaculo in ipairs(obstaculos) do
        love.graphics.rectangle("fill", obstaculo.x, obstaculo.y, obstaculo.largura, obstaculo
            .altura)
    end

    -- Contorno dos obstáculos
    love.graphics.setColor(255 / 255, 121 / 255, 198 / 255) -- Cor #FF79C6
    for i, obstaculo in ipairs(obstaculos) do
        love.graphics.rectangle("line", obstaculo.x, obstaculo.y, obstaculo.largura, obstaculo
            .altura)
    end

    -- Moedas
    for i, moeda in ipairs(moedas) do
        if not moeda.coletada then
            if moeda.valor > 10 then
                love.graphics.setColor(255 / 255, 184 / 255, 108 / 255) -- Cor #FFB86C para moeda especial
            else
                love.graphics.setColor(241 / 255, 250 / 255, 140 / 255) -- Cor #F1FA8C para moeda normal
            end

            local centroX = moeda.x + moeda.largura / 2
            local centroY = moeda.y + moeda.altura / 2
            love.graphics.circle("fill", centroX, centroY, moeda.largura / 2)

            -- Brilho da moeda especial
            if moeda.valor > 10 then
                love.graphics.setColor(1, 1, 1, 0.3)
                love.graphics.circle("fill", centroX, centroY, moeda.largura / 2 + 3)
            end
        end
    end

    -- Jogador
    love.graphics.setColor(jogador.cor)
    love.graphics.rectangle("fill", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Contorno do jogador
    love.graphics.setColor(189 / 255, 147 / 255, 249 / 255) -- Cor #BD93F9
    love.graphics.rectangle("line", jogador.x, jogador.y, jogador.largura, jogador.altura)

    -- Interface
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Pontuação: " .. pontuacao, 10, 10)
    love.graphics.print("Moedas: " .. moedasColetadas .. "/" .. totalMoedas, 10, 35)
    love.graphics.print("Tempo: " .. math.floor(tempo) .. "s", 10, 60)

    -- Controles
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("Use WASD ou setas para mover", 10, love.graphics.getHeight() - 25)

    -- Mensagem de vitória
    if jogoGanho then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(1, 1, 0)
        local msg = "PARABÉNS!"
        local largura = fonte:getWidth(msg)
        love.graphics.print(msg, (love.graphics.getWidth() - largura) / 2, 200)

        love.graphics.setColor(1, 1, 1)
        local msg2 = "Pontuação Final: " .. pontuacao
        local largura2 = fonte:getWidth(msg2)
        love.graphics.print(msg2, (love.graphics.getWidth() - largura2) / 2, 230)

        local msg3 = "Tempo: " .. math.floor(tempo) .. " segundos"
        local largura3 = fonte:getWidth(msg3)
        love.graphics.print(msg3, (love.graphics.getWidth() - largura3) / 2, 260)

        local msg4 = "Pressione R para reiniciar"
        local largura4 = fonte:getWidth(msg4)
        love.graphics.print(msg4, (love.graphics.getWidth() - largura4) / 2, 290)

        love.graphics.setColor(0.8, 0.8, 0.8)
        local msg5 = "Pressione ESC para sair"
        local largura5 = fonte:getWidth(msg5)
        love.graphics.print(msg5, (love.graphics.getWidth() - largura5) / 2, 320)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "r" and jogoGanho then
        -- Reiniciar jogo
        for i, moeda in ipairs(moedas) do
            moeda.coletada = false
        end
        pontuacao = 0
        moedasColetadas = 0
        tempo = 0
        jogoGanho = false
        jogador.x = 50
        jogador.y = 50
    end
end
