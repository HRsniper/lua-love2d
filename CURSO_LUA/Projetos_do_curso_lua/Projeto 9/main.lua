local dotenv = require("parser Dotenv")

-- Exemplo 1: String simples
local env_string = "DB_HOST=localhost\nDB_PORT=5432\nDEBUG=true\nNAME=\"Lua Test\""
local env1 = dotenv.read(env_string)

print("Exemplo 1 - String simples:")
print("DB_HOST:", env1.DB_HOST)
print("DB_PORT:", env1.DB_PORT)
print("DEBUG:", env1.DEBUG)
print("NAME:", env1.NAME)
print()

-- Exemplo 2: String multilinha com [[]]
local env_multiline = [[
# Configurações do banco de dados
DB_HOST=localhost
DB_PORT=5432
DB_USER=admin
DB_PASS=secret123

# Configurações da aplicação
DEBUG=true
LOG_LEVEL=info
MAX_CONNECTIONS=100

# Configurações de texto
APP_NAME="Minha Aplicação"
VERSION='1.0.0'
DESCRIPTION=Uma aplicação de exemplo
]]

local env2 = dotenv.read(env_multiline)

print("Exemplo 2 - String multilinha:")
print("DB_HOST:", env2.DB_HOST)
print("DB_PORT:", env2.DB_PORT)
print("DB_USER:", env2.DB_USER)
print("DEBUG:", env2.DEBUG)
print("MAX_CONNECTIONS:", env2.MAX_CONNECTIONS)
print("APP_NAME:", env2.APP_NAME)
print("VERSION:", env2.VERSION)
print()

-- Exemplo 3: Comparando load e read
print("Exemplo 3 - Comparando load (arquivo) e read (string):")

-- Carregando do arquivo
-- local path = love.filesystem.getRealDirectory("exemplo.env") -- sao para testes no love2d
-- local env_from_file = dotenv.load(path .. "/exemplo.env")

local env_from_file = dotenv.load("exemplo.env")

-- Carregando da string (mesmo conteúdo)
local file_content = [[
DB_HOST=localhost
DB_PORT=5432
DEBUG=true
NAME="Lua Test"
]]
local env_from_string = dotenv.read(file_content)

-- Verificando se são iguais
print("Conteúdos são iguais:")
for key, value in pairs(env_from_file) do
    print(string.format("  %s: %s == %s? %s",
        key,
        tostring(value),
        tostring(env_from_string[key]),
        tostring(value == env_from_string[key])
    ))
end

-- Testes de validação
assert(env1.DB_HOST == "localhost")
assert(env1.DB_PORT == 5432)
assert(env1.DEBUG == true)
assert(env1.NAME == "Lua Test")

assert(env2.DB_HOST == "localhost")
assert(env2.MAX_CONNECTIONS == 100)
assert(env2.APP_NAME == "Minha Aplicação")
assert(env2.VERSION == "1.0.0")

print("\nTodos os testes passaram! ✓")
