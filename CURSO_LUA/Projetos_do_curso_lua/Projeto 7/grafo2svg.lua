-- O grafo tree será composto por vértices com coordenadas (x, y) e arestas entre eles
-- Cada vértice será um objeto com metatable que define como ele é convertido em SVG
-- As arestas serão linhas SVG entre os vértices
-- Uma corrotina será usada para gerar os elementos SVG progressivamente
-- Ao final, o SVG será salvo em um arquivo com os.execute ou io.open


-- Define metatable para vértices
local Vertex = {}
Vertex.__index = Vertex

function Vertex:new(id, x, y, color)
    return setmetatable({ id = id, x = x, y = y, color = color or "blue" }, self)
end

function Vertex:toSvg()
    return string.format(
        '<circle cx="%d" cy="%d" r="12" fill="%s" stroke="black" stroke-width="2"/>\n' ..
        '<text x="%d" y="%d" font-size="12" fill="white">%s</text>\n',
        self.x, self.y, self.color,
        self.x - 4, self.y + 4, self.id
    )
end

-- Define metatable para arestas
local Edge = {}
Edge.__index = Edge

function Edge:new(v1, v2)
    return setmetatable({ v1 = v1, v2 = v2 }, self)
end

function Edge:toSvg()
    return string.format(
        '<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="black" stroke-width="2" />\n',
        self.v1.x, self.v1.y, self.v2.x, self.v2.y
    )
end

-- determinar o retângulo mínimo que envolve todos os vértices do grafo para o limite do svg
local function calculateBounds(vertices, padding)
    padding = padding or 20
    local minX, minY = math.huge, math.huge   -- Borda esquerda, Borda superior
    local maxX, maxY = -math.huge, -math.huge -- Borda direta, Borda inferior

    for _, vertex in ipairs(vertices) do
        if vertex.x < minX then minX = vertex.x end
        if vertex.y < minY then minY = vertex.y end
        if vertex.x > maxX then maxX = vertex.x end
        if vertex.y > maxY then maxY = vertex.y end
    end

    local left = minX - padding
    local top = minY - padding
    local width = (maxX - minX) + 2 * padding
    local height = (maxY - minY) + 2 * padding

    return left, top, width, height
end

-- Corrotina para gerar SVG progressivamente
local function svgGenerator(vertices, edges)
    local minX, minY, width, height = calculateBounds(vertices)

    return coroutine.wrap(function()
        coroutine.yield(string.format(
            '<?xml version="1.0"?>\n<svg xmlns="http://www.w3.org/2000/svg" viewBox="%d %d %d %d" preserveAspectRatio="xMidYMid meet">\n',
            minX, minY, width, height
        ))

        for _, edge in ipairs(edges) do
            coroutine.yield(edge:toSvg())
        end

        for _, vertex in ipairs(vertices) do
            coroutine.yield(vertex:toSvg())
        end

        coroutine.yield('</svg>\n')
    end)
end

-- Exemplo de grafo
local v1 = Vertex:new("A", 100, 100, "red") -- raiz marcada em vermelho
local v2 = Vertex:new("B", 200, 150)
local v3 = Vertex:new("C", 150, 250)
local v4 = Vertex:new("D", 300, 100)

local vertices = { v1, v2, v3, v4 }
local edges = {
    Edge:new(v1, v2), -- a com b
    Edge:new(v2, v3), -- b com c
    Edge:new(v2, v4)  -- b com d
}

-- Gera SVG usando corrotina
local svg = {}
local gen = svgGenerator(vertices, edges)
for part in gen do
    table.insert(svg, part)
end

-- Salva em arquivo usando os/io
local filename = "grafo.svg"
local file = assert(io.open(filename, "w"))
file:write(table.concat(svg))
file:close()

print("Arquivo SVG gerado:", filename)
-- abrir arquivo usando o programa padrão associado a ele
-- os.execute("start " .. filename) -- Windows
-- os.execute("xdg-open " .. filename) -- Linux
