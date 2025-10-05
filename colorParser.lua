local Color = {}

function Color.parser(input)
    if type(input) ~= "string" then return 1, 1, 1, 1 end

    input = input:match("^%s*(.-)%s*$") -- remove espaços
    if input:find("^#") then
        -- Trata como HEX
        local hex = input:gsub("#", "")

        if #hex == 3 then
            hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
        elseif #hex == 4 then
            hex = hex:sub(1, 1):rep(2) ..
                hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2) .. hex:sub(4, 4):rep(2)
        end

        if #hex ~= 6 and #hex ~= 8 then return 1, 1, 1, 1 end

        local r = tonumber(hex:sub(1, 2), 16) or 255
        local g = tonumber(hex:sub(3, 4), 16) or 255
        local b = tonumber(hex:sub(5, 6), 16) or 255
        local a = #hex == 8 and tonumber(hex:sub(7, 8), 16) or 255

        return r / 255, g / 255, b / 255, a / 255
    else
        -- Trata como RGB ou RGBA
        local parts = {}
        for num in input:gmatch("%d+") do
            table.insert(parts, tonumber(num))
        end

        if #parts < 3 or #parts > 4 then return 1, 1, 1, 1 end

        local r = math.min(parts[1], 255)
        local g = math.min(parts[2], 255)
        local b = math.min(parts[3], 255)
        local a = parts[4] or 255

        return r / 255, g / 255, b / 255, a / 255
    end
end

return Color

-- function love.draw()
--     love.graphics.setColor(parseColor("#fdf")) --> 1.0, 1.0, 1.0, 1.0
--     love.graphics.rectangle("fill", 10, 10, 50, 50)

--     love.graphics.setColor(parseColor("#ffcb")) --> 1.0, 1.0, 1.0, 1.0
--     love.graphics.rectangle("fill", 70, 10, 50, 50)

--     love.graphics.setColor(parseColor("#fafcff")) --> 1.0, 1.0, 1.0, 1.0
--     love.graphics.rectangle("fill", 130, 10, 50, 50)

--     love.graphics.setColor(parseColor("#cffafcff")) --> 1.0, 1.0, 1.0, 1.0
--     love.graphics.rectangle("fill", 190, 10, 50, 50)

--     love.graphics.setColor(parseColor("21,204,255")) --> 0.082, 0.917, 1.0, 1.0
--     love.graphics.rectangle("fill", 250, 10, 50, 50)

--     love.graphics.setColor(parseColor("21,24,255,128")) --> 0.082, 0.917, 1.0, 0.502
--     love.graphics.rectangle("fill", 310, 10, 50, 50)
-- end
