local M = {}

function M.init(items)
	self.items = items
	self.current_index = 1
	
	self.left_button = self.druid:new_button("left", self.on_left)
	self.label = self:get_node("value_text")
	self.right_button = self.druid:new_button("right", self.on_right)

	self:_update_display()
end

function M:on_left()
	self.current_index = self.current_index - 1
	if self.current_index < 1 then
		-- if we get to the first, cycle to the last
		self.current_index = #self.items
	end
	self._animate("right")
end

function M:on_right()
	self.current_index = self.current_index + 1
	if self.current_index > #self.items then
		self.current_index = 1
	end
	self._animate("left")
end

function M:_update_display()
	gui.set_text(self.label, self.items[self.current_index])
end

function M_animate(direction)
	gui.set() -- TODO: set the material property in the items array, then animate see go.animate
	self._update_display()
end

return M