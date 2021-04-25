local FuelBagEntity = {}
FuelBagEntity.__index = FuelBagEntity
FuelBagEntity.type = 'FuelBagEntity'

function FuelBagEntity.new(objId)
	self = {}
	self.objId = objId
	self.isWork = true
	self.isFuelBag = true
	self.speed = 0.25
	return self
end

return FuelBagEntity