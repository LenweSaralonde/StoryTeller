
StoryTeller = {}

--- Main init
--
function StoryTeller.Init()
	StoryTeller.Print(string.gsub(StoryTeller.Msg.STARTUP, "{version}", StoryTeller.Highlight(GetAddOnMetadata("StoryTeller", "Version"))))

	-- Init settings
	local defaultSettings = {
		minimapPosition = 137,
		mutedPlayers = {}
	}
	if StoryTeller_Settings ~= nil then
		local k, v
		for k,v in pairs(StoryTeller_Settings) do defaultSettings[k] = v end
	end
	StoryTeller_Settings = defaultSettings

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

--- Display a message in the console
-- @param msg (string)
function StoryTeller.Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

--- Display an error message in the console
-- @param msg (string)
function StoryTeller.Error(msg)
	message(msg)
	PlaySoundFile("Sound\\interface\\Error.ogg")
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
