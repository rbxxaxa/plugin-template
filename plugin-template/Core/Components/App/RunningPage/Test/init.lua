local Plugin = script.Parent.Parent.Parent.Parent.Parent

local Libs = Plugin.Libs
local Roact = require(Libs.Roact)

local Components = Plugin.Core.Components
local Foundation = Components.Foundation
local ScrollingVerticalList = require(Foundation.ScrollingVerticalList)

local Draw = Roact.PureComponent:extend("Test")
function Draw:init()
	self.state = {}
end

function Draw:render()
	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[Roact.Ref] = self.frameRef
		},
		{
			Scroller = Roact.createElement(
				ScrollingVerticalList,
				{
					BackgroundTransparency = 1
				},
				{
				}
			)
		}
	)
end

return Draw
