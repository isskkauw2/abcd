if not game:IsLoaded() then game.Loaded:Wait() end

local Cloneref = (cloneref or clonereference or function(Instance) return Instance end)
local HttpService = Cloneref(game:GetService("HttpService"))

local function Load(Url, FileName)
	local Loader = (type(loadstring) == "function" and loadstring) or (type(load) == "function" and load)
	if not Loader then error("Load: this executor does not provide loadstring/load") end

	local function FetchRaw(FetchUrl)
		for _, Attempt in ipairs({
			function() return game:HttpGet(FetchUrl) end,
			function() return HttpService:GetAsync(FetchUrl) end,
			function() local ReqFn = (type(request) == "function" and request) or (type(http_request) == "function" and http_request) or (type(syn) == "table" and type(syn.request) == "function" and syn.request) or (type(http) == "table" and type(http.request) == "function" and http.request); return ReqFn and ReqFn({ Url = FetchUrl, Method = "GET" }).Body end,
		}) do
			local Ok, Res = pcall(Attempt)
			if Ok and Res and Res ~= "" then return Res end
		end
		error("Load: all fetch methods are not supported")
	end

	local function FetchJSON(FetchUrl)
		local Ok, Decoded = pcall(HttpService.JSONDecode, HttpService, FetchRaw(FetchUrl)); return Ok and Decoded or nil
	end

	local function LoadCachedFile(Path)
		local Chunk, Err
		if type(loadfile) == "function" then Chunk, Err = loadfile(Path) else
			local Ok, Raw = pcall(readfile, Path)
			if not Ok then warn("Load: failed to read cache (" .. FileName .. "): " .. tostring(Raw)); return nil, Raw end
			Chunk, Err = Loader(Raw)
		end
		if not Chunk then warn("Load: cached " .. FileName .. " failed to compile: " .. tostring(Err)); return nil, Err end
		local Ok, Result = pcall(Chunk); if not Ok then warn("Load: cached " .. FileName .. " failed to run: " .. tostring(Result)); return nil, Result end
		return Result
	end

	local FileSystemApiSupport = writefile and isfile and makefolder and isfolder and (type(loadfile) == "function" or type(readfile) == "function")
	if FileSystemApiSupport and not isfolder("LoadCache") then makefolder("LoadCache") end

	local Hash = 5381
	for I = 1, #Url do Hash = ((Hash * 33) + string.byte(Url, I)) % 4294967296 end
	local Path = "LoadCache/" .. string.format("%08x", Hash) .. "_" .. FileName:gsub("[^%w%.%-]", "_")
	local SidecarPath = Path .. ".meta.lua"

	local GhSha, JsdHash
	if FileSystemApiSupport then
		local Owner, Repo, Branch, FilePath = Url:gsub("/refs/heads/", "/"):gsub("/refs/tags/", "/"):match("raw%.githubusercontent%.com/([^/]+)/([^/]+)/([^/]+)/(.+)")

		if Owner then
			local GhData = FetchJSON("https://api.github.com/repos/" .. Owner .. "/" .. Repo .. "/contents/" .. FilePath .. "?ref=" .. Branch); GhSha = type(GhData) == "table" and GhData.sha

			local JsdData = FetchJSON("https://data.jsdelivr.com/v1/package/gh/" .. Owner .. "/" .. Repo .. "@" .. Branch .. "/flat")
			if type(JsdData) == "table" and type(JsdData.files) == "table" then
				for _, File in ipairs(JsdData.files) do
					if File.name == "/" .. FilePath then JsdHash = File.hash; break end
				end
			end
		end

		if (GhSha or JsdHash) and isfile(Path) and isfile(SidecarPath) then
			local Meta = LoadCachedFile(SidecarPath)
			if type(Meta) == "table" and ((GhSha and Meta.gh == GhSha) or (JsdHash and Meta.jsd == JsdHash)) then
				local Result, Err = LoadCachedFile(Path)
				if Result ~= nil or Err == nil then return Result end
			end
		end
	end

	while true do
		local Result = FetchRaw(Url)
		if Result then
			if FileSystemApiSupport then
				pcall(writefile, Path, Result)
				if GhSha or JsdHash then pcall(writefile, SidecarPath, string.format("return {gh=%q,jsd=%q}", tostring(GhSha), tostring(JsdHash))) end
			end

			local Chunk, CompileErr = Loader(Result)
			if not Chunk then error("Load: failed to compile " .. FileName .. ": " .. tostring(CompileErr)) end
			return Chunk()
		end
		warn("Load: fetch failed for " .. FileName .. ", retrying in 2s...")
		task.wait(2)
	end
end

--[[ Services ]]--
local Players = Cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer

--[[ Variables ]]--
local UIGesture = Load("https://raw.githubusercontent.com/isskkauww/Modules/refs/heads/main/UIGesture.luau", "UIGesture.luau")

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
})

UI.CommandBar = {}

UI.CommandBar.Frame = NewInstance("Frame", {
	Parent = ScreenGui,
	Size = UDim2.new(0, 0, 0, 48),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(12, 12, 12),
	BackgroundTransparency = 0.129,
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
		BackgroundTransparency = 0.08,
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
	Position = UDim2.new(0.5, 0, 0.07, 0),
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
