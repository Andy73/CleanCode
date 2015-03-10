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

local function printMenu()
	term.setBackgroundColour(colours.grey)
	term.clear()
	for i,v in ipairs(entries) do
		term.setCursorPos(3,i*2+5)
		term.write(v[1])
	end
end

local function GameMenu()
	while RunGameMenu do
		local ev={coroutine.yield()}
		if ev[1]=="mouse_click" then
			if ev[3]<w/3 then
				if entries[math.ceil((ev[4]-5)/2)] then
					entries[math.ceil((ev[4]-5)/2)][2]()
				end
			end
		end
	end
end



local c=coroutine.create(GameMenu)
while true do
	printMenu()
	local ev = {os.pullEvent()}
	local ok,err=coroutine.resume(c,unpack(ev))
	if not ok then error("Ended"..err,0) end
end
