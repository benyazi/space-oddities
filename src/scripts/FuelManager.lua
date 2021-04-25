local FuelManager = {}

function FuelManager.addFuel(value)
	-- msg.post('/ShipManager#ShipManagerCtrl', 'FUEL_ADD', {value = value})
end

function FuelManager.recalculateDiff()
	
end

function FuelManager.recalculateSpeed()
	local count = 0
	for k, v in pairs(WORK_OBJECTS) do
		if v.isEngine and v.fuelBag and v.fuelBag > 0 then 
			count = count + 1
		end
	end
	msg.post('/ShipManager#ShipManagerCtrl', 'UPDATE_SPEED', {value = count})
end

function FuelManager.addFuelToEngine(eng, value)
	if eng.fuelBag == nil then
		msg.post(msg.url(nil, eng.objId, 'flame'), 'enable')
		msg.post(msg.url(nil, eng.objId, 'sprite'), "play_animation", {id = hash("EngineWork")})
		eng.fuelBag = 0
		msg.post('/GameManager', 'ENGINE_START', {engine = eng})
	end
	eng.fuelBag = eng.fuelBag + value
	if eng.fuelBag > eng.maxFuel then 
		eng.fuelBag = eng.maxFuel
	end
	World:addEntity(eng)
	msg.post('/ShipManager#ShipManagerCtrl', 'FUEL_ADD', {value = value})
end

return FuelManager