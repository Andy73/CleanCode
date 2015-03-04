local function load( path )
	path=shell.resolve'./'.."/"..path
	local f=fs.open(path,'r')
	print('Loading '..path)
	local fn,err=loadstring(f.readAll(),'lib @'..path)
	if fn then return fn() end
	error(err,0)
end

load'ParticleEffect.lua'