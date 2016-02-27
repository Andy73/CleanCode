
-- Opening credits for CleanCode

shared = shared or {}

local w, h = term.getSize()
local lastCall

local function _slowWrite( x, y, str, time, reverse )
	local startTime = os.clock()

	x = x - 1

	term.setCursorPos( x, y )

	local colours = { colours.black, colours.grey, colours.lightGrey, colours.white }

	if reverse then
		local _colours = {}
		for i = 1, #colours do
			_colours[ #colours - i + 1 ] = colours[ i ]
		end
		colours = _colours
	end

	for i = 1, #str + #colours do
		for ii = i, 1, -1 do
			term.setCursorPos( x + i - ii, y )
			term.setTextColour( colours[ math.min( ii, #colours ) ] )
			term.write( str:sub( i - ii, i - ii ) )
		end

		local sleepTime = ( time - ( os.clock() - startTime ) ) / ( #str + #colours - i )
		if sleepTime > 0.0 then
			sleep( sleepTime )
		end
	end
end

local function slowWrite( ... )
	lastCall = { ... }
	return _slowWrite( unpack( lastCall ) )
end

local function reverse( newTime )
	if newTime then
		lastCall[ #lastCall ] = newTime
	end

	lastCall[ #lastCall + 1 ] = true
	return _slowWrite( unpack( lastCall ) )
end

term.setBackgroundColour( colours.black )
term.clear()

local f = io.open( "/language.tbl", "r" )
local contents = f:read( "*a" )
f:close()

shared.language = textutils.unserialize( contents )

-- Actual code

local halfWidth, halfHeight = math.floor( w / 2 ), math.floor( h / 2 )
local tokens = shared.language.Tokens[ "opening_credits" ]

-- "AndySoft Presents"
slowWrite( halfWidth - #tokens[ 1 ] / 2, halfHeight, tokens[ 1 ], 1.4 )
sleep( 1.0 )
reverse()

sleep( 1.0 )

-- "In Association with"
slowWrite( halfWidth - #tokens[ 2 ] / 2 - w / 6, halfHeight - 2, tokens[ 2 ], 1.8 )
-- "Herobrine Technologies"
slowWrite( halfWidth - #tokens[ 3 ] / 2 + w / 6, halfHeight - 1, tokens[ 3 ], 1.6 )

sleep( 0.5 )
parallel.waitForAll( function()
	-- Remove "In Association with"
	slowWrite( halfWidth - #tokens[ 2 ] / 2 - w / 6, halfHeight - 2, tokens[ 2 ], 1.0, true )
end, function()
	sleep( 0.45 )
	-- "And Atorture Science"
	slowWrite( halfWidth - #tokens[ 4 ] / 2, halfHeight + 1, tokens[ 4 ], 1.5 )
end )

sleep( 1.0 )

-- Remove "And Atorture Science" and "Herobrine Technologies"
parallel.waitForAll( reverse, function() slowWrite( halfWidth - #tokens[ 3 ] / 2 + w / 6, halfHeight - 1, tokens[ 3 ], 1.5, true ) end )

sleep( 0.2 )

-- "An Open Source Game"
slowWrite( halfWidth - #tokens[ 5 ] / 2, halfHeight, tokens[ 5 ], 2 )
sleep( 1.0 )
reverse()

sleep( 0.5 )

-- "CleanCode"
slowWrite( halfWidth - #tokens[ 6 ] / 2, halfHeight, tokens[ 6 ], 1.0 )
sleep( 1.5 )
reverse()

sleep( 1.5 )
