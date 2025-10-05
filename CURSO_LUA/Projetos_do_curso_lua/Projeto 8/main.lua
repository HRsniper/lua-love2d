local json = require("parser JSON")

-- JSON válido simples
local s = '{"nome":"João","idade":30,"ativo":true,"lista":[1,2,3]}'
local t = json.decode(s)
print(t.nome)
assert(t.nome == "João")
assert(t.idade == 30)
assert(t.ativo == true)
assert(#t.lista == 3 and t.lista[1] == 1)

-- JSON com espaços, nova linha
s = [[
    {
        "chave": "valor",
        "numero": 123.45,
        "nullvalor": null
        }
        ]]
t = json.decode(s)
print(t.chave)
assert(t.chave == "valor")
assert(t.numero == 123.45)
assert(t.nullvalor == nil)

-- Encode teste round-trip
local tb = { x = 10, y = { a = "oi", b = false } }
local s2 = json.encode(tb)
print(s2)
local t2 = json.decode(s2)
print(t2)
assert(t2.x == 10)
assert(t2.y.a == "oi")
assert(t2.y.b == false)
