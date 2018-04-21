local Trigger = require('trigger')
local Target = require('target')

local entities = {}
local triggers = {}
targets = {}

-- TODO: take from user input
local difficulty = 1

function love.load()
	love.window.setTitle("Pain in the Butterfly")
	gameWidth, gameHeight = love.graphics.getDimensions()
	loadTriggerTable()

	love.graphics.setBackgroundColor(255, 255, 255)
	background = love.graphics.newImage('/images/background_tile.png')
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
end

function love.draw()
	for r = 0, gameWidth / background:getWidth() do
		for c = 0, gameHeight / background:getHeight() do
			love.graphics.draw(background, r * background:getWidth(), c * background:getHeight())
		end
	end
	for idx, entity in ipairs(entities) do
		entity:draw()
	end
end

function love.update(dt)

	local currentTargetNumber = 0
	for idx, entity in ipairs(entities) do
		entity:update(dt)
		if entity.class == 'target' then
			currentTargetNumber = currentTargetNumber + 1
			if entity.inactive == true then
				table.remove(entities, idx)
				for idx, target in ipairs(targets) do
					if entity.inactive == true then
						table.remove(targets, idx)
					end
				end
			end
		end
	end

	if currentTargetNumber < difficulty then
		addNewTarget(dt)
	end
end

function love.keypressed(key)
	for idx, trigger in ipairs(triggers) do
		trigger:keypressed(key)
	end
end

function addNewTarget(dt)
	local newTarget = Target(difficulty)
	table.insert(entities, newTarget)
	table.insert(targets, newTarget)
	print('inserted target!')
end
