function love.load()
    -- Define a identidade do jogo (nome da pasta)
    love.filesystem.setIdentity("MeuJogo")

    -- Mostra onde os arquivos serão salvos
    print("Diretório de save: " .. love.filesystem.getSaveDirectory())

    -- Lista arquivos existentes
    local arquivos = love.filesystem.getDirectoryItems("")
    for i, arquivo in ipairs(arquivos) do
        print("Arquivo encontrado: " .. arquivo)
    end
end
