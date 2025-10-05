function love.conf(t)
    t.identity = "Cap2_saves"          -- O nome do diretório de salvamento (string)
    t.version = "11.5"
    t.console = false                  -- Anexar um console (booleano, apenas Windows)
    t.gammacorrect = true              -- Habilitar renderização com correção de gama, quando suportado pelo sistema (booleano)
    t.window.title = "Um lindo titulo" -- O título da janela (string)
    t.window.icon =
    "icon/meu_icone.png"               -- Caminho para uma imagem a usar como ícone da janela (string)
    t.window.width = 1280              -- Largura da janela (número)
    t.window.height = 720              -- Altura da janela (número)
    t.window.resizable = true          -- Permitir que a janela seja redimensionada pelo usuário (booleano)
    t.window.minwidth = 800            -- Largura mínima da janela se redimensionável (número)
    t.window.minheight = 600           -- Altura mínima da janela se redimensionável (número)
    t.window.borderless = false        -- Remover todas as bordas visuais da janela (booleano)
    t.window.fullscreen = false        -- Habilitar tela cheia (booleano)
    t.window.fullscreentype =
    "desktop"                          -- Escolher entre tela cheia "desktop" ou "exclusive" (string)
    t.modules.joystick = true          -- Habilitar o módulo de joystick (booleano)
    t.modules.touch = true             -- Habilitar o módulo de touch (booleano)
end
