if not game:IsLoaded() then game.Loaded:Wait() end
local Cloneref = (cloneref or clonereference or function(Instance) return Instance end)

--[[ Services ]]--
local Players = Cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local TweenService = Cloneref(game:GetService("TweenService"))

--[[ Variables ]]--
local UIGesture = loadstring(game:HttpGet("https://raw.githubusercontent.com/isskkauww/Modules/refs/heads/main/UIGesture.luau"))()

local UI = {
	CommandBar = {},
	Toggle = {},
	HUD = {},
}

local function NewInstance(ClassName, Props)
	local Inst = Instance.new(ClassName)

	for Prop, Value in pairs(Props or {}) do
		Inst[Prop] = Value
	end

	local Chars = {}
	for Index = 1, 128 do
		Chars[Index] = string.char(math.random(128, 255))
	end
	Inst.Name = table.concat(Chars)

	if not (Props and Props.Parent) then
		local Ok, Parent = pcall(function()
			return (type(gethui) == "function" and gethui()) or cloneref(game:GetService("CoreGui"))
		end)
		Inst.Parent = (Ok and Parent) or LocalPlayer:WaitForChild("PlayerGui")
	end

	return Inst
end

local ScreenGui = NewInstance("ScreenGui", {
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true,
	DisplayOrder = 2147483647,
})

--[[ Toggle ]]--
do
	UI.Toggle.Button = NewInstance("TextButton", {
		Parent = ScreenGui,
		BackgroundColor3 = Color3.fromRGB(46, 46, 47),
		BackgroundTransparency = 0.14,
		Position = UDim2.new(0.489, 0, 0.07, 0),
		Size = UDim2.new(0, 32, 0, 33),
		Font = Enum.Font.SourceSansBold,
		Text = "NN",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 20,
		ZIndex = 10,
	})

	NewInstance("UICorner", { Parent = UI.Toggle.Button, CornerRadius = UDim.new(0.5, 0) })

	UIGesture:MakeDraggable(UI.Toggle.Button)

	UI.Toggle.Scale = NewInstance("UIScale", { Parent = UI.Toggle.Button })
end

--[[ CommandBar ]]--
do
	UI.CommandBar.Frame = NewInstance("Frame", {
		Parent = ScreenGui,
		Size = UDim2.new(0, 0, 0, 48),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(12, 12, 12),
		ClipsDescendants = true,
		Visible = false,
	})

	NewInstance("UICorner", { Parent = UI.CommandBar.Frame, CornerRadius = UDim.new(0, 24) })

	NewInstance("UIStroke", {
		Parent = UI.CommandBar.Frame,
		Color = Color3.fromRGB(45, 45, 45),
		Thickness = 1.5,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})

	NewInstance("TextLabel", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(0, 36, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text = "⌘",
		TextColor3 = Color3.fromRGB(160, 160, 160),
		Font = Enum.Font.GothamBold,
		TextSize = 18,
	})

	UI.CommandBar.InputBox = NewInstance("TextBox", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(1, -50, 1, 0),
		Position = UDim2.new(0, 40, 0, 0),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Color3.fromRGB(220, 220, 220),
		PlaceholderText = "Type a command...",
		PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
		Font = Enum.Font.GothamSemibold,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	UI.CommandBar.SuggFrame = NewInstance("Frame", {
		Parent = ScreenGui,
		Size = UDim2.new(0, 400, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, -32),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1,
		Visible = false,
	})

	NewInstance("UIListLayout", {
		Parent = UI.CommandBar.SuggFrame,
		Padding = UDim.new(0, 10),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})

	UI.CommandBar.SuggItems = {}
	for I = 1, 6 do
		local Item = NewInstance("TextButton", {
			Parent = UI.CommandBar.SuggFrame,
			Size = UDim2.new(0, 165, 0, 30),
			BackgroundColor3 = Color3.fromRGB(12, 12, 12),
			BackgroundTransparency = 0,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			AutoButtonColor = false,
			Text = "",
			Visible = false,
			LayoutOrder = I,
		})

		NewInstance("UICorner", { Parent = Item, CornerRadius = UDim.new(0, 7) })

		NewInstance("UIStroke", {
			Parent = Item,
			Color = Color3.fromRGB(45, 45, 45),
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		UI.CommandBar.SuggItems[I] = Item
	end
end

--[[ HUD ]]--
do
	local function BuildValueRow(Frame, Value, Placeholder, Tw, OnValueChanged)
		local ValueLabel = NewInstance("TextLabel", {
			Parent = Frame,
			Size = UDim2.new(0, 36, 0, 44),
			Position = UDim2.new(1, -60, 0, 0),
			BackgroundTransparency = 1,
			Text = tostring(Value),
			TextColor3 = Color3.fromRGB(140, 140, 140),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})

		local ToggleBtn = NewInstance("TextButton", {
			Parent = Frame,
			Size = UDim2.new(0, 22, 0, 22),
			Position = UDim2.new(1, -26, 0, 11),
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
			Text = "+",
			TextColor3 = Color3.fromRGB(200, 200, 200),
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			ZIndex = 5,
		})

		NewInstance("UICorner", { Parent = ToggleBtn, CornerRadius = UDim.new(0, 6) })

		local InputRow = NewInstance("Frame", {
			Parent = Frame,
			Size = UDim2.new(1, -16, 0, 38),
			Position = UDim2.new(0, 8, 0, 50),
			BackgroundColor3 = Color3.fromRGB(32, 32, 32),
			BorderSizePixel = 0,
			Visible = false,
		})

		NewInstance("UICorner", { Parent = InputRow, CornerRadius = UDim.new(0, 8) })

		NewInstance("UIStroke", {
			Parent = InputRow,
			Color = Color3.fromRGB(60, 60, 80),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		local InputBox = NewInstance("TextBox", {
			Parent = InputRow,
			Size = UDim2.new(1, -16, 1, -8),
			Position = UDim2.new(0, 8, 0, 4),
			BackgroundTransparency = 1,
			Text = tostring(Value),
			TextColor3 = Color3.fromRGB(230, 230, 230),
			Font = Enum.Font.GothamBold,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			PlaceholderText = Placeholder,
		})

		local Expanded = false

		local function SetExpanded(State)
			Expanded = State
			ToggleBtn.Text = State and "-" or "+"
			if State then
				TweenService:Create(Frame, Tw, { Size = UDim2.new(0, 130, 0, 98) }):Play()
				task.delay(0.15, function() InputRow.Visible = true end)
			else
				InputRow.Visible = false
				TweenService:Create(Frame, Tw, { Size = UDim2.new(0, 130, 0, 44) }):Play()
			end
		end

		InputBox.FocusLost:Connect(function()
			local N = tonumber(InputBox.Text)
			local V = N or InputBox.Text
			ValueLabel.Text = tostring(V)
			InputBox.Text = tostring(V)
			OnValueChanged(V)
		end)

		return ToggleBtn, ValueLabel, InputBox, SetExpanded, function() return Expanded end
	end

	function UI.HUD.MakeButton(Label, StartFn, Placeholder, DefaultValue)
		local HasValue = Placeholder ~= nil and DefaultValue ~= nil
		local Value = DefaultValue
		local Tw = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
		local Frame, NameLabel
		local Built = false
		local SetExpanded, GetExpanded

		local function Build()
			if Built then return end
			Built = true

			Frame = NewInstance("Frame", {
				Parent = ScreenGui,
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderSizePixel = 0,
				Active = true,
				Visible = false,
				ClipsDescendants = HasValue,
				Size = HasValue and UDim2.new(0, 130, 0, 44) or UDim2.new(0, 100, 0, 40),
				Position = HasValue and UDim2.new(1, -146, 0, 20) or UDim2.new(1, -120, 0, 20),
			})

			NewInstance("UICorner", { Parent = Frame, CornerRadius = UDim.new(0, 12) })

			NewInstance("UIStroke", {
				Parent = Frame,
				Color = Color3.fromRGB(100, 100, 100),
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			})

			NameLabel = NewInstance("TextLabel", {
				Parent = Frame,
				BackgroundTransparency = 1,
				Text = Label,
				TextColor3 = Color3.fromRGB(100, 100, 100),
				Font = Enum.Font.GothamBold,
				TextSize = 16,
				Size = HasValue and UDim2.new(1, -64, 0, 44) or UDim2.new(1, 0, 1, 0),
				Position = HasValue and UDim2.new(0, 10, 0, 0) or UDim2.new(0, 0, 0, 0),
				TextXAlignment = HasValue and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			})

			if HasValue then
				local ToggleBtn, _, _, SExp, GExp = BuildValueRow(Frame, Value, Placeholder, Tw, function(V)
					Value = V
				end)
				SetExpanded = SExp
				GetExpanded = GExp

				local Th = false
				ToggleBtn.Activated:Connect(function()
					Th = true
					SetExpanded(not GetExpanded())
				end)

				local ClickArea = NewInstance("TextButton", {
					Parent = Frame,
					Size = UDim2.new(1, -36, 0, 44),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 2,
				})

				UIGesture:MakeDraggable(Frame, ClickArea)

				ClickArea.Activated:Connect(function()
					if Th then Th = false return end
					StartFn(Value)
				end)
			else
				local ClickArea = NewInstance("TextButton", {
					Parent = Frame,
					Size = UDim2.new(1, -8, 1, -8),
					Position = UDim2.new(0, 4, 0, 4),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 2,
				})

				UIGesture:MakeDraggable(Frame, ClickArea)

				ClickArea.Activated:Connect(function()
					StartFn()
				end)
			end
		end

		return {
			Show = function() Build(); Frame.Visible = true end,
			Hide = function()
				if not Built then return end
				if HasValue and GetExpanded() then SetExpanded(false) end
				Frame.Visible = false
			end,
			ShowOff = function() Build(); Frame.Visible = true end,
			Destroy = function()
				if Frame then Frame:Destroy(); Frame = nil end
				Built = false
			end,
		}
	end

	function UI.HUD.MakeToggle(StartFn, StopFn, Placeholder, DefaultValue, LabelOn, LabelOff)
		local HasValue = Placeholder ~= nil and DefaultValue ~= nil
		local Active = false
		local Value = DefaultValue
		local Tw = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
		local Frame, Stroke, NameLabel, ValueLabelRef, InputBoxRef
		local Built = false
		local SetExpanded, GetExpanded

		local function Build()
			if Built then return end
			Built = true

			Frame = NewInstance("Frame", {
				Parent = ScreenGui,
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderSizePixel = 0,
				Active = true,
				Visible = false,
				ClipsDescendants = HasValue,
				Size = HasValue and UDim2.new(0, 130, 0, 44) or UDim2.new(0, 100, 0, 40),
				Position = HasValue and UDim2.new(1, -146, 0, 20) or UDim2.new(1, -120, 0, 20),
			})

			NewInstance("UICorner", { Parent = Frame, CornerRadius = UDim.new(0, 12) })

			Stroke = NewInstance("UIStroke", {
				Parent = Frame,
				Color = Color3.fromRGB(80, 220, 120),
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			})

			NameLabel = NewInstance("TextLabel", {
				Parent = Frame,
				BackgroundTransparency = 1,
				Text = LabelOn,
				TextColor3 = Color3.fromRGB(80, 220, 120),
				Font = Enum.Font.GothamBold,
				TextSize = 16,
				Size = HasValue and UDim2.new(1, -64, 0, 44) or UDim2.new(1, 0, 1, 0),
				Position = HasValue and UDim2.new(0, 10, 0, 0) or UDim2.new(0, 0, 0, 0),
				TextXAlignment = HasValue and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			})

			if HasValue then
				local ToggleBtn, SLabel, IBox, SExp, GExp = BuildValueRow(Frame, Value, Placeholder, Tw, function(V)
					Value = V
					if Active then StartFn(Value) end
				end)
				ValueLabelRef = SLabel
				InputBoxRef = IBox
				SetExpanded = SExp
				GetExpanded = GExp

				local Th = false
				ToggleBtn.Activated:Connect(function()
					Th = true
					SetExpanded(not GetExpanded())
				end)

				local ClickArea = NewInstance("TextButton", {
					Parent = Frame,
					Size = UDim2.new(1, -36, 0, 44),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 2,
				})

				UIGesture:MakeDraggable(Frame, ClickArea)

				ClickArea.Activated:Connect(function()
					if Th then Th = false return end
					Active = not Active
					local Col = Active and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(220, 70, 70)
					NameLabel.Text = Active and LabelOn or LabelOff
					TweenService:Create(Stroke, Tw, { Color = Col }):Play()
					TweenService:Create(NameLabel, Tw, { TextColor3 = Col }):Play()
					if Active then StartFn(Value) else StopFn() end
					if not Active and GetExpanded() then SetExpanded(false) end
				end)
			else
				local ClickArea = NewInstance("TextButton", {
					Parent = Frame,
					Size = UDim2.new(1, -8, 1, -8),
					Position = UDim2.new(0, 4, 0, 4),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 2,
				})

				UIGesture:MakeDraggable(Frame, ClickArea)

				ClickArea.Activated:Connect(function()
					Active = not Active
					local Col = Active and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(220, 70, 70)
					NameLabel.Text = Active and LabelOn or LabelOff
					TweenService:Create(Stroke, Tw, { Color = Col }):Play()
					TweenService:Create(NameLabel, Tw, { TextColor3 = Col }):Play()
					if Active then StartFn() else StopFn() end
				end)
			end
		end

		return {
			Show = function(NewValue)
				Build()
				if HasValue and NewValue then
					Value = tonumber(NewValue) or NewValue
					if ValueLabelRef then ValueLabelRef.Text = tostring(Value) end
					if InputBoxRef then InputBoxRef.Text = tostring(Value) end
				end
				Active = true
				Frame.Visible = true
				Stroke.Color = Color3.fromRGB(80, 220, 120)
				NameLabel.Text = LabelOn
				NameLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
				StartFn(HasValue and Value or nil)
			end,
			Hide = function()
				if not Built then return end
				Active = false
				Frame.Visible = false
				if HasValue and GetExpanded() then SetExpanded(false) end
				StopFn()
			end,
			ShowOff = function()
				Build()
				Active = false
				Frame.Visible = true
				Stroke.Color = Color3.fromRGB(220, 70, 70)
				NameLabel.Text = LabelOff
				NameLabel.TextColor3 = Color3.fromRGB(220, 70, 70)
			end,
			Destroy = function()
				if Frame then Frame:Destroy(); Frame = nil end
				Built = false
			end,
		}
	end
end

return UI
