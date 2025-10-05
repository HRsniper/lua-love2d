# 🧠 Estrutura do Curso: Dominando LÖVE2D com Lua

## 📘 Capítulo 1: Introdução ao LÖVE2D e Lua

**Referências:** [REF 1](https://love2d.org/wiki/Getting_Started), [REF 3 - Capítulo 1 e Introdução](https://www.sheepolution.com/learn/book/contents)

-   O que é LÖVE2D e por que usá-lo?
-   Instalação do LÖVE2D em Windows, Linux, macOS
-   Configuração do ambiente com VS Code ou ZeroBrane Studio
-   Primeiro jogo: Hello World

```lua
function love.draw()
    love.graphics.print("Hello World", 400, 300)
end
```

## 🧮 Capítulo 2: Configs e Fundamentos

**Referências:** [REF 3 - Capítulos 2 e 3](https://www.sheepolution.com/learn/book/contents)

```lua
local frutas = {"maçã", "banana", "laranja"}
for i, fruta in ipairs(frutas) do
    print("Fruta:", fruta)
end
```

## 🎮 Capítulo 3: Estrutura de um Jogo com LÖVE

**Referências:** [REF 2](https://love2d.org/wiki/love), [REF 3 - Capítulo 4](https://www.sheepolution.com/learn/book/contents)

-   Ciclo de vida: love.load, love.update, love.draw
-   Delta time (dt) e lógica de atualização
-   Separação de responsabilidades

```lua
function love.load()
    x = 100
end

function love.update(dt)
    x = x + 100 * dt
end

function love.draw()
    love.graphics.circle("fill", x, 200, 20)
end
```

## 🧱 Capítulo 4: Movimento e Interação

**Referências:** [REF 3 - Capítulos 5 e 6](https://www.sheepolution.com/learn/book/contents)

-   Movimento com teclado (love.keyboard)
-   Condições e colisões simples
-   Criando um personagem controlável

```lua
function love.update(dt)
    if love.keyboard.isDown("right") then
        x = x + 200 * dt
    end
end
```

## 🧩 Capítulo 5: Estrutura de Dados e Organização

**Referências:** [REF 3 - Capítulos 7 a 9](https://www.sheepolution.com/learn/book/contents)

-   Tabelas como listas de objetos
-   Separação em múltiplos arquivos
-   Escopo e modularização

```lua
-- player.lua
local player = {x = 100, y = 100, speed = 150}
function player.update(dt)
    -- lógica de movimento
end
return player
```

## 🧰 Capítulo 6: Programação Orientada a Objetos com Lua

**Referências:** [REF 3 - Capítulos 10 e 11](https://www.sheepolution.com/learn/book/contents)

-   Simulando classes com metatables
-   Utilizando bibliotecas como middleclass
-   Herança e encapsulamento

```lua
Player = Class{}

function Player:init(x, y)
    self.x = x
    self.y = y
end
```

## 🖼️ Capítulo 7: Gráficos e Imagens

**Referências:** [REF 2 - love.graphics](https://love2d.org/wiki/love), [REF 3 - Capítulo 12](https://www.sheepolution.com/learn/book/contents)

-   Desenhando formas básicas
-   Carregando e exibindo imagens
-   Manipulação de sprites

```lua
function love.load()
    img = love.graphics.newImage("player.png")
end

function love.draw()
    love.graphics.draw(img, 100, 100)
end
```

## 💥 Capítulo 8: Detecção e Resolução de Colisões

**Referências:** [REF 3 - Capítulos 13 e 23](https://www.sheepolution.com/learn/book/contents)

-   Colisão AABB
-   Resolução de sobreposição
-   Sistema de colisão modular

```lua
function checkCollision(a, b)
    return a.x < b.x + b.w and
           b.x < a.x + a.w and
           a.y < b.y + b.h and
           b.y < a.y + a.h
end
```

## 🔫 Capítulo 9: Criando um Jogo Completo

**Referências:** [REF 3 - Capítulo 14](https://www.sheepolution.com/learn/book/contents)

-   Projeto: "Shoot the Enemy"
-   Gerenciamento de estados
-   Pontuação e HUD

## 🔊 Capítulo 10: Áudio e Música

**Referências:** [REF 2 - love.audio](https://love2d.org/wiki/love), [REF 3 - Capítulo 19](https://www.sheepolution.com/learn/book/contents)

-   Carregando sons e músicas
-   Efeitos sonoros
-   Controle de volume e looping

```lua
function love.load()
    som = love.audio.newSource("tiro.wav", "static")
end

function love.keypressed(key)
    if key == "space" then
        som:play()
    end
end
```

## 🎞️ Capítulo 11: Animações e Tiles

**Referências:** [REF 3 - Capítulos 17 e 18](https://www.sheepolution.com/learn/book/contents)

-   Animações quadro a quadro
-   Mapas com tiles
-   Ferramentas como Tiled

## 🧠 Capítulo 12: Técnicas Avançadas

**Referências:** [REF 2 - love.physics, love.thread](https://love2d.org/wiki/love), [REF 3 - Capítulo 22](https://www.sheepolution.com/learn/book/contents)

-   Física com love.physics
-   Multithreading com love.thread
-   Câmeras e canvases

## 💾 Capítulo 13: Salvando Dados e Persistência

**Referências:** [REF 2 - love.filesystem](https://love2d.org/wiki/love), [REF 3 - Capítulo 21](https://www.sheepolution.com/learn/book/contents)

-   Salvando progresso com arquivos
-   Serialização de dados
-   Sistema de save/load

## 🚀 Capítulo 14: Empacotamento e Distribuição

**Referências:** [REF 1](https://love2d.org/wiki/Getting_Started), [REF 3 - Capítulo 15](https://www.sheepolution.com/learn/book/contents)

-   Criando arquivos .love
-   Distribuição para Windows, Android, iOS
-   Otimização e fusão de arquivos

## 🧪 Capítulo 15: Debugging e Boas Práticas

**Referências:** [REF 3 - Capítulo 20](https://www.sheepolution.com/learn/book/contents)

-   Uso de print, love.errhand
-   Ferramentas de debug
-   Organização de código e performance

---

## Referências Completas

-   **REF 1:** [Getting Started - LÖVE2D Wiki](https://love2d.org/wiki/Getting_Started)
-   **REF 2:** [love - LÖVE2D API Reference](https://love2d.org/wiki/love)
-   **REF 3:** [How to LÖVE - Sheepolution](https://www.sheepolution.com/learn/book/contents)
