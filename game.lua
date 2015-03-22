local args = {...}

local levels,level,load,s,saveLevel,saveGame,loadLevel,sw=unpack(args)


--[[
local f=fs.open("/CleanCode/args","w")
f.write(Debug.Serialize(args))
f.close()]]


--local c={colours.black,colours.grey,colours.lightGrey,colours.white}
term.setBackgroundColour(colours.black)
term.clear()
term.setBackgroundColour(colours.grey)





term.clear() --  <--REMOVE WHEN ANIMATION ENABLED






local function s()
	os.queueEvent"QuickSleep"
	return coroutine.yield"QuickSleep"
end

local w,h=term.getSize()

local length=5
--[[
for x=w,-length*2,-4 do
	for y=1,h do
		local len=length
		

		for i=0,w-length do
			if i%len==0 then
				term.setCursorPos(x+i+(y%2),y)
				term.write(" ")
				if i>length*2 then
					break
				end
				if len>1 then
					len=len-1
				end
			end
		end
	end
	sleep(0)
end]]

term.setCursorPos(1,1)


local menu={
	{"Hints",function()end,},
	{"Documentation",function()end,},
}

local function wrap(text, maxWidth)
	local lines = {''}
	for word, space in text:gmatch('(%S+)(%s*)') do
		local temp = lines[#lines] .. word .. space:gsub('\n','')
		if #temp > maxWidth then
				table.insert(lines, '')
		end
		if space:find('\n') then
			lines[#lines] = lines[#lines] .. word

			space = space:gsub('\n', function()
				table.insert(lines, '')
				return ''
			end)
		else
			lines[#lines] = lines[#lines] .. word .. space
		end
	end
	if #lines[1] == 0 then
		table.remove(lines,1)
	end
	return lines
end

local function printgui()
	--print level name as title
	term.setCursorPos(4,3)
	term.write(levels[level].name)

	--print menu of options (hints, docs, leave etc)
	term.setCursorPos(w-19,1) --TODO calculate how far from right
	term.setBackgroundColour(colours.white)
	
	term.write((" "):rep(w-19))
	term.setCursorPos(w-20,1)
	
	term.setTextColour(colours.lightGrey)
	term.write"|"
	term.setTextColour(colours.black)

	for i,v in ipairs(menu) do
		local _x,_y=term.getCursorPos()
		term.write(v[1])
		term.setTextColour(colours.lightGrey)

		term.write"|"

		term.setTextColour(colours.black)
		term.setCursorPos(_x+#v[1]+1,_y)
	end

	--print description (task) of the level
	--term.setCursorPos(w/2,4)
	term.setBackgroundColour(colours.grey)
	term.setTextColour(colours.lightGrey)

	for i,v in pairs(wrap(levels[level].desc,math.ceil(w/2))) do
		term.setCursorPos(w/2,3+i)
		term.write(v)
	end

	--print the placeholder for the editor
	term.setBackgroundColour(colours.white)
	term.setCursorPos(1,1)

end


printgui()













sleep(2)
