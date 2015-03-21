local Path = "/"..shell.resolve"./".."/"
local t=true
local w,h=term.getSize()

local function load( path )
	path=Path..path
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

local function saveGame(data,a)
	local f=fs.open(Path.."Save.json",(a and"a"or"w"))
	f.write(data)
	f.close()
end

local function loadLevel(name)
	name=Path.."Levels/"..tostring(name)
	local f=fs.open(name,"r")
	local c=f.readAll()
	f.close()
	return json.decode(c)
end

local function saveLevel(name,data)
	name=Path.."Levels/"..tostring(name)..".json"
	data=json.encode(data)
	local f=fs.open(name,"w")
	f.write(data)
	return f.close()
end

load 'Debug.lua'
load 'ParticleEffect.lua'

os.loadAPI(Path.."json")



local RunGameMenu=t
local menu,selected = "MainMenu",1

local entries={
	["MainMenu"]={
		[1]={"Play",function()menu="PlayMenu";selected=1;end},
		[2]={"Test",function()term.clear();sleep(2);end},
		[3]={"Hmmm",function()term.setBackgroundColour(colours.white);term.clear();sleep(2);end},
		[4]={"Profile",function()end},
	},
	["PlayMenu"]={
		[1]={"Career",function()menu="LevelsMenu";selected=1;end},
		[2]={"Community",function()end},
		[3]={"< Back",function()menu="MainMenu";selected=1;end},
	},
	["LevelsMenu"]={},
}

local level=false
local levels={}

--load levels
local list=fs.list(Path.."Levels/")
for i,v in ipairs(list) do
	levels[i]=loadLevel(v)
	entries["LevelsMenu"][i]={levels[#levels].name,function()level=i;error()end} --TODO add actual play
end

local function printMenu()
	term.setBackgroundColour(colours.grey)
	term.setTextColour(colors.white)
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
		term.setTextColour(colors.lightBlue)
		printMenu()
	end
end



--CODE

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
	sleep(0)
end

--TODO/IN_PROGRESS: add "AndySoft presents..." etc

--[[local function sw( txt, w8, x, y ) --slowwrite
	txt=tostring(txt).." "
	if not x and y then x,y=term.getCursorPos() end
	term.setCursorPos(x,y)
	local c={colours.white,colours.lightGrey,colours.grey}
	for i=1,#txt do
		for ii=0,3 do
			term.setCursorPos(x+i+ii,y)
			term.setTextColour(c[ii+1])
			term.write(i+ii<#txt and txt:sub(i+ii,i+ii) or "")
		end
		sleep(w8 or 0)
	end
end

local function rsw( txt, w8, x, y ) --reverse slowwrite
	txt=tostring(txt).." "
	if not x and y then x,y=term.getCursorPos() end
	term.setCursorPos(x,y)
	local c={colours.black,colours.grey,colours.lightGrey,colours.white}
	for i=1,#txt do
		for ii=0,3 do
			term.setCursorPos(x+i+ii,y)
			term.setTextColour(c[ii+1])
			term.write(ii==0 and " " or (i+ii<#txt and txt:sub(i+ii,i+ii) or ""))
		end
		sleep(w8 or 0)
	end
end]]

local function sw( txt, w8, x, y, reverse ) --slowwrite
	txt=tostring(txt).." "
	if not x and y then x,y=term.getCursorPos() end
	term.setCursorPos(x,y)
	local cl={colours.white,colours.lightGrey,colours.grey,colours.black}
	local c={}
	if reverse<0 then
		for i,v in ipairs(cl) do
			c[#cl-i+1]=v
		end
	else
		c=cl
	end

	for i=1,#txt do
		for ii=0,#c-1 do
			term.setCursorPos(x+i+ii,y)
			term.setTextColour(c[ii+1])
			term.write(ii==(reverse<0 and 0 or #c-1) and " " or (i+ii<#txt and txt:sub(i+ii,i+ii) or ""))
		end
		sleep(w8 or 0)
	end

	if reverse>0 then
		sleep(reverse)
		return sw(txt,w8,x,y,reverse*(-1))
	end
end

term.setBackgroundColour(colours.black)
term.setTextColour(colours.white)

sw("AndySoft presents...",0.1,w/5,h/3,1)

--/TODO


local f=fs.open(Path.."game.lua","r")
local c=f.readAll()
f.close()
local fn=loadstring(c)
return fn(levels,level,load,s,saveLevel,saveGame,loadLevel)







--[[print(level)

local hello_world={
	name="Hello World",
	desc="Welcome to ComputerCraft! Your task today will be to write 'Hello World' to the screen.",
	hnts={
		"Use the 'print' function to write text.",
		"Most functions need arguments. Those are supplied in brackets, e.g. 'print(\"asdf\")'.",
		"Strings are variables that store text. An example string would be 'MyString=\"some text\"'"
	},
}

--saveLevel("hello_world",hello_world)

]]