return tiny.system {
	name = "systems.debugging",
	system_type = "update",

	update = function(_, entity)
		if launch.trace_mouse then
			log.debug(graphics.camera:toWorld(love.mouse.getPosition()))
		end
	end,
}