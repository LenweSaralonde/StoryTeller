--- StoryTeller options panel
-- @module StoryTeller.Options

StoryTeller.Options = {}

local currentShortcutMinimapHide
local currentShortcutMenuHide

--- Options panel initialization
--
function StoryTeller.Options.Init()
	-- Register panel
	local panel = StoryTellerOptionsPanelContainer
	panel.name = StoryTeller.Msg.OPTIONS_TITLE
	panel.refresh = StoryTeller.Options.Refresh
	panel.okay = StoryTeller.Options.Save
	panel.cancel = StoryTeller.Options.Cancel
	panel.default = StoryTeller.Options.Defaults
	StoryTellerOptionsPanelContainer:SetScript("OnShow", StoryTeller.Options.UpdateSize)
	InterfaceOptions_AddCategory(StoryTellerOptionsPanelContainer)

	-- Set title
	StoryTellerOptionsPanelTitle:SetText(StoryTeller.Msg.OPTIONS_TITLE)

	-- Shortcuts
	StoryTellerOptionsPanelShortcutTitle:SetText(StoryTeller.Msg.OPTIONS_CATEGORY_SHORTCUTS)
	StoryTeller.Options.SetupCheckbox(StoryTellerOptionsPanelShortcutMinimap, StoryTeller.Msg.OPTIONS_SHORTCUT_MINIMAP)
	StoryTeller.Options.SetupCheckbox(StoryTellerOptionsPanelShortcutMenu, StoryTeller.Msg.OPTIONS_SHORTCUT_ADDON_MENU)
	StoryTellerOptionsPanelShortcutMinimap:HookScript("OnClick", function(self)
		StoryTeller_CharacterSettings.minimap.hide = not self:GetChecked()
		StoryTellerButton.Refresh()
	end)
	StoryTellerOptionsPanelShortcutMenu:HookScript("OnClick", function(self)
		StoryTeller_CharacterSettings.addOnMenu.hide = not self:GetChecked()
		StoryTellerButton.Refresh()
	end)
	-- Hide add-on menu option if the component is not available on the current WoW version
	if not AddonCompartmentFrame then
		StoryTellerOptionsPanelShortcutMenu:Hide()
	end
end

--- Enable or disable the checkbox based on the dependant controls status
-- @param checkbox (CheckButton)
local function computeDependantControls(checkbox)
	local isEnabled = true
	for _, dependantControl in pairs(checkbox.dependantControls) do
		if not dependantControl:GetChecked() then
			isEnabled = false
		end
	end

	if isEnabled then
		checkbox:Enable()
	else
		checkbox:Disable()
	end
end

--- Set up an option checkbox
-- @param checkbox (CheckButton)
-- @param labelText (string)
-- @param[opt] dependantControl (CheckButton)
-- @param[opt] dependantControl2 (CheckButton)
-- @param[opt] dependantControln... (CheckButton)
function StoryTeller.Options.SetupCheckbox(checkbox, labelText, ...)
	local labelElement = checkbox.Text
	labelElement:SetText(labelText)
	checkbox:SetHitRectInsets(0, -labelElement:GetWidth(), 0, 0)

	checkbox.dependantControls = { ... }
	for _, dependantControl in pairs(checkbox.dependantControls) do
		dependantControl:HookScript("OnClick", function()
			computeDependantControls(checkbox)
		end)
		hooksecurefunc(dependantControl, "SetChecked", function()
			computeDependantControls(checkbox)
		end)
	end
end

--- Show StoryTeller's option panel
--
function StoryTeller.Options.Show()
	if InterfaceOptionsFrame_Show then
		InterfaceOptionsFrame_Show() -- This one has to be opened first
	end
	InterfaceOptionsFrame_OpenToCategory("StoryTeller")
end

function StoryTeller.Options.Refresh()
	StoryTellerOptionsPanelShortcutMinimap:SetChecked(not StoryTeller_CharacterSettings.minimap.hide)
	StoryTellerOptionsPanelShortcutMenu:SetChecked(not StoryTeller_CharacterSettings.addOnMenu.hide)
	currentShortcutMinimapHide = StoryTeller_CharacterSettings.minimap.hide
	currentShortcutMenuHide = StoryTeller_CharacterSettings.addOnMenu.hide
end

function StoryTeller.Options.Defaults()
	StoryTeller_CharacterSettings.minimap.hide = false
	StoryTeller_CharacterSettings.addOnMenu.hide = true
	StoryTellerButton.Refresh()
end

function StoryTeller.Options.Cancel()
	StoryTeller_CharacterSettings.minimap.hide = currentShortcutMinimapHide
	StoryTeller_CharacterSettings.addOnMenu.hide = currentShortcutMenuHide
	StoryTellerButton.Refresh()
end

function StoryTeller.Options.Save()

end

--- Update the size of the StoryTeller option panel
--
function StoryTeller.Options.UpdateSize()
	local panel = StoryTellerOptionsPanel
	panel:SetWidth(panel:GetParent():GetWidth())

	local relativeFrame = StoryTellerOptionsPanelSubText
	local height = 0
	for _, child in ipairs({ panel:GetChildren() }) do
		if child:IsVisible() then
			child:ClearAllPoints()
			child:SetPoint("TOPLEFT", relativeFrame, "BOTTOMLEFT", 0, -10)
			height = height + child:GetHeight()
			relativeFrame = child
		end
	end

	panel:SetHeight(height)
end