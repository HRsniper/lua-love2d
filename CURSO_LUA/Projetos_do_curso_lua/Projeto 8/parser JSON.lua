local json = {}

-- Funções auxiliares

local function is_whitespace(c)
    return c == ' ' or c == '\t' or c == '\n' or c == '\r'
end

-- Escapa caracteres especiais em strings
local escape_chars = {
    ['"']  = '\\"',
    ['\\'] = '\\\\',
    ['/']  = '\\/',
    ['\b'] = '\\b',
    ['\f'] = '\\f',
    ['\n'] = '\\n',
    ['\r'] = '\\r',
    ['\t'] = '\\t',
}

local function escape_string(s)
    return '"' .. s:gsub('[%z\1-\31\\/"\b\f\n\r\t]', function(c)
        return escape_chars[c] or string.format("\\u%04x", c:byte())
    end) .. '"'
end

-- Parser interno: consome caracteres um por um
local Parser = {}
Parser.__index = Parser

function Parser:new(str)
    local o = {
        s = str,
        i = 1,
        len = #str
    }
    setmetatable(o, self)
    return o
end

function Parser:peek()
    if self.i > self.len then
        return nil -- retorna nil ao invés de string vazia
    end
    return self.s:sub(self.i, self.i)
end

function Parser:next()
    if self.i > self.len then
        return nil -- retorna nil ao invés de string vazia
    end
    local c = self.s:sub(self.i, self.i)
    self.i = self.i + 1
    return c
end

function Parser:skip_whitespace()
    while self.i <= self.len and is_whitespace(self:peek()) do
        self.i = self.i + 1
    end
end

function Parser:error(msg)
    error(string.format("JSON parse error at position %d: %s", self.i, msg))
end

-- Leitura de valores

function Parser:parse_null()
    if self.s:sub(self.i, self.i + 3) == "null" then
        self.i = self.i + 4
        return nil
    else
        self:error("invalid null")
    end
end

function Parser:parse_boolean()
    local s, i = self.s, self.i
    if s:sub(i, i + 3) == "true" then
        self.i = i + 4
        return true
    elseif s:sub(i, i + 4) == "false" then
        self.i = i + 5
        return false
    else
        self:error("invalid boolean")
    end
end

function Parser:parse_number()
    local start_i = self.i
    local s = self.s
    -- opcional sinal
    if self:peek() == '-' then
        self.i = self.i + 1
    end
    -- parte inteira
    local c = self:peek()
    if c == '0' then
        self.i = self.i + 1
    elseif c and c:match('[1-9]') then
        repeat
            self.i = self.i + 1
            c = self:peek()
        until not c or not c:match('%d')
    else
        self:error("invalid number")
    end
    -- parte fracionária
    if self:peek() == '.' then
        self.i = self.i + 1
        if not self:peek():match('%d') then
            self:error("invalid fractional part")
        end
        repeat
            self.i = self.i + 1
            c = self:peek()
        until not c or not c:match('%d')
    end
    -- expoente
    c = self:peek()
    if c == 'e' or c == 'E' then
        self.i = self.i + 1
        c = self:peek()
        if c == '-' or c == '+' then
            self.i = self.i + 1
            c = self:peek()
        end
        if not c:match('%d') then
            self:error("invalid exponent in number")
        end
        repeat
            self.i = self.i + 1
            c = self:peek()
        until not c or not c:match('%d')
    end
    local number_str = self.s:sub(start_i, self.i - 1)
    local num = tonumber(number_str)
    if not num then
        self:error("invalid number value: " .. number_str)
    end
    return num
end

function Parser:parse_string()
    -- assume current char é "
    self.i = self.i + 1 -- pula "
    local chars = {}
    while true do
        if self.i > self.len then
            self:error("unterminated string")
        end
        local c = self:next()
        if not c then -- Verificação adicional
            self:error("unterminated string")
        end
        if c == '"' then
            break
        end
        if c == '\\' then
            local esc = self:next()
            if not esc then -- Verificação adicional
                self:error("unterminated escape sequence")
            end
            if esc == '"' or esc == '\\' or esc == '/' then
                table.insert(chars, esc)
            elseif esc == 'b' then
                table.insert(chars, '\b')
            elseif esc == 'f' then
                table.insert(chars, '\f')
            elseif esc == 'n' then
                table.insert(chars, '\n')
            elseif esc == 'r' then
                table.insert(chars, '\r')
            elseif esc == 't' then
                table.insert(chars, '\t')
            elseif esc == 'u' then -- suporte a \uXXXX
                -- Verificar se há caracteres suficientes
                if self.i + 3 > self.len then
                    self:error("incomplete unicode escape")
                end
                local hex = self.s:sub(self.i, self.i + 3)
                if not hex:match('^%x%x%x%x$') then
                    self:error("invalid unicode escape: \\u" .. hex)
                end
                local code = tonumber(hex, 16)
                -- converter code para utf-8
                -- simplificado: apenas BMP
                local utf8 = ""
                if code <= 0x7F then
                    utf8 = string.char(code)
                elseif code <= 0x7FF then
                    utf8 = string.char(0xC0 + math.floor(code / 0x40),
                        0x80 + (code % 0x40))
                else
                    utf8 = string.char(0xE0 + math.floor(code / 0x1000),
                        0x80 + (math.floor(code / 0x40) % 0x40),
                        0x80 + (code % 0x40))
                end
                table.insert(chars, utf8)
                self.i = self.i + 4
            else
                self:error("invalid escape char: \\" .. esc)
            end
        elseif c:byte() < 32 then -- Verificar caracteres de controle
            self:error("unescaped control character in string")
        else
            table.insert(chars, c)
        end
    end
    return table.concat(chars)
end

function Parser:parse_array()
    -- assume current char é '['
    self.i = self.i + 1
    local res = {}
    self:skip_whitespace()
    if self:peek() == ']' then
        self.i = self.i + 1
        return res
    end
    while true do
        self:skip_whitespace()
        local val = self:parse_value()
        table.insert(res, val)
        self:skip_whitespace()
        local c = self:peek()
        if c == ']' then
            self.i = self.i + 1
            break
        end
        if c ~= ',' then
            self:error("expected ',' or ']' in array")
        end
        self.i = self.i + 1
    end
    return res
end

function Parser:parse_object()
    -- assume current char is '{'
    self.i = self.i + 1
    local res = {}
    self:skip_whitespace()
    if self:peek() == '}' then
        self.i = self.i + 1
        return res
    end
    while true do
        self:skip_whitespace()
        if self:peek() ~= '"' then
            self:error("expected string key in object")
        end
        local key = self:parse_string()
        self:skip_whitespace()
        if self:peek() ~= ':' then
            self:error("expected ':' after key in object")
        end
        self.i = self.i + 1
        self:skip_whitespace()
        local val = self:parse_value()
        res[key] = val
        self:skip_whitespace()
        local c = self:peek()
        if c == '}' then
            self.i = self.i + 1
            break
        end
        if c ~= ',' then
            self:error("expected ',' or '}' in object")
        end
        self.i = self.i + 1
    end
    return res
end

function Parser:parse_value()
    self:skip_whitespace()
    local c = self:peek()
    if not c then
        self:error("unexpected end of input")
    end
    if c == '{' then
        return self:parse_object()
    elseif c == '[' then
        return self:parse_array()
    elseif c == '"' then
        return self:parse_string()
    elseif c == 'n' then
        return self:parse_null()
    elseif c == 't' or c == 'f' then
        return self:parse_boolean()
    elseif c == '-' or c:match('%d') then
        return self:parse_number()
    else
        self:error("invalid value")
    end
end

-- Função pública

function json.decode(str)
    assert(type(str) == "string", "json.decode requires a string")
    local p = Parser:new(str)
    local result = p:parse_value()
    p:skip_whitespace()
    if p.i <= p.len then
        -- se tiver lixo depois do valor JSON válido
        p:error("trailing characters after JSON value")
    end
    return result
end

function json.encode(val)
    local t = type(val)
    if t == "nil" then
        return "null"
    elseif t == "boolean" then
        return tostring(val)
    elseif t == "number" then
        assert(val == val and val ~= math.huge and val ~= -math.huge, "cannot encode NaN or inf")
        return tostring(val)
    elseif t == "string" then
        return escape_string(val)
    elseif t == "table" then
        -- detecção de array
        local is_array = true
        local count = 0
        local max = 0

        for k, _ in pairs(val) do
            count = count + 1
            if type(k) == "number" and k > 0 and math.floor(k) == k then
                if k > max then max = k end
            else
                is_array = false
                break
            end
        end
        -- Verificar se é array contíguo (sem buracos)
        if is_array and count > 0 and count ~= max then
            is_array = false
        end

        local parts = {}
        if is_array then
            for i = 1, max do
                parts[i] = json.encode(val[i])
            end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            for k, v in pairs(val) do
                assert(type(k) == "string", "object keys must be strings")
                table.insert(parts, escape_string(k) .. ":" .. json.encode(v))
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    else
        error("unsupported type: " .. t)
    end
end

return json
