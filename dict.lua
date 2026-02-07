#!/usr/bin/env lua
-- Dictgame
-- TODO (in order of importance):
-- * choose language at runtime
--   X also perhaps only require one file for a language, reversing its entries?
-- X option between typing the word or choosing it via its assigned number
-- X randomize options
-- * make interface pretty/readable
-- * more game modes
-- X more languages

math.randomseed(os.time())

-- Player score
local score = 0
-- Maximum number of words to choose from
local maxopt = 4
-- Others
local esc='\27['

-- Read and parse the tsv file
local function readtsv(filename)
	local data = {}
	local i=1
	
	-- Open the file for reading
	local file = io.open(filename, "r")
	if not file then
		error("Could not open "..filename)
	end
	
	-- Read each line in the file
	for line in file:lines() do
		local fields = {}
		for field in line:gmatch("([^\t]+)") do
			table.insert(fields, field)
		end
		-- I probably could optimize this but it works
		data[i] = {}
		data[i].word = fields[1]
		data[i].def = fields[2]
		i=i+1
	end
	i=_
	
	-- Close the file
	file:close()
	return data
end

local getword = function(data)
	local nr = math.random(1,#data)
	local position = math.random(1,maxopt)
	-- Return the word, its true definition, and position
	return data[nr].word, data[nr].def, position
end

local printword = function(data, word, def, position)
	print(word)
	print('choose:')
	-- Randomize answer position
	for i=1,maxopt do
		if i == position then
			print('\t'..def)
		else
			print('\t'..data[math.random(1,#data)].def)
		end
	end
end

-- Reading the dictionary 'database'
-- User can also choose language
if #arg < 1 then
	-- Print help message if no arg is given
	print('usage: '..arg[0]..' [lang] [opt]')
	os.exit(2)
else
	lang = arg[1]
	d = readtsv('res/en-'..lang..'.tsv')
end

-- Clear screen
io.write(esc..'0;0H'..esc..'2J')
io.flush()

-- Game loop
while score >= 0 do
	word, ans, position = getword(d)
	printword(d, word, ans, position)
	
	opt=io.read()

	if opt == ans or tonumber(opt) == position then
		print(esc..'32m'..'Correct!'..esc..'m')
		score = score+1
	else
		print(esc..'31mWrong! '..'Score:'..score..esc..'m')
		print(esc..'31mThe correct word was: '..esc..'m'..ans)
		score = score-1
	end
end

print('\nYou lost! Score: '..score)
