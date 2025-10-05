-- Sistema de combate
local jogador = {
    nome = "Guerreiro",
    vida = 100,
    forca = 15,
    defesa = 5
}

local inimigo = {
    nome = "Goblin",
    vida = 50,
    forca = 10,
    defesa = 2
}

function calcularDano(atacante, defensor)
    local danoBase = atacante.forca
    local defesaEfetiva = defensor.defesa
    local danoFinal = math.max(1, danoBase - defesaEfetiva)
    return danoFinal
end

function atacar(atacante, defensor)
    local dano = calcularDano(atacante, defensor)
    defensor.vida = defensor.vida - dano

    print(atacante.nome .. " ataca " .. defensor.nome)
    print("Dano causado: " .. dano)
    print(defensor.nome .. " tem " .. defensor.vida .. " de vida")

    if defensor.vida <= 0 then
        print(defensor.nome .. " foi derrotado!")
        return true
    end
    return false
end

function love.keypressed(tecla)
    if tecla == "space" and inimigo.vida > 0 then
        local derrotou = atacar(jogador, inimigo)

        if not derrotou and inimigo.vida > 0 then
            atacar(inimigo, jogador)

            if jogador.vida <= 0 then
                print("Você foi derrotado!")
            end
        end
    elseif tecla == "r" then
        -- Resetar combate
        jogador.vida = 100
        inimigo.vida = 50
        print("Combate reiniciado!")
    end
end

function love.draw()
    -- Status dos personagens
    love.graphics.print("=== COMBATE ===", 300, 100)

    love.graphics.print("JOGADOR:", 100, 150)
    love.graphics.print("Nome: " .. jogador.nome, 100, 170)
    love.graphics.print("Vida: " .. jogador.vida, 100, 190)
    love.graphics.print("Força: " .. jogador.forca, 100, 210)

    love.graphics.print("INIMIGO:", 500, 150)
    love.graphics.print("Nome: " .. inimigo.nome, 500, 170)
    love.graphics.print("Vida: " .. inimigo.vida, 500, 190)
    love.graphics.print("Força: " .. inimigo.forca, 500, 210)

    -- Instruções
    love.graphics.print("SPACE - Atacar", 300, 350)
    love.graphics.print("R - Reiniciar", 300, 370)

    -- Status do jogo
    if jogador.vida <= 0 then
        love.graphics.print("VOCÊ PERDEU!", 300, 300)
    elseif inimigo.vida <= 0 then
        love.graphics.print("VOCÊ VENCEU!", 300, 300)
    end
end
