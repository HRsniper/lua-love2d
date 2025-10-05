local utils = {}

function utils.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function utils.collision(obj1, obj2)
    return obj1.x < obj2.x + obj2.largura and
        obj2.x < obj1.x + obj1.largura and
        obj1.y < obj2.y + obj2.altura and
        obj2.y < obj1.y + obj1.altura
end

function utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function utils.lerp(a, b, t)
    return a + (b - a) * t
end

return utils
