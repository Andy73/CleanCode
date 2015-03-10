local function load( path )
	path='/'..shell.resolve'./'.."/"..path
	local f=fs.open(path,'r')
	print('Loading '..path)
	local fn,err=loadstring(f.readAll(),'lib @'..path)
	f.close()
	if fn then return fn() end
	error(err,0)
end

load'Debug.lua'
load'ParticleEffect.lua'

local w,h=term.getSize()

local MyParticleEffect=ParticleEffect.New()
local MyParticle=Particle.New()

MyParticle.Sprite[1]='X'
MyParticle.Sprite[2]=colours.blue
MyParticle.Sprite[3]=colours.grey
MyParticle.Velocity.y=1
MyParticle.Acceleration.x=1

MyParticleEffect.Position.x=20
MyParticleEffect.Position.y=5

MyParticleEffect.Emmit(MyParticle,5,10,{min=1;max=2;})

for i=1,10 do
	Debug.Clear()
	Debug.Print(i,'Frame',true)
	Debug.BottomLeft(MyParticleEffect.GetHighestValue('Acceleration'))
	MyParticleEffect.Frame()
	MyParticleEffect.Render()
	sleep(0.2)
end
