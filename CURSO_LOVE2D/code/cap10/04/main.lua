-- Sistema de áudio completo para jogo
function love.load()
    -- Inicializar configurações
    love.window.setTitle("Jogo com Sistema de Áudio Completo")

    -- Carregar todos os sons
    audio = {
        musica = {
            menu = love.audio.newSource("assets/background.mp3", "stream"),
            jogo = love.audio.newSource("assets/background.mp3", "stream"),
            vitoria = love.audio.newSource("assets/background.mp3", "stream")
        },
        efeitos = {
            tiro = love.audio.newSource("assets/shoot.ogg", "static"),
            explosao = love.audio.newSource("assets/hitsound.ogg", "static"),
            coleta = love.audio.newSource("assets/hitsound.ogg", "static"),
            dano = love.audio.newSource("assets/shoot.ogg", "static"),
            clique = love.audio.newSource("assets/shoot.ogg", "static")
        }
    }

    -- Configurar músicas
    for nome, musica in pairs(audio.musica) do
        musica:setLooping(true)
        musica:setVolume(0.4)
    end

    -- Configurar efeitos
    for nome, som in pairs(audio.efeitos) do
        som:setVolume(0.6)
    end

    -- Variáveis do jogo
    estadoJogo = "menu" -- "menu", "jogando", "pausado", "vitoria"
    musicaAtual = nil
    pontuacao = 0
    metaPontuacao = 50

    -- Configurações de áudio
    volumeMusica = 0.4
    volumeEfeitos = 0.6
    audioHabilitado = true

    -- UI
    botoes = {
        { texto = "Iniciar Jogo", x = 300, y = 200, largura = 200, altura = 50 },
        { texto = "Toggle Áudio", x = 300, y = 270, largura = 200, altura = 50 },
        { texto = "Sair",         x = 300, y = 340, largura = 200, altura = 50 }
    }

    -- Iniciar com música do menu
    trocarMusica("menu")
end

function trocarMusica(nome)
    -- Parar música atual
    if musicaAtual then
        musicaAtual:stop()
    end

    -- Iniciar nova música
    if audio.musica[nome] then
        musicaAtual = audio.musica[nome]
        if audioHabilitado then
            musicaAtual:setVolume(volumeMusica)
            musicaAtual:play()
        end
    end
end

function tocarEfeito(nome)
    if audio.efeitos[nome] and audioHabilitado then
        audio.efeitos[nome]:stop()
        audio.efeitos[nome]:setVolume(volumeEfeitos)
        audio.efeitos[nome]:play()
    end
end

function love.update(dt)
    if estadoJogo == "jogando" then
        -- Simular coleta de pontos com som
        if love.keyboard.isDown("space") then
            pontuacao = pontuacao + 1
            tocarEfeito("coleta")

            -- Verificar vitória
            if pontuacao >= metaPontuacao then
                estadoJogo = "vitoria"
                trocarMusica("vitoria")
                tocarEfeito("explosao") -- Som de comemoração
            end
        end
    end
end

function love.draw()
    if estadoJogo == "menu" then
        -- Menu principal
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("JOGO COM ÁUDIO", 0, 100, 800, "center")

        -- Desenhar botões
        for i, botao in ipairs(botoes) do
            love.graphics.setColor(0.3, 0.3, 0.3)
            love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", botao.x, botao.y, botao.largura, botao.altura)
            love.graphics.printf(botao.texto, botao.x, botao.y + 15, botao.largura, "center")
        end

        -- Indicador de áudio
        love.graphics.setColor(audioHabilitado and { 0, 1, 0 } or { 1, 0, 0 })
        love.graphics.print("Áudio: " .. (audioHabilitado and "LIGADO" or "DESLIGADO"), 10, 10)
    elseif estadoJogo == "jogando" then
        -- Tela do jogo
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("PRESSIONE ESPAÇO PARA COLETAR PONTOS", 0, 200, 800, "center")
        love.graphics.printf("Pontuação: " .. pontuacao .. "/" .. metaPontuacao, 0, 250, 800,
            "center")
        love.graphics.printf("Pressione P para pausar", 0, 350, 800, "center")

        -- Barra de progresso
        local larguraBarra = 400
        local progresso = pontuacao / metaPontuacao
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", 200, 300, larguraBarra, 20)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", 200, 300, larguraBarra * progresso, 20)
    elseif estadoJogo == "pausado" then
        -- Tela de pausa
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("JOGO PAUSADO", 0, 250, 800, "center")
        love.graphics.printf("Pressione P para continuar", 0, 300, 800, "center")
        love.graphics.printf("Pressione M para menu", 0, 350, 800, "center")
    elseif estadoJogo == "vitoria" then
        -- Tela de vitória
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf("VITÓRIA!", 0, 200, 800, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Pontuação Final: " .. pontuacao, 0, 250, 800, "center")
        love.graphics.printf("Pressione R para reiniciar", 0, 300, 800, "center")
        love.graphics.printf("Pressione M para menu", 0, 350, 800, "center")
    end

    -- Controles de volume
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("Controles:", 10, 500)
    love.graphics.print("+ / - : Volume da música", 10, 520)
    love.graphics.print("Ctrl + / Ctrl - : Volume dos efeitos", 10, 540)
    love.graphics.print("A : Toggle áudio", 10, 560)
end

function love.mousepressed(x, y, button)
    if button == 1 and estadoJogo == "menu" then
        for i, botao in ipairs(botoes) do
            if x >= botao.x and x <= botao.x + botao.largura and
                y >= botao.y and y <= botao.y + botao.altura then
                tocarEfeito("clique")

                if i == 1 then -- Iniciar Jogo
                    estadoJogo = "jogando"
                    pontuacao = 0
                    trocarMusica("jogo")
                elseif i == 2 then -- Toggle Áudio
                    audioHabilitado = not audioHabilitado
                    if audioHabilitado then
                        trocarMusica("menu")
                    else
                        if musicaAtual then
                            musicaAtual:pause()
                        end
                    end
                elseif i == 3 then -- Sair
                    love.event.quit()
                end
                break
            end
        end
    end
end

function love.keypressed(key)
    if key == "p" then
        if estadoJogo == "jogando" then
            estadoJogo = "pausado"
            if musicaAtual then
                musicaAtual:pause()
            end
            tocarEfeito("clique")
        elseif estadoJogo == "pausado" then
            estadoJogo = "jogando"
            if musicaAtual and audioHabilitado then
                musicaAtual:play()
            end
            tocarEfeito("clique")
        end
    elseif key == "m" then
        if estadoJogo ~= "menu" then
            estadoJogo = "menu"
            trocarMusica("menu")
            tocarEfeito("clique")
        end
    elseif key == "r" and estadoJogo == "vitoria" then
        estadoJogo = "jogando"
        pontuacao = 0
        trocarMusica("jogo")
        tocarEfeito("clique")
    elseif key == "a" then
        audioHabilitado = not audioHabilitado
        if audioHabilitado then
            if musicaAtual then
                musicaAtual:play()
            end
        else
            if musicaAtual then
                musicaAtual:pause()
            end
        end
        tocarEfeito("clique")
    elseif key == "=" or key == "+" then
        -- Aumentar volume da música
        volumeMusica = math.min(1, volumeMusica + 0.1)
        if musicaAtual then
            musicaAtual:setVolume(volumeMusica)
        end
        print("Volume música: " .. math.floor(volumeMusica * 100) .. "%")
    elseif key == "-" then
        -- Diminuir volume da música
        volumeMusica = math.max(0, volumeMusica - 0.1)
        if musicaAtual then
            musicaAtual:setVolume(volumeMusica)
        end
        print("Volume música: " .. math.floor(volumeMusica * 100) .. "%")
    end

    -- Controle de volume dos efeitos (Ctrl + / Ctrl -)
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        if key == "=" or key == "+" then
            volumeEfeitos = math.min(1, volumeEfeitos + 0.1)
            print("Volume efeitos: " .. math.floor(volumeEfeitos * 100) .. "%")
        elseif key == "-" then
            volumeEfeitos = math.max(0, volumeEfeitos - 0.1)
            print("Volume efeitos: " .. math.floor(volumeEfeitos * 100) .. "%")
        end
    end
end

function love.quit()
    -- Parar todas as músicas ao sair
    for nome, musica in pairs(audio.musica) do
        musica:stop()
    end
end
