local triggerClass = { }
triggerClass.__index = triggerClass

local triggers = {
	a = {x = 1, y = 2, note = '/sounds/040.wav'},
	s = {x = 2, y = 2, note = '/sounds/041.wav'},
	d = {x = 3, y = 2, note = '/sounds/042.wav'},
	f = {x = 4, y = 2, note = '/sounds/043.wav'},
	j = {x = 5, y = 2, note = '/sounds/044.wav'},
	k = {x = 6, y = 2, note = '/sounds/045.wav'},
	l = {x = 7, y = 2, note = '/sounds/046.wav'},
	[';'] = {x = 8, y = 2, note = '/sounds/047.wav'}
}
local xOffset = 150
local yOffset = 150

function Trigger(key)
	local triggerFile = '/images/transparent_trigger.png'
	local image = love.graphics.newImage(triggerFile)
	local width, height = image:getDimensions( )
	local x, y = getTriggerPlacement(key)
	local noteFile = getNoteFileFromKey(key)
	print("noteFile: ", noteFile)
	local sound = love.audio.newSource(noteFile, "static")
	local instance = {
		class = "trigger",
		key = key,
		note = sound,
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

function triggerClass:keypressed(key)
	if key == self.key then
		self.note:stop()
		self.note:play()
		print("you pressed: ", key)
	end
end

function getTriggerPlacement(key)
	local triggerTableEntry = triggers[key]
	return triggerTableEntry.x, triggerTableEntry.y
end

-- Musical note recordings from "Pack: Piano FF by jobro" on freesound.org
function getNoteFileFromKey(key)
	local triggerTableEntry = triggers[key]
	return triggerTableEntry.note
end

return Trigger
