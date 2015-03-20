local function load( path )
	path='/'..shell.resolve'./'.."/"..path
	local f=fs.open(path,'r')
	print('Loading '..path)
	local fn,err=loadstring(f.readAll(),'lib @'..path)
	f.close()
	if fn then return fn() end
	error(err,0)
end

load 'Debug.lua'
load 'ParticleEffect.lua'

local w,h=term.getSize()

local RunGameMenu=true

local entries={
	[1]={"Play",function()print"STOP";sleep(2);RunGameMenu=false;end},
	[2]={"Test",function()term.clear();sleep(2);end},
	[3]={"Hmmm",function()term.setBackgroundColour(colours.white);term.clear();sleep(2);end},
}
local selected = 1

local function printMenu()
	term.setBackgroundColour(colours.grey)
	term.setTextColor(colors.white)
	term.clear()

	term.setCursorPos(8,4)
	term.write"CleanCode"

	for i,v in ipairs(entries) do
		term.setCursorPos(2,i*2+5)
		term.setBackgroundColour(selected==i and colours.lightGrey or colours.grey)
		term.write(" "..v[1]..string.rep(" ",4))
	end
end

local function GameMenu()
	local c = 0
	while RunGameMenu do
		c=c+1
		os.startTimer(1)
		--Debug.Print(c)
		local ev={os.pullEvent()}
		--Debug.Print(textutils.serialize(ev))
		if ev[1]=="mouse_click" then
			if ev[3]<w/3 then
				local index=math.ceil((ev[4]-5)/2)
				if entries[index] then
					selected=index
					printMenu()
					sleep(0)
					entries[index][2]()
				end
			end
		end
		term.setTextColor(colors.lightBlue)
		printMenu()
	end
end

--GameMenu()

local c=coroutine.create(GameMenu)
coroutine.resume(c)

while true do
	--printMenu()
	local ev = {os.pullEvent()}
	local ok,err=coroutine.resume(c,unpack(ev))
	if not ok then error("Ended "..tostring(err or "(status:dead)"),0)
	elseif coroutine.status(c)=="dead"then break end
end

term.setBackgroundColour(colours.black)

for i=1,h do
	term.setCursorPos(1,i)
	term.clearLine()
	s()
end
