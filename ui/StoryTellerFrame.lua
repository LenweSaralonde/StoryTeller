--- Main frame init
--
StoryTellerFrame.Init = function()
	StoryTellerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	StoryTellerFrame:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			StoryTellerFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
			StoryTeller.Init()
			StoryTellerFrameText:SetText(StoryTeller.Msg.PASTE_TEXT)
			StoryTellerFrameTitle:SetText(StoryTeller.Msg.TELL_A_STORY)
			StoryTellerFrameClearButton:SetText(StoryTeller.Msg.CLEAR)
			StoryTellerFramePrevButton:SetText(StoryTeller.Msg.PREV)
			StoryTellerFrameNextButton:SetText(StoryTeller.Msg.NEXT)
			StoryTellerFrameReadButton:SetText(StoryTeller.Msg.READ)
		end
	end)
end

--- Handle escape key
--
StoryTellerFrame.Escape = function()
	if StoryTellerFrameText:HasFocus() then
		StoryTellerFrameText:ClearFocus()
	else
		StoryTellerFrame:Hide()
	end
end

--- Highlight the current line in the edit box
--
StoryTellerFrame.HighlightCurrentLine = function()
	local lineCount = table.getn(StoryTeller.text)
	if lineCount > 0 and StoryTeller.text[StoryTeller.textCursor] ~= nil then
		local line = StoryTeller.text[StoryTeller.textCursor]
		StoryTellerFrameText:HighlightText(line[2], line[3])

		-- Adjust scrolling
		local boxWidth = StoryTellerFrameText:GetWidth()
		local _, fontHeight = StoryTellerFrame.GetTextLineSize('0', boxWidth)
		local scrollRange = StoryTellerFrameScrollFrame:GetVerticalScrollRange()
		local scrollHeight = StoryTellerFrameScrollFrame:GetHeight()
		local textHeight = scrollRange + scrollHeight
		local lineY = line[4] * fontHeight
		local lineHeight = line[5] * fontHeight
		local visibleLines = scrollHeight / fontHeight
		local scrollCenter = 1/3

		local scrollTo = lineY - scrollHeight * scrollCenter + lineHeight / 2
		StoryTellerFrameScrollFrame:SetVerticalScroll(min(scrollRange, max(0, min(lineY, scrollTo))))

		StoryTellerFrameText:ClearFocus()
	elseif lineCount == 0 then
		StoryTellerFrameText:HighlightText(0)
		StoryTellerFrameText:SetFocus()
	else
		StoryTellerFrameText:HighlightText(0, 0)
		StoryTellerFrameText:ClearFocus()
	end
end

--- Load text
--
StoryTellerFrame.Load = function()
	local lines = {}
	StoryTeller.text = {}
	StoryTeller.textCursor = 1

	if StoryTellerFrameText:GetText() ~= StoryTeller.Msg.PASTE_TEXT then
		lines = { strsplit("\n", string.gsub(StoryTellerFrameText:GetText(), "\r", "")) }

		local i
		local length = 0
		local y = 0
		local boxWidth = StoryTellerFrameText:GetWidth()
		local _, fontHeight = StoryTellerFrame.GetTextLineSize('0', boxWidth)
		local lineIsSpaces = false
		for i = 1, table.getn(lines) do
			local lineLength = string.len(lines[i])
			local lineWidth, lineHeight = StoryTellerFrame.GetTextLineSize(lines[i], boxWidth)
			local wrapLines = floor(.5 + lineHeight / fontHeight)

			if not(StoryTellerFrame.IsTextLineEmpty(lines[i])) then
				table.insert(StoryTeller.text, { lines[i], length, length + lineLength, y, wrapLines })
				lineIsSpaces = false
			elseif strtrim(lines[i]) == "" then
				if lineIsSpaces then
					wrapLines = 0
				else
					wrapLines = 1
				end
				lineIsSpaces = true
			else
				lineIsSpaces = false
			end

			y = y + wrapLines
			length = length + lineLength + 1
		end
	end

	StoryTellerFrame.HighlightCurrentLine()
	StoryTellerFrame.Refresh()
end

--- Return true if the provided text line is blank or is a comment
-- @param text (string)
-- @return (boolean)
StoryTellerFrame.IsTextLineEmpty = function(text)
	local line = strtrim(text)
	return line == "" or string.find(line, "%#") == 1 or string.find(line, "%-%-") == 1 or string.find(line, "%/%/") == 1 or string.find(line, "REM%s") == 1
end

--- Returns the width and height in pixels of the text line
-- @param text (string)
-- @param maxWidth (number)
-- @return (number), (number)
StoryTellerFrame.GetTextLineSize = function(text, maxWidth)
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
StoryTellerFrame.Prev = function()
	local lineCount = table.getn(StoryTeller.text)
	if lineCount and StoryTeller.textCursor > 1 then
		StoryTeller.textCursor = StoryTeller.textCursor -  1
		StoryTellerFrame.HighlightCurrentLine()
		StoryTellerFrame.Refresh()
	end
end

--- Go to next text line
--
StoryTellerFrame.Next = function()
	local lineCount = table.getn(StoryTeller.text)
	if lineCount and StoryTeller.textCursor <= lineCount then
		StoryTeller.textCursor = StoryTeller.textCursor + 1
		StoryTellerFrame.HighlightCurrentLine()
		StoryTellerFrame.Refresh()
	end
end

--- Read the current line
--
StoryTellerFrame.Read = function()
	local lineCount = table.getn(StoryTeller.text)
	if lineCount and StoryTeller.textCursor <= lineCount then
		StoryTellerFrame.ReadLine(StoryTeller.text[StoryTeller.textCursor][1])
		StoryTellerFrame.Next()
	end
end

--- Refresh buttons
--
StoryTellerFrame.Refresh = function()
	local lineCount = table.getn(StoryTeller.text)

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

--- Read text line or macro
--
StoryTellerFrame.ReadLine = function(text)
	text = strtrim(text)
	local editBox = ChatFrame1EditBox
	editBox:SetText(text)
	ChatEdit_ParseText(editBox, 1)
	ChatEdit_OnEnterPressed(editBox)
end

-- Init main
StoryTellerFrame.Init()
