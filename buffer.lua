local lib={}

lib.New=function()
	local n={} --new instance
	local c={} --new instance's content

	local w,h=1,1 --width, height
	local x,y=1,1 --cursor position
	local bc,tc=1,1 --background and text colour

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

	return n
end

_G.Buffer=lib