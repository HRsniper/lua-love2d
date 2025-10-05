local StateManager = {}
StateManager.__index = StateManager

function StateManager:new()
    local sm = {
        states = {},
        currentState = nil,
        stateStack = {}
    }
    setmetatable(sm, StateManager)
    return sm
end

function StateManager:addState(name, state)
    self.states[name] = state
    if not state.manager then
        state.manager = self
    end
end

function StateManager:changeState(name, ...)
    if self.currentState and self.currentState.exit then
        self.currentState:exit()
    end

    self.currentState = self.states[name]

    if self.currentState and self.currentState.enter then
        self.currentState:enter(...)
    end
end

function StateManager:pushState(name, ...)
    if self.currentState then
        table.insert(self.stateStack, self.currentState)
        if self.currentState.pause then
            self.currentState:pause()
        end
    end

    self.currentState = self.states[name]

    if self.currentState and self.currentState.enter then
        self.currentState:enter(...)
    end
end

function StateManager:popState()
    if self.currentState and self.currentState.exit then
        self.currentState:exit()
    end

    self.currentState = table.remove(self.stateStack)

    if self.currentState and self.currentState.resume then
        self.currentState:resume()
    end
end

function StateManager:update(dt)
    if self.currentState and self.currentState.update then
        self.currentState:update(dt)
    end
end

function StateManager:draw()
    if self.currentState and self.currentState.draw then
        self.currentState:draw()
    end
end

-- Estados de exemplo
local MenuState = {}
function MenuState:enter() print("Entrando no menu") end

function MenuState:update(dt) end

function MenuState:draw()
    love.graphics.print("=== MENU ===", 100, 100)
    love.graphics.print("Pressione ENTER para jogar", 100, 120)
end

function MenuState:keypressed(key)
    if key == "return" then
        self.manager:changeState("game")
    end
end

local GameState = {}
function GameState:enter()
    print("Iniciando jogo")
    -- Inicializar mundo do jogo
end

function GameState:update(dt)
    -- Lógica do jogo
end

function GameState:draw()
    love.graphics.print("=== JOGO ===", 100, 100)
    love.graphics.print("Pressione P para pausar", 100, 120)
end

function GameState:keypressed(key)
    if key == "p" then
        self.manager:pushState("pause")
    elseif key == "escape" then
        self.manager:changeState("menu")
    end
end

local PauseState = {}
function PauseState:enter() print("Jogo pausado") end

function PauseState:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("=== PAUSADO ===", 100, 100)
    love.graphics.print("Pressione P para continuar", 100, 120)
end

function PauseState:keypressed(key)
    if key == "p" then
        self.manager:popState()
    end
end

-- Uso do sistema
local stateManager = StateManager:new()

function love.load()
    stateManager:addState("menu", MenuState)
    stateManager:addState("game", GameState)
    stateManager:addState("pause", PauseState)

    stateManager:changeState("menu")
end

function love.update(dt)
    stateManager:update(dt)
end

function love.draw()
    stateManager:draw()
end

function love.keypressed(key)
    if stateManager.currentState and stateManager.currentState.keypressed then
        stateManager.currentState:keypressed(key)
    end
end
