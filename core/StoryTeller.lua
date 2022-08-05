
StoryTeller = {}

StoryTeller.Locale = {}

--- Main init
--
function StoryTeller.Init()
	StoryTeller.Print(string.gsub(StoryTeller.Msg.STARTUP, "{version}", StoryTeller.Highlight(GetAddOnMetadata("StoryTeller", "Version"))))

	-- Init settings
	local defaultSettings = {
	}
	StoryTeller_Settings = Mixin(defaultSettings, StoryTeller_Settings or {})

	-- Remove obsolete settings
	StoryTeller_Settings.mutedPlayers = nil
	StoryTeller_Settings.minimapPosition = nil
	StoryTeller_Settings.minimap = nil

	-- Init character settings
	local defaultCharacterSettings = {
		minimap = {
			minimapPos =
				LE_EXPANSION_LEVEL_CURRENT == 0 and 160 or -- Classic Era
				LE_EXPANSION_LEVEL_CURRENT == 1 and 180 or -- BC
				LE_EXPANSION_LEVEL_CURRENT == 2 and 131 or -- WotLK
				137, -- Retail
			hide = false
		},
	}
	StoryTeller_CharacterSettings = Mixin(defaultCharacterSettings, StoryTeller_CharacterSettings or {})

	-- /storyteller command
	SlashCmdList["STORYTELLER"] = function(cmd)

		cmd = strlower(strtrim(cmd))

		if cmd == "show" or cmd == "" then
			StoryTellerFrame:Show()
			StoryTellerFrameText:SetFocus()
		end
	end

	SLASH_STORYTELLER1 = "/storyteller"
	SLASH_STORYTELLER2 = "/story"

	StoryTeller.text = {}
	StoryTeller.textCursor = nil

end

--- Initialize a locale and returns the initialized message table
-- @param languageCode (string) Short language code (ie 'en')
-- @param languageName (string) Locale name (ie "English")
-- @param localeCode (string) Long locale code (ie 'enUS')
-- @param[opt] ... (string) Additional locale codes
-- @return msg (table) Initialized message table
function StoryTeller.InitLocale(languageCode, languageName, localeCode, ...)
	local localeCodes = { localeCode, ... }

	-- Set English (en) as base locale
	local baseLocale = languageCode == 'en' and StoryTeller.LocaleBase or StoryTeller.Locale.en

	-- Init table
	local msg = Mixin({}, baseLocale)
	StoryTeller.Locale[languageCode] = msg
	msg.LOCALE_NAME = languageName
	msg.LOCALE_CODES = localeCodes

	-- Set English (en) as the current language by default
	if languageCode == 'en' then
		StoryTeller.Msg = msg
	else
		-- Set localized messages
		for _, locale in pairs(localeCodes) do
			if GetLocale() == locale then
				StoryTeller.Msg = msg
				break
			end
		end
	end

	return msg
end

--- Display a message in the console
-- @param msg (string)
function StoryTeller.Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

--- Highlight text
-- @param text (string)
-- @param color (string)
-- @return (string)
function StoryTeller.Highlight(text, color)
	if color == nil then
		color = 'FFFFFF'
	end
	return "|cFF" .. color .. text .. "|r"
end

--- Format text, adding highlights etc.
-- @param text (string)
-- @return (string)
function StoryTeller.FormatText(text)

	-- Highlight **text**
	local search = "%*%*[^%*]+%*%*"
	while string.find(text, search) do
		local from, to = string.find(text, search)
		text = string.sub(text, 1, from - 1) ..StoryTeller.Highlight(string.sub(text, from + 2, to - 2)) .. string.sub(text, to + 1)
	end

	return text
end

--- Constraints the button text size
-- @param button (Button)
function StoryTeller.SetButtonTextSize(button)
	local fontString = button:GetFontString()
	fontString:SetWidth(button:GetWidth() - 10)
	if fontString:IsTruncated() and button.tooltipText == nil then
		button.tooltipText = fontString:GetText()
	end
end
