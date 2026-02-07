#!/usr/bin/env lua
-- Test TSV dictionary files
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
		print(i..'\t'..fields[1]..' -> '..fields[2])
		i=i+1
	end
	
	-- Close the file
	file:close()
	return fields
end
--readtsv('res/en-ro.tsv')
readtsv(arg[1])
