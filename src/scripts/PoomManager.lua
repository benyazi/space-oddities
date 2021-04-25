local PoomManager = {}

function PoomManager.dead(PoomEntity)
	local pos = go.get_position(PoomEntity.objId)
	PoomManager.delete(PoomEntity)
	local objId = factory.create("/GameManager#PoomDeadFactory", pos)
end

function PoomManager.delete(PoomEntity)
	if ACTIVE_POOM == PoomEntity then 
		ACTIVE_POOM = nil
		msg.post(msg.url(nil, PoomEntity.objId, 'sign'), 'disable')
	end
	msg.post(msg.url(nil, PoomEntity.objId, 'sprite'), 'disable')
	POOMS[PoomEntity.objId] = nil
	World:removeEntity(PoomEntity)
	go.delete( PoomEntity.objId)
	FoodManager.recalculateDiff()
end

function PoomManager.make()

	
end

function PoomManager.setActive(PoomEntity, status)
	if status == true then 
		msg.post('/gui_manager#PoomInfo', 'SHOW_NODES')
		PoomEntity.isActive = true
		World:addEntity(PoomEntity)
	end
end

local lastUsedName = 1
function PoomManager.loadNames()
	local jsonstring = sys.load_resource("/jsonData/nameList.json")
	nameList = json.decode(jsonstring)
	-- pprint(nameList)
end

function PoomManager.getName()
	lastUsedName = lastUsedName+1
	return nameList[lastUsedName]
end

local nameList = {}
return PoomManager