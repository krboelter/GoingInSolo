local story = require "scripts.lua.story"
local player_dialog = require "scripts.lua.player_dialog"

local M = {}

M.chapter = nil -- string
M.sequence = nil -- number
M.state = "running" -- "running" | "paused"
M.on_state_changed = nil -- callback
M.last_player_response = nil -- "a", "b", "c" ... "z"

-- @private when state changes - runs the callback given to on_state_changed
-- @param new_state string "running" | "paused"
local function set_state(new_state)
	if M.state ~= new_state then
		M.state = new_state
		
		if M.on_state_changed then
			M.on_state_changed(new_state)
		end
	end
end

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

function M:fetch_sequence_name(seq_num)
	local name, _ = next(self.chapter.data[seq_num])
	return name
end

-- fetches the next story sequence (if running)
-- returns the current story table as text
function M:fetch_next_sequence()
	if not self.chapter or not self.sequence then
		print("Ensure chapter and sequence have been set first!")
		return nil
	end

	local text = nil
	
	if self.state == "running" then
		self.sequence = self.sequence + 1
		text = self.chapter.data[self.sequence]
	end

	local sequence_key, _ = next(self.chapter.data[self.sequence])
	if string.find(sequence_key, "question") then
		set_state("paused")
	end

	return text
end

function M:fetch_npc_response()
	local selection = self.chapter.data[self.sequence][self:fetch_sequence_name(self.sequence)][self.last_player_response]
	local unique_response_key = self:fetch_sequence_name(self.sequence) .. "_" .. self.last_player_response

	if selection then
		return { [unique_response_key] = selection }
	end
	return { [unique_response_key] = self.chapter.data[self.sequence][self:fetch_sequence_name(self.sequence)]["response"] }
end

-- fetches the player options table
function M:fetch_player_options()
	return player_dialog[self.chapter.name][self:fetch_sequence_name(self.sequence)]
end

function M:select_player_option(index)
	local letter, response_text = next(player_dialog[self.chapter.name][self:fetch_sequence_name(self.sequence)][index])
	local player_selection_text = "(You): " .. response_text

	self.last_player_response = letter
	self.sequence = self.sequence + 1

	set_state("running")

	local unique_response_key = self:fetch_sequence_name(self.sequence) .. "_" .. letter
	return { [unique_response_key] = player_selection_text }
end

return M