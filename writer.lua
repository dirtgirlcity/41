local writerClass = { }
writerClass.__index = writerClass

local idiomTable = {
	"laws catch flies but let hornets go free",
	"with lies you may get ahead in life but you may never go back",
	"in the house of the hanged man they do not mention the rope",
	"two deaths will not happen but one is inevitable",
	"forbidden fruit is sweetest",
	"whatever we fight for destroys us",
	"a word dropped from a song makes it all wrong",
	"a guilty conscience needs no accuser",
	"little strokes fell great oaks",
	"curses like chickens come home to roost"
}

function Writer( )
	local w, h = 0, 0
	local alphabet = { }

	for i = 97, 122 do
		local c = string.char(i)
		local file = string.format("/images/letters/transparent_%s.png", c)
		local img = love.graphics.newImage(file)
		alphabet[c] = img
		local w, h = img:getDimensions()
	end

	local idiom = chooseIdiom()
	local words = getWordsFromIdiom(idiom)
	local characters = getCharactersFromWords(words)

	local instance = {
		alphabet = alphabet,
		idiom = idiom,
		words = words,
		characters = characters,
		x = 50,
		y = 50,
		w = w,
		h = h,
		queue = { }
	}
	setmetatable(instance, writerClass)
	return instance
end

function writerClass:draw()
	local buffer = 40
	local xOffset = 0
	local yOffset = 0

	for idx, character in ipairs(self.characters) do
		print("character: ", character)
		if character ~= " " then
			love.graphics.draw(self.alphabet[character], self.x + xOffset , self.y + yOffset)
			xOffset = xOffset + self.w + buffer
		else
			print("at a space")
			print("self.x: ", self.x)
			print("gameWidth: ", gameWidth)
			print("#self.characters: ", #self.characters)
			print("self.x + (xOffset * idx): ", self.x + (xOffset * idx))
			if (self.x + (5 * xOffset)) >= gameWidth then
				xOffset = 0
				yOffset = yOffset + self.h + buffer
			else
				xOffset = xOffset + buffer
			end
		end
	end

	print("characters length: ", #self.characters)
end

function writerClass:update(dt)
end

function chooseIdiom()
	love.math.setRandomSeed(111)
	local i = math.random(1, #idiomTable)
	local current = idiomTable[i]
	table.remove(idiomTable, i)
	return current
end

function getWordsFromIdiom(idiom)
	local words = { }
	for w in string.gmatch(idiom, "%S+") do
		table.insert(words, w)
	end
	return words
end

function getCharactersFromWords(words)
	characters = { }
	for idx, word in ipairs(words) do
		print("word: ", word)
		for character in string.gmatch(word, ".") do
			table.insert(characters, character)
			print("character: ", character)
		end
		table.insert(characters, " ")
	end
	return characters
end

return Writer

