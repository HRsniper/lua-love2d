local class = require("libs.middleclass")
local Gamestate = require("libs.hump.gamestate")
local State = require("states.State")

local wf = require("libs.windfield")
local Player = require("classes.Player")
local Enemy = require("classes.Enemy")
local Map = require("classes.Map")
local Camera = require("classes.Camera")
local HUD = require("classes.HUD")
local Artifact = require("classes.Artifact")

local GameState = class("GameState", State)

function GameState:initialize()
    self.world = wf.newWorld(0, 0, true)
    self.world:addCollisionClass("Player")
    self.world:addCollisionClass("Enemy")
    self.world:addCollisionClass("Obstacle")
    self.world:addCollisionClass("Artifact")

    self.map       = Map:new(self.world, "assets/mapas/ruinas.lua")
    self.player    = Player:new(self.world, 100, 100)
    self.enemies   = {
        Enemy:new(self.world, 300, 100),
        Enemy:new(self.world, 500, 200)
    }
    self.artifacts = {
        Artifact:new(self.world, 200, 200, "assets/sprites/artifact.png"),
        Artifact:new(self.world, 400, 300, "assets/sprites/artifact.png"),
        Artifact:new(self.world, 600, 150, "assets/sprites/artifact.png"),
    }
    self.camera    = Camera:new(self.player.collider:getX(), self.player.collider:getY())
    self.hud       = HUD:new(self.player)

    self.mapWidth  = self.map.map.width * self.map.map.tilewidth
    self.mapHeight = self.map.map.height * self.map.map.tileheight
end

function GameState:update(dt)
    -- Atualiza física
    self.world:update(dt)

    -- Atualiza mapa
    self.map:update(dt)

    -- Atualiza jogador
    self.player:update(dt)

    -- Atualiza inimigos
    for _, e in ipairs(self.enemies) do
        e:update(dt, self.player.collider:getX(), self.player.collider:getY())
        e:checkCollisionWithPlayer(self.player)
    end

    -- Atualiza artefatos
    for _, a in ipairs(self.artifacts) do
        a:update(self.player)
    end

    -- Condições de fim de jogo
    if self.player.vida <= 0 then
        local EndState = require("states.fim")
        Gamestate.switch(EndState(false))
    elseif self.player.artefatos >= 5 then
        local EndState = require("states.fim")
        Gamestate.switch(EndState(true))
    end

    -- Calcula tamanho real do mapa
    self.mapWidth  = self.map.map.width * self.map.map.tilewidth
    self.mapHeight = self.map.map.height * self.map.map.tileheight

    -- Atualiza câmera com limites corretos
    self.camera:update(
        dt,
        self.player.collider:getX(),
        self.player.collider:getY(),
        self.mapWidth,
        self.mapHeight
    )
end

function GameState:draw()
    self.camera:attach()
    self.map:draw()
    self.player:draw()
    for _, e in ipairs(self.enemies) do e:draw() end
    for _, a in ipairs(self.artifacts) do a:draw() end
    self.camera:detach()

    self.hud:draw()
end

return GameState
