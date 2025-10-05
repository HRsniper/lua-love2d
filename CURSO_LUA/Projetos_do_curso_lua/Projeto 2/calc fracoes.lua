--[[ Calculadora de Frações ]]

-- Função para calcular fração simplificada
local function calcFrag(numerator, denominator)
    if denominator == 0 then
        return numerator
    end
    return calcFrag(denominator, numerator % denominator)
end

-- Loop de leitura de expressões
while true do
    io.write("\nDigite uma fração (exemplo: 3/4) ou 'exit':\n")
    local userInput = io.read()

    if userInput == "exit" then
        print("Saindo...")
        break
    end

    local numerator, denominator = userInput:match("^(%d+)%s*/%s*(%d+)$")
    numerator, denominator = tonumber(numerator), tonumber(denominator)

    if numerator and denominator and denominator ~= 0 then
        local div = calcFrag(numerator, denominator)
        local displayFormatted = string.format("%d/%d | Simplificado = %d/%d", numerator, denominator,
            numerator / div,
            denominator / div)
        print(displayFormatted)
    else
        print("Entrada inválida. Tente novamente.")
    end
end
