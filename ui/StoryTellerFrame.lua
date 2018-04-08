--- Main frame init
--
StoryTellerFrame.Init = function()
	StoryTellerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	StoryTellerFrame:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
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
		local scrollRange = StoryTellerFrameScrollFrame:GetVerticalScrollRange()
		local scrollHeight = StoryTellerFrameScrollFrame:GetHeight()
		local textHeight = scrollRange + scrollHeight
		local lineHeight = textHeight / lineCount
		local visibleLines = scrollHeight / lineHeight

		local scrollTo
		if StoryTeller.textCursor <= visibleLines / 2 then
			scrollTo = 0
		elseif StoryTeller.textCursor >= lineCount - visibleLines / 2 then
			scrollTo = scrollRange
		else
			scrollTo = lineHeight * (StoryTeller.textCursor - visibleLines / 2)
		end

		StoryTellerFrameScrollFrame:SetVerticalScroll(scrollTo)
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
	StoryTeller.textCursor = nil
	if StoryTellerFrameText:GetText() ~= StoryTeller.Msg.PASTE_TEXT then
		lines = { strsplit("\n", string.gsub(StoryTellerFrameText:GetText(), "\r", "")) }
		StoryTeller.textCursor = 1
		local i
		local length = 0
		for i = 1, table.getn(lines) do
			local lineLength = string.len(lines[i])
			table.insert(StoryTeller.text, { lines[i], length, length + lineLength })
			length = length + lineLength + 1
		end
	end

	StoryTellerFrame.HighlightCurrentLine()
	StoryTellerFrame.Refresh()
end

--- Return true if the current line is blank or is a comment
-- @return (boolean)
StoryTellerFrame.IsCurrentLineEmpty = function()
	local lineCount = table.getn(StoryTeller.text)
	if lineCount and StoryTeller.text[StoryTeller.textCursor] ~= nil then
		local line = strtrim(StoryTeller.text[StoryTeller.textCursor][1])
		return line == "" or string.find(line, "%#") == 1 or string.find(line, "%-%-") == 1 or string.find(line, "%/%/") == 1 or string.find(line, "REM%s") == 1
	else
		return false
	end
end

--- Go to previous text line
--
StoryTellerFrame.Prev = function()
	local lineCount = table.getn(StoryTeller.text)
	if lineCount and StoryTeller.textCursor > 1 then
		StoryTeller.textCursor = StoryTeller.textCursor -  1
		-- Skip blank line
		if StoryTellerFrame.IsCurrentLineEmpty() then
			return StoryTellerFrame.Prev()
		end
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
		-- Skip blank line
		if StoryTellerFrame.IsCurrentLineEmpty() then
			return StoryTellerFrame.Next()
		end
		StoryTellerFrame.HighlightCurrentLine()
		StoryTellerFrame.Refresh()
	end
end

--- Read the current line
--
StoryTellerFrame.Read = function()
	local lineCount = table.getn(StoryTeller.text)
	if lineCount and StoryTeller.textCursor <= lineCount then
		if not(StoryTellerFrame.IsCurrentLineEmpty()) then
			StoryTellerFrame.ReadLine(StoryTeller.text[StoryTeller.textCursor][1])
		end
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
