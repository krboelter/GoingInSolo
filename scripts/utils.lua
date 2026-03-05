local M = {}

function M.get_text_size(self, node)
	local font_name = gui.get_font(node)
	local font = gui.get_font_resource(font_name)
	local text = gui.get_text(node)

	local options = {
		width = gui.get_size(node).x,
		line_break = gui.get_line_break(node),
		leading = gui.get_leading(node),
		tracking = gui.get_tracking(node)
	}
	local metrics = resource.get_text_metrics(font, text, options)

	local scale = gui.get_scale(node)
	local rendered_height = metrics.height * scale.y

	return rendered_height
end

return M