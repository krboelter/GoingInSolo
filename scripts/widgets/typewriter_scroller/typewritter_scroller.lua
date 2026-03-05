local typewriter = require "scripts.widgets.typewriter"
local utils = require "scripts.utils"

--@type carousel: druid.widget
local M = {}

function M:init()
	self.text_speed = 0.02

	self.container = self:get_node("scroller_container")
	self.content = self:get_node("scroller_content")
	self.scroll = self.druid:new_scroll("scroller_container", "scroller_content")
	self.scroll:set_horizontal_scroll(false)
	self.scroll:set_inert(true)
	self.previous_content_position = vmath.vector3(0, 0, 0)

	self.text_node = self:get_node("scroller_text")
end

function M:set_text_speed(speed)
	self.text_speed = speed
end

-- can be used to reset text with empty string or default text
function M:set_text(text)
	gui.set_text(self.text_node, text)
end

-- used to append new text to the current text
---@param text string
---@param unique_id string - Required for tracking and identifying new text nodes
function M:add_text(text, unique_id)
	if self.current_widget_text then
		self.current_widget_text = ""
	end

	if self.current_widget then
		self.current_widget = nil
	end
	
	local current_content_size = gui.get_size(self.content)

	local nodes = gui.clone_tree(self.text_node)
	local new_text_node = nodes[self._meta.template .. "/scroller_text"]
	gui.set_id(new_text_node, "text_node_" .. unique_id)
	gui.set_parent(new_text_node, self.content, true)

	-- temporarily set text to measure new text height
	gui.set_text(new_text_node, text)
	local new_text_size = utils.get_text_size(self, new_text_node)
	-- remove text after measurements so we can use the typewriter
	gui.set_text(new_text_node, "")

	local buffer = 10 -- distance between this node and NEXT node (gap between text)
	local new_content_height = new_text_size + buffer
	gui.set_enabled(new_text_node, true)
	gui.set_position(new_text_node, self.previous_content_position)

	-- new y for the next text sequence
	local new_y = self.previous_content_position.y - new_content_height
	local new_text_node_position = vmath.vector3(self.previous_content_position.x, new_y, self.previous_content_position.z)
	self.previous_content_position = new_text_node_position

	if -new_text_node_position.y >= current_content_size.y then
		local new_container_height = -new_text_node_position.y + buffer
		gui.set_size(self.content, vmath.vector3(current_content_size.x, new_container_height, 0))
	end

	self.scroll:update_view_size()

	-- handle auto-scroll before new text shows
	timer.delay(0, false, function()
		self:scroll_to_bottom()
	end)

	-- current_widget set here
	self.current_widget = {
		text_node = new_text_node,
		timer_handle = nil
	}
	self.current_widget = typewriter.new(new_text_node, self.text_speed)
	self.current_widget:type_text(text)
	
	-- current_widget_text set here
	self.current_widget_text = text
end

function M:scroll_to_top()
	self.scroll:scroll_to_percent(vmath.vector3(0, 1, 0), true)
end

function M:scroll_to_bottom()
	self.scroll:scroll_to_percent(vmath.vector3(0, 0, 0), true)
end

return M