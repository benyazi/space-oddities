local DuplicatorEntity = {}
DuplicatorEntity.__index = DuplicatorEntity
DuplicatorEntity.type = 'DuplicatorEntity'

function DuplicatorEntity.new(objId)
	self = {}
	self.objId = objId
	self.isWork = true
	self.isDuplicator = true
	return self
end

return DuplicatorEntity