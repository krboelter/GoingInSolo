-- Questions (or dialog that requires response) should always have the string "question" in the key.
-- The key must have a matching player_dialog[key] with the value as the response.
-- NPC responses may have multiple dialog options. Associate each response key with the player dialog key for matching dialog.
-- If not all responses have an associated dialog, 'response' will be used as the generic NPC response (if applicable).

local story = {}

story.intro = {
	unconscious = "It's dark. Quiet. You slowly regain consciousnes as your eyes blink from fatigue.",
	bound = "Your hands are bound. Your memory, hazy. You are slumped against the wall and you have no recolection of how you ended up here.",
	where = "Where was here?",
	cell = "You quickly look around and the only thing you see is the dark cell surrounding you. A few damp cobblestones glisten from the moonlight shining in from a small window above your head.",
	man = "Your eyes stray from the window, following the moonlight, until your gaze is met by a dark, hooded figure.",
	man_question_1 = "That was some trick you pulled back there.",
	man_response_1 = {
		c = "HA! Petty trickster? That was no petty trick. He says, tilting his head and pointing at you.",
		response = "Well, whatever it was it edded you up in here."
	},
	man_question_2 = "You hear steps approach. The man looks towards the door, then back at you. Are you ready to answer for your crimes?",
	man_response_2 = {
		a = "Murder. He says through his teeth.",
		b = "Your 'tricks' cost the lives of children! He screams.",
		c = "A punishment too sweet for a murderer, I'm affraid.",
		d = "The silence of a murderer is deafening."
	},
	fin = "Immediately 2 large men burst through the door. They pick you up violently, slip a sack over your head, and lead you through a long, dark hallway...",
	sequence_key = {
		"unconscious",
		"bound",
		"where",
		"cell",
		"man",
		"man_question_1",
		"man_response_1",
		"man_question_2",
		"man_response_2",
		"fin"
	}
}

return story