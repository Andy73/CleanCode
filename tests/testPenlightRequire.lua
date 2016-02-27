
local lfs = require "lfs"

local cwd, err = lfs.currentdir()
if not cwd then
	error( err )
end

dofile( cwd .. "/lib/require.lua" )

require "pl"
