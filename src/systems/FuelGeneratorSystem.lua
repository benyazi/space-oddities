local utils = require("lib/utils")
local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('isFuelGenerator','workTimer')

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
		local placed = false
		for k, nearestPoint in pairs(nearestPoints) do
			if -(j+1) ~= nearestPoint.y or (i+1) ~= nearestPoint.x and placed == false then 
				local objId = factory.create("/GameManager#FuelBagFactory", vmath.vector3(pos.x, pos.y, pos.z))
				local FuelBagEntity = Entities.FuelBagEntity.new(objId)
				local path = MapManager.calculateWay(-(j+1), (i+1), nearestPoint.y, nearestPoint.x)
				if path then 
					FuelBagEntity.path = path
				end
				World:addEntity(FuelBagEntity)
				WORK_OBJECTS[objId] = FuelBagEntity
				placed = true
			end
		end
		
		FuelManager.addFuel(50)
		e.workTimer = nil
		World:addEntity(e)
		msg.post(msg.url(nil, e.objId, 'sprite'), "play_animation", {id = hash("FuelGeneratorIdle")})
	end
end

return system