-- This file is for player responses to questions. It should give each option for an associated key from story.lua.

local player_dialog = {}

player_dialog.intro = {
	man_question_1 = {
		a = "What are you talking about?",
		b = "You think that was a trick?",
		c = "Do you always throw petty 'tricksters' in a cell?",
		d = "[no response]"
	},
	man_question_2 = {
		a = "What crimes am I to have committed?",
		b = "Crimes? I mearly played a few 'tricks' and you accuse me of crimes?",
		c = "I'd rather waste away in this cell.",
		d = "[no response]... You turn your head towards the floor."
	}
}

return player_dialog