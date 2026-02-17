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

	local _, sequence_data = next(self.chapter.data[self.sequence])
	if string.find(sequence_data, "question") then
		set_state("paused")
	end

	return text
end

function M:fetch_npc_response(option)
	self.sequence = self.sequence + 1 -- move to the response
	local response_options = self.chapter.data[self.sequence]

	local text = {}

	-- TODO: fix
	if response_options[option] then
		text = response_options[option]
	else
		text = response_options["response"]
	end
	
	return text
end

-- fetches the player options table
function M:fetch_player_options()
	return player_dialog[self.chapter.name][self.sequence]
end

-- @param option string "a", "b", ..."z"
function M:select_player_option(option)
	local player_selection = "(You): " .. player_dialog[self.chapter.name][self.sequence][option]
	
	local text = player_selection .. "\n"
	set_state("running")

	-- TODO: fix this - might need to have these be 2 separate operations...
	return self:fetch_npc_response(option)
end

return M