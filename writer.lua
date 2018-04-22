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

function Writer(idiomType)
	local w, h = 0, 0
	local alphabet = { }

	for i = 97, 122 do
		local c = string.char(i)
		local file = string.format("/images/letters/transparent_%s.png", c)
		local img = love.graphics.newImage(file)
		alphabet[c] = img
		local w, h = img:getDimensions()
	end

	local idiom = { }
	if idiomType == "idiom" then
		idiom = chooseIdiom()
	elseif idiomType == "gameOver" then
		idiom = "you have learned all this has to teach you"
	else
		idiom = "test practice typing"
	end
	
	local words = getWordsFromIdiom(idiom)
	local characters = getCharactersFromWords(words)
	local wordsAsCharacters = getWordsAsCharacters(characters)

	local instance = {
		alphabet = alphabet,
		idiom = idiom,
		words = words,
		characters = characters,
		wordsAsCharacters = wordsAsCharacters,
		lastLetter = "",
		x = 50,
		y = 50,
		w = w,
		h = h,
		letterQueue = { },
		wordQueue = { },
		wordsComplete = { }
	}
	setmetatable(instance, writerClass)
	return instance
end

function writerClass:draw()
	local buffer = 40
	local xOffset = 0
	local yOffset = 0

	for idx, character in ipairs(self.characters) do
		if character ~= " " then
			love.graphics.draw(self.alphabet[character], self.x + xOffset , self.y + yOffset)
			xOffset = xOffset + self.w + buffer
		else
			if (self.x + (3 * xOffset)) >= gameWidth then
				xOffset = 0
				yOffset = yOffset + self.h + buffer
			else
				xOffset = xOffset + buffer
			end
		end
	end

	if self.alphabet[self.lastLetter] then
		love.graphics.draw(self.alphabet[self.lastLetter], gameWidth - 100, gameHeight - 100)
	end
end

function writerClass:update(dt)
	self:endHelper()
end

function writerClass:keypressed(key)
	if key == "return" then
		self:endHelper()
	end
end

function writerClass:endHelper()
	local complete = self:checkForCompleteIdiom()
	if complete == true then
		self:restart()
	end
end

function writerClass:textinput(t)
	self.lastLetter = t

	local candidateWords = { }
	if next(self.wordQueue) == nil then
		candidateWords = copy(self.wordsAsCharacters)
	else
		candidateWords = copy(self.wordQueue)
	end
	
	self:checkText(t, (#self.letterQueue + 1), candidateWords)
end

function writerClass:checkText(t, currentPosition, candidateWords)
	for idx, word in pairs(candidateWords) do
		
		if word[currentPosition] == t then
			-- this condition avoids duplicate inserts if more than one word is valid
			if self.letterQueue[currentPosition] ~= t then
				table.insert(self.letterQueue, t)
			end
		
			if #word == #self.letterQueue then
				table.insert(self.wordsComplete, idx)
				self.letterQueue = { }
			end
		
		else
			candidateWords[idx] = nil
		end
	
	end				
	
	self.wordQueue = copy(candidateWords)
end

function writerClass:checkForCompleteIdiom()
	local complete = false
	if #self.wordsComplete >= #self.words then
		for i, requiredWord in ipairs(self.words) do
			local matches = 0
			for j, completedWord in ipairs(self.wordsComplete) do
				if j == #self.wordsComplete and matches == #self.words then
					complete = true
				else
					if requiredWord == completedWord then
						matches = matches + 1
					end
				end
			end
		end
	end
	return complete
end

function copy(entry)
	local tbl = { }
	for k, v in pairs(entry) do
		tbl[k] = v
	end
	return tbl
end

function chooseIdiom()
	math.randomseed(os.time())
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

function getWordsAsCharacters(characters)
	local wordsAsCharacters = { }
	local wordCharacters = { }
	for idx, character in ipairs(characters) do
		if character ~= " " then
			table.insert(wordCharacters, character)
		else
			local joinedCharacters = table.concat(wordCharacters)
			wordsAsCharacters[joinedCharacters] = wordCharacters
			wordCharacters = { }
		end
	end
	return wordsAsCharacters
end

function getCharactersFromWords(words)
	characters = { }
	for idx, word in ipairs(words) do
		for character in string.gmatch(word, ".") do
			table.insert(characters, character)
		end
		table.insert(characters, " ")
	end
	return characters
end

function writerClass:restart()
	self.idiom = chooseIdiom()
	if next(self.idiom) ~= nil then
		gameOver = true
	end
	self.words = getWordsFromIdiom(self.idiom)
	self.characters = getCharactersFromWords(self.words)
	self.wordsAsCharacters = getWordsAsCharacters(self.characters)
end

return Writer
