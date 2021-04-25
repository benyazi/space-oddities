local FoodManager = {}

function FoodManager.addFood(value)
	msg.post('/ShipManager#ShipManagerCtrl', 'FOOD_ADD', {value = value})
end

function FoodManager.recalculateDiff()
	local count = 0
	for _ in pairs(POOMS) do count = count + 1 end
	if count <= 0 then 
		local hasDuplicatorWork = false
		for k, v in pairs(WORK_OBJECTS) do
			if v.isDuplicator and v.workTimer and v.workTimer > 0 then
				hasDuplicatorWork = true
			end
		end
		if hasDuplicatorWork == false then 
			msg.post('/GameManager#GameManager', 'EMPTY_POOMS')
			msg.post('/ShipManager#ShipManagerCtrl', 'FOOD_DIFF', {value = count})
		end
	else
		msg.post('/ShipManager#ShipManagerCtrl', 'FOOD_DIFF', {value = -count})
	end
end

return FoodManager