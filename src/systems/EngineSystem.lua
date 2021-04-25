local utils = require("lib/utils")
local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('isEngine','fuelBag')

function system:process(e, dt)
	if e.fuelBag > 0 then
		e.fuelBag = e.fuelBag - dt
		local perOne = 50/11
		local frame = math.floor(e.fuelBag/perOne) + 1
		-- print('FRAME = '..frame .. ' > ' .. (frame / 11))
		go.set(msg.url(nil, e.objId, 'fuelLevel'), "cursor", (1 - (frame / 11)))
		World:addEntity(e)
	else
		-- EngineManager.stop(e)
		e.fuelBag = nil
		World:addEntity(e)
		msg.post(msg.url(nil, e.objId, 'flame'), 'disable')
		msg.post(msg.url(nil, e.objId, 'sprite'), "play_animation", {id = hash("EngineIdle")})
		msg.post('/GameManager', 'ENGINE_STOP', {engine = e})
	end
end

return system