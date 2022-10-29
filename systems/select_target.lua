return tiny.processingSystem {  -- TODO selection system?
	name = "systems.select_target",
	system_type = "mousepressed",
	ingame = true,
	filter = tiny.requireAll("garrison", "hitbox"),

	process = function(self, entity, event)
		local x, y, button = unpack(event)

		if  devices.mouse.mutex.pressed[button] or 
			not devices.mouse.is_over(entity) 
		then return end
		
		devices.mouse.mutex.pressed[button] = true

		if self.behaviours[ui.mode] then
			self.behaviours[ui.mode](self, entity, button)
		end
		
		ui.mode = ui.modes.normal
	end,

	behaviours = {
		[ui.modes.normal] = function(_, entity, button) 
			if button == 1 then
				if entity.owner ~= player then return end

				if devices.keyboard.modifiers.shift then
					ui.sources[entity] = not ui.sources[entity] or nil
				else
					-- if-else instead of single expression for readability
					if fun.iter(ui.sources):length() == 1 and ui.sources[entity] then
						ui.sources = {}
					else
						ui.sources = {[entity] = true}
					end
				end
			elseif button == 2 then
				kit.orders.attack(ui.sources, entity)
			end
		end,

		[ui.modes.aggression] = function(_, entity)
			kit.orders.attack(ui.sources, entity)
		end,
	},
}