
function StoryTellerButton.Init()
	StoryTellerButton.Reposition()
	StoryTellerButton:SetScript("OnClick", StoryTellerButton.OnClick)
end

function StoryTellerButton.Reposition()
	local radius = Minimap:GetWidth() / 2 + 8
	StoryTellerButton:SetPoint("CENTER", "Minimap", "CENTER", radius * cos(StoryTeller_Settings.minimapPosition), radius * sin(StoryTeller_Settings.minimapPosition))
	StoryTellerButton:SetFrameLevel(Minimap:GetFrameLevel()+1000)
end

function StoryTellerButton.DraggingFrame_OnUpdate()
	local xpos, ypos = GetCursorPosition()
	local xmin, ymin = Minimap:GetCenter()
	local scale = UIParent:GetScale()

	xpos = xpos / scale
	ypos = ypos / scale

	StoryTeller_Settings.minimapPosition = math.deg(math.atan2(ypos - ymin, xpos - xmin)) % 360
	StoryTellerButton.Reposition()
end

function StoryTellerButton.OnMouseDown()
	StoryTellerButton_Icon:SetWidth(14)
	StoryTellerButton_Icon:SetHeight(14)
end

function StoryTellerButton.OnMouseUp()
	StoryTellerButton_Icon:SetWidth(16)
	StoryTellerButton_Icon:SetHeight(16)
end

function StoryTellerButton.OnClick(self, button)
	if button == "LeftButton" then
		if StoryTellerFrame:IsVisible() then
			StoryTellerFrame:Hide()
		else
			StoryTellerFrame:Show()
			StoryTellerFrame.HighlightCurrentLine(0)
		end
	elseif button == "RightButton" then
		if StoryTellerEditFrame:IsVisible() then
			StoryTellerEditFrame:Hide()
		else
			StoryTellerEditFrame:Show()
		end
	end
	StoryTellerButton.Reposition()
	StoryTellerButton.ShowTooltip()
end

function StoryTellerButton.ShowTooltip()
	GameTooltip:SetOwner(StoryTellerButton, "ANCHOR_BOTTOMLEFT");

	local mainLine = string.gsub(StoryTeller.Msg.PLAYER_TOOLTIP_VERSION, "{version}", GetAddOnMetadata("StoryTeller", "Version"))

	local leftClickLine = StoryTeller.Msg.TOOLTIP_LEFT_CLICK
	local leftAction
	if StoryTellerFrame:IsVisible() then
		leftAction = StoryTeller.Msg.TOOLTIP_ACTION_HIDE_MAIN_WINDOW
	else
		leftAction = StoryTeller.Msg.TOOLTIP_ACTION_SHOW_MAIN_WINDOW
	end
	leftClickLine = string.gsub(leftClickLine, "{action}", leftAction)

	local rightClickLine = StoryTeller.Msg.TOOLTIP_RIGHT_CLICK
	local rightAction
	if StoryTellerEditFrame:IsVisible() then
		rightAction = StoryTeller.Msg.TOOLTIP_ACTION_HIDE_EDIT_WINDOW
	else
		rightAction = StoryTeller.Msg.TOOLTIP_ACTION_SHOW_EDIT_WINDOW
	end
	rightClickLine = string.gsub(rightClickLine, "{action}", rightAction)

	GameTooltip:AddLine(mainLine, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(StoryTeller.FormatText(leftClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(StoryTeller.FormatText(rightClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(StoryTeller.FormatText(StoryTeller.Msg.TOOLTIP_DRAG_AND_DROP), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	GameTooltip:Show();
end

function StoryTellerButton.HideTooltip()
	GameTooltip:Hide();
end
