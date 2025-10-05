-- blur.lua
local blur = {}

function blur.load()
    blur.canvas1 = love.graphics.newCanvas()
    blur.canvas2 = love.graphics.newCanvas()
    blur.shader = love.graphics.newShader([[
        extern number blur_size;

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 sum = vec4(0.0);
            int samples = 5;

            for(int i = -samples; i <= samples; i++) {
                for(int j = -samples; j <= samples; j++) {
                    vec2 offset = vec2(i, j) * blur_size;
                    sum += Texel(texture, texture_coords + offset);
                }
            }

            return sum / float((samples * 2 + 1) * (samples * 2 + 1));
        }
]])
end

function blur.apply(sourceCanvas, blurAmount)
    blur.shader:send("blur_size", blurAmount)

    love.graphics.setCanvas(blur.canvas1)
    love.graphics.clear()
    love.graphics.setShader(blur.shader)
    love.graphics.draw(sourceCanvas)
    love.graphics.setShader()
    love.graphics.setCanvas()

    return blur.canvas1
end

return blur
