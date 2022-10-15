return tiny.processingSystem {
	name = "systems.control",
	system_type = "mousepressed",
	filter = tiny.requireAll("garrison"),

	process = function(self, entity, key)
		if not kit.is_mouse_over(entity) then return end

		self.behaviours[ui.mode](self, entity, key)
	end,

	behaviours = {
		[standard.ui_modes.normal] = function(_, entity) 
			if entity.owner ~= player then return end

			if fun.iter(ui.sources):index(entity) then
				table.remove(ui.sources, fun.iter(ui.sources):index(entity))
			else
				table.insert(ui.sources, entity)
			end
		end,

		[standard.ui_modes.investing] = function(_, entity)
			if entity.owner == player then
				kit.invest(entity)
			end
		end,

		[standard.ui_modes.aggression] = function(_, entity)
			if entity.owner ~= player then
				kit.attack(ui.sources, entity)
			end
		end,
	},
}