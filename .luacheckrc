max_line_length = false

exclude_files = {
	"lib",
}

ignore = {
	-- Ignore global writes/accesses/mutations on anything prefixed with the add-on name.
	-- This is the standard prefix for all of our global frame names and mixins.
	"11./^StoryTeller",

	-- Ignore unused self. This would popup for Mixins and Objects
	"212/self",

	-- Ignore unused event. This would popup for event handlers
	"212/event",
}

globals = {
	"StoryTeller",

	-- Globals

	-- AddOn Overrides
}

read_globals = {
	-- Libraries
	"LibStub",

	-- 3rd party add-ons
}

std = "lua51+wow"

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
		"tinsert",
		"tremove",
		"tIndexOf",

		-- Global Functions
		"Mixin",
		"hooksecurefunc",
		"GetAddOnMetadata",
		"GetLocale",
		"IsSecureCmd",
		"ScrollingEdit_OnTextChanged",
		"ChatEdit_ParseText",
		"ChatEdit_OnEnterPressed",
		"PlaySound",
		"ScrollingEdit_OnCursorChanged",
		"ScrollingEdit_OnUpdate",
		"GameTooltip_SetTitle",
		"InterfaceOptions_AddCategory",
		"InterfaceOptionsFrame_Show",
		"InterfaceOptionsFrame_OpenToCategory",
		"InCombatLockdown",

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
		SOUNDKIT = {
			fields = {
				"IG_QUEST_LIST_OPEN",
				"IG_QUEST_LIST_CLOSE"
			}
		},
		AddonCompartmentFrame = {
			fields = {
				"RegisterAddon",
				"registeredAddons",
				"UpdateDisplay"
			}
		},
		C_AddOns = {
			fields = {
				"GetAddOnMetadata",
			}
		},

		"ChatFrame1EditBox",

		-- Global Constants
		"TOOLTIP_DEFAULT_COLOR",
		"TOOLTIP_DEFAULT_BACKGROUND_COLOR",
		"LE_EXPANSION_LEVEL_CURRENT",
		"NORMAL_FONT_COLOR",
		"GRAY_FONT_COLOR",
		"SOUNDKIT",
	},
}
