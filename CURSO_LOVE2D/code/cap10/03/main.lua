function love.load()
    -- Múltiplas variações do mesmo som
    sonsTiro = {
        love.audio.newSource("assets/shoot.ogg", "static"),
        love.audio.newSource("assets/hitsound.ogg", "static"),
    }

    for i, som in ipairs(sonsTiro) do
        som:setVolume(0.5)
    end

    -- Carregar música (stream para economizar memória)
    musica = love.audio.newSource("assets/background.mp3", "stream")
    -- Configurar para repetir infinitamente
    musica:setLooping(true)
    -- Definir volume
    musica:setVolume(0.05)
    -- Iniciar reprodução
    musica:play()
end

function tocarTiroAleatorio()
    local indice = math.random(1, #sonsTiro)
    sonsTiro[indice]:stop()
    sonsTiro[indice]:play()
end

function love.keypressed(tecla)
    if tecla == "space" then
        -- Reproduzir som
        tocarTiroAleatorio()
    end
end
