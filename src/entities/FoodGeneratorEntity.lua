local FoodGeneratorEntity = {}
FoodGeneratorEntity.__index = FoodGeneratorEntity
FoodGeneratorEntity.type = 'FoodGeneratorEntity'

function FoodGeneratorEntity.new(objId)
	self = {}
	self.objId = objId
	self.isWork = true
	self.isFoodGenerator = true
	return self
end

return FoodGeneratorEntity