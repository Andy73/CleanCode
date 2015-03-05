local lib={}

local names={}

local w,h=term.getSize()
local i=1

lib.Print=function(str,name,d)
	str=tostring(str)
	local ii=names[name] or i
	term.setCursorPos(w-#((d and name..' ' or '')..str),ii)
	term.setBackgroundColour(colours.black)
	term.setTextColour(colours.white)
	term.write((d and name..' ' or '')..str)
	names[name]=ii
	i=i+1
	if i>h then i=1 end
end

lib.Clear=function()
	term.setBackgroundColour(colours.black)
	term.setTextColour(colours.white)
	term.clear()
end

_G.Debug=lib
