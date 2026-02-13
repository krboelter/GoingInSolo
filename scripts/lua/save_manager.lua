-- This is how we manage our save files - data get's initialized from the save files here (from main.script)
-- All of the save data used in the app gets managed here

local M = {}

-- initialize 
M.save_data = {
	story_chapter = "intro",
	sequence_key = 1
}

-- used for resetting the game (for testing)
function M.reset()
	M.save_data = {
		story_chapter = "intro",
		sequence_key = 1
	}
end

return M