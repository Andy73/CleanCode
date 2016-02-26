
local files = {
	"credits.lua";
}

local tables = {
	"language.tbl";
}

print( "Test:\n ALL: Compile" )

for k, path in pairs( files ) do
	print( "  Compiling file " .. path .. "..." )

	loadfile( "../" .. path )
end

for k, path in pairs( tables ) do
	print( "  Compiling table " .. path .. "..." )
	
	local f, err = io.open( "/" .. path, "r" )
	if not f then
		error( err )
	end

	local content = f:read( "*a" )
	f:close()

	local ok, err = loadstring( "return " .. content )

	if not ok then
		error( err )
	end
end
