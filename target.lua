local targetClass = { }
targetClass.__index = targetClass

function Target()
	local targetFile = '/images/butterfly.png'
	local image = love.graphics.newImage(targetFile)
	local width, height = image:getDimension( )
	local x, y = setStartSide()
	local instance = {
		class = 'target',
		i = image,
		w = width,
		h = height,
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

return Target
