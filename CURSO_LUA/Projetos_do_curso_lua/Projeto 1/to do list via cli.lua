--[[ To-Do List via CLI: Gerenciar uma lista de tarefas em memória ]]

-- Tabela para armazenar tarefas
local tasks = {}

-- Função para exibir menu e tarefas
local function showMenu()
    print("\nTo-Do List")

    for index, task in ipairs(tasks) do
        print(index .. ". " .. task)
    end

    print("Comandos: add <tarefa>, del <indices>, exit\n")
end

-- Loop principal de interação
local regExp = "^(%S+)%s*(.*)$"
while true do
    showMenu()
    io.write("Digite um comando: \n")
    local userInput = io.read()
    local command, rest = userInput:match(regExp)

    if command == "add" and rest ~= "" then
        table.insert(tasks, rest)                             -- Adicionar tarefa à lista
    elseif command == "del" and tonumber(rest) then
        if tonumber(rest) < 1 or tonumber(rest) > #tasks then -- Verificar se o índice é válido antes de remover a tarefa
            print("Índice inválido. Tente novamente.")
        else
            local indexes = tonumber(rest)
            table.remove(tasks, indexes) -- Remover tarefa da lista pelo índice
        end
    elseif command == "exit" then
        print("Saindo...")
        break
    else
        print("Comando inválido. Tente novamente.")
    end
end
