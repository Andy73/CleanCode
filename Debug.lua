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

lib.Clear=function()
	term.setBackgroundColour(colours.black)
	term.setTextColour(colours.white)
	term.clear()
end

_G.Debug=lib
