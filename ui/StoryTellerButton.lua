StoryTellerButton = LibStub("AceAddon-3.0"):NewAddon("StoryTellerButton")

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

local icon = LibStub("LibDBIcon-1.0")

local BUTTON_ICON = "Interface\\Icons\\Inv_misc_book_08"
local BUTTON_TEXT = "StoryTeller"

local addOnMenuInfo

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

	-- Create addon menu info
	addOnMenuInfo = {
		notCheckable = true,
		text = BUTTON_TEXT,
		icon = BUTTON_ICON,
		registerForRightClick = true,
		func = function(self, event, _, _, button)
			if event and event.buttonName then
				StoryTellerButton.OnClick(nil, event.buttonName)
			else
				-- Old school way
				StoryTellerButton.OnClick(nil, button)
			end
		end,
		funcOnEnter = StoryTellerButton.ShowTooltip,
		funcOnLeave = StoryTellerButton.HideTooltip
	}

	-- Refresh button
	StoryTellerButton.Refresh()
end

function StoryTellerButton.Refresh()
	-- Create/show or hide minimap button
	if StoryTeller_CharacterSettings.minimap.hide then
		icon:Hide("StoryTeller")
	else
		icon:Show("StoryTeller")
	end

	-- Update add-on minimap menu
	if AddonCompartmentFrame then
		local registeredAddons = AddonCompartmentFrame.registeredAddons
		local pos = tIndexOf(registeredAddons, addOnMenuInfo)
		local addMenu = not StoryTeller_CharacterSettings.addonCompartment.hide
		if addMenu and pos == nil then
			tinsert(registeredAddons, addOnMenuInfo.pos or (#registeredAddons + 1), addOnMenuInfo)
			AddonCompartmentFrame:UpdateDisplay()
		elseif not addMenu and pos ~= nil then
			addOnMenuInfo.pos = pos
			tremove(registeredAddons, pos)
			AddonCompartmentFrame:UpdateDisplay()
		end
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
	local isTooltipFromMinimapButton = self:GetName() ~= nil

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
	GameTooltip:AddLine(StoryTeller.FormatText(leftClickLine), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
		NORMAL_FONT_COLOR.b)
	GameTooltip:AddLine(StoryTeller.FormatText(rightClickLine),
		NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	if isTooltipFromMinimapButton then
		GameTooltip:AddLine(StoryTeller.FormatText(StoryTeller.Msg.TOOLTIP_DRAG_AND_DROP),
			NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	GameTooltip:Show()
end

function StoryTellerButton.HideTooltip()
	GameTooltip:Hide()
end
