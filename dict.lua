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

-- Player score and lose count
local score = 0
local lose = 0
-- Maximum number of wrong guesses
local max = 3
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
	nr = math.random(1,#d)
	print(d[nr].word)
	print('choose:')
	-- Randomize answer position
	local position = math.random(1,maxopt)
	for i=1,maxopt do
		if i == position then
			print('\t'..d[nr].def)
		else
			print('\t'..d[math.random(1,#d)].def)
		end
	end

	-- Get the word and its true definition
	return d[nr].word, d[nr].def, position
end

-- Read 'database'
-- User can also choose language
if #arg < 1 then
	-- Print help message if no arg is given
	print('usage: '..arg[0]..' [lang] [opt]')
	print('available options:\n\tr\tplay the reverse game')
	os.exit(2)
else
	lang = arg[1]
	d = readtsv('res/en-'..lang..'.tsv')
end

-- Clear screen
io.write(esc..'0;0H'..esc..'2J')
io.flush()

-- Game loop
while lose <= max do
	-- Grab a random word
	-- Also change order if in reverse mode
	if arg[1] == 'r' or arg[2] == 'r' then
		ans, word, position = getword(d)
	else
		word, ans, position = getword(d)
	end
	
	opt=io.read()

	if opt == ans or tonumber(opt) == position then
		print(esc..'32m'..'Correct!'..esc..'m')
		score = score+1
	else
		print(esc..'31mWrong! '..max-lose..' tries left.'..esc..'m')
		print(esc..'31mThe correct word was: '..esc..'m'..ans)
		lose = lose+1
	end
end

print('\nYou lost!\nscore: '..score)
