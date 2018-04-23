local Trigger = require('trigger')
local Target = require('target')
local Writer = require('writer')

targets = { }
textQueue = { }
triggers = { }

local difficulty = 1

function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)
	background = love.graphics.newImage('/images/background_tile.png')
	love.window.setTitle("pain in the butterfly")
	gameWidth, gameHeight = love.graphics.getDimensions()
	entities = { }
	
	for i = 97, 122 do
		local c = string.char(i)
		local t = Trigger(c)
		table.insert(triggers, t)
	end
	table.insert(triggers, Trigger('return'))

	for idx, trigger in ipairs(triggers) do
		table.insert(entities, trigger)
	end

	writer = Writer("idiom")
	table.insert(entities, writer)
end

function love.draw()
	for r = 0, gameWidth / background:getWidth() do
		for c = 0, gameHeight / background:getHeight() do
			love.graphics.draw(background, r * background:getWidth(), c * background:getHeight())
		end
	end
	if gameOver then
		writer:draw()
	else
		for idx, entity in ipairs(entities) do
			entity:draw()
		end
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
	writer:keypressed(key)
end

function love.textinput(key)
	writer:textinput(key)
end

function addNewTarget(dt)
	local newTarget = Target(difficulty)
	table.insert(entities, newTarget)
	table.insert(targets, newTarget)
end
