local lib={}

local names={}

local w,h=term.getSize()
local i=1

lib.Print=function(str,name,d)
	str=tostring(str)
	--i=math.max(#names+2,i) TODO fix
	local ii=names[name] or i
	term.setCursorPos(w-#((d and name..' ' or '')..str),ii)
	term.setBackgroundColour(colours.black)
	term.setTextColour(colours.white)
	term.write((d and name..' ' or '')..str)
	names[(name or true)]=ii
	i=i+1
	if i>h then i=1 end
end

lib.PrintTable=function(tbl,...)
	return lib.Print(textutils.serialize(tbl),...)
end

lib.Clear=function()
	term.setBackgroundColour(colours.black)
	term.setTextColour(colours.white)
	term.clear()
end

local function CornerPrint( str ) --TODO include positioning
	str=tostring(str)
	term.setBackgroundColour(colours.black)
	term.setTextColour(colours.white)
	term.write(str)
end

lib.BottomLeft=function(str)
	term.setCursorPos(1,h)
	CornerPrint(str)
end

lib.TopLeft=function(str)
	term.setCursorPos(1,1)
	CornerPrint(str)
end

_G.Debug=lib
