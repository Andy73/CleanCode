
--local ok,err=commands.exec("setblock ~ ~ ~-5 minecraft:quartz_block")

--print(textutils.serialize(err))

for i=1,10 do
	for ii=1,10 do
		commands.execAsync("summon FallingSand ~"..i.." ~2 ~"..(ii+5).." {TileID:155,Time:1,Motion:[0.0,0.5,0.0]}")	
	end
	sleep(0)
end
--,BlockID:155,DropItem:155

--summon FallingSand x y z {TileID:5,Time:2,Motion:[0.0,0.0,0.5]}


--[[
Todo:
-make this into an API
-use commands.getBlockPosition (or how its called)
-OOP!!!
-would be nice to cheCck If the blocks fell on the right spot!
-more awesomeness to come
]]