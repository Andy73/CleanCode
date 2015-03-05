local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


local lib={}
local particle={}

particle.New=function(s,p,v)
	local n={}
	local time=os.clock()
	local deltaTime=0

	n.Sprite=s  or  {' ';0;0;}
	n.Position=p or {x=1;y=1;}
	n.Velocity=v or {x=0;y=0;}
	n.Life=l or 5

	n.Frame=function()
		if n.Life<0 then n.Sprite[1]='' end
		deltaTime=os.clock()-time
		for k,v in pairs(n.Position) do
			n.Position[k]=v+n.Velocity[k] --universal for any amount of dimensions
		end
		n.Life=n.Life-deltaTime
		time=os.clock()
	end

	return n
end

--static
lib.Shape={}
lib.Shape.Rectangular='ParticleEffect.Shape.Rectangular'
lib.Shape.Point='ParticleEffect.Shape.Point'

--methods
lib.New=function(s,p,sz,st,wt)
	local n={} --instance

	n.Shape=s or lib.Shape.Rectangular
	n.Position=p or {x=0;y=0;}
	n.Size=sz or {w=0;h=0;}
	n.StepTime=st or 1
	n.WaitTime=wt or 1
	
	local particles={}

	n.Render=function()
		for i,p in ipairs(particles) do
			term.setCursorPos(n.Position.x+p.Position.x,n.Position.y+p.Position.y)
			if p.Sprite[2]>0 then term.setTextColor(p.Sprite[2]) end
			if p.Sprite[3]>0 then term.setBackgroundColor(p.Sprite[3]) end
			term.write(p.Sprite[1])
		end
	end

	n.EmmitRaw=function(n,fn,...) --number of particles, noise function, masks (particle to derive values from)
		local masks={...}

		local function newParticle()
			local mask=masks[math.random(1,#masks)]
			local np={}

			np=deepcopy(mask)

			if fn then np=fn(np,mask,masks) end
			table.insert(particles,np)
		end

		for i=1,n do
			newParticle()
		end
	end

	n.Emmit=function(default,amount,m,modifier) --default particle, amount of particles, number of masks to use, modifier
		--generate masks
		local masks={}

		local function generateMask()
			local mask=deepcopy(default)
			
			for k,v in pairs(mask) do
				if type(v)=='table' then
					for kk,vv in pairs(v) do
						if type(vv)=='number' then
							mask[k][kk]=vv*math.random((modifier.min),(modifier.max))
						end
					end
				end
			end

			table.insert(masks,mask)
		end

		for i=1,m do
			generateMask()
		end

		--emmit
		n.EmmitRaw(amount,nil,unpack(masks)) --TODO not nil
	end

	n.Frame=function()
		for k,v in pairs(particles) do
			v.Frame()
		end
	end

	return n
end

_G.ParticleEffect=lib
_G.Particle=particle
