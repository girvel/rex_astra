local module = {}
local path_mt = {}
local path_methods = {}
path_mt.__index = path_methods


-- constructor --
setmetatable(module, {
	__call = function(self, path_string)
		return setmetatable({_path_string = path_string}, path_mt)
	end
})


-- operators --
path_mt.__div = function(self, other)
	local other_path_string = type(other) == "table" 
		and other._path_string 
		or tostring(other)

	return module(self._path_string .. "/" .. other_path_string)
end

path_mt.__tostring = function(self)
	return self._path_string
end


-- methods --
path_methods.exists = function(self)
	return love.filesystem.getInfo(self._path_string) ~= nil
end

path_methods.modtime = function(self)
	return love.filesystem.getInfo(self._path_string).modtime
end

path_methods.children = function(self)
	return love.filesystem.getDirectoryItems(self._path_string)
end


-- game directories --
path_methods.load_image_data = function(self)
	return love.image.newImageData(self._path_string)
end

path_methods.load_image = function(self)
	return love.graphics.newImage(self._path_string)
end

path_methods.load_text = function(self)
	local content = love.filesystem.read(self._path_string)
	return content and content:gsub("\r", "")
end


-- global directories --
path_methods.write_text = function(self, text)
	local f = io.open(self._path_string, "wb")
	f:write(text)
	f:close()
end

path_methods.write_image_data = function(self, content)
	self:write_text(content:encode("png", "last.png"):getString())
end


return module