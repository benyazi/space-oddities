local utils = require("lib/utils")
local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('path','objId', 'speed')

function system:process(e, dt)
	if e.stepTimer == nil then 
		e.stepTimer = 0	
	end
	if e.stepDelayTimer == nil then 
		e.stepDelayTimer = 0	
	end
	
	if e.stepTimer <= 0 then
		if e.pathIndex == nil then
			e.pathIndex = 1
		end 
		e.pathIndex = e.pathIndex + 1
		if e.path[e.pathIndex] == nil then 
			e.path = nil
			e.pathIndex = nil
			World:addEntity(e)
			print("End of moving")
			return
		end
		local speed = e.speed
		if e.hasFuelBag then 
			speed = speed*2
		end
		e.stepTimer = speed --0.25
		local playerPosition = go.get(e.objId, 'position')
		
		-- local posX, posY = playerPosition.x - 8, playerPosition.y
		local posX, posY = utils:coords_to_screen(e.path[e.pathIndex].x, e.path[e.pathIndex].y)
		if e.isPoom then 
			posY = posY - 2
		end
		go.animate(e.objId, "position.x", go.PLAYBACK_ONCE_FORWARD, posX, go.EASING_INOUTCUBIC, speed)
		go.animate(e.objId, "position.y", go.PLAYBACK_ONCE_FORWARD, posY + 4, go.EASING_INCUBIC, speed/2)
		go.animate(e.objId, "position.y", go.PLAYBACK_ONCE_FORWARD, posY, go.EASING_INOUTCUBIC, speed/2, speed/2)
		World:addEntity(e)
	else
		e.stepTimer = e.stepTimer - dt 
		World:addEntity(e)
	end
end

return system