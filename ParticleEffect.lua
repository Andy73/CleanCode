function deepcopy(orig)
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
		if Life<0 then n.Sprite[1]='' end
		deltaTime=os.clock()-time
		for k,v in pairs(n.Position) do
			n.Position[k]=v+n.Velocity[k] --universal for any amount of dimensions
		end
		n.Life=n.Life-deltaTime
		time=os.clock()
	end
end

lib.New=function()
	local n={} --instance
	
	local particles={}

	n.Render=function()
		for i,p in ipairs(particles) do
			term.setCursorPos(unpack(p.Position))
			if p.Sprite[2]>0 then term.setTextColor(p.Sprite[2]) end
			if p.Sprite[3]>0 then term.setBackgroundColor(p.Sprite[3]) end
			term.write(p.Sprite[1])
		end
	end

	n.Emmit=function(n,fn,...) --number of particles, noise function, masks (particle to derive values from)
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

	n.Frame=function()
		
	end
end