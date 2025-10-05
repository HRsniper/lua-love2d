local sti = require("lib.sti")
local Profiler = require("debug.profiler")

function love.load()
    mapa = sti("maps/meu_mapa.lua")

    -- Player
    player = {
        x = 100,
        y = 100,
        width = 18,
        height = 18,
        speed = 150
    }
end

function love.update(dt)
    Profiler:start("update")
    local dx, dy = 0, 0

    -- Input do jogador
    if love.keyboard.isDown("left") then dx = -player.speed * dt end
    if love.keyboard.isDown("right") then dx = player.speed * dt end
    if love.keyboard.isDown("up") then dy = -player.speed * dt end
    if love.keyboard.isDown("down") then dy = player.speed * dt end

    -- Verifica colisão antes de mover
    if not temColisao(player.x + dx, player.y) then
        player.x = player.x + dx
    end

    if not temColisao(player.x, player.y + dy) then
        player.y = player.y + dy
    end

    mapa:update(dt)
    Profiler:stop("update")
    Profiler:endFrame()
end

function temColisao(x, y)
    local layer = mapa.layers["collision"]
    if not layer then return false end

    local function isSolid(tx, ty)
        local tile = layer.data[ty] and layer.data[ty][tx]
        return tile ~= nil and tile ~= 0
    end

    -- Coordenadas dos cantos do jogador
    local tileX1 = math.floor(x / mapa.tilewidth) + 1
    local tileY1 = math.floor(y / mapa.tileheight) + 1
    local tileX2 = math.floor((x + player.width - 1) / mapa.tilewidth) + 1
    local tileY2 = math.floor((y + player.height - 1) / mapa.tileheight) + 1

    -- Verifica os quatro cantos
    return isSolid(tileX1, tileY1) or isSolid(tileX2, tileY1) or
        isSolid(tileX1, tileY2) or isSolid(tileX2, tileY2)
end

function love.draw()
    Profiler:profile("draw", function()
        mapa:draw()
        -- Desenha o jogador
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
        love.graphics.setColor(1, 1, 1)
    end)
    Profiler:draw()
end
