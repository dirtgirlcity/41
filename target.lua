local targetClass = { }
targetClass.__index = targetClass

local directions = { "N", "S", "E", "W" }

function Target(difficulty)
	local targetFile = '/images/transparent_butterfly.png'
	local image = love.graphics.newImage(targetFile)
	local w, h = image:getDimensions( )
	local x, y, direction = setStartSide(w, h)
	local speed = setStartSpeed(difficulty)
	local instance = {
		class = 'target',
		d = direction,
		i = image,
		w = w,
		h = h,
		x = x,
		y = y,
		s = speed,
		inactive = false
	}
	setmetatable(instance, targetClass)
	return instance
end

function targetClass:draw()
	love.graphics.draw(self.i, self.x, self.y)
end

function targetClass:update(dt)
	if self:edgeDetected() then
		self.inactive = true
	else
		self:move()
	end
end

function targetClass:move()
	if self.d == "N" then
		self.y = self.y - self.s
	end
	
	if self.d == "S" then
		self.y = self.y + self.s
	end
	
	if self.d == "E" then
		self.x = self.x + self.s
	end
	
	if self.d == "W" then
		self.x = self.x - self.s
	end
end

function targetClass:edgeDetected()
	if self.d == "N" and self.y <= 0 - self.h then
		return true
	end

	if self.d == "S" and self.y >= gameHeight then
		return true
	end

	if self.d == "E" and self.x >= gameWidth then
		return true
	end

	if self.d == "W" and self.x <= 0 - self.w then
		return true
	end
	
	return false
end

function setStartSide(w, h)
	local direction = math.random(1,4)
	local side = directions[direction]

	local xBoundary = (math.random(0, gameWidth - w) / 10) * 10
	local yBoundary = (math.random(0, gameHeight - h) / 10) * 10

	if side == "N" then
		x = xBoundary
		y = 0 - h
		d = "S"
	end

	if side == "S" then
		x = xBoundary
		y = gameHeight
		d = "N"
	end

	if side == "E" then
		x = gameWidth
		y = yBoundary
		d = "W"
	end

	if side == "W" then
		x = 0 - w
		y = yBoundary
		d = "E"
	end

	return x, y, d
end

function setStartSpeed(difficulty)
	return 5*(difficulty)
end

return Target
