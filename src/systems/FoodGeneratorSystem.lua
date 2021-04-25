local utils = require("lib/utils")
local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('isFoodGenerator','workTimer')

function system:process(e, dt)
	if e.workTimer > 0 then
		e.workTimer = e.workTimer - dt
		World:addEntity(e)
	else
		FoodManager.addFood(50)
		e.workTimer = nil
		World:addEntity(e)
		msg.post(msg.url(nil, e.objId, 'sprite'), "play_animation", {id = hash("FoodGeneratorIdle")})
	end
end

return system