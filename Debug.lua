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

lib.Serialize=function(tbl,indent)
	local str=""
	if not tonumber(indent) then indent=1 end
	indent=string.rep("	",indent)
	for k,v in pairs(tbl) do
		if type(v)=="table" then
			str=str..indent..tostring(k).."={"..lib.Serialize(v,#indent+1)..indent.."\n}"
		elseif type(v)=="string" then
			str=str.."\n"..indent..tostring(k).."=\""..tostring(v).."\""
		else
			str=str.."\n"..indent..tostring(k).."="..tostring(v)
		end
	end
	return str
end

lib.PrintTable=function(tbl,...)
	return lib.Print(lib.Serialize(tbl),...)
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
