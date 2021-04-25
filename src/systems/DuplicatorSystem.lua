local utils = require("lib/utils")
local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('isDuplicator','workTimer')

function system:process(e, dt)
	if e.workTimer > 0 then
		e.workTimer = e.workTimer - dt
		World:addEntity(e)
	else
		--find nearest points
		local pos = go.get_position(e.objId)
		local i,j = utils:screen_to_coords(pos.x, pos.y)
		print('FIND FOR ' .. -(j+1) .. 'x' .. (i+1))
		local nearestPoints = MapManager.calculateNear(-(j+1), (i+1))
		
		-- pprint(nearestPoints)
		local count = 2
		for k, nearestPoint in pairs(nearestPoints) do
			if -(j+1) ~= nearestPoint.y or (i+1) ~= nearestPoint.x then 
				if count > 0 then
					local objId = factory.create("/GameManager#PoomFactory", vmath.vector3(pos.x, pos.y, pos.z))
					msg.post(msg.url(nil, objId, 'sign'), 'disable')
					msg.post(msg.url(nil, objId, 'hasFuelBag'), 'disable')
					local PoomEntity = Entities.PoomEntity.new(objId)
					
					if count == 1 then 
						PoomEntity.name = e.sourceName
					else
						PoomEntity.name = PoomManager.getName()
					end

					local path = MapManager.calculateWay(-(j+1), (i+1), nearestPoint.y, nearestPoint.x)
					if path then 
						PoomEntity.path = path
					end

					if count > 1 then 
						-- corruption of health
						PoomEntity.generation = e.sourceGeneration + count - 1
						if PoomEntity.generation > 1 then 
							PoomEntity.health.perSec = PoomEntity.health.perSec + 0.5 * PoomEntity.generation
							PoomEntity.health.max = PoomEntity.health.max - 5 * PoomEntity.generation
							if PoomEntity.health.max < 30 then 
								PoomEntity.health.max = 30
							end
						end
					end
					-- 
					World:addEntity(PoomEntity)
					POOMS[objId] = PoomEntity
					count = count - 1
				else
					print('limit')
				end
			end
		end		
		
		e.workTimer = nil
		World:addEntity(e)
		msg.post(msg.url(nil, e.objId, 'sprite'), "play_animation", {id = hash("DuplicatorIdle")})
		FoodManager.recalculateDiff()
	end
end

return system