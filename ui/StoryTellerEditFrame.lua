function StoryTellerEditFrame.Init()
	StoryTellerEditFrameTitle:SetText(StoryTeller.Msg.EDIT_TEXT)
	StoryTellerEditFrameClearButton:SetText(StoryTeller.Msg.CLEAR)
	StoryTellerEditFrameCancelButton:SetText(StoryTeller.Msg.CANCEL)
	StoryTellerEditFrameSaveButton:SetText(StoryTeller.Msg.SAVE)
	StoryTeller.SetButtonTextSize(StoryTellerEditFrameClearButton)
	StoryTeller.SetButtonTextSize(StoryTellerEditFrameCancelButton)
	StoryTeller.SetButtonTextSize(StoryTellerEditFrameSaveButton)
end

function StoryTellerEditFrame.Clear()
	StoryTellerEditFrameText:SetText("")
	StoryTellerEditFrameScrollFrame:SetVerticalScroll(0)
	StoryTellerEditFrameText:SetFocus()
end

function StoryTellerEditFrame.Save()
	StoryTellerFrameText:SetText(StoryTellerEditFrameText:GetText())
	StoryTellerFrame.Load()
	StoryTellerEditFrame:Hide()
end

function StoryTellerEditFrame.Cancel()
	StoryTellerEditFrame:Hide()
end
