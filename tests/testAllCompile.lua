
local files = {
	"credits.lua";
}

print( "Test:\n ALL: Compile" )

for k, path in pairs( files ) do
	print( "  Compiling " .. path .. "..." )
	loadfile( "../" .. path )
end
