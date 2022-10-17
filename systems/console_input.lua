return tiny.system {
	name = "systems.console_input",
	system_type = "textinput",

	update = function(self, text)
		if not launch.debug or not ui.console.active then return end

		for key, _ in pairs(keyboard.mutex_lock) do
			if #key == 1 then
				text = text:gsub(key, "")
			end
		end

		ui.console.command = ui.console.command .. text

		text = text:capitalize():swapcase()
		for i in fun.range(#text) do
			keyboard.mutex_lock[text(i)] = true
		end
	end,
}