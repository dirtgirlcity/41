local triggerClass = { }
triggerClass.__index = triggerClass

local triggerTable = {
	q = {x = 1, y = 1, note = '/sounds/030.wav', image = '/images/letters/transparent_q.png', group = 'lp'},
	w = {x = 2, y = 1, note = '/sounds/031.wav', image = '/images/letters/transparent_w.png', group = 'lr'},
	e = {x = 3, y = 1, note = '/sounds/032.wav', image = '/images/letters/transparent_e.png', group = 'lm'},
	r = {x = 4, y = 1, note = '/sounds/033.wav', image = '/images/letters/transparent_r.png', group = 'li'},
	t = {x = 5, y = 1, note = '/sounds/034.wav', image = '/images/letters/transparent_t.png', group = 'li'},
	y = {x = 6, y = 1, note = '/sounds/035.wav', image = '/images/letters/transparent_y.png', group = 'ri'},
	u = {x = 7, y = 1, note = '/sounds/036.wav', image = '/images/letters/transparent_u.png', group = 'ri'},
	i = {x = 8, y = 1, note = '/sounds/037.wav', image = '/images/letters/transparent_i.png', group = 'rm'},
	o = {x = 9, y = 1, note = '/sounds/038.wav', image = '/images/letters/transparent_o.png', group = 'rp'},
	p = {x = 10, y = 1, note = '/sounds/039.wav', image = '/images/letters/transparent_p.png', group = 'lp'},
	a = {x = 1, y = 2, note = '/sounds/040.wav', image = '/images/letters/transparent_a.png', group = 'lp'},
	s = {x = 2, y = 2, note = '/sounds/041.wav', image = '/images/letters/transparent_s.png', group = 'lr'},
	d = {x = 3, y = 2, note = '/sounds/042.wav', image = '/images/letters/transparent_d.png', group = 'lm'},
	f = {x = 4, y = 2, note = '/sounds/043.wav', image = '/images/letters/transparent_f.png', group = 'li'},
	g = {x = 5, y = 2, note = '/sounds/044.wav', image = '/images/letters/transparent_g.png', group = 'li'},
	h = {x = 6, y = 2, note = '/sounds/045.wav', image = '/images/letters/transparent_h.png', group = 'ri'},
	j = {x = 7, y = 2, note = '/sounds/046.wav', image = '/images/letters/transparent_j.png', group = 'ri'},
	k = {x = 8, y = 2, note = '/sounds/047.wav', image = '/images/letters/transparent_k.png', group = 'rm'},
	l = {x = 9, y = 2, note = '/sounds/048.wav', image = '/images/letters/transparent_l.png', group = 'rp'},
	z = {x = 1, y = 3, note = '/sounds/049.wav', image = '/images/letters/transparent_z.png', group = 'lp'},
	x = {x = 2, y = 3, note = '/sounds/050.wav', image = '/images/letters/transparent_x.png', group = 'lr'},
	c = {x = 3, y = 3, note = '/sounds/051.wav', image = '/images/letters/transparent_c.png', group = 'lm'},
	v = {x = 4, y = 3, note = '/sounds/052.wav', image = '/images/letters/transparent_v.png', group = 'li'},
	b = {x = 5, y = 3, note = '/sounds/053.wav', image = '/images/letters/transparent_b.png', group = 'li'},
	n = {x = 6, y = 3, note = '/sounds/054.wav', image = '/images/letters/transparent_n.png', group = 'ri'},
	m = {x = 7, y = 3, note = '/sounds/055.wav', image = '/images/letters/transparent_m.png', group = 'ri'},
	["return"] = {x = 8, y = 3, note = '/sounds/056.wav', image = '/images/letters/transparent_enter.png', group = 'special'}}

function Trigger(key)
	local letterFile = getLetterFileFromKey(key)
	local image = love.graphics.newImage(letterFile)
	local width, height = image:getDimensions( )

	local noteFile = getNoteFileFromKey(key)
	local sound = love.audio.newSource(noteFile, 'static')
	
	local activeBorderImage = love.graphics.newImage('/images/transparent_yellow_border.png')
	local inactiveBorderImage = love.graphics.newImage('/images/transparent_pink_border.png')

	local x, y = getTriggerPlacement(key)
	local group = getGroupFromKey(key)

	local xOffset = width + 10
	local yOffset = height + 10

	-- the widest row is 10 keys long, the longest column is  3 keys long
	local xInitOffset = ((y - 1)*25) + (gameWidth - (11 * xOffset)) / 2
	local yInitOffset = (gameHeight - (3 * yOffset)) / 2 
	
	local instance = {
		class = "trigger",
		key = key,
		note = sound,
		i = image,
		activeBorderImage = activeBorderImage,
		inactiveBorderImage = inactiveBorderImage,
		w = width,
		h = height,
		x = (x * xOffset) + xInitOffset,
		y = (y * yOffset) + yInitOffset,
		group = group,
		inactive = false
	}
	setmetatable(instance, triggerClass)
	return instance
end

function triggerClass:draw()
	local borderImage = self.activeBorderImage
	if self.inactive == true then
		borderImage = self.inactiveBorderImage
	end
	love.graphics.draw(borderImage, self.x, self.y)
	love.graphics.draw(self.i, self.x, self.y)
end

function triggerClass:update(dt)
end

function triggerClass:keypressed(key)
	if key == self.key and self.inactive == false then
		self.note:stop()
		self.note:play()
		if self:collisionDetected() then
			self.inactive = true
		else
			table.insert(textQueue, self.key)
		end
	end
end

function triggerClass:collisionDetected()
	for idx, target in ipairs(targets) do
		local targetCenterX = target.x + (target.w / 2)
		local targetCenterY = target.y + (target.h / 2)
		if targetCenterX > self.x and
			targetCenterX < self.x + self.w and
			targetCenterY > self.y and
			targetCenterY < self.y + self.h then
			inactivateGroup(self.group)
		end
	end
end

function inactivateGroup(group)
	for idx, trigger in ipairs(triggers) do
		if trigger.group == group then
			trigger.inactive = true
		end
	end
end

function getGroupFromKey(key)
	local triggerTableEntry = triggerTable[key]
	return triggerTableEntry.group
end

function getTriggerPlacement(key)
	local triggerTableEntry = triggerTable[key]
	return triggerTableEntry.x, triggerTableEntry.y
end

-- musical note recordings from "Pack: Piano FF by jobro" on freesound.org
function getNoteFileFromKey(key)
	local triggerTableEntry = triggerTable[key]
	return triggerTableEntry.note
end

function getLetterFileFromKey(key)
	local triggerTableEntry = triggerTable[key]
	return triggerTableEntry.image
end

return Trigger
