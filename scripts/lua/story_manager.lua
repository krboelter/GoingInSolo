local story = require "scripts.lua.story"
local player_dialog = require "scripts.lua.player_dialog"

local M = {}

M.chapter = nil -- string
M.sequence = nil -- number
M.story_table = {} -- Array<string>
M.state = "running" -- "running" | "paused"
M.on_state_changed = nil -- callback

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
		table.insert(self.story_table, self.chapter.data[self:fetch_sequence_name(self.sequence)] .. "\n")
	end
	
	if string.find(self.chapter.sequence_key[self.sequence], "question") then
		set_state("paused")
	end

	return table.concat(self.story_table, "\n")
end

function M:fetch_npc_response(option)
	self.sequence = self.sequence + 1 -- move to the response
	local response_options = self.chapter.data[self:fetch_sequence_name(self.sequence)]

	if response_options[option] then
		table.insert(self.story_table, response_options[option] .. "\n")
	else
		table.insert(self.story_table, response_options["response"] .. "\n")
	end
	
	return table.concat(self.story_table, "\n")
end

-- fetches the player options table
function M:fetch_player_options()
	return player_dialog[self.chapter.name][self:fetch_sequence_name(self.sequence)]
end

-- @param option string "a", "b", ..."z"
function M:select_player_option(option)
	local player_selection = "(You): " .. player_dialog[self.chapter.name][self:fetch_sequence_name(self.sequence)][option]
	
	table.insert(self.story_table, player_selection)
	set_state("running")

	return self:fetch_npc_response(option)
end

return M