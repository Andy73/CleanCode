local function load( path )
	path='/'..shell.resolve'./'.."/"..path
	local f=fs.open(path,'r')
	print('Loading '..path)
	local fn,err=loadstring(f.readAll(),'lib @'..path)
	f.close()
	if fn then return fn() end
	error(err,0)
end

load'ParticleEffect.lua'

local MyParticleEffect=ParticleEffect.New()
local MyParticle=Particle.New()

MyParticle.Sprite[1]='X'
MyParticle.Sprite[2]=colours.blue
MyParticle.Sprite[3]=colours.red
MyParticle.Velocity.y=-1

MyParticleEffect.Position.x=20
MyParticleEffect.Position.y=5

MyParticleEffect.Emmit(MyParticle,5,2,{min=1;max=3;})

MyParticleEffect.Frame()
MyParticleEffect.Render()
