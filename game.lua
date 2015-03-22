local args = {...}

local levels,level,load,s,saveLevel,saveGame,loadLevel,sw=unpack(args)


--local c={colours.black,colours.grey,colours.lightGrey,colours.white}
term.setBackgroundColour(colours.black)
term.clear()
term.setBackgroundColour(colours.grey)

local function s()
	os.queueEvent"QuickSleep"
	return coroutine.yield"QuickSleep"
end

local w,h=term.getSize()

--[[for x=w,-3,-4 do
	for i=0,3 do
		for y=1,h,4 do
			for _=0,i do
				for __=0,i do
					term.setCursorPos(x+_,y+__)
					term.write(" ")
				end
			end
		end
		sleep(0)
	end
end]]

local length=5

for x=w,-length*2,-4 do
	for y=1,h do
		local len=length
		--[[term.setBackgroundColour(colours.black)
		term.clear()
		term.setBackgroundColour(colours.grey)]]

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
end

term.setCursorPos(1,1)
