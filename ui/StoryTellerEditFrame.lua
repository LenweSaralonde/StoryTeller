StoryTellerEditFrame.Init = function()
	StoryTellerEditFrameTitle:SetText(StoryTeller.Msg.EDIT_TEXT)
	StoryTellerEditFrameClearButton:SetText(StoryTeller.Msg.CLEAR)
	StoryTellerEditFrameCancelButton:SetText(StoryTeller.Msg.CANCEL)
	StoryTellerEditFrameSaveButton:SetText(StoryTeller.Msg.SAVE)
end

StoryTellerEditFrame.Clear = function()
	StoryTellerEditFrameText:SetText("")
	StoryTellerEditFrameScrollFrame:SetVerticalScroll(0)
	StoryTellerEditFrameText:SetFocus()
end

StoryTellerEditFrame.Save = function()
	StoryTellerFrameText:SetText(StoryTellerEditFrameText:GetText())
	StoryTellerFrame.Load()
	StoryTellerEditFrame:Hide()
end

StoryTellerEditFrame.Cancel = function()
	StoryTellerEditFrame:Hide()
end
