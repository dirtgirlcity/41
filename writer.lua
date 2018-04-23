local writerClass = { }
writerClass.__index = writerClass


local idiomTable = {
	"hi ello",
	"bye good"
}
local idiotTable = {
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

function Writer()
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
	if key == "escape" then
		love.event.quit()
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
	local candidateWords = self:refreshQueue()
	self:checkText(t, (#self.letterQueue + 1), candidateWords)
end

function writerClass:refreshQueue()
	local candidateWords = { }
	if next(self.wordQueue) == nil then
		print('copying from words as characters')
		candidateWords = copy(self.wordsAsCharacters)
	else
		print('copying from word queue')
		candidateWords = copy(self.wordQueue)
	end
	return candidateWords
end

function writerClass:checkText(t, currentPosition, candidateWords)
		
		print(require('dump')({
			t = t,
			currentPosition = currentPosition,
			candidateWords = candidateWords
		}))

		for idx, word in pairs(candidateWords) do
		
			print(require('dump')({
				idx = idx,
				word = word
			}))
						
			if word[currentPosition] == t then
				-- this condition avoids duplicate inserts if more than one word is valid
				if self.letterQueue[currentPosition] ~= t then
					table.insert(self.letterQueue, t)
				end
		
				if #word == #self.letterQueue then
					table.insert(self.wordsComplete, idx)
					self.letterQueue = { }
					candidateWords = self:refreshQueue()
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
			for j, completedWord in ipairs(self.wordsComplete) do
				
				if completedWord == requiredWord then
					table.remove(self.words, i) -- don't double-check
				end

				if j == #self.wordsComplete and next(self.words) ~= nil then
					complete = false
				elseif next(self.words) == nil then
					complete = true
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
	if next(idiomTable) ~= nil then
		math.randomseed(os.time())
		local i = math.random(1, #idiomTable)
		local current = idiomTable[i]
		table.remove(idiomTable, i)
		return current
	else
		gameOver = true
		local gameOverText = "you have done all you can here"
		return gameOverText
	end
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
	self.words = getWordsFromIdiom(self.idiom)
	self.characters = getCharactersFromWords(self.words)
	self.wordsAsCharacters = getWordsAsCharacters(self.characters)
	self.lastLetter = ""
	self.letterQueue = { }
	self.wordQueue = { }
	self.wordsComplete = { }
end

return Writer
