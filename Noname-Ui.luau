if not game:IsLoaded() then game.Loaded:Wait() end
local Cloneref = (cloneref or clonereference or function(Instance) return Instance end)

--[[ Services ]]--
local Players = Cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local TweenService = Cloneref(game:GetService("TweenService"))
local UserInputService = Cloneref(game:GetService("UserInputService"))

--[[ Variables ]]--
local UIGesture = loadstring(game:HttpGet("https://raw.githubusercontent.com/isskkauww/Modules/refs/heads/main/UIGesture.luau"))()
local ToggleBusy = false
local IsMobile = UserInputService:GetPlatform() == Enum.Platform.Android or UserInputService:GetPlatform() == Enum.Platform.IOS

local UI = {
	CommandBar = {},
	HUD = {},
}
UI.CmdOpen = false

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

UI.AutoScale = NewInstance("UIScale", { Parent = ScreenGui })

--[[ Toggle ]]--
do
	local ToggleButton = NewInstance("TextButton", {
		Parent = ScreenGui,
		BackgroundColor3 = Color3.fromRGB(46, 46, 47),
		BackgroundTransparency = 0.14,
		Position = UDim2.new(0.489, 0, 0.07, 0),
		Size = UDim2.new(0, 0, 0, 0),
		Font = Enum.Font.SourceSansBold,
		Text = "NN",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 20,
		TextTransparency = 1,
		Visible = false,
		ZIndex = 10,
	})

	UI.ToggleButton = ToggleButton

	NewInstance("UICorner", { Parent = ToggleButton, CornerRadius = UDim.new(0.5, 0) })

	UIGesture:MakeDraggable(ToggleButton)

	function UI.PlayToggleSpawn()
		ToggleButton.Visible = true
		TweenService:Create(ToggleButton, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = UDim2.new(0, 32, 0, 33), TextTransparency = 0 }):Play()
		TweenService:Create(ToggleButton, TweenInfo.new(1.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Rotation = 720 }):Play()
	end

	ToggleButton.Activated:Connect(function()
		if ToggleBusy then return end
		ToggleBusy = true

		local TweenPress = TweenService:Create(ToggleButton, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 32 * 0.78, 0, 33 * 0.78) })
		local TweenRelease = TweenService:Create(ToggleButton, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 32, 0, 33) })

		TweenPress:Play()
		TweenPress.Completed:Wait()
		TweenRelease:Play()
		if not UI.CmdOpen then
			UI.CommandBar.Open()
		end
		TweenRelease.Completed:Wait()
		ToggleBusy = false
	end)
end

--[[ CommandBar ]]--
do
	local BarWidth = 520
	local RowHeight = 38
	UI.CommandBar.SuggLimit = 5

	UI.CommandBar.Frame = NewInstance("Frame", {
		Parent = ScreenGui,
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 20,
	})

	local Shell = NewInstance("Frame", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(13, 13, 15),
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		ZIndex = 20,
	})

	NewInstance("UICorner", { Parent = Shell, CornerRadius = UDim.new(0, 12) })

	NewInstance("UIGradient", {
		Parent = Shell,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 23)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 12)),
		}),
	})

	local CmdOutline = NewInstance("UIStroke", {
		Parent = Shell,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(235, 235, 240),
		Thickness = 1.25,
		Transparency = 0.58,
	})

	NewInstance("TextLabel", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(0, 18, 0, 22),
		Position = UDim2.new(0, 15, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Text = ">",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 18,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		ZIndex = 24,
	})

	UI.CommandBar.InputBox = NewInstance("TextBox", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(1, -207, 1, 0),
		Position = UDim2.new(0, 43, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		TextColor3 = Color3.fromRGB(246, 246, 248),
		PlaceholderText = "Type a command...",
		PlaceholderColor3 = Color3.fromRGB(130, 130, 138),
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = false,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		ZIndex = 23,
	})

	UI.CommandBar.Enter = NewInstance("TextButton", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(0, 52, 0, 22),
		Position = UDim2.new(1, -12, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(31, 31, 35),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "ENTER",
		TextColor3 = Color3.fromRGB(196, 196, 204),
		TextSize = 9,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		ZIndex = 24,
	})

	NewInstance("UICorner", { Parent = UI.CommandBar.Enter, CornerRadius = UDim.new(0, 5) })

	NewInstance("UIStroke", {
		Parent = UI.CommandBar.Enter,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(255, 255, 255),
		Thickness = 1,
		Transparency = 0.78,
	})

	UI.CommandBar.Prediction = NewInstance("TextBox", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(1, -207, 1, 0),
		Position = UDim2.new(0, 43, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		TextColor3 = Color3.fromRGB(155, 155, 164),
		TextTransparency = 0.55,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = false,
		TextEditable = false,
		Active = false,
		Selectable = false,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 22,
	})

	UI.CommandBar.Tab = NewInstance("TextLabel", {
		Parent = UI.CommandBar.Frame,
		Size = UDim2.new(0, 82, 0, 22),
		Position = UDim2.new(1, -70, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(27, 27, 31),
		BackgroundTransparency = 0.18,
		BorderSizePixel = 0,
		Text = "TAB  AUTOFILL",
		TextColor3 = Color3.fromRGB(150, 150, 158),
		TextSize = 9,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		ZIndex = 24,
	})

	NewInstance("UICorner", { Parent = UI.CommandBar.Tab, CornerRadius = UDim.new(0, 5) })

	local TabOutline = NewInstance("UIStroke", {
		Parent = UI.CommandBar.Tab,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(255, 255, 255),
		Thickness = 1,
		Transparency = 0.86,
	})

	local function SyncPrediction()
		local Has = UI.CommandBar.Prediction.Text ~= "" and UI.CommandBar.Prediction.Text ~= UI.CommandBar.InputBox.Text
		UI.CommandBar.Prediction.Visible = Has
		UI.CommandBar.Tab.TextColor3 = Has and Color3.fromRGB(245, 245, 248) or Color3.fromRGB(150, 150, 158)
		UI.CommandBar.Tab.BackgroundColor3 = Has and Color3.fromRGB(42, 42, 47) or Color3.fromRGB(27, 27, 31)
		UI.CommandBar.Tab.BackgroundTransparency = Has and 0.04 or 0.18
		TabOutline.Transparency = Has and 0.52 or 0.86
	end

	UI.CommandBar.Prediction:GetPropertyChangedSignal("Text"):Connect(SyncPrediction)
	UI.CommandBar.InputBox:GetPropertyChangedSignal("Text"):Connect(SyncPrediction)

	UI.CommandBar.SuggFrame = NewInstance("Frame", {
		Parent = ScreenGui,
		Size = UDim2.new(0, 520, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, -33),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 18,
	})

	NewInstance("UIPadding", {
		Parent = UI.CommandBar.SuggFrame,
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
	})

	NewInstance("UIListLayout", {
		Parent = UI.CommandBar.SuggFrame,
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	UI.CommandBar.SuggItems = {}

	local function RefreshSugg()
		local Count = 0
		for _, Item in ipairs(UI.CommandBar.SuggItems) do
			if Item.Visible then
				Count += 1
			end
		end

		local Target = UDim2.new(0, BarWidth, 0, 16 + Count * RowHeight + (Count - 1) * 6)
		if UI.CommandBar.SuggFrame.Visible then
			TweenService:Create(UI.CommandBar.SuggFrame, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = Target }):Play()
		else
			UI.CommandBar.SuggFrame.Size = Target
		end
	end

	UI.CommandBar.SuggFrame:GetPropertyChangedSignal("Visible"):Connect(RefreshSugg)

	for I = 1, 5 do
		local Row = NewInstance("Frame", {
			Parent = UI.CommandBar.SuggFrame,
			Size = UDim2.new(1, -16, 0, 38),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = I,
			Visible = false,
			ZIndex = 19,
		})

		local RowShell = NewInstance("Frame", {
			Parent = Row,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 27),
			BackgroundTransparency = 0.2,
			BorderSizePixel = 0,
			ZIndex = 20,
		})

		NewInstance("UICorner", { Parent = RowShell, CornerRadius = UDim.new(0, 8) })

		NewInstance("UIGradient", {
			Parent = RowShell,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 34)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(19, 19, 22)),
			}),
		})

		local RowStroke = NewInstance("UIStroke", {
			Parent = RowShell,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(225, 225, 232),
			Thickness = 1,
			Transparency = 0.76,
		})

		local RowLine = NewInstance("Frame", {
			Parent = RowShell,
			Size = UDim2.new(0, 2, 1, -16),
			Position = UDim2.new(0, 7, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(245, 245, 248),
			BackgroundTransparency = 0.42,
			BorderSizePixel = 0,
			ZIndex = 21,
		})

		NewInstance("UICorner", { Parent = RowLine, CornerRadius = UDim.new(0, 3) })

		local Item = NewInstance("TextButton", {
			Parent = Row,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			TextColor3 = Color3.fromRGB(232, 232, 236),
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = false,
			ClipsDescendants = true,
			Visible = false,
			ZIndex = 22,
		})

		NewInstance("UIPadding", {
			Parent = Item,
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 14),
		})

		local function Reveal()
			RowShell.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
			RowShell.BackgroundTransparency = 0.2
			RowStroke.Transparency = 0.76
			RowLine.BackgroundTransparency = 0.42
			Row.Size = UDim2.new(0.96, -16, 0, RowHeight - 2)
			TweenService:Create(Row, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, -16, 0, RowHeight) }):Play()
		end

		local function Hover(Active)
			local Info = TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			TweenService:Create(RowShell, Info, {
				BackgroundColor3 = Active and Color3.fromRGB(38, 38, 43) or Color3.fromRGB(24, 24, 27),
				BackgroundTransparency = Active and 0.08 or 0.2,
			}):Play()
			TweenService:Create(RowStroke, Info, { Transparency = Active and 0.28 or 0.76 }):Play()
			TweenService:Create(RowLine, Info, { BackgroundTransparency = Active and 0.05 or 0.42 }):Play()
			if Active then
				UI.CommandBar.InputBox:CaptureFocus()
			end
		end

		UIGesture:MakeHoverable(Item, nil, Hover)

		Item:GetPropertyChangedSignal("Visible"):Connect(function()
			Row.Visible = Item.Visible
			if Item.Visible then
				Reveal()
			end
			RefreshSugg()
		end)

		Item:GetPropertyChangedSignal("Text"):Connect(function()
			if Item.Visible and Item.Text ~= "" then
				Reveal()
			end
		end)

		UI.CommandBar.SuggItems[I] = Item
	end

	local function ResetRows()
		for _, Item in ipairs(UI.CommandBar.SuggItems) do
			Item.Parent.Size = UDim2.new(1, -16, 0, RowHeight)
		end
	end

	local function Relayout()
		local ScreenSize = ScreenGui.AbsoluteSize
		local Scale = math.max(UI.AutoScale.Scale, 0.01)
		BarWidth = math.min(520, math.max(280, math.floor((ScreenSize.X - 24) / Scale + 0.5)))

		local Compact = IsMobile and ScreenSize.Y < 620
		UI.CommandBar.SuggLimit = Compact and 3 or 5
		RowHeight = Compact and 40 or 38

		local Clearance = IsMobile and 76 or 164
		UI.CommandBar.InputBox.Size = UDim2.new(1, -(43 + Clearance), 1, 0)
		UI.CommandBar.Prediction.Size = UI.CommandBar.InputBox.Size
		UI.CommandBar.Tab.Visible = not IsMobile

		if UI.CmdOpen then
			UI.CommandBar.Frame.Size = UDim2.new(0, BarWidth, 0, 46)
		end

		ResetRows()
		RefreshSugg()
	end

	ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(Relayout)
	UI.AutoScale:GetPropertyChangedSignal("Scale"):Connect(Relayout)
	Relayout()

	function UI.CommandBar.Open()
		UI.CmdOpen = true
		ResetRows()
		UI.CommandBar.InputBox.Text = ""
		UI.CommandBar.Frame.Visible = true
		UI.CommandBar.Frame.Size = UDim2.new(0, BarWidth - 36, 0, 44)
		TweenService:Create(CmdOutline, TweenInfo.new(0.108, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Transparency = 0.18 }):Play()
		TweenService:Create(UI.CommandBar.Enter, TweenInfo.new(0.108, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			TextColor3 = Color3.fromRGB(245, 245, 248),
			BackgroundColor3 = Color3.fromRGB(40, 40, 45),
		}):Play()
		TweenService:Create(UI.CommandBar.Frame, TweenInfo.new(0.108, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, BarWidth, 0, 46) }):Play()
		task.delay(0.1, function()
			UI.CommandBar.InputBox:CaptureFocus()
		end)
	end

	function UI.CommandBar.Close()
		UI.CmdOpen = false
		TweenService:Create(CmdOutline, TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Transparency = 0.58 }):Play()
		TweenService:Create(UI.CommandBar.Enter, TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			TextColor3 = Color3.fromRGB(196, 196, 204),
			BackgroundColor3 = Color3.fromRGB(31, 31, 35),
		}):Play()

		for _, Item in ipairs(UI.CommandBar.SuggItems) do
			if Item.Visible then
				TweenService:Create(Item.Parent, TweenInfo.new(0.12, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), { Size = UDim2.new(0.96, -16, 0, 34) }):Play()
			end
		end

		task.delay(0.14, function()
			if UI.CmdOpen then return end
			UI.CommandBar.SuggFrame.Visible = false
			ResetRows()
		end)

		local CloseTween = TweenService:Create(UI.CommandBar.Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 0, 0, 0) })
		CloseTween.Completed:Connect(function()
			if not UI.CmdOpen then
				UI.CommandBar.Frame.Visible = false
			end
		end)
		CloseTween:Play()
	end
end

--[[ HUD ]]--
do
	local function BuildValueRow(Frame, Value, Placeholder, Tw, OnValueChanged, Numeric)
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

		local InputStroke = NewInstance("UIStroke", {
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

		if Numeric then
			local LastText = InputBox.Text
			InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				if InputBox.Text ~= "" and not tonumber(InputBox.Text) then
					InputBox.Text = LastText
				else
					LastText = InputBox.Text
				end
			end)
		end

		InputBox.Focused:Connect(function()
			TweenService:Create(InputStroke, TweenInfo.new(1.2), { Color = Color3.fromRGB(0, 191, 255) }):Play()
		end)

		InputBox.FocusLost:Connect(function()
			TweenService:Create(InputStroke, TweenInfo.new(1.2), { Color = Color3.fromRGB(60, 60, 80) }):Play()

			local N = tonumber(InputBox.Text)
			local V = N or InputBox.Text
			ValueLabel.Text = tostring(V)
			InputBox.Text = tostring(V)
			OnValueChanged(V)
		end)

		return ToggleBtn, ValueLabel, InputBox, SetExpanded, function() return Expanded end
	end

	function UI.HUD.MakeButton(Label, StartFn, Placeholder, DefaultValue, Numeric)
		Numeric = Numeric ~= false
		local HasValue = Placeholder ~= nil and DefaultValue ~= nil
		local Value = DefaultValue
		local Tw = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
		local Frame, NameLabel, Hud
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
				Position = UDim2.new(0.8, 0, 0.3, 0),
			})
			Hud.Frame = Frame

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
				end, Numeric)
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
					StartFn(Value, true)
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
					StartFn(nil, true)
				end)
			end
		end

		Hud = {
			Show = function() Build(); Frame.Visible = true end,
			Hide = function()
				if not Built then return end
				if HasValue and GetExpanded() then SetExpanded(false) end
				Frame.Visible = false
			end,
			ShowOff = function() Build(); Frame.Visible = true end,
			Destroy = function()
				if Frame then Frame:Destroy(); Frame = nil; Hud.Frame = nil end
				Built = false
			end,
		}

		return Hud
	end

	function UI.HUD.MakeToggle(StartFn, StopFn, Placeholder, DefaultValue, LabelOn, LabelOff, Numeric)
		Numeric = Numeric ~= false
		local HasValue = Placeholder ~= nil and DefaultValue ~= nil
		local Active = false
		local Value = DefaultValue
		local Tw = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
		local Frame, Stroke, NameLabel, ValueLabelRef, InputBoxRef, Hud
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
				Position = UDim2.new(0.8, 0, 0.3, 0),
			})
			Hud.Frame = Frame

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
					if Active then StartFn(Value, true) end
				end, Numeric)
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
					if Active then StartFn(Value, true) else StopFn(true) end
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
					if Active then StartFn(nil, true) else StopFn(true) end
				end)
			end
		end

		Hud = {
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
				if Frame then Frame:Destroy(); Frame = nil; Hud.Frame = nil end
				Built = false
			end,
		}

		return Hud
	end
end

return UI
