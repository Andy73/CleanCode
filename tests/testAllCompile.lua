
local files = {
	"credits.lua";
}

for k, path in pairs( files ) do
	loadfile( "../" .. path )
end
