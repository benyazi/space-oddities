local PoomEntity = {}
PoomEntity.__index = PoomEntity
PoomEntity.type = 'PoomEntity'

function PoomEntity.new(objId)
	self = {}
	self.objId = objId
	self.name = ''
	self.isPoom = true
	self.psychoLevel = {
		current = 100,
		max = 100
	}
	self.needFood = true
	self.health = {
		current = 100,
		max = 100,
		perSec = 5
	}
	self.generation = 1
	self.unactiveTimer = 1
	self.speed = 0.5
	self.corructionOfGen = 0
	-- self.isKwaMoving = true
	return self
end

return PoomEntity