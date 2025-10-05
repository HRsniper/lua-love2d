function love.load()
    -- Múltiplas variações do mesmo som
    sonsTiro = {
        love.audio.newSource("assets/shoot.ogg", "static"),
        love.audio.newSource("assets/hitsound.ogg", "static"),
    }

    for i, som in ipairs(sonsTiro) do
        som:setVolume(0.5)
    end
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
