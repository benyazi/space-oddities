local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('isPoom', 'isActive')

function system:process(e, dt)
	if e.updateInfoTime == nil then 
		e.updateInfoTime = 0
	end
	if e.updateInfoTime > 0 then 
		e.updateInfoTime = e.updateInfoTime - dt
		World:addEntity(e)
		return 
	end
	msg.post('/gui_manager#PoomInfo', 'UPDATE_VALUES', {
		type =  'health',
		value = math.floor(e.health.current)
	})
	msg.post('/gui_manager#PoomInfo', 'UPDATE_VALUES', {
		type =  'generation',
		value = e.generation
	})
	msg.post('/gui_manager#PoomInfo', 'UPDATE_NAME', {
		value = e.name
	})
	e.updateInfoTime = 1
	World:addEntity(e)
end

return system