return tiny.processingSystem {  -- TODO selection system?
	name = "systems.select_target",
	system_type = "mousepressed",
	filter = tiny.requireAll("garrison", "hitbox"),

	process = function(self, entity, event)
		local x, y, button = unpack(event)

		if mouse.mutex.pressed[button] or not kit.is_mouse_over(entity) then return end
		mouse.mutex.pressed[button] = true

		if self.behaviours[ui.mode] then
			self.behaviours[ui.mode](self, entity, button)
		end
		
		ui.mode = standard.ui_modes.normal
	end,

	behaviours = {
		[standard.ui_modes.normal] = function(_, entity) 
			if entity.owner ~= player then return end

			if keyboard.modifiers.shift then
				ui.sources[entity] = not ui.sources[entity] or nil
			else
				-- if-else instead of single expression for readability
				if fun.iter(ui.sources):length() == 1 and ui.sources[entity] then
					ui.sources = {}
				else
					ui.sources = {[entity] = true}
				end
			end
		end,

		[standard.ui_modes.aggression] = function(_, entity)
			kit.attack(ui.sources, entity)
		end,
	},
}