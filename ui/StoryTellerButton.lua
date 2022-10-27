StoryTellerButton = LibStub("AceAddon-3.0"):NewAddon("StoryTellerButton")

local icon = LibStub("LibDBIcon-1.0")

local BUTTON_ICON = "Interface\\Icons\\Inv_misc_book_08"
local BUTTON_TEXT = "StoryTeller"

function StoryTellerButton.Init()
	local storyTellerLDB = LibStub("LibDataBroker-1.1"):NewDataObject("StoryTeller", {
		type = "launcher",
		text = BUTTON_TEXT,
		icon = BUTTON_ICON,
		OnClick = StoryTellerButton.OnClick,
		OnEnter = StoryTellerButton.ShowTooltip,
		OnLeave = StoryTellerButton.HideTooltip
	})

	-- Create button
	icon:Register("StoryTeller", storyTellerLDB, StoryTeller_CharacterSettings.minimap)

	-- Add background texture to fill the gap of the thinner WoW 10.0 minimap button border
	if LE_EXPANSION_LEVEL_CURRENT == 9 then
		local buttonFrame = icon:GetMinimapButton("StoryTeller")
		local backdropMask = buttonFrame:CreateMaskTexture(nil, "BACKGROUND", nil, -7)
		backdropMask:SetTexture(130925)
		backdropMask:SetPoint("BOTTOMRIGHT", -1, 2)
		backdropMask:SetPoint("TOPLEFT", 4, -3)
		local backdrop = buttonFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
		backdrop:AddMaskTexture(backdropMask)
		backdrop:SetAllPoints(backdropMask)
		backdrop:SetColorTexture(0, 0, 0, 1)
	end

	-- Register add-on on the minimap
	if AddonCompartmentFrame then
		AddonCompartmentFrame:RegisterAddon({
			notCheckable = true,
			text = BUTTON_TEXT,
			icon = BUTTON_ICON,
			registerForRightClick = true,
			func = function(self, _, _, _, button) StoryTellerButton.OnClick(nil, button) end
		})
	end
end

function StoryTellerButton.OnClick(self, button)
	if button == "LeftButton" then
		if StoryTellerFrame:IsVisible() then
			StoryTellerFrame:Hide()
		else
			StoryTellerFrame:Show()
			StoryTeller.Frame.HighlightCurrentLine(0)
		end
	elseif button == "RightButton" then
		if StoryTellerEditFrame:IsVisible() then
			StoryTellerEditFrame:Hide()
		else
			StoryTellerEditFrame:Show()
		end
	end
end

function StoryTellerButton.ShowTooltip(self)
	if self then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	end

	local mainLine = string.gsub(StoryTeller.Msg.PLAYER_TOOLTIP_VERSION, "{version}",
		GetAddOnMetadata("StoryTeller", "Version"))

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
	GameTooltip:AddLine(StoryTeller.FormatText(rightClickLine),
		NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(StoryTeller.FormatText(StoryTeller.Msg.TOOLTIP_DRAG_AND_DROP),
		NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	GameTooltip:Show()
end

function StoryTellerButton.HideTooltip()
	GameTooltip:Hide()
end