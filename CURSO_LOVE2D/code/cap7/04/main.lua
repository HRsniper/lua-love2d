function love.load()
    img = love.graphics.newImage("player.png")
    escala = 1
    crescendo = true
end

function love.update(dt)
    if crescendo then
        escala = escala + dt
        if escala > 2 then
            crescendo = false
        end
    else
        escala = escala - dt
        if escala < 0.5 then
            crescendo = true
        end
    end
end

function love.draw()
    -- Cor #282A36
    love.graphics.setBackgroundColor(40 / 255, 42 / 255, 54 / 255)

    love.graphics.draw(img, 300, 300, 0, escala, escala, img:getWidth() / 2, img:getHeight() / 2)
end
