local component = require("druid.component")

---@class typewriter
---@field text_node any
---@field speed number
---@field timer_handle nil
local Typewriter = component.create("typewriter")

function Typewriter:init(text_node, speed)
	self.text_node = text_node
	self.speed = speed or 0.05
	self.timer_handle = nil
	gui.set_text(self.text_node, "")
end

function Typewriter:type_text(full_text, callback)
	self:stop() -- stop any existing typing

	local current_index = 0
	local total_length = #full_text

	self.timer_handle = timer.delay(self.speed, true, function(_, handle)
		current_index = current_index + 1
		if current_index <= total_length then
			gui.set_text(self.text_node, string.sub(full_text, 1, current_index))
		else
			timer.cancel(handle)
			self.timer_handle = nil
			if callaback then callback() end
		end
	end)
end

function Typewriter:stop()
	if self.timer_handle then
		timer.cancel(self.timer_handle)
		self.timer_handle = nil
	end
end

function Typewriter:skip(full_text)
	self:stop()
	gui.set_text(self.text_node, full_text)
end

return Typewriter