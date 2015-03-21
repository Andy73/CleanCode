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
local used={x={none=true},y={none=true}}
for i=1,w*h do
	local x,y,cnt="none","none",1
	while used.x[x] or used.y[y] do
		x=used.x[x] and math.random(1,w) or x
		y=used.y[y] and math.random(1,h) or y
		cnt=cnt+1
		if cnt%5==0 then sleep(0) end
		Debug.BottomLeft(cnt)
	end
	term.setCursorPos(x,y)
	term.write" "
	used.x[x]=true
	used.y[y]=true
	sleep(0)
end

