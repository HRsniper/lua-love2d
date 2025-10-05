local dotenv = {}

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function parse_content(content)
    local env = {}

    -- Processa linha por linha
    for line in content:gmatch("[^\r\n]+") do
        -- remove BOM se presente
        if line:sub(1, 3) == "\239\187\191" then
            line = line:sub(4)
        end
        -- ignora comentários e linhas vazias
        line = trim(line)
        if line ~= "" and not line:match("^#") then
            local key, value = line:match("^([%w_%.]+)%s*=%s*(.*)$")
            if key and value then
                value = trim(value)
                -- remover aspas simples ou duplas
                local first = value:sub(1, 1)
                local last = value:sub(-1)
                if (first == '"' and last == '"') or (first == "'" and last == "'") then
                    value = value:sub(2, -2)
                end
                -- interpretar booleanos
                if value:lower() == "true" then
                    value = true
                elseif value:lower() == "false" then
                    value = false
                    -- interpretar número se for um número
                elseif tonumber(value) then
                    local num = tonumber(value)
                    value = num
                end
                env[key] = value
            end
        end
    end

    return env
end

function dotenv.load(path)
    assert(type(path) == "string", "dotenv.load: path must be a string")
    local file, err = io.open(path, "r")
    if not file then
        error("dotenv.load: cannot open file: " .. tostring(err))
    end

    local content = file:read("*all")
    file:close()

    return parse_content(content)
end

function dotenv.read(content)
    assert(type(content) == "string", "dotenv.read: content must be a string")
    return parse_content(content)
end

return dotenv
