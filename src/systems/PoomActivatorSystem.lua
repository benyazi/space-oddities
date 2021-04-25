local system = Tiny.processingSystem()

system.filter = Tiny.requireAll('unactiveTimer')

function system:process(e, dt)
	if e.unactiveTimer > 0 then
		e.unactiveTimer = e.unactiveTimer - dt
		World:addEntity(e)
	else
		e.unactiveTimer = nil
		World:addEntity(e)
	end
end

return system