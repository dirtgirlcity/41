local Trigger = require('trigger')
local Target = require('target')

local entities = {}
local triggers = {}

function love.load()
	gameWidth, gameHeight = love.graphics.getDimensions()
	loadTriggerTable()
end

function loadTriggerTable()
	local a = Trigger('a')
	table.insert(triggers, a)
	local s = Trigger('s')
	table.insert(triggers, s)
	local d = Trigger('d')
	table.insert(triggers, d)

	for idx, trigger in ipairs(triggers) do
		table.insert(entities, trigger)
	end
	print("entities: ", #entities)
end

function love.draw()
	for idx, entity in ipairs(entities) do
		entity:draw()
	end
end

function love.update(dt)
	for idx, entity in ipairs(entities) do
		entity:update(dt)
	end
end
