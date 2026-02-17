local M = {}

-- Creates a new typewriter instance for a given GUI text node
function M.new(text_node, speed)
	local instance = {
		text_node = text_node,
		speed = speed or 0.05,
		timer_handle = nil
	}
	setmetatable(instance, { __index = M })
	return instance
end

function M:stop()
	if self.timer_handle then
		timer.cancel(self.timer_handle)
		self.timer_handle = nil
	end
end

function M:skip(full_text)
	self:stop()
	gui.set_text(self.text_node, full_text)
end

function M:type_text(full_text, callback)
	self:stop()
	gui.set_text(self.text_node, "")
	local current_index = 0
	local total_length = #full_text
	self.timer_handle = timer.delay(self.speed, true, function(_, handle)
		current_index = current_index + 1
		if current_index <= total_length then
			gui.set_text(self.text_node, string.sub(full_text, 1, current_index))
		else
			timer.cancel(handle)
			self.timer_handle = nil
			if callback then callback() end
		end
	end)
end

return M