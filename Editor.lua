











local lib={}

lib.New=function(posx,posy)
	local n={} --new instance
	local c={} --new instance's content

	local insert=false --toggle insert/replace (false = insert new chars)
	local x,y=1,1 --cursor position

	n.Write=function(txt)
		txt=tostring(txt)
		for i=1,#txt do
			if not c[y] then c[y]={} end
			c[y][x]=txt:sub(i,i)
		end
	end

	n.Backspace=function(n)
		n=tonumber(n) or 1
		for i=1,n do
			table.remove(c[y],x-1)
		end
	end

	n.Delete=function(n) --TODO join these two
		n=tonumber(n) or 1
		for i=1,n do
			table.remove(c[y],x)
		end
	end

	n.SetCursorPos=function(a,b,ignore) --new x and y, ignore end of line (fill the rest with spaces)
		if type(a)~="number" or type(b)~="number" then error("Expected number, number",2)end

		if not c[b] then c[b]={} end --TODO correct?

		if ignore then
			if #c[b]<a then
				x,y=#c[b],b
				n.Backspace()
				return n.Write(string.rep(" ",a-#c[b]+1))
			end
			x,y=a,b
			return true
		end
		--[[
			local lastWhitespace=1
			for i=#c[b],1,-1 do
				local s=c[b][i]
				if not (s==" " or s=="\n" or s=="	") then lastWhitespace=i-1 break end
			end
		]]

		x,y=math.min(a,#c[b]),b
		return true

	end

	n.SetCursorPosRelative=function(a,b,ignore)
		if type(a)~="number" or type(b)~="number" then error("Expected number, number",2)end
		a=a-posx+1
		b=b-posy+1
		return n.SetCursorPos(a,b,ignore)
	end

	n.Reposition=function(a,b)
		if type(a)~="number" or type(b)~="number" then error("Expected number, number",2)end
		posx,posy=a,b
	end

	n.ToString=function(format)
		local str=""
		for y=1,#c do
			for x=1,#c[y] do
				str=str.."\n"..c[y][x]
			end
		end
		if type(format)=="string" then return str:format(format) end
		return str
	end

	n.ToStringsByLines=function()
		local out={}

		for y=1,#c do
			out[#out+1]=table.concat(c[y])
		end

		return out
	end

	n.GetCusorPos=function()
		return x,y
	end

	return n
end