local Plugin = script.Parent.Parent
local Libs = Plugin.Libs

local Constants = require(Plugin.Core.Util.Constants)
local semver = require(Libs.semver)
local Maid = require(Libs.Maid)
local createSignal = require(Plugin.Core.Util.createSignal)

local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local MainManager = {}

function MainManager.new(plugin)
	local self = setmetatable({}, {__index = MainManager})
	self._signal = createSignal()
	self.plugin = plugin
	self.maid = Maid.new()
	self.mode = "None"
	self.mouse = plugin:GetMouse()
	self.ready = false
	self.collapsibleSections = {}

	self.deactivationConn =
		plugin.Deactivation:Connect(
		function()
			self.mode = "None"
			self._signal:fire()
		end
	)
	
	return self
end

function MainManager:subscribe(...)
	return self._signal:subscribe(...)
end

function MainManager:IsInEditMode()
	if RunService:IsStudio() and RunService:IsEdit() then
		return true
	else
		return false
	end
end

function MainManager:destroy()
	self.maid:Destroy()
end

function MainManager:GetMode()
	return self.mode
end

function MainManager:Activate(mode)
	self.mode = mode
	self.plugin:Activate(true)
	self._signal:fire()
end

function MainManager:Deactivate()
	self.mode = "None"
	self.plugin:Deactivate()
	self._signal:fire()
end

function MainManager:IsActive()
	return self.mode ~= "None"
end

function MainManager:ToggleCollapsibleSection(sectionId)
	local isCollapsed = self.collapsibleSections[sectionId]
	if isCollapsed == nil then
		self.collapsibleSections[sectionId] = true
		self._signal:fire()
	else
		self.collapsibleSections[sectionId] = not isCollapsed
		self._signal:fire()
	end
end

function MainManager:IsSectionCollapsed(sectionId)
	local isCollapsed = self.collapsibleSections[sectionId]
	if isCollapsed == nil then
		return false
	end

	return isCollapsed
end

return MainManager
