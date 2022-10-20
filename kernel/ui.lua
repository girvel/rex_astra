local standard = require "kernel.standard"
local graphics = require "kernel.graphics"


return {
	mode = standard.ui_modes.normal,
	sources = {},
	console = {
		command = "",
		active = false,
	},
	chat = {
		w = graphics.world_size[1] / 4,
		font = standard.fonts.small,
		line_spacing = 1,

		put = function(self, message)
			log.info(
				"Chat:", 
				fun.iter(message)
					:filter(function(x) return type(x) == "string" end)
					:reduce(fun.operator.concat, "")
			)

			return self:_put(message)
		end,

		_put = function(self, message)
			local line = {}
			local w = self.w
			local i = 0

			local color, text
			while true do
				if i == #message then
					table.insert(self, line)
					return
				end

				color = message[i + 1]
				text = message[i + 2]
				local dw = self.font:getWidth(text)

				if dw > w then break end

				table.insert(line, color)
				table.insert(line, text)

				w = w - dw
				i = i + 2
			end

			local j = math.floor(w / self.font:getWidth('w'))
			repeat
				j = j + 1
			until self.font:getWidth(text:sub(1, j + 1)) >= w

			table.insert(line, color)
			table.insert(line, text:sub(1, j))

			table.insert(self, line)

			log.debug("chain(%s, %s)" % {
				inspect {color, text:sub(j + 1, #text)},
				inspect(fun.iter(message):drop_n(i + 2):totable())
			})

			self:_put(kit.concat(
				{color, text:sub(j + 1, #text)},
				fun.iter(message):drop_n(i + 2):totable()
			))
		end,

		message = function(self, message, ...)
			for i, color in ipairs {...} do
				message = message:gsub("#%i" % i, 
					fun.iter(graphics.palette)
						:filter(function(key, value) return value == color end)
						:map(function(key) return key end)
						:head()
				)
			end

			return self:put(self:_message(message))
		end,

		_message = function(self, message, result)
			local result = result or {}
			local a, b = message:find("%a[%a%d]+{")

			if a == nil then
				log.debug {graphics.palette.white, message}
				table.insert(result, graphics.palette.white)
				table.insert(result, message)
				return result
			end

			local first_message = message:sub(1, a - 1)
			local first_color = graphics.palette.white

			local second_color = graphics.palette[message:sub(a, b - 1)]

			local c, d = message:find("}")

			local second_message = message:sub(b + 1, c - 1)

			log.debug {first_color, first_message, second_color, second_message}

			table.insert(result, first_color)
			table.insert(result, first_message)
			table.insert(result, second_color)
			table.insert(result, second_message)

			return self:_message(message:sub(d + 1), result)
		end,
	},
}
