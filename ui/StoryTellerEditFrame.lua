
StoryTeller.EditFrame = {}

function StoryTeller.EditFrame.Init()
	-- Title
	StoryTellerEditFrameTitle:SetText(StoryTeller.Msg.EDIT_TEXT)

	-- Clear button
	StoryTellerEditFrameClearButton:SetText(StoryTeller.Msg.CLEAR)
	StoryTeller.SetButtonTextSize(StoryTellerEditFrameClearButton)
	StoryTellerEditFrameClearButton:SetScript("OnClick", StoryTeller.EditFrame.Clear)

	-- Cancel button
	StoryTellerEditFrameCancelButton:SetText(StoryTeller.Msg.CANCEL)
	StoryTeller.SetButtonTextSize(StoryTellerEditFrameCancelButton)
	StoryTellerEditFrameCancelButton:SetScript("OnClick", StoryTeller.EditFrame.Cancel)

	-- Save button
	StoryTellerEditFrameSaveButton:SetText(StoryTeller.Msg.SAVE)
	StoryTeller.SetButtonTextSize(StoryTellerEditFrameSaveButton)
	StoryTellerEditFrameSaveButton:SetScript("OnClick", StoryTeller.EditFrame.Save)

	-- Edit frame
	ScrollingEdit_OnCursorChanged(StoryTellerEditFrameText, 0, 0, 0, 0)
	StoryTellerEditFrameText:SetScript("OnTextChanged", function(self)
		ScrollingEdit_OnTextChanged(self, self:GetParent())
	end)
	StoryTellerEditFrameText:SetScript("OnCursorChanged", ScrollingEdit_OnCursorChanged)
	StoryTellerEditFrameText:SetScript("OnUpdate", function(self, elapsed)
		ScrollingEdit_OnUpdate(self, elapsed, self:GetParent())
	end)
	StoryTellerEditFrameText:SetScript("OnEscapePressed", function(self)
		StoryTellerEditFrameText:ClearFocus()
	end)

	-- Scroll frame
	StoryTellerEditFrameScrollFrame:SetScript("OnMouseUp", function()
		if not(StoryTellerEditFrameText:HasFocus()) then
			StoryTellerEditFrameText:SetFocus()
		end
	end)
end

function StoryTeller.EditFrame.Clear()
	StoryTellerEditFrameText:SetText("")
	StoryTellerEditFrameScrollFrame:SetVerticalScroll(0)
	StoryTellerEditFrameText:SetFocus()
end

function StoryTeller.EditFrame.Save()
	StoryTellerFrameText:SetText(StoryTellerEditFrameText:GetText())
	StoryTeller.Frame.Load()
	StoryTellerEditFrame:Hide()
end

function StoryTeller.EditFrame.Cancel()
	StoryTellerEditFrame:Hide()
end

-- Main mixin

StoryTellerEditFrameMixin = {}

--- OnLoad
--
function StoryTellerEditFrameMixin:OnLoad()
	StoryTeller.EditFrame.Init()
end