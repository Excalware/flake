--!strict
local root = script.Parent.Parent.Parent
local actions = script.Parent.Parent:WaitForChild("actions")
local libraries = root:WaitForChild("libraries")
local components = script.Parent

local Cryo = require(libraries:WaitForChild("llama"))
local types = require(root:WaitForChild("types"))
local Roact = require(libraries:WaitForChild("roact-compat"))
local Window = require(components:WaitForChild("Window"))
local RoactRodux = require(libraries:WaitForChild("roact-rodux"))
local InputLabel = require(components:WaitForChild("InputLabel"))
local flakeContext = require(components:WaitForChild("flakeContext"))
local SetCommandListVisible = require(actions:WaitForChild("SetCommandListVisible"))

return RoactRodux.connect(function(state)
	return {
		visible = state.interface.commandListVisible
	}
end, function(dispatch)
	return {
		onClose = function()
			dispatch(SetCommandListVisible(false))
		end
	}
end)(function(props)
    return Roact.createElement(flakeContext.Consumer, {
		render = function(flake: types.flake)
			return Roact.createElement(Window, {
				icon = "rbxassetid://11568224787",
				title = "Command list",
				height = 250,
				hidden = not props.visible,
				onClose = function()
					props.onClose()
				end
			}, {
				Roact.createElement("UIListLayout"),
				Roact.createElement(InputLabel, nil, "Command list"),
				Roact.createElement("ScrollingFrame", {
					Size = UDim2.new(1, 0, 0, 160),
					CanvasSize = UDim2.fromScale(0, 0),
					BorderSizePixel = 0,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}, {
					Roact.createElement("UIListLayout", {
						Padding = UDim.new(0, 8)
					}),
					table.unpack(Cryo.List.map(flake.commandSystem.commands, function(command)
						return Roact.createElement("Frame", {
							Size = UDim2.fromScale(1, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundColor3 = Color3.fromRGB(80, 80, 80)
						}, {
							Roact.createElement("UICorner"),
							Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 6),
								PaddingLeft = UDim.new(0, 8),
								PaddingRight = UDim.new(0, 8),
								PaddingBottom = UDim.new(0, 6)
							}),
							Roact.createElement("TextLabel", {
								Text = string.format("%s%s(%s)", command.aliases[1], command.aliases[2] and (", "..command.aliases[2].." ") or " ", command.id),
								TextSize = 12,
								FontFace = Font.fromName("GothamSSm", Enum.FontWeight.Regular),
								TextColor3 = Color3.fromRGB(240, 240, 240),
								AutomaticSize = Enum.AutomaticSize.XY,
								BackgroundTransparency = 1
							})
						})
					end))
				})
			})
		end
	})
end)