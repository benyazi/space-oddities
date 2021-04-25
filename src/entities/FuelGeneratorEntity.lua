local FuelGeneratorEntity = {}
FuelGeneratorEntity.__index = FuelGeneratorEntity
FuelGeneratorEntity.type = 'FuelGeneratorEntity'

function FuelGeneratorEntity.new(objId)
	self = {}
	self.objId = objId
	self.isWork = true
	self.isFuelGenerator = true
	return self
end

return FuelGeneratorEntity