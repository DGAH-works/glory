--[[
	太阳神三国杀游戏工具扩展包·战功荣耀（声明部分）
	适用版本：V2 - 愚人版（版本号：20150401）清明补丁（版本号：20150405）
]]--
MiddleClass = require "middleclass"
--[[****************************************************************
	字符串处理工具
]]--****************************************************************
function string:ltrim()
	return string.match(self, "%s*(.*)")
end
function string:rtrim()
	return string.match(self, "(.*%S)%s*")
end
function string:trim()
	return string.match(self, "%s*(.*%S)%s*")
end
--[[****************************************************************
	数据行类型
]]--****************************************************************
GLine = MiddleClass.class("GLine")
function GLine:initialize(line)
	local text = line:trim()
	self.type = "blank"
	self.text = text
	self.key = ""
	self.value = ""
	if text ~= "" then
		local start = string.sub(text, 1, 1)
		if start == ";" then
			self.type = "note"
		elseif start == "[" then
			self.type = "section"
			text = string.match(text, "%[(.*)%]")
			if text == "" then
				self.type = "blank"
			else
				self.text = text
			end
		else
			self.type = "data"
			local msg = text:split("=")
			self.key = msg[1]:rtrim()
			self.value = msg[2]:ltrim()
		end
	end
end
function GLine:setValue(value)
	self.value = value
	self.modified = true
end
function GLine:tostring()
	if self.type == "data" and self.modified then
		return self.key .. " = " .. self.value
	elseif self.type == "section" then
		return "[" .. self.text .. "]"
	end
	return self.text
end
--[[****************************************************************
	数据文件类型
]]--****************************************************************
GFile = MiddleClass.class("GFile")
function GFile:initialize()
	self.lines = {}
end
function GFile:addLine(line)
	local new_line = GLine(line)
	table.insert(self.lines, new_line)
	return new_line
end
function GFile:nextLine()
	if #self.lines > 0 then
		local line = self.lines[1]
		table.remove(self.lines, 1)
		return line
	end
end