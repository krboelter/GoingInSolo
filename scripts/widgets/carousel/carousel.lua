--@type carousel: druid.widget
local M = {}

function M:init(items)
	self.items = items
	self.current_index = 1
	
	self.left_button = self.druid:new_button("left", self.on_left)
	self.label = self:get_node("value_text")
	self.start_pos = gui.get_position(self.label)
	self.right_button = self.druid:new_button("right", self.on_right)

	self:_update_text()
end

function M:on_left()
	print("LEFT")
	self.current_index = self.current_index - 1
	if self.current_index < 1 then
		-- if we get to the first, cycle to the last
		self.current_index = #self.items
	end
	
	self:_animate_slide_out("left", function()
		self:_update_text()
		self:_jump_to_entry_position("left")
		self:_animate_slide_in("left")
	end)
end

function M:on_right()
	print("RIGHT")
	self.current_index = self.current_index + 1
	if self.current_index > #self.items then
		-- if we get to the last, cycle to the fist
		self.current_index = 1
	end

	self:_animate_slide_out("right", function()
		self:_update_text()
		self:_jump_to_entry_position("right")
		self:_animate_slide_in("right")
	end)
end

function M:_update_text()
	gui.set_text(self.label, self.items[self.current_index])
end

function M:_animate_slide_out(direction, on_complete)
	local offset = direction == "right" and 70 or -70
	local target = vmath.vector3(self.start_pos)
	target.x = target.x + offset

	gui.animate(self.label, "position.x", target.x, gui.EASING_INOUTEXPO, 0.2, 0, on_complete)
end

function M:_jump_to_entry_position(direction)
	local offset = direction == "right" and -70 or 70 -- opposite of out
	local pos = vmath.vector3(self.start_pos)
	pos.x = pos.x + offset

	gui.set_position(self.label, pos)
end

function M:_animate_slide_in(direction, on_complete)
	gui.animate(self.label, "position.x", self.start_pos.x, gui.EASING_INOUTEXPO, 0.2)
end

return M