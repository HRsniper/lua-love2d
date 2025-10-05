function adicionarLog(mensagem)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local linha = timestamp .. " - " .. mensagem .. "\n"

    love.filesystem.append("game.log", linha)
end

-- Exemplo de uso
adicionarLog("Jogo iniciado")
adicionarLog("Nível 1 completo")
adicionarLog("Game over")

print("Diretório de save: " .. love.filesystem.getSaveDirectory())
