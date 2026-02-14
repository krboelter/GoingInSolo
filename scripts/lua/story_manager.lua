local story = require "scripts.lua.story"
local player_dialog = require "scripts.lua.player_dialog"

local M = {}

M.chapter = nil
M.sequence = nil
M.story_table = {} -- Array<string>
M.state = "running" -- "running" | "paused"
M.player_options = {}

-- MUST GET CALLED EVERY TIME WE USE STORY_MANAGER
function M:set_chapter(chap)	
	self.chapter = story[chap]
end

-- MUST GET CALLED EVERY TIME WE USE STORY_MANAGER
function M:set_sequence(sequence_number)
	if not self.chapter then
		print("Chapter must be set before setting sequence!")
		return
	end
	
	self.sequence = sequence_number
end

function M:fetch_sequence_name(seq_key)
	return self.chapter.sequence_key[seq_key]
end

-- fetches the next story sequence (if running)
-- returns the current story table as text
function M:fetch_next_sequence()
	if not self.chapter or not self.sequence then
		print("Ensure chapter and sequence have been set first!")
		return nil
	end
	
	if self.state == "running" then
		self.sequence = self.sequence + 1
		table.insert(self.story_table, self.chapter[self:fetch_sequence_name(self.sequence)] .. "\n")
	end
	
	if string.find(self.chapter.sequence_key[self.sequence], "question") then
		self.state = "paused"
	end

	return table.concat(self.story_table, "\n")
end

function M:select_player_option(option)
	local player_selection = "(You): " .. player_dialog[self:fetch_sequence_name(self.sequence)][option] .. "\n"
	
	table.insert(self.story_table, player_selection)
	self.state = "running"

	-- reset player options (hide from view)
	self.player_options = {}

	return self:fetch_next_sequence()
end

return M