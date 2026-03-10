local M = {}

M.classes = {
	warrior = {
		name = "Warrior",
		hp = 100,
		shield = 0,
		strength = 0,
		crit_chance = 0.0,
		stamina = 0,
		resource_type = "rage",
		special_abilities = {
			taunt = "", -- TODO: should these abilities be in their own data file with values and descriptions?
			intimidate = ""
		},
		movement = 0,
		charisma = 0,
		intelligence = 0,
		description = [[
			As a proud warrior, you will never turn down a fight.
			Bearing the mark of the Ironhowl Guild you are charged with the
			duty to stand in the front lines of battle.
		]]
	},
	dark_mage = {
		name = "Dark Mage",
		hp = 70,
		strength = 0,
		crit_chance = 0.0,
		stamina = 0,
		resource_type = "mana",
		special_abilities = {},
		movement = 0,
		charisma = 0,
		intelligence = 0,
		description = ""
	},
	ranger = {
		name = "Ranger",
		hp = 70,
		strength = 0,
		crit_chance = 0.0,
		stamina = 0,
		resource_type = "arrows",
		special_abilities = {},
		movement = 0,
		charisma = 0,
		intelligence = 0,
		description = ""
	},
	cleric = {
		name = "Cleric",
		hp = 90,
		strength = 0,
		crit_chance = 0.0,
		stamina = 0,
		resource_type = "mana",
		special_abilities = {},
		movement = 0,
		charisma = 0,
		intelligence = 0,
		description = ""
	},
	assassin = {
		name = "Assassin",
		hp = 90,
		strength = 0,
		crit_chance = 0.0,
		stamina = 0,
		resource_type = "shadow",
		special_abilities = {},
		movement = 0,
		charisma = 0,
		intelligence = 0,
		description = ""
	}
}

return M