local function load( path )
	path='/'..shell.resolve'./'.."/"..path
	local f=fs.open(path,'r')
	print('Loading '..path)
	local fn,err=loadstring(f.readAll(),'lib @'..path)
	f.close()
	if fn then return fn() end
	error(err,0)
end

local function s()
	os.queueEvent"QuickSleep"
	coroutine.yield"QuickSleep"
end

load 'Debug.lua'
load 'ParticleEffect.lua'

local w,h=term.getSize()

local RunGameMenu=true


local menu,selected = "MainMenu",1

local entries={
	["MainMenu"]={
		[1]={"Play",function()menu="PlayMenu";selected=1;end},
		[2]={"Test",function()term.clear();sleep(2);end},
		[3]={"Hmmm",function()term.setBackgroundColour(colours.white);term.clear();sleep(2);end},
		[4]={"Profile",function()end},
	},
	["PlayMenu"]={
		[1]={"Career",function()end},
		[2]={"Community",function()end},
		[3]={"< Back",function()menu="MainMenu";selected=1;end},
	},
}


local function printMenu()
	term.setBackgroundColour(colours.grey)
	term.setTextColor(colors.white)
	term.clear()

	term.setCursorPos(8,4)
	term.write"CleanCode"

	for i,v in ipairs(entries[menu]) do
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
		local ev={os.pullEvent()}

		if ev[1]=="mouse_click" then
			if ev[3]<w/3 then
				local index=math.ceil((ev[4]-5)/2)
				if entries[menu][index] then
					selected=index
					printMenu()
					sleep(0.01)
					entries[menu][index][2]()
				end
			end
		elseif ev[1]=="key" then
			local case={
				[keys.enter]=function()
					if entries[menu][selected] then
						entries[menu][selected][2]()
					end
				end;
				[keys.down]=function()
					selected=selected+1
					if #entries[menu]<selected then selected=1 end
				end;
				[keys.up]=function()
					selected=selected-1
					if 1>selected then selected=#entries[menu] end
				end;
			}
			if case[ev[2]] then case[ev[2]]() end
		end
		term.setTextColor(colors.lightBlue)
		printMenu()
	end
end

local c=coroutine.create(GameMenu)
coroutine.resume(c)

while true do
	local ev = {os.pullEvent()}
	local ok,err=coroutine.resume(c,unpack(ev))
	if not ok then error("Ended "..tostring(err or "(status:?)"),0)
	elseif coroutine.status(c)=="dead"then break end
end

term.setBackgroundColour(colours.black)

for i=1,h do
	term.setCursorPos(1,i)
	term.clearLine()
	s()
end
