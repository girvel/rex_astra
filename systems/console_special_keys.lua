return engine.keySystem("pressed", {
	name = "systems.console_special_keys",

	process_key = function(self, scancode)
		if not launch.debug then return end

		if scancode == "`" then
			ui.console.active = not ui.console.active
			return true
		end

		if not ui.console.active then return end

		if scancode == "return" then
			local success, message = pcall(load(
				(ui.console.command("=") and "" or "return ") 
				.. ui.console.command
			))

			log.info(">", ui.console.command, ">>", message)

			if not success then
				log.debug("console error:", message)
			end

			ui.console.command = ""
			return true

		elseif scancode == "backspace" then
			if #ui.console.command > 0 then
				ui.console.command = ui.console.command:sub(1, -2)
			end
			return true
		end
	end,
})