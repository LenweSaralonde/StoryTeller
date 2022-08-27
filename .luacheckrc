max_line_length = false

exclude_files = {
	"lib",
};

ignore = {
	-- Ignore global writes/accesses/mutations on anything prefixed with
	-- "Musician". This is the standard prefix for all of our global frame names
	-- and mixins.
	"11./^StoryTeller",

	-- Ignore unused self. This would popup for Mixins and Objects
	"212/self",

	-- Ignore unused event. This would popup for event handlers
	"212/event",
};

globals = {
	"StoryTeller",

	-- Globals

	-- AddOn Overrides
};

read_globals = {
	-- Libraries
	"LibStub",

	-- 3rd party add-ons
};

std = "lua51+wow";

stds.wow = {
	-- Globals that we mutate.
	globals = {
		"SlashCmdList",
		"SLASH_STORYTELLER1",
		"SLASH_STORYTELLER2",
	},

	-- Globals that we access.
	read_globals = {
		-- Lua function aliases and extensions
		"strlower",
		"strtrim",
		"strsplit",
		"strjoin",
		"min",
		"max",
		"floor",
		"ceil",

		-- Global Functions
		"Mixin",
		"GetAddOnMetadata",
		"GetLocale",
		"IsSecureCmd",
		"ScrollingEdit_OnTextChanged",
		"ChatEdit_ParseText",
		"ChatEdit_OnEnterPressed",

		-- Global Mixins and UI Objects
		DEFAULT_CHAT_FRAME = {
			fields = {
				"AddMessage"
			}
		},
		GameTooltip = {
			fields = {
				"SetOwner",
				"AddLine",
				"Show",
				"Hide",
			}
		},
		"ChatFrame1EditBox",

		-- Global Constants
		"LE_EXPANSION_LEVEL_CURRENT",
		"NORMAL_FONT_COLOR",
	},
};
