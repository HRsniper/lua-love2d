-- debug/profiler.lua
local Profiler = {}

Profiler.sections = {}
Profiler.current_frame = {}
Profiler.history = {}
Profiler.max_history = 60
Profiler.enabled = true

function Profiler:start(name)
    if not self.enabled then return end

    self.current_frame[name] = {
        start_time = love.timer.getTime(),
        start_memory = collectgarbage("count")
    }
end

function Profiler:stop(name)
    if not self.enabled or not self.current_frame[name] then return end

    local section = self.current_frame[name]
    local duration = love.timer.getTime() - section.start_time
    local memory_used = collectgarbage("count") - section.start_memory

    if not self.sections[name] then
        self.sections[name] = {
            total_time = 0,
            call_count = 0,
            avg_time = 0,
            max_time = 0,
            min_time = math.huge,
            memory_usage = 0
        }
    end

    local stats = self.sections[name]
    stats.total_time = stats.total_time + duration
    stats.call_count = stats.call_count + 1
    stats.avg_time = stats.total_time / stats.call_count
    stats.max_time = math.max(stats.max_time, duration)
    stats.min_time = math.min(stats.min_time, duration)
    stats.memory_usage = memory_used

    self.current_frame[name] = nil
end

function Profiler:endFrame()
    if not self.enabled then return end

    -- Salvar dados do frame atual
    local frame_data = {}
    for name, stats in pairs(self.sections) do
        frame_data[name] = {
            avg_time = stats.avg_time,
            memory_usage = stats.memory_usage
        }
    end

    table.insert(self.history, frame_data)

    if #self.history > self.max_history then
        table.remove(self.history, 1)
    end

    -- Reset para próximo frame
    self.sections = {}
end

function Profiler:getReport()
    local report = {}

    for name, stats in pairs(self.sections) do
        table.insert(report, {
            name = name,
            avg_time = stats.avg_time * 1000, -- ms
            max_time = stats.max_time * 1000,
            min_time = stats.min_time * 1000,
            call_count = stats.call_count,
            memory = stats.memory_usage
        })
    end

    -- Ordenar por tempo médio
    table.sort(report, function(a, b)
        return a.avg_time > b.avg_time
    end)

    return report
end

function Profiler:draw()
    if not self.enabled then return end

    local report = self:getReport()
    local font = love.graphics.getFont()
    local y = 10
    local line_height = font:getHeight() + 2

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", love.graphics.getWidth() - 300, 0, 300, 200)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("PROFILER", love.graphics.getWidth() - 290, y)
    y = y + line_height * 2

    for i, section in ipairs(report) do
        if i > 8 then break end -- Limitar exibição

        local text = string.format("%s: %.2fms (%.1fKB)",
            section.name, section.avg_time, section.memory)

        -- Colorir baseado na performance
        if section.avg_time > 5 then
            love.graphics.setColor(1, 0, 0) -- Vermelho para lento
        elseif section.avg_time > 2 then
            love.graphics.setColor(1, 1, 0) -- Amarelo para médio
        else
            love.graphics.setColor(0, 1, 0) -- Verde para rápido
        end

        love.graphics.print(text, love.graphics.getWidth() - 290, y)
        y = y + line_height
    end
end

-- Macro para facilitar uso
function Profiler:profile(name, func, ...)
    self:start(name)
    local results = {func(...)}
    self:stop(name)
    return unpack(results)
end

return Profiler
