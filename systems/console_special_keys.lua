return tiny.system {
	name = "systems.console_special_keys",
	system_type = "keypressed",

	update = function(self, event)
		local _, scancode = unpack(event)

		if  not launch.debug or 
			devices.keyboard.mutex.pressed[scancode] 
		then return end

		-- mutex = nil if function reaches the end
		devices.keyboard.mutex.pressed[scancode] = true

		if scancode == "`" then
			ui.console.active = not ui.console.active
			return
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
			return
		elseif scancode == "backspace" then
			if #ui.console.command > 0 then
				ui.console.command = ui.console.command:sub(1, -2)
			end
			return
		end

		devices.keyboard.mutex.pressed[scancode] = nil
	end,
}