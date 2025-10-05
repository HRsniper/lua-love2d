local M = {} -- A tabela que será retornada

M.PI = 3.14159

function M.somar(a, b)
    return a + b
end

function M.subtrair(a, b)
    return a - b
end

return M -- Retorna a tabela com as funções e valores públicos
--[[
M {
    PI
    somar (a, b)
    subtrair (a, b)
}
]]

