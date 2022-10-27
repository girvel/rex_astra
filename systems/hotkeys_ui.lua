return engine.keySystem("pressed", {
	name = "systems.hotkeys_ui",

	process_key = function(self, scancode)
		if scancode == "h" and devices.keyboard.modifiers.shift then
			-- TODO global narrator?
			local content = kit.read_text("lines/ui_help.txt")
			for _, line in ipairs(content / "\n\n") do
				ui.chat(line)
			end
		end
	end
})