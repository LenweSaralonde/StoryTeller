--- Dialog window template
-- @module StoryTellerDialogTemplate

StoryTellerDialogTemplateMixin = {}

--- Disable the Escape key for the frame
--
function StoryTellerDialogTemplateMixin:DisableEscape()
	for index, frameName in pairs(UISpecialFrames) do
		if frameName == self:GetName() then
			table.remove(UISpecialFrames, index)
			return
		end
	end
end

--- OnLoad
--
function StoryTellerDialogTemplate_OnLoad(self)
	self:RegisterForDrag("LeftButton")

	-- Slightly rescale the close button on Retail
	if LE_EXPANSION_LEVEL_CURRENT >= 9 then
		self.close:SetScale(.75)
		self.close:SetPoint("CENTER", self, "TOPRIGHT", -10, -10)
	end

	-- Enable the Escape key to close the frame by default
	table.insert(UISpecialFrames, self:GetName())
end

--- OnDragStart
--
function StoryTellerDialogTemplate_OnDragStart(self)
	self:StartMoving()
end

--- OnDragStop
--
function StoryTellerDialogTemplate_OnDragStop(self)
	self:StopMovingOrSizing()
end

--- OnShow
--
function StoryTellerDialogTemplate_OnShow(self)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN)
end

--- OnHide
--
function StoryTellerDialogTemplate_OnHide(self)
	PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
end