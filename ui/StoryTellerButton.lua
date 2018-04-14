
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
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft() + Minimap:GetWidth() / 2, Minimap:GetBottom() + Minimap:GetHeight() / 2

	xpos = xpos-xmin/UIParent:GetScale()
	ypos = ypos-ymin/UIParent:GetScale()

	StoryTeller_Settings.minimapPosition = math.deg(math.atan2(ypos,xpos))
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
	if button == "LeftButton" or button == "RightButton" then
		if StoryTellerFrame:IsVisible() then
			StoryTellerFrame:Hide()
		else
			StoryTellerFrame:Show()
			StoryTellerFrameText:SetFocus()
			StoryTellerFrameText:HighlightText(0)
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
		leftAction = StoryTeller.Msg.TOOLTIP_ACTION_HIDE
	else
		leftAction = StoryTeller.Msg.TOOLTIP_ACTION_SHOW
	end
	leftClickLine = string.gsub(leftClickLine, "{action}", leftAction)

	GameTooltip:AddLine(mainLine, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(StoryTeller.FormatText(leftClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(StoryTeller.FormatText(StoryTeller.Msg.TOOLTIP_DRAG_AND_DROP), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	GameTooltip:Show();
end

function StoryTellerButton.HideTooltip()
	GameTooltip:Hide();
end

