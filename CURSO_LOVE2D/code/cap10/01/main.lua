function love.load()
    -- Carregar som de tiro (static para resposta rápida)
    somTiro = love.audio.newSource("assets/shoot.ogg", "static")

    -- Configurações opcionais
    somTiro:setVolume(0.7) -- Volume a 70%
end

function love.keypressed(tecla)
    if tecla == "space" then
        -- Reproduzir som
        somTiro:play()
    end
end
