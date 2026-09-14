if not game:IsLoaded() then game.Loaded:Wait() end
local Cloneref = (cloneref or clonereference or function(Instance) return Instance end)

--[[ Services ]]--
local Players = Cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer

--[[ Variables ]]--
local UIGesture = loadstring(game:HttpGet("https://raw.githubusercontent.com/isskkauww/Modules/refs/heads/main/UIGesture.luau"))()

local UI = {}

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

UI.CommandBar = {}

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

UI.Toggle = {}

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

return UI
