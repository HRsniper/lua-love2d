local channel = love.thread.getChannel("resultado")

-- Simula processamento pesado
local soma = 0
for i = 1, 1000000 do
    soma = soma + i
end

-- Envia resultado de volta
channel:push("Soma: " .. soma)
