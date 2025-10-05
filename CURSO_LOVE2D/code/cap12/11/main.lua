local Console = {}

function Console:new()
    local console = {
        visible = false,
        input = "",
        history = {},
        commands = {},
        logs = {},
        maxLogs = 50
    }

    setmetatable(console, { __index = self })

    -- Comandos padrão
    console:addCommand("help", function()
        console:log("Comandos disponíveis:")
        for name, _ in pairs(console.commands) do
            console:log("  " .. name)
        end
    end)

    console:addCommand("clear", function()
        console.logs = {}
    end)

    console:addCommand("fps", function()
        console:log("FPS: " .. love.timer.getFPS())
    end)

    return console
end

function Console:addCommand(name, func)
    self.commands[name] = func
end

function Console:log(message)
    table.insert(self.logs, message)
    if #self.logs > self.maxLogs then
        table.remove(self.logs, 1)
    end
end

function Console:executeCommand(command)
    local parts = {}
    for part in command:gmatch("%S+") do
        table.insert(parts, part)
    end

    if #parts > 0 then
        local cmdName = parts[1]
        local args = { unpack(parts, 2) }

        if self.commands[cmdName] then
            local success, error = pcall(self.commands[cmdName], unpack(args))
            if not success then
                self:log("Erro: " .. error)
            end
        else
            self:log("Comando não encontrado: " .. cmdName)
        end
    end
end

function Console:toggle()
    self.visible = not self.visible
    if self.visible then
        love.keyboard.setKeyRepeat(true)
    else
        love.keyboard.setKeyRepeat(false)
    end
end

function Console:textinput(text)
    if self.visible then
        self.input = self.input .. text
    end
end

function Console:keypressed(key)
    if key == "f1" then
        self:toggle()
    elseif self.visible then
        if key == "return" then
            if self.input ~= "" then
                self:log("> " .. self.input)
                self:executeCommand(self.input)
                table.insert(self.history, self.input)
                self.input = ""
            end
        elseif key == "backspace" then
            self.input = self.input:sub(1, -2)
        end
    end
end

function Console:draw()
    if not self.visible then return end

    local height = 300
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), height)

    love.graphics.setColor(1, 1, 1)

    -- Desenha logs
    local y = 10
    for i = math.max(1, #self.logs - 15), #self.logs do
        love.graphics.print(self.logs[i], 10, y)
        y = y + 15
    end

    -- Desenha input
    local inputY = height - 25
    love.graphics.print("> " .. self.input .. "_", 10, inputY)

    love.graphics.setColor(1, 1, 1)
end

function love.load()
    console = Console:new()
end

function love.textinput(t)
    console:textinput(t)
end

function love.keypressed(key)
    console:keypressed(key)
end

function love.draw()
    -- Aqui você desenha seu jogo normalmente
    -- ...
    -- Depois desenha o console por cima
    love.graphics.print("Console: f1", 10, 10)
    console:draw()
end
