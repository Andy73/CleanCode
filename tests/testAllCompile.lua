
local lfs = require "lfs"

if not lfs then
	error( "Build Environment Error: Missing dependency 'LuaFileSystem'" )
end

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
	
	local cwd, err = lfs.currentdir()
	if not cwd then
		error( err )
	end

	local f, err = io.open( cwd .. path, "r" )
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
