local lib={}
local colourLookup={}

for k,v in pairs(colours) do
	colourLookup[v]=k
end

lib.New=function()
	local n={} --new instance
	local c={} --new instance's content

	local w,h=1,1 --width, height
	local x,y=1,1 --cursor position
	local bc,tc=1,1 --background and text colour
	local b,coloured=true,true --blink, advanced display

	--prepare the content table
	for _y=1,h do
		c[_y]={}
		for _x=1,w do
			c[_y][_x]={bc,tc," "}
		end
	end

	n.setCursorPos=function(a,b)
		if type(a)~="number" or type(b)~="number" then error("Expected number, number",2) end
		x,y=a,b
	end

	n.write=function(txt)
		txt=tostring(txt)
		for i=1,#txt do
			c[y][x+i-1]={bc,tc,txt:sub(i,i)}
		end
	end

	n.setBackgroundColour=function(c)
		c=tonumber(c)
		if not c or not colourLookup[c] then error("Invalid coulour!",2) end
		bc=c
	end

	n.setTextColour=function(c)
		c=tonumber(c)
		if not c or not colourLookup[c] then error("Invalid coulour!",2) end
		tc=c
	end

	n.clearLine=function()
		x=1
		return n.write(string.rep(" ",w))
	end

	n.clear=function()
		for i=1,h do
			y=i
			n.clearLine()
		end
	end

	n.setCursorBlink=function(x)
		if type(x)~="bool" then error("Expected boolean, got "..type(x),2) end
		b=x
	end

	n.Draw=function()
		for _y,row in ipairs(c) do
			for _x,px in ipairs(row) do
				term.setCursorPos(posx+x-1,posy+y-1)
				term.setBackgroundColour(px[1])
				term.setTextColour(px[2])
				term.write(px[3])
			end
		end
	end

	--symlinks :P
	n.setTextColor=n.setTextColour
	n.setBackgroundColor=n.setBackgroundColour

	return n
end

_G.Buffer=lib