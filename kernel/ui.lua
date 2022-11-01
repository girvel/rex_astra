local module = {
	modes = types.enumeration {
		"normal",
		"investing",
		"aggression",
		"pause"
	},
	sources = {},
	console = {
		command = "",
		active = false,
	},
	cursor = love.graphics.newImage("sprites/cursor.png"),
	chat = setmetatable({
		font = graphics.fonts.ui_small,
		line_spacing = 2,

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

			self:_put(kit.table.concat(
				{color, text:sub(j + 1, #text)},
				fun.iter(message):drop_n(i + 2):totable()
			))
		end,

		_parse_colors = function(self, message, result)
			local result = result or {}
			local a, b = message:find("[%a_][%a%d_]+{")

			if a == nil then
				table.insert(result, graphics.palette.white)
				table.insert(result, message)
				return result
			end

			local first_message = message:sub(1, a - 1)
			local first_color = graphics.palette.white

			local second_color = graphics.palette[message:sub(a, b - 1)]

			local c, d = message:find("}")

			local second_message = message:sub(b + 1, c - 1)

			table.insert(result, first_color)
			table.insert(result, first_message)
			table.insert(result, second_color)
			table.insert(result, second_message)

			return self:_parse_colors(message:sub(d + 1), result)
		end,
	}, {
		__call = function(self, message, ...)
			-- color the player mentions --
			local color = function(m, pl)
				return m:gsub(pl.name, "%s{%s}" % {
					kit.table.reverse_index(graphics.palette, pl.color), 
					pl.name,
				})
			end

			message = color(message, player)
			for _, ai in pairs(level.ai) do
				message = color(message, ai)
			end

			-- color #<N> --
			for i, color in ipairs {...} do
				message = message:gsub("#%i" % i, 
					fun.iter(graphics.palette)
						:filter(function(key, value) return value == color end)
						:map(function(key) return key end)
						:head()
				)
			end

			-- add timestamp --
			message = clock:format("%Y.%m.%d ") .. message

			return self:put(self:_parse_colors(message))
		end,
	}),
}


module.initialize = function(self)
	self.mode = self.modes.normal
	self.chat.w = graphics.window_size[1] / 4
end


return module