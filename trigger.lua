local triggerClass = { }
triggerClass.__index = triggerClass

local triggers = {
	a = {x = 1, y = 2},
	s = {x = 2, y = 2},
	d = {x = 3, y = 2},
	f = {x = 4, y = 2},
	j = {x = 5, y = 2},
	k = {x = 6, y = 2},
	l = {x = 7, y = 2},
	[';'] = {x = 8, y = 2}
}
local xOffset = 50
local yOffset = 100

function Trigger(key)
	local triggerFile = '/images/trigger.png'
	local image = love.graphics.newImage(triggerFile)
	local width, height = image:getDimensions( )
	local x, y = getTriggerPlacement(key)
	local instance = {
		class = 'trigger',
		i = image,
		w = width,
		h = height,
		x = x * xOffset,
		y = y * yOffset
	}
	setmetatable(instance, triggerClass)
	return instance
end

function triggerClass:draw()
	love.graphics.draw(self.i, self.x, self.y)
end

function triggerClass:update(dt)
end

function getTriggerPlacement(key)
	local coordinates = triggers[key]
	return coordinates.x, coordinates.y
end

return Trigger
