local MapManager = {}

function MapManager.foo()
	print("Hello World!")
end

function MapManager.Split(s, delimiter)
	result = {}
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end

LEVEL_MAP = {}

local map_width = 11
local map_height = 10

function MapManager.spawnPoom(spawnPosition)
	local objId = factory.create("/GameManager#PoomFactory", spawnPosition)
	msg.post(msg.url(nil, objId, 'sign'), 'disable')
	msg.post(msg.url(nil, objId, 'hasFuelBag'), 'disable')
	local PoomEntity = Entities.PoomEntity.new(objId)
	PoomEntity.name = PoomManager.getName()
	World:addEntity(PoomEntity)
	POOMS[objId] = PoomEntity
end

function MapManager.initShip()
	local map = {
		0      ,0      ,'wt'   ,'wt'  ,'wt'   ,0      ,0      ,0      ,0      ,0      ,0      ,
		0      ,'wl'   ,'b'    ,'b'   ,'b'    ,'wr+wt','wt'   ,'wt'   ,0      ,0      ,0      ,
		0      ,'wl'   ,'b1+en','b1+p','b1'   ,'b1'   ,'b1'   ,'b1+fg','wr'   ,0      ,0      ,
		0      ,0      ,'wb'   ,'wb'  ,'wb+wl','b1+st','wr+wb','wb'   ,0      ,0      ,0      ,
		0      ,0      ,0      ,'wt'  ,'wl+wt','b1+st','wr+wt','wt'   ,'wt'   ,'wt'   ,0      ,
		0      ,0      ,'wl'   ,'b1+en','b1'  ,'b1+st','b1'   ,'b1'   ,'b1'   ,'b1+flg','wr'   ,
		0      ,0      ,0      ,'wb'  ,'wb'   ,'wb+wl','b1+st','wb+wr','wb'   ,'wb'   ,0      ,
		0      ,0      ,0      ,0     ,'wt'   ,'wt+wl','b1+st','wt+wr','wt'   ,0      ,0      ,
		0      ,0      ,0      ,'wl'  ,'b1+en','b1+p' ,'b1+st','b1'   ,'b1+dp','wr'  ,0      ,
		0      ,0      ,0      ,0     ,'wb'   ,'wb'   ,'wb'   ,'wb'   ,'wb'   ,0      ,0      ,
	}
	local mapHeight = map_height
	local mapWidth = map_width
	for inc = 1, mapHeight * mapWidth do
		local key = map[inc]
		local pos = {
			x = 0,
			y = 0
		}
		local l,r = math.modf(inc / mapWidth)
		local i = l + 1
		if r == 0 then 
			i = l
		end
		local j = inc - (i - 1) * mapWidth
		-- print( 'i=' ..i .. ', j=' .. j .. ', key = ' .. key)

		local keys = MapManager.Split(key, '+')

		for k, v in pairs(keys) do
			local z = 0
			if v == 'p' then 
				z = 1
			elseif v == 'fg' or v == 'flg' or v == 'dp' or v == 'en' then 
				z = 0.6
			elseif v == 'st' then 
				z = 0.5
			end
			
			if v == 0 or v == '0' then 
			elseif v == 'p' then 
				local spawnPosition = vmath.vector3(j*16 - 8, -i*16 - 8 - 2, z)
				POOM_START_POSITION[#POOM_START_POSITION+1] = spawnPosition
				MapManager.spawnPoom(spawnPosition)
			elseif v == 'fg' then 
				local objId = factory.create('/Ship#' .. v .. 'Factory', vmath.vector3(j*16 - 8, -i*16 - 8, z))
				local FoodGeneratorEntity = Entities.FoodGeneratorEntity.new(objId)
				World:addEntity(FoodGeneratorEntity)
				WORK_OBJECTS[objId] = FoodGeneratorEntity
			elseif v == 'dp' then 
				local objId = factory.create('/Ship#' .. v .. 'Factory', vmath.vector3(j*16 - 8, -i*16 - 8, z))
				local DpEntity = Entities.DuplicatorEntity.new(objId)
				World:addEntity(DpEntity)
				WORK_OBJECTS[objId] = DpEntity
			elseif v == 'flg' then 
				local objId = factory.create('/Ship#' .. v .. 'Factory', vmath.vector3(j*16 - 8, -i*16 - 8, z))
				local FuelGeneratorEntity = Entities.FuelGeneratorEntity.new(objId)
				World:addEntity(FuelGeneratorEntity)
				WORK_OBJECTS[objId] = FuelGeneratorEntity
			elseif v == 'en' then 
				local objId = factory.create('/Ship#' .. v .. 'Factory', vmath.vector3(j*16 - 8, -i*16 - 8, z))
				local EngineEntity = Entities.EngineEntity.new(objId)
				EngineEntity.fuelBag = ENGINE_START_FUEL
				World:addEntity(EngineEntity)
				WORK_OBJECTS[objId] = EngineEntity
				msg.post('/GameManager', 'ENGINE_START', {engine = EngineEntity})
			else
				factory.create('/Ship#' .. v .. 'Factory', vmath.vector3(j*16 - 8, -i*16 - 8, z))
			end

		end

		if string.find(key, 'b1') then
			LEVEL_MAP[inc] = 2
		else 
			LEVEL_MAP[inc] = 0
		end
	end

	-- pprint(LEVEL_MAP)
	local str = ''
	for i = 1, #LEVEL_MAP do
		local l,r = math.modf(i / map_width)
		if r == 0 then 
			str = str .. LEVEL_MAP[i]  .. ','
			-- print(l .. ' - ' .. str)
			str = ''
		else
			str = str .. LEVEL_MAP[i]  .. ','
		end
	end	
	-- print(str)
	MapManager.setMap()
	FoodManager.recalculateDiff()
end

local direction = astar.DIRECTION_FOUR
local allocate = map_width * map_height
local typical_adjacent = 8
local cache = true
local utils = require("lib/utils")

function MapManager.calculateWay(start_x, start_y, end_x, end_y)
	-- pprint(LEVEL_MAP)
	local result, size, total_cost, path = astar.solve(start_y - 1, start_x - 1, end_y - 1, end_x - 1)
	if result == astar.SOLVED then
		print("SOLVED")
		-- pprint(path)
		local recalculatedPath = {}
		for i, v in ipairs(path) do
			-- print("Tile #" .. i .. ": ", v.y+1 .. "-" .. v.x+1)
			recalculatedPath[i] = {
				x = v.x,
				y = v.y+2
			}
			-- local posX, posY = utils:coords_to_screen(v.x, v.y)
			-- local blockPos = vmath.vector3(posX, posY, 0.75)
			-- local block_id = factory.create("/BlockSpawner#blockFactoryRed", blockPos)
			-- redBLock[#redBLock+1] = block_id
		end
		return recalculatedPath
	elseif result == astar.NO_SOLUTION then
		print("NO_SOLUTION")
	elseif result == astar.START_END_SAME then
		print("START_END_SAME")
	end
	return nil
end

function MapManager.calculateNear(start_x, start_y)

	local near_result, near_size, nears = astar.solve_near(start_y-1, start_x-1, 3.0)

	if near_result == astar.SOLVED then
		print("SOLVED FOR " .. start_x ..'x'.. start_y)
		local recalculatedPath = {}
		for i, v in ipairs(nears) do
			-- print("Tile #" .. i .. ": ", v.x+1 .. "-" .. v.y+1)
			-- recalculatedPath[i] = {
			-- 	x = v.x,
			-- 	y = v.y+2
			-- }
			recalculatedPath[i] = {
				x = v.x+1,
				y = v.y+1
			}
		end
		return recalculatedPath
	elseif near_result == astar.NO_SOLUTION then
		print("NO_SOLUTION")
	elseif near_result == astar.START_END_SAME then
		print("START_END_SAME")
	end
	return nil
end

function MapManager.setMap()
	astar.setup(map_width, map_height, direction, 45, typical_adjacent, cache)
	astar.set_map(LEVEL_MAP)
	local costs = {
		[1] = {
			1,
			1,
			1,
			1
		},
		[2] = {
			1,
			1,
			1,
			1
		}
	}
	astar.set_costs(costs)
end

function MapManager.generateMap()
	
end

return MapManager