local json = require("json-simu")

local Game = {
    estado = "menu", -- menu, jogo, gameover
    pontuacao = 0,
    recorde = 0,
    nivel = 1,
    vidas = 3,
    tempoJogo = 0,
    configuracoes = {},
    estatisticas = {}
}

function love.load()
    love.filesystem.setIdentity("JogoPersistencia")

    -- Carrega configurações
    -- ...

    -- Carrega dados do jogo
    Game.carregarDados()

    print("Jogo carregado! Recorde atual: " .. Game.recorde)
end

function Game.carregarDados()
    local dadosSalvos = json.carregarDados("gamedata.json", {
        recorde = 0,
        estatisticas = {
            partidasJogadas = 0,
            tempoTotalJogo = 0,
            pontuacaoMaxima = 0
        }
    })

    Game.recorde = dadosSalvos.recorde or 0
    Game.estatisticas = dadosSalvos.estatisticas or {}
end

function Game.salvarDados()
    local dados = {
        recorde = math.floor(Game.recorde),
        estatisticas = Game.estatisticas
    }

    json.salvarDados("gamedata.json", dados)
    adicionarLog("Dados salvos - Recorde: " .. Game.recorde)
end

function Game.novaPartida()
    Game.pontuacao = 0
    Game.nivel = 1
    Game.vidas = 3
    Game.tempoJogo = 0
    Game.estado = "jogo"

    Game.estatisticas.partidasJogadas = (Game.estatisticas.partidasJogadas or 0) + 1
end

function Game.gameOver()
    Game.estado = "gameover"

    -- Atualiza estatísticas
    if Game.pontuacao > Game.recorde then
        Game.recorde = Game.pontuacao
        print("Novo recorde! " .. Game.recorde)
    end

    if Game.pontuacao > (Game.estatisticas.pontuacaoMaxima or 0) then
        Game.estatisticas.pontuacaoMaxima = Game.pontuacao
    end

    Game.estatisticas.tempoTotalJogo = (Game.estatisticas.tempoTotalJogo or 0) + Game.tempoJogo

    -- Salva automaticamente
    Game.salvarDados()
end

function adicionarLog(msg)
    print("[LOG] " .. msg)
end

function love.update(dt)
    if Game.estado == "jogo" then
        Game.tempoJogo = Game.tempoJogo + dt

        -- Lógica simples do jogo
        Game.pontuacao = Game.pontuacao + dt * 10

        -- Auto-save a cada 30 segundos
        -- ...
    end
end

function love.draw()
    if Game.estado == "menu" then
        love.graphics.print("=== MENU PRINCIPAL ===", 100, 100)
        love.graphics.print("Pressione ENTER para jogar", 100, 130)
        love.graphics.print("Pressione C para configurações", 100, 150)
        love.graphics.print("Recorde atual: " .. math.floor(Game.recorde), 100, 180)
    elseif Game.estado == "jogo" then
        love.graphics.print("Pontuação: " .. math.floor(Game.pontuacao), 10, 10)
        love.graphics.print("Recorde: " .. math.floor(Game.recorde), 10, 30)
        love.graphics.print("Nível: " .. Game.nivel, 10, 50)
        love.graphics.print("Vidas: " .. Game.vidas, 10, 70)
        love.graphics.print("Tempo: " .. math.floor(Game.tempoJogo) .. "s", 10, 90)

        love.graphics.print("Pressione ESC para sair", 10, 500)
    elseif Game.estado == "gameover" then
        love.graphics.print("=== GAME OVER ===", 100, 200)
        love.graphics.print("Pontuação final: " .. math.floor(Game.pontuacao), 100, 230)
        love.graphics.print("Recorde: " .. math.floor(Game.recorde), 100, 250)
        love.graphics.print("Pressione R para jogar novamente", 100, 280)
        love.graphics.print("Pressione ESC para o menu", 100, 300)
    end

    -- Mostra FPS se habilitado
    -- ...
end

function love.keypressed(key)
    if Game.estado == "menu" then
        if key == "return" then
            Game.novaPartida()
        elseif key == "c" then
            -- Abrir menu de configurações
        end
    elseif Game.estado == "jogo" then
        if key == "escape" then
            Game.gameOver()
        end
    elseif Game.estado == "gameover" then
        if key == "r" then
            Game.novaPartida()
        elseif key == "escape" then
            Game.estado = "menu"
        end
    end
end

-- Salva dados ao sair
function love.quit()
    Game.salvarDados()
    print("Dados salvos ao sair do jogo!")
end
