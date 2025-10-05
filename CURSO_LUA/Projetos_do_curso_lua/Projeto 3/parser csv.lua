--[[ Parser de CSV e Estatísticas ]]

-- Função para ler CSV em tabela de linhas
local function readCsv(path)
    local file = assert(io.open(path, "r"), "Erro ao abrir o arquivo: " .. path)

    -- Lê o cabeçalho e extrai os nomes das colunas
    local header = file:read("*l")
    local headerMatch = string.gmatch(header, "([^,]+)")
    local columns = {}
    for column in headerMatch do
        columns[#columns + 1] = column
    end
    -- for k, v in ipairs(columns) do
    --     print(k .. ": " .. tostring(v))
    -- end

    -- Lê cada linha e associa os valores às colunas
    local data = {}
    for line in file:lines() do
        local lineMatch = string.gmatch(line, "([^,]+)")
        local row = {}
        local i = 1
        for cell in lineMatch do
            -- columns[i] é o nome da coluna correspondente à posição atual (por exemplo, "Jogo", "Vendas Estimadas" etc.)
            -- Resultado: cada célula é armazenada em row com a chave sendo o nome da coluna
            row[columns[i]] = tonumber(cell) or cell
            i = i + 1
        end
        -- for k, v in pairs(row) do
        --     print(k .. ": " .. tostring(v))
        -- end

        data[#data + 1] = row
    end
    -- for index, row in ipairs(data) do
    --     print("Index: " .. index)
    --     for key, value in pairs(row) do
    --         print(" " .. key .. " = " .. tostring(value))
    --     end
    --     print("-----------")
    -- end

    file:close()
    return data
end

-- Função para estatísticas de coluna numérica
local function stats(data, col)
    local sum, count = 0, 0
    local min, max = math.huge, -math.huge

    for _, row in ipairs(data) do
        local value = row[col]
        if type(value) == "number" then
            sum = sum + value
            count = count + 1
            if value < min then min = value end
            if value > max then max = value end
        end
    end

    return sum / count, min, max
end

-- Uso
local dados = readCsv("steam-sales.csv")
local media, minimo, maximo = stats(dados, "Vendas Estimadas")
print(string.format("Média: %.2f, Min: %.2f, Max: %.2f", media, minimo, maximo))
