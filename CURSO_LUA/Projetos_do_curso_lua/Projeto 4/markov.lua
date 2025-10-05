--[[ Gerador de Texto com Cadeia de Markov ]]

-- Uma cadeia de Markov é uma estrutura matemática que modela um processo onde a probabilidade de transição de um estado para outro depende apenas do estado atual, não do passado;

-- Construção do modelo de Markov
local function buildModel(text)
    local model = {}
    local words = {}
    local textMath = string.gmatch(text, "%S+")
    for word in textMath do table.insert(words, word) end

    for i = 1, #words - 1 do
        local w1, w2 = words[i], words[i + 1]    -- Pega pares de palavras consecutivas
        model[w1] = model[w1] or {}              -- Cria entrada para w1 se não existir
        model[w1][w2] = (model[w1][w2] or 0) + 1 -- Conta quantas vezes w2 segue w1
        --[[ {
            ["o"] = { ["gato"] = 2 },
            ["gato"] = { ["preto"] = 1, ["branco"] = 1 },
            ["preto"] = { ["o"] = 1 }
        } ]]
    end
    return model
end

-- Seleciona próxima palavra aleatoriamente
local function nextWord(probs)
    local sum = 0
    for _, frequency in pairs(probs) do sum = sum + frequency end --- Calcula o total de ocorrências de todas as palavras seguinte

    -- Esse número será usado para escolher uma palavra proporcionalmente à sua frequência
    local random = math.random() * sum
    for word, frequency in pairs(probs) do
        if random < frequency then return word end
        random = random - frequency
    end
end

-- Gera frase de n palavras
local function generate(model, startWord, fraseLength)
    local word = startWord
    local list = { word }
    for i = 2, fraseLength do
        local probs = model[word]
        if not probs then break end
        word = nextWord(probs)
        table.insert(list, word)
    end
    return table.concat(list, " ")
end

-- Uso
math.randomseed(os.time())
local texto = "lua é simples e poderosa lua suporta metatables e coroutines"
local model = buildModel(texto)
print(generate(model, "lua", 10))
