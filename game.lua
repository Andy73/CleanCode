local args = {...}

local levels,level,load,s,saveLevel,saveGame,loadLevel,sw=unpack(args)
if type(load)~="function" then error("Please run CleanCode with ./main.lua",0) end

local description=true --false when closed
local MenuState="Editor"

local buffer,editor

--why Lua, why? ;(
local menu={}


--[[
	local f=fs.open("/CleanCode/args","w")
	f.write(Debug.Serialize(args))
	f.close()
]]

term.setCursorBlink(true) --DEBUG

--local c={colours.black,colours.grey,colours.lightGrey,colours.white}
term.setBackgroundColour(colours.black)
term.clear()
term.setBackgroundColour(colours.grey)


local function s()
	os.queueEvent"QuickSleep"
	return coroutine.yield"QuickSleep"
end

local w,h=term.getSize()

local length=5
--[[
	for x=w,-length*2,-4 do
		for y=1,h do
			local len=length
			

			for i=0,w-length do
				if i%len==0 then
					term.setCursorPos(x+i+(y%2),y)
					term.write(" ")
					if i>length*2 then
						break
					end
					if len>1 then
						len=len-1
					end
				end
			end
		end
		sleep(0)
	end
]]

term.setCursorPos(1,1)


local function wrap(text, maxWidth)
	local lines = {''}
	for word, space in text:gmatch('(%S+)(%s*)') do
		local temp = lines[#lines] .. word .. space:gsub('\n','')
		if #temp > maxWidth then
				table.insert(lines, '')
		end
		if space:find('\n') then
			lines[#lines] = lines[#lines] .. word

			space = space:gsub('\n', function()
				table.insert(lines, '')
				return ''
			end)
		else
			lines[#lines] = lines[#lines] .. word .. space
		end
	end
	if #lines[1] == 0 then
		table.remove(lines,1)
	end
	return lines
end



local function printgui()
	term.setBackgroundColour(colours.grey)
	term.setTextColour(colours.white)
	term.clear()
	--print level name as title
	term.setCursorPos(4,(description and 3 or 2))
	term.write(levels[level].name)

	--print menu of options (hints, docs, leave etc) HUGE TODO: Fix this menu! (@EventHandler)
		--calculate how far from right the items should be positioned
		local distance = 0
		for k,v in pairs(menu) do
			distance=distance+#v[1]
		end
		distance=distance+#menu
	term.setCursorPos(w-distance,1)
	term.setBackgroundColour(colours.white)
	
	term.write((" "):rep(w-distance))
	term.setCursorPos(w-distance,1)
	
	term.setTextColour(colours.lightGrey)
	term.write"|"
	term.setTextColour(colours.black)

	for i,v in ipairs(menu) do
		local _x,_y=term.getCursorPos()
		term.write(v[1])
		term.setTextColour(colours.lightGrey)

		term.write"|"

		term.setTextColour(colours.black)
		term.setCursorPos(_x+#v[1]+1,_y)
	end

	--if the description is open
	if description then
		--print description (task) of the level
		--term.setCursorPos(w/2,4)
		term.setBackgroundColour(colours.grey)
		term.setTextColour(colours.lightGrey)

		for i,v in pairs(wrap(levels[level].desc,math.ceil(w/2))) do
			term.setCursorPos(w/2,3+i)
			term.write(v)
		end

		--print "x" button for closing the description
		term.setCursorPos(w-1,3)
		term.setTextColour(colours.red)
		term.write"x"
	else 
		--print "v" button to show the desc.
		term.setCursorPos(w-2,2)
		term.setTextColour(colours.lightGrey)
		term.setBackgroundColour(colours.grey)
		term.write"v"
	end
	--print the placeholder for the editor
	term.setBackgroundColour(colours.white)
	term.setCursorPos(1,1)
	for y=(description and math.ceil(h/2)-1 or 3),h-1 do
		term.setCursorPos(2,y)
		term.write(string.rep(" ",w-2))
	end
	buffer.clear()

	for i,v in ipairs(editor.ToStringsByLines()) do
		buffer.setCursorPos(1,i)
		buffer.write(v)
	end

	buffer.Draw()

	--print the run button
	term.setTextColour(colours.white)
	term.setBackgroundColour(colours.green)
	term.setCursorPos(w-4,h)
	term.write"Run >"

end

local function printHints()
	local oldDesc=description
	description=false
	printgui()

	term.setBackgroundColour(colours.grey)
	for y=3,h do
		term.setCursorPos(1,y)
		term.clearLine()
	end

	-- remove "v" button
	term.setCursorPos(w-2,2)
	term.setBackgroundColour(colours.grey)
	term.write" "

	term.setTextColour(colours.lightBlue)

	for i,v in ipairs(levels[level].hnts) do
		for _,txt in ipairs(wrap(v,w-4)) do
			term.setCursorPos(2,2+i*3+_)
			term.write(txt)
		end
	end

	description=oldDesc
end

--why Lua? :'(
menu={
	{"Hints",function()printHints()end,},
	{"Documentation",function()end,},
	{"Some button",function()error()end,}
}


local function RunCode()
	--TODO: add actual execution :D
end

buffer=Buffer.New(2,math.ceil(h/2)-1)
buffer.Resize(w-4,h-math.ceil(h/2)+1)

editor=Editor.New(2,math.ceil(h/2)-1)

local function main()
	local case={
		mouse_click=function(_,btn,x,y)
			--code
			if MenuState=="Editor" then
				if y==h and x>w-4 then --run button
					return RunCode()
				elseif y>=(description and math.ceil(h/2)-1 or 3) and y<h and x>1 and x<w then --code placeholder
					editor.SetCursorPosRelative(x,y)
					--TODO context menus?
				elseif x==w-1 and y==3 and description then --x button, close desc.
					description=false
					buffer.Reposition(2,3)
					buffer.Resize(w-4,h-3)
					editor.Reposition(2,3)
					--force reprint
					term.setBackgroundColour(colours.grey)
					term.clear()
					return printgui()
				elseif x==w-2 and y==2 and not description then --v button, open desc.
					description=true
					buffer.Reposition(2,math.ceil(h/2)-1)
					buffer.Resize(w-4,h-math.ceil(h/2)+1)
					editor.Reposition(2,math.ceil(h/2)-1)
					--force reprint
					term.setBackgroundColour(colours.grey)
					term.clear()
					return printgui()
				elseif y==1 then --menu
					local distance = 0
					for k,v in pairs(menu) do
						distance=distance+#v[1]
						--print(distance)
					end
					distance=distance+#menu

					--print("final="..distance)

					local length=0
					local i=false
					for k,v in pairs(menu) do
						length=length+#v[1]
						--print(length)
						if length+w-distance>=x then i=k break
						elseif length+w-distance>w then break end
					end
					--print("key is "..tostring(i))
					if i and type(menu[i][2])=="function" then 
						if menu[i][1]=="Hints" then MenuState="Hint" end
						menu[i][2]()
					end
				end
			elseif MenuState=="Hint" then
				if y==1 then
					MenuState="Editor"
					printgui()
				elseif false then

				end
			end
		end,
		char=function(_,ch)
			editor.Write(ch)
			return printgui()
		end,
		key=function(_,key)
			if key==keys.enter then
				local _,_y=editor.GetCursorPos()
				editor.SetCursorPos(1,_y+1)
			elseif key==keys.backspace then
				editor.Backspace()
				printgui()
			elseif key==keys.delete then
				editor.Delete()
			end
		end,
		mouse_scroll=function(_,n)
			buffer.scroll(n) --TODO!!!!
			printgui()
		end
	}
	while true do
		local ev={os.pullEvent()}
		--printgui()
		if case[ev[1]] then case[ev[1]](unpack(ev)) end
	end
end


printgui()

main()






os.pullEvent"char"
