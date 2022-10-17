return tiny.processingSystem {
	name = "systems.hotkeys_target",
	system_type = "mousepressed",
	filter = tiny.requireAll("garrison", "hitbox"),

	process = function(self, entity, key)
		if not kit.is_mouse_over(entity) then return end

		if self.behaviours[ui.mode] then
			self.behaviours[ui.mode](self, entity, key)
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
			if entity.owner ~= player then
				kit.attack(ui.sources, entity)
			end
		end,
	},
}