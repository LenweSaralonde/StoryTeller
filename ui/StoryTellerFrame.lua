StoryTeller.Frame = {}

--- Main frame init
--
function StoryTeller.Frame.Init()
	StoryTellerFrame:DisableEscape()

	-- Main frame title
	StoryTellerFrameTitle:SetText(StoryTeller.Msg.TELL_A_STORY)

	-- Clear button
	StoryTellerFrameClearButton:SetText(StoryTeller.Msg.CLEAR)
	StoryTellerFrameClearButton:HookScript("OnClick", StoryTeller.Frame.Clear)
	StoryTeller.SetButtonTextSize(StoryTellerFrameClearButton)

	-- Edit button
	StoryTellerFrameEditButton:SetText(StoryTeller.Msg.EDIT)
	StoryTeller.SetButtonTextSize(StoryTellerFrameEditButton)
	StoryTellerFrameEditButton:HookScript("OnClick", StoryTeller.Frame.Edit)

	-- Previous button
	StoryTellerFramePrevButton:SetText(StoryTeller.Msg.PREV)
	StoryTeller.SetButtonTextSize(StoryTellerFramePrevButton)
	StoryTellerFramePrevButton:HookScript("OnClick", StoryTeller.Frame.Prev)

	-- Next button
	StoryTellerFrameNextButton:SetText(StoryTeller.Msg.NEXT)
	StoryTeller.SetButtonTextSize(StoryTellerFrameNextButton)
	StoryTellerFrameNextButton:HookScript("OnClick", StoryTeller.Frame.Next)

	-- Read button
	StoryTellerFrameReadButton:SetText(StoryTeller.Msg.READ)
	StoryTeller.SetButtonTextSize(StoryTellerFrameReadButton)
	StoryTellerFrameReadButton:HookScript("OnClick", StoryTeller.Frame.Read)

	-- Frame text
	ScrollingEdit_OnCursorChanged(StoryTellerFrameText, 0, 0, 0, 0)
	StoryTellerFrameText:SetText(StoryTeller.Msg.PASTE_TEXT)
	-- Create text highlight texture (workaround to text select bug introduced in WoW 8.2)
	StoryTellerFrameText.highlightTexture = StoryTellerFrameText:CreateTexture(nil, "BACKGROUND")
	StoryTellerFrameText.highlightTexture:SetColorTexture(1, 1, 1, .25)
	StoryTellerFrameText.highlightTexture:SetPoint("LEFT")
	StoryTellerFrameText.highlightTexture:SetPoint("RIGHT")
	StoryTellerFrameText:SetScript("OnTextChanged", StoryTeller.Frame.TextChanged)
	StoryTellerFrameText:SetScript("OnEditFocusGained", function()
		StoryTellerFrameText:HighlightText(0)
	end)
	StoryTellerFrameText:SetScript("OnCursorChanged", ScrollingEdit_OnCursorChanged)
	StoryTellerFrameText:SetScript("OnUpdate", function(self, elapsed)
		ScrollingEdit_OnUpdate(self, elapsed, self:GetParent())
	end)
	StoryTellerFrameText:SetScript("OnEscapePressed", function()
		StoryTellerFrameText:ClearFocus()
		StoryTellerFrameText:ClearHighlightText()
	end)

	-- Scroll frame
	StoryTellerFrameScrollFrame:SetScript("OnMouseUp", function()
		if not StoryTellerFrameText:HasFocus() then
			StoryTellerFrameText:SetFocus()
			StoryTellerFrameText:HighlightText(0)
		end
	end)

	-- Register events
	StoryTellerFrame:RegisterEvent("PLAYER_LOGIN")
	StoryTellerFrame:SetScript("OnUpdate", StoryTeller.Frame.OnUpdate)
	StoryTellerFrame:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			StoryTellerFrame:UnregisterEvent("PLAYER_LOGIN")
			StoryTeller.Init()
			StoryTellerButton.Init()
			StoryTeller.Frame.Clear()
		end
	end)
	StoryTeller.Frame.StopAnimation()
end

--- Highlight the current line in the edit box
-- @param smooth (number) Smooth scroll duration
--
function StoryTeller.Frame.HighlightCurrentLine(smooth)
	local lineCount = #StoryTeller.text
	if lineCount > 0 and StoryTeller.text[StoryTeller.textCursor] ~= nil then
		local line = StoryTeller.text[StoryTeller.textCursor]
		StoryTellerFrameText:HighlightText(0, 0)

		-- Adjust scrolling
		local boxWidth = StoryTellerFrameText:GetWidth()
		local _, fontHeight = StoryTeller.Frame.GetTextLineSize('0', boxWidth)
		local scrollRange = StoryTellerFrameScrollFrame:GetVerticalScrollRange()
		local scrollHeight = StoryTellerFrameScrollFrame:GetHeight()
		local lineY = line[4] * fontHeight
		local lineHeight = line[5] * fontHeight
		local scrollCenter = 1 / 3

		local scrollTo = lineY - scrollHeight * scrollCenter + lineHeight / 2
		StoryTeller.Frame.ScrollTo(min(scrollRange, max(0, min(lineY, scrollTo))), smooth)

		-- Highlight current line
		StoryTellerFrameText.highlightTexture:Show()
		StoryTellerFrameText.highlightTexture:SetPoint("TOP", 0, -lineY)
		StoryTellerFrameText.highlightTexture:SetHeight(lineHeight)

		StoryTellerFrameText:ClearFocus()
	elseif lineCount == 0 then
		StoryTellerFrameText:HighlightText(0)
		StoryTellerFrameText:SetFocus()
	else
		StoryTellerFrameText:HighlightText(0, 0)
		StoryTellerFrameText:ClearFocus()
	end
end

--- Split text in parts of max 255 characters long
-- @param text (string)
-- @param level (int)
-- @return (string)
local function splitText(text, level)

	if string.len(text) <= 255 then
		return text
	end

	if not level then
		level = 0
	end

	local separator
	if level == 0 then
		separator = "\n"
	elseif level == 1 then
		separator = "%.%!%?"
	elseif level == 2 then
		separator = "%;%:"
	elseif level == 3 then
		separator = "%,"
	elseif level == 4 then
		separator = " "
	end

	local function wrapLine(line)
		return string.gsub(line, "[\n]$", "") .. "\n"
	end

	local splittedParts = ""
	local splittedPart = ""

	local cursor = 1
	local chunk

	while cursor <= string.len(text) do
		local regexp = "[^" .. separator .. "]*[" .. separator .. "]"

		if level ~= 0 then
			regexp = regexp .. "+[\n]?"
		end

		local from, to = string.find(text, regexp, cursor)

		if from ~= nil then
			chunk = string.sub(text, from, to)
			cursor = to + 1
		else
			chunk = string.sub(text, cursor)
			cursor = string.len(text) + 1
		end

		if string.len(splittedPart) + string.len(chunk) <= 255 then
			splittedPart = splittedPart .. chunk
		else
			if splittedPart ~= "" then
				splittedParts = splittedParts .. wrapLine(splittedPart)
			end
			splittedPart = ""

			if string.len(chunk) <= 255 then
				splittedParts = splittedParts .. chunk
			elseif level < 4 then
				splittedParts = splittedParts .. wrapLine(splitText(chunk, level + 1))
			else
				splittedParts = splittedParts .. wrapLine(chunk)
			end
		end
	end

	if splittedPart ~= "" then
		splittedParts = splittedParts .. wrapLine(splittedPart)
	end

	return splittedParts
end

--- Load text
--
function StoryTeller.Frame.Load()
	StoryTeller.text = {}
	StoryTeller.textCursor = 1

	if strtrim(StoryTellerFrameText:GetText()) == "" then
		StoryTellerFrameText:SetText(StoryTeller.Msg.PASTE_TEXT)
	end

	if StoryTellerFrameText:GetText() ~= StoryTeller.Msg.PASTE_TEXT then
		local text = string.gsub(StoryTellerFrameText:GetText(), "\r", "")
		local lines = { strsplit("\n", splitText(text)) }

		local length = 0
		local y = 0
		local boxWidth = StoryTellerFrameText:GetWidth()
		local _, fontHeight = StoryTeller.Frame.GetTextLineSize('0', boxWidth)
		for i = 1, #lines do
			lines[i] = strtrim(lines[i])

			-- Comment secure commands
			local command = string.match(lines[i], "^/%w+")
			if command then
				if IsSecureCmd(command) then
					lines[i] = '# ' .. lines[i]
				end
			end

			local lineLength = string.len(lines[i])
			local _, lineHeight = StoryTeller.Frame.GetTextLineSize(lines[i], boxWidth)
			local wrapLines = max(1, floor(.5 + lineHeight / fontHeight))

			if not StoryTeller.Frame.IsTextLineEmpty(lines[i]) then
				table.insert(StoryTeller.text, { lines[i], length, length + lineLength, y, wrapLines })
			end

			y = y + wrapLines
			length = length + lineLength + 1
		end

		local newText = strjoin("\n", unpack(lines))
		StoryTellerFrameText:SetText(newText)
		StoryTellerEditFrameText:SetText(newText)
		StoryTellerEditFrameScrollFrame:SetVerticalScroll(0)
		StoryTeller.Frame.HighlightCurrentLine(0)
	else
		StoryTeller.Frame.ScrollTo(0, 0)
		StoryTellerEditFrameText:SetText("")
		StoryTellerEditFrameScrollFrame:SetVerticalScroll(0)
	end

	StoryTeller.Frame.Refresh()
end

--- Reload text when changed
--
function StoryTeller.Frame.TextChanged(self, isUserInput)
	ScrollingEdit_OnTextChanged(self, self:GetParent())
	if isUserInput then
		StoryTeller.Frame.Load()
	end
	StoryTeller.Frame.HighlightCurrentLine(0)
end

--- Clear text
--
function StoryTeller.Frame.Clear()
	StoryTellerFrameText:SetText(StoryTeller.Msg.PASTE_TEXT)
	StoryTeller.Frame.Load()
	StoryTellerFrameText:SetFocus()
	StoryTellerFrameText:HighlightText(0)
	StoryTellerFrameText.highlightTexture:Hide()
end

--- Open edit frame
--
function StoryTeller.Frame.Edit()
	if not StoryTellerEditFrame:IsVisible() then
		StoryTellerEditFrame:Show()
		StoryTellerEditFrameText:SetFocus()
	end
end

--- Return true if the provided text line is blank or is a comment
-- @param text (string)
-- @return (boolean)
function StoryTeller.Frame.IsTextLineEmpty(text)
	local line = strtrim(text)
	return line == "" or
		string.find(line, "%#") == 1 or
		string.find(line, "%-%-") == 1 or
		string.find(line, "%/%/") == 1 or
		string.find(line, "REM%s") == 1
end

--- Returns the width and height in pixels of the text line
-- @param text (string)
-- @param maxWidth (number)
-- @return (number), (number)
function StoryTeller.Frame.GetTextLineSize(text, maxWidth)
	-- Create a clone of the FontString for measurements
	if StoryTellerFrame.fsClone == nil then
		local fs = StoryTellerFrameText:GetRegions()
		StoryTellerFrame.fsClone = StoryTellerFrameText:CreateFontString()
		StoryTellerFrame.fsClone:SetFontObject(fs:GetFontObject())
	end
	-- Measure dimensions
	StoryTellerFrame.fsClone:SetWidth(maxWidth)
	StoryTellerFrame.fsClone:SetText(text)
	return StoryTellerFrame.fsClone:GetStringWidth(), StoryTellerFrame.fsClone:GetStringHeight()
end

--- Go to previous text line
--
function StoryTeller.Frame.Prev()
	local lineCount = #StoryTeller.text
	if lineCount and StoryTeller.textCursor > 1 then
		StoryTeller.textCursor = StoryTeller.textCursor - 1
		StoryTeller.Frame.HighlightCurrentLine()
		StoryTeller.Frame.Refresh()
	end
end

--- Go to next text line
--
function StoryTeller.Frame.Next()
	local lineCount = #StoryTeller.text
	if lineCount and StoryTeller.textCursor <= lineCount then
		StoryTeller.textCursor = StoryTeller.textCursor + 1
		StoryTeller.Frame.HighlightCurrentLine()
		StoryTeller.Frame.Refresh()
	end
end

--- Read the current line
--
function StoryTeller.Frame.Read()
	local lineCount = #StoryTeller.text
	if lineCount and StoryTeller.textCursor <= lineCount then
		StoryTeller.Frame.ReadLine(StoryTeller.text[StoryTeller.textCursor][1])
		StoryTeller.Frame.Next()
	end
end

--- Refresh buttons
--
function StoryTeller.Frame.Refresh()
	local lineCount = #StoryTeller.text

	if lineCount > 0 and StoryTeller.textCursor <= lineCount then
		StoryTellerFrameNextButton:Enable()
	else
		StoryTellerFrameNextButton:Disable()
	end

	if lineCount > 0 and StoryTeller.textCursor > 1 then
		StoryTellerFramePrevButton:Enable()
	else
		StoryTellerFramePrevButton:Disable()
	end

	if lineCount > 0 and StoryTeller.text[StoryTeller.textCursor] ~= nil then
		StoryTellerFrameReadButton:Enable()
	else
		StoryTellerFrameReadButton:Disable()
	end
end

--- Update frame
-- @param self (Frame)
-- @param elapsed (number
function StoryTeller.Frame.OnUpdate(self, elapsed)
	if StoryTellerFrame.animateScrollDuration ~= 0 and
		StoryTellerFrame.animateScrollFrom ~= StoryTellerFrame.animateScrollTo then

		StoryTellerFrame.animateScrollTime = StoryTellerFrame.animateScrollTime + elapsed

		local range = StoryTellerFrame.animateScrollTo - StoryTellerFrame.animateScrollFrom
		local progression = min(1, StoryTellerFrame.animateScrollTime / StoryTellerFrame.animateScrollDuration)
		local scrollTo = StoryTellerFrame.animateScrollFrom + range * progression

		StoryTellerFrameScrollFrame:SetVerticalScroll(scrollTo)

		if progression == 1 then
			StoryTeller.Frame.StopAnimation()
		end
	end
end

--- Smooth scroll to position
-- @param to (number)
-- @param duration (number)
function StoryTeller.Frame.ScrollTo(to, duration)
	if duration == nil then
		duration = .25
	end
	if duration == 0 then
		StoryTellerFrameScrollFrame:SetVerticalScroll(to)
	else
		StoryTellerFrame.animateScrollFrom = StoryTellerFrameScrollFrame:GetVerticalScroll()
		StoryTellerFrame.animateScrollTo = to
		StoryTellerFrame.animateScrollTime = 0
		StoryTellerFrame.animateScrollDuration = duration
	end
end

--- Stop smooth scroll animation
--
function StoryTeller.Frame.StopAnimation()
	StoryTellerFrame.animateScrollFrom = 0
	StoryTellerFrame.animateScrollTo = 0
	StoryTellerFrame.animateScrollTime = 0
	StoryTellerFrame.animateScrollDuration = 0
end

--- Read text line or macro
--
function StoryTeller.Frame.ReadLine(text)
	text = strtrim(text)
	local editBox = ChatFrame1EditBox
	editBox:SetText(text)
	ChatEdit_ParseText(editBox, 1)
	ChatEdit_OnEnterPressed(editBox)
end

-- Main mixin

StoryTellerFrameMixin = {}

--- OnLoad
--
function StoryTellerFrameMixin:OnLoad()
	StoryTeller.Frame.Init()
end