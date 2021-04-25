local utils = require("lib/utils")
local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('health', 'needFood')

function system:process(e, dt)
	if SHIP_RESOURCES.food > 0 and e.health.current < e.health.max then 
		e.health.current = e.health.current + e.health.perSec/2 * dt
		World:addEntity(e)
		return
	elseif SHIP_RESOURCES.food > 0 then
		return
	end

	e.health.current = e.health.current - e.health.perSec * dt

	if e.health.current <= 0 then 
		e.needFood = nil
		World:addEntity(e)
		PoomManager.dead(e)
	else
		World:addEntity(e)
	end
end

return system