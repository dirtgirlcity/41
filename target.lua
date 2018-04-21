local targetClass = { }
targetClass.__index = targetClass

function Target()
	local targetFile = '/images/butterfly.png'
	local image = love.graphics.newImage(targetFile)
	local w, h = image:getDimension( )
	local x, y = setStartSide(w, h)
	local instance = {
		class = 'target',
		i = image,
		w = w,
		h = h,
		x = x,
		y = y,
		s = setStartSpeed()
	}
	setmetatable(instance, targetClass)
	return instance
end

function targetClass:draw()
	love.graphics.draw(self.i, self.x, self.y)
end

function targetClass:update(dt)
end

function setStartSide()
	local side = "L"
	if side == "L" then
		x = 0
		y = 300 --TODO: calculate bound box
	end
	return x, y
end

return Target
