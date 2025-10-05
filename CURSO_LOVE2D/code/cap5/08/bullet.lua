local utils = require("utils")

local bullet = {}

function bullet.new(p, balas)
    -- Limitar taxa de tiro
    if not p.ultimoTiro or love.timer.getTime() - p.ultimoTiro > 0.1 then
        table.insert(balas, {
            x = p.x + p.largura / 2 - 2,
            y = p.y,
            largura = 4,
            altura = 10,
            velocidade = 400
        })
        p.ultimoTiro = love.timer.getTime()
    end
end

function bullet.update(p, balas, inimigos, pontuacao, dt)
    local novaPontuacao = pontuacao


    -- Criar balas
    if love.keyboard.isDown("space") then
        bullet.new(p, balas)
    end

    for i = #balas, 1, -1 do
        local bala = balas[i]
        bala.y = bala.y - bala.velocidade * dt

        -- Remover balas fora da tela
        if bala.y < -10 then
            table.remove(balas, i)
        else
            -- Verificar colisão com inimigos
            for j = #inimigos, 1, -1 do
                if utils.collision(bala, inimigos[j]) then
                    inimigos[j].vida = inimigos[j].vida - 1
                    table.remove(balas, i)

                    if inimigos[j].vida <= 0 then
                        novaPontuacao = novaPontuacao + inimigos[j].tipo * 10
                        table.remove(inimigos, j)
                    end
                    break
                end
            end
        end
    end
    return novaPontuacao
end

function bullet.draw(balas)
    -- Desenhar balas
    love.graphics.setColor(1, 1, 0)
    for _, bala in ipairs(balas) do
        love.graphics.rectangle("fill", bala.x, bala.y, bala.largura, bala.altura)
    end
end

return bullet
