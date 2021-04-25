local EngineEntity = {}
EngineEntity.__index = EngineEntity
EngineEntity.type = 'EngineEntity'

function EngineEntity.new(objId)
	self = {}
	self.objId = objId
	self.isWork = true
	self.isEngine = true
	self.maxFuel = 50
	return self
end

return EngineEntity