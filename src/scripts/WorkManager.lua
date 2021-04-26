local WorkManager = {}

local utils = require("lib/utils")

function WorkManager.activate(WorkEntity, PoomEntity)
	local pos = go.get_position(WorkEntity.objId)
	local i,j = utils:screen_to_coords(pos.x, pos.y)
	print(''..(i+1)..'x' ..(j+1))
	local Poom = PoomEntity
	local PoomPos = go.get_position(Poom.objId)
	local pi,pj = utils:screen_to_coords(PoomPos.x, PoomPos.y)
	Poom.path = MapManager.calculateWay(-(pj+1), (pi+1), -(j+1), (i+1))
	World:addEntity(Poom)
end

function WorkManager.activateByGo(WorkGoId, PoomGoId)
	-- pprint(WorkGoId)
	-- pprint(WORK_OBJECTS)
	if WORK_OBJECTS[WorkGoId] then 
		local WorkEntity = WORK_OBJECTS[WorkGoId]
		local PoomEntity = POOMS[PoomGoId]
		if WorkEntity.isDuplicator ~= nil and WorkEntity.workTimer == nil and PoomEntity.unactiveTimer == nil then 
			WorkEntity.workTimer = 5
			WorkEntity.sourceGeneration = PoomEntity.generation
			WorkEntity.sourceName = PoomEntity.name
			WorkEntity.health = PoomEntity.health
			World:addEntity(WorkEntity)
			msg.post(msg.url(nil, WorkGoId, 'sprite'), "play_animation", {id = hash("DuplicatorWork")})
			-- remove PoomPoomGoId
			PoomManager.delete(PoomEntity)
		end
		if WorkEntity.isFuelGenerator ~= nil and WorkEntity.workTimer == nil and PoomEntity.unactiveTimer == nil then 
			WorkEntity.workTimer = 3
			World:addEntity(WorkEntity)
			msg.post(msg.url(nil, WorkGoId, 'sprite'), "play_animation", {id = hash("FuelGeneratorWork")})
			-- remove PoomPoomGoId
			PoomManager.delete(PoomEntity)
		end
		if WorkEntity.isFoodGenerator ~= nil and WorkEntity.workTimer == nil and PoomEntity.unactiveTimer == nil then 
			WorkEntity.workTimer = 3
			World:addEntity(WorkEntity)
			msg.post(msg.url(nil, WorkGoId, 'sprite'), "play_animation", {id = hash("FoodGeneratorWork")})
			
			-- remove PoomPoomGoId
			PoomManager.delete(PoomEntity)
			-- if ACTIVE_POOM == PoomEntity then 
			-- 	ACTIVE_POOM = nil
			-- 	msg.post(msg.url(nil, PoomGoId, 'sign'), 'disable')
			-- end
			-- msg.post(msg.url(nil, PoomGoId, 'sprite'), 'disable')
			-- POOMS[PoomGoId] = nil
			-- World:removeEntity(PoomEntity)
			-- go.delete(PoomGoId)
			-- FoodManager.recalculateDiff()
		end
		if WorkEntity.isFuelBag ~= nil and PoomEntity.unactiveTimer == nil then 
			if WorkEntity.fuelCount then
				PoomEntity.hasFuelBag = WorkEntity.fuelCount
			else
				PoomEntity.hasFuelBag = 50
			end

			msg.post(msg.url(nil, PoomGoId, 'hasFuelBag'), 'enable')
			msg.post(msg.url(nil, WorkGoId, 'sprite'), 'disable')
			WORK_OBJECTS[WorkGoId] = nil
			World:removeEntity(WorkEntity)
			go.delete(WorkGoId)
		end
		if WorkEntity.isEngine ~= nil and PoomEntity.unactiveTimer == nil and PoomEntity.hasFuelBag ~= nil then 
			msg.post(msg.url(nil, PoomGoId, 'hasFuelBag'), 'disable')
			FuelManager.addFuelToEngine(WorkEntity, PoomEntity.hasFuelBag)
			PoomEntity.hasFuelBag = nil
			PoomEntity.speed = PoomEntity.speed - 0.05
			if PoomEntity.speed < 0.2 then 
				PoomEntity.speed = 0.2
			end
			World:addEntity(PoomEntity)
		end
	end	
	
	-- local pos = go.get_position(WorkEntity.objId)
	-- local i,j = utils:screen_to_coords(pos.x, pos.y)
	-- print(''..(i+1)..'x' ..(j+1))
	-- local Poom = PoomEntity
	-- local PoomPos = go.get_position(Poom.objId)
	-- local pi,pj = utils:screen_to_coords(PoomPos.x, PoomPos.y)
	-- Poom.path = MapManager.calculateWay(-(pj+1), (pi+1), -(j+1), (i+1))
	-- World:addEntity(Poom)
end

function WorkManager.activate(WorkEntity, PoomEntity)
	local pos = go.get_position(WorkEntity.objId)
	local i,j = utils:screen_to_coords(pos.x, pos.y)
	print(''..(i+1)..'x' ..(j+1))
	local Poom = PoomEntity
	local PoomPos = go.get_position(Poom.objId)
	local pi,pj = utils:screen_to_coords(PoomPos.x, PoomPos.y)
	Poom.path = MapManager.calculateWay(-(pj+1), (pi+1), -(j+1), (i+1))
	World:addEntity(Poom)
end

function WorkManager.makePoomActive(PoomEntity)
	if ACTIVE_POOM then 
		msg.post(msg.url(nil, ACTIVE_POOM.objId, 'sign'), 'disable')
		ACTIVE_POOM.isActive = nil 
		ACTIVE_POOM.updateInfoTime = nil 
		World:addEntity(ACTIVE_POOM)
	end
	msg.post(msg.url(nil, PoomEntity.objId, 'sign'), 'enable')
	ACTIVE_POOM = PoomEntity
	ACTIVE_POOM.isActive = true 
	ACTIVE_POOM.updateInfoTime = nil 
	World:addEntity(ACTIVE_POOM)
	msg.post('/gui_manager#PoomInfo', 'SHOW_NODES')
end

function WorkManager.movePoom(wPos, PoomEntity)
	local i,j = utils:screen_to_coords(wPos.x, wPos.y)
	print(''..(i+1)..'x' ..(j+1))
	local Poom = PoomEntity
	local PoomPos = go.get_position(Poom.objId)
	local pi,pj = utils:screen_to_coords(PoomPos.x, PoomPos.y)
	Poom.path = MapManager.calculateWay(-(pj+1), (pi+1), -(j+1), (i+1))
	World:addEntity(Poom)
end

return WorkManager