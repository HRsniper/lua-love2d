-- Define corrotina para cada estado
local function state_idle()
    while true do
        local event = coroutine.yield("idle")
        if event == "start" then return "run" end
    end
end

local function state_run()
    local count = 0
    while true do
        count = count + 1
        local event = coroutine.yield("running " .. count)
        if event == "stop" then return "idle" end
    end
end

-- Mapeia nomes para funções de estado
local states = { idle = state_idle, run = state_run }

-- Executor da máquina de estados
local function run_machine(initial)
    local current = initial
    while true do
        local co = coroutine.create(states[current])
        local ok, status = coroutine.resume(co)
        while coroutine.status(co) ~= "dead" do
            print("Comandos: <start>, <stop>, <exit>")
            print("Estado:", status)
            io.write("Evento: \n")
            local ev = io.read()
            if ev == "exit" then return "dead" end
            ok, status = coroutine.resume(co, ev)
        end
        current = status -- status retornado é nome do próximo estado
    end
end

-- Inicia com estado 'idle'
run_machine("idle")
