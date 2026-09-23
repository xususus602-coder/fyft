print("[NXUS WEAL] Anti Bat")

repeat task.wait() until game:IsLoaded()

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")


pcall(function()
    for _, n in ipairs({"NXUS WEAL", "Space X Hook Anti Bat", "Space X Hook anti bat", "Space_X_Hook_Anti_Bat"}) do
        local old = PlayerGui:FindFirstChild(n)
        if old then old:Destroy() end
    end
end)

local CONFIG_FILE = "NXUS_WEAL_Config.json"

local AntiBatEnabled        = false
local InfiniteJumpEnabled   = false
local InfiniteJumpHoldEnabled = false
local IsJumpingHold         = false
local CurrentKeybind        = Enum.KeyCode.N
local WaitingForKeybind     = false
local minimized             = false

local AntiBatConn    = nil
local AntiRagdollConn = nil
local JumpHoldConn   = nil

local function saveConfig()
    local data = {
        Keybind    = CurrentKeybind.Name,
        AntiBat    = AntiBatEnabled,
        InfJump    = InfiniteJumpEnabled,
    }
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadConfig()
    local ok, result = pcall(function()
        if isfile and isfile(CONFIG_FILE) then
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
    end)
    if ok and type(result) == "table" then
        if result.Keybind and Enum.KeyCode[result.Keybind] then
            CurrentKeybind = Enum.KeyCode[result.Keybind]
        end
        if result.AntiBat ~= nil then AntiBatEnabled = result.AntiBat == true end
        if result.InfJump ~= nil then
            InfiniteJumpEnabled = result.InfJump == true
            InfiniteJumpHoldEnabled = InfiniteJumpEnabled
        end
    end
end
pcall(loadConfig)

local function startAntiBat()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if AntiBatConn then AntiBatConn:Disconnect() end
    AntiBatConn = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent then return end
        local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
        end
    end)
end

local function stopAntiBat()
    if AntiBatConn then
        AntiBatConn:Disconnect()
        AntiBatConn = nil
    end
end


local function startJumpHoldLoop()
    if JumpHoldConn then JumpHoldConn:Disconnect() end
    JumpHoldConn = RunService.Heartbeat:Connect(function()
        if not InfiniteJumpHoldEnabled or not IsJumpingHold then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = false
    end
end)

UserInputService.JumpRequest:Connect(function()
    if not InfiniteJumpEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)


local function startAntiRagdoll()
    if AntiRagdollConn then return end
    AntiRagdollConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum2 then
            local st = hum2:GetState()
            if st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                hum2:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum2
                pcall(function()
                    local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                    if pm then
                        local cm = pm:FindFirstChild("ControlModule")
                        if cm then require(cm):Enable() end
                    end
                end)
                if root then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then
                obj.Enabled = true
            end
        end
    end)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    if AntiBatEnabled then startAntiBat() end
    task.wait(0.5)
    startAntiRagdoll()
end)

local NXUS_WEAL = Instance.new("ScreenGui")
NXUS_WEAL.Name = "NXUS WEAL"
NXUS_WEAL.IgnoreGuiInset = true
NXUS_WEAL.ResetOnSpawn = false
NXUS_WEAL.DisplayOrder = 10
NXUS_WEAL.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NXUS_WEAL.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -135, 0.5, -130)
Main.Size = UDim2.new(0, 270, 0, 260)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Parent = NXUS_WEAL

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Main

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Active = true
Header.ZIndex = 2
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundTransparency = 1
Header.Parent = Main

local HeaderIcon = Instance.new("Frame")
HeaderIcon.Name = "HeaderIcon"
HeaderIcon.ZIndex = 5
HeaderIcon.Position = UDim2.new(0, 16, 0.5, -5)
HeaderIcon.Size = UDim2.new(0, 10, 0, 10)
HeaderIcon.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
HeaderIcon.BorderSizePixel = 0
HeaderIcon.Parent = Header
Instance.new("UICorner", HeaderIcon).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.ZIndex = 5
Title.Position = UDim2.new(0, 36, 0, 6)
Title.Size = UDim2.new(1, -130, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "NXUS WEAL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.ZIndex = 5
SubTitle.Position = UDim2.new(0, 36, 0, 26)
SubTitle.Size = UDim2.new(1, -130, 0, 14)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "ANTI BAT"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.ZIndex = 5
MinBtn.AnchorPoint = Vector2.new(1, 0.5)
MinBtn.Position = UDim2.new(1, -12, 0.5, 0)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.ZIndex = 2
ContentHolder.ClipsDescendants = true
ContentHolder.Position = UDim2.new(0, 0, 0, 48)
ContentHolder.Size = UDim2.new(1, 0, 1, -48)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.ZIndex = 2
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = ContentHolder

local StatusRow = Instance.new("Frame")
StatusRow.Name = "StatusRow"
StatusRow.ZIndex = 4
StatusRow.Position = UDim2.new(0, 12, 0, 6)
StatusRow.Size = UDim2.new(1, -24, 0, 32)
StatusRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusRow.BackgroundTransparency = 0.5
StatusRow.Parent = Content
Instance.new("UICorner", StatusRow).CornerRadius = UDim.new(0, 12)

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.ZIndex = 6
StatusDot.Position = UDim2.new(0, 14, 0.5, -4)
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusRow
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.ZIndex = 6
StatusLabel.Position = UDim2.new(0, 30, 0, 0)
StatusLabel.Size = UDim2.new(0, 100, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusRow

local StatusValue = Instance.new("TextLabel")
StatusValue.Name = "StatusValue"
StatusValue.ZIndex = 6
StatusValue.Position = UDim2.new(1, -114, 0, 0)
StatusValue.Size = UDim2.new(0, 100, 1, 0)
StatusValue.BackgroundTransparency = 1
StatusValue.Text = "INACTIVE"
StatusValue.TextColor3 = Color3.fromRGB(255, 70, 90)
StatusValue.TextSize = 14
StatusValue.Font = Enum.Font.GothamBlack
StatusValue.TextXAlignment = Enum.TextXAlignment.Right
StatusValue.Parent = StatusRow


local AntiBatRow = Instance.new("Frame")
AntiBatRow.Name = "AntiBatRow"
AntiBatRow.ZIndex = 4
AntiBatRow.Position = UDim2.new(0, 12, 0, 46)
AntiBatRow.Size = UDim2.new(1, -24, 0, 50)
AntiBatRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AntiBatRow.BackgroundTransparency = 0.5
AntiBatRow.Parent = Content
Instance.new("UICorner", AntiBatRow).CornerRadius = UDim.new(0, 12)

local AntiBatLabel = Instance.new("TextLabel")
AntiBatLabel.Name = "AntiBatLabel"
AntiBatLabel.ZIndex = 6
AntiBatLabel.Position = UDim2.new(0, 14, 0.5, -8)
AntiBatLabel.Size = UDim2.new(0, 150, 0, 18)
AntiBatLabel.BackgroundTransparency = 1
AntiBatLabel.Text = "Anti Bat"
AntiBatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiBatLabel.TextSize = 14
AntiBatLabel.Font = Enum.Font.GothamBlack
AntiBatLabel.TextXAlignment = Enum.TextXAlignment.Left
AntiBatLabel.Parent = AntiBatRow

local ToggleBg = Instance.new("Frame")
ToggleBg.Name = "ToggleBg"
ToggleBg.ZIndex = 6
ToggleBg.Position = UDim2.new(1, -58, 0.5, -11)
ToggleBg.Size = UDim2.new(0, 44, 0, 22)
ToggleBg.BackgroundColor3 = Color3.fromRGB(52, 52, 58)
ToggleBg.BorderSizePixel = 0
ToggleBg.Parent = AntiBatRow
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local ToggleDot = Instance.new("Frame")
ToggleDot.Name = "ToggleDot"
ToggleDot.ZIndex = 7
ToggleDot.Position = UDim2.new(0, 3, 0.5, -8)
ToggleDot.Size = UDim2.new(0, 16, 0, 16)
ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleDot.BorderSizePixel = 0
ToggleDot.Parent = ToggleBg
Instance.new("UICorner", ToggleDot).CornerRadius = UDim.new(1, 0)

local AntiBatClick = Instance.new("TextButton")
AntiBatClick.Name = "AntiBatClick"
AntiBatClick.ZIndex = 10
AntiBatClick.Position = UDim2.new(1, -65, 0, 0)
AntiBatClick.Size = UDim2.new(0, 50, 0, 50)
AntiBatClick.BackgroundTransparency = 1
AntiBatClick.Text = ""
AntiBatClick.Parent = AntiBatRow

local InfJumpRow = Instance.new("Frame")
InfJumpRow.Name = "InfJumpRow"
InfJumpRow.ZIndex = 4
InfJumpRow.Position = UDim2.new(0, 12, 0, 104)
InfJumpRow.Size = UDim2.new(1, -24, 0, 50)
InfJumpRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InfJumpRow.BackgroundTransparency = 0.5
InfJumpRow.Parent = Content
Instance.new("UICorner", InfJumpRow).CornerRadius = UDim.new(0, 12)

local InfJumpLabel = Instance.new("TextLabel")
InfJumpLabel.Name = "InfJumpLabel"
InfJumpLabel.ZIndex = 6
InfJumpLabel.Position = UDim2.new(0, 14, 0.5, -8)
InfJumpLabel.Size = UDim2.new(0, 150, 0, 18)
InfJumpLabel.BackgroundTransparency = 1
InfJumpLabel.Text = "Inf Jump"
InfJumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpLabel.TextSize = 14
InfJumpLabel.Font = Enum.Font.GothamBlack
InfJumpLabel.TextXAlignment = Enum.TextXAlignment.Left
InfJumpLabel.Parent = InfJumpRow

local InfToggleBg = Instance.new("Frame")
InfToggleBg.Name = "InfToggleBg"
InfToggleBg.ZIndex = 6
InfToggleBg.Position = UDim2.new(1, -58, 0.5, -11)
InfToggleBg.Size = UDim2.new(0, 44, 0, 22)
InfToggleBg.BackgroundColor3 = Color3.fromRGB(52, 52, 58)
InfToggleBg.BorderSizePixel = 0
InfToggleBg.Parent = InfJumpRow
Instance.new("UICorner", InfToggleBg).CornerRadius = UDim.new(1, 0)

local InfToggleDot = Instance.new("Frame")
InfToggleDot.Name = "InfToggleDot"
InfToggleDot.ZIndex = 7
InfToggleDot.Position = UDim2.new(0, 3, 0.5, -8)
InfToggleDot.Size = UDim2.new(0, 16, 0, 16)
InfToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfToggleDot.BorderSizePixel = 0
InfToggleDot.Parent = InfToggleBg
Instance.new("UICorner", InfToggleDot).CornerRadius = UDim.new(1, 0)

local InfJumpClick = Instance.new("TextButton")
InfJumpClick.Name = "InfJumpClick"
InfJumpClick.ZIndex = 10
InfJumpClick.Position = UDim2.new(1, -65, 0, 0)
InfJumpClick.Size = UDim2.new(0, 50, 0, 50)
InfJumpClick.BackgroundTransparency = 1
InfJumpClick.Text = ""
InfJumpClick.Parent = InfJumpRow

local KeybindRow = Instance.new("Frame")
KeybindRow.Name = "KeybindRow"
KeybindRow.ZIndex = 4
KeybindRow.Position = UDim2.new(0, 12, 0, 162)
KeybindRow.Size = UDim2.new(1, -24, 0, 32)
KeybindRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeybindRow.BackgroundTransparency = 0.5
KeybindRow.Parent = Content
Instance.new("UICorner", KeybindRow).CornerRadius = UDim.new(0, 12)

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.ZIndex = 6
KeybindLabel.Position = UDim2.new(0, 14, 0, 0)
KeybindLabel.Size = UDim2.new(0, 80, 1, 0)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Keybind"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.TextSize = 12
KeybindLabel.Font = Enum.Font.GothamBlack
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Parent = KeybindRow

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Name = "KeybindBtn"
KeybindBtn.ZIndex = 10
KeybindBtn.AnchorPoint = Vector2.new(1, 0.5)
KeybindBtn.Position = UDim2.new(1, -14, 0.5, 0)
KeybindBtn.Size = UDim2.new(0, 50, 0, 20)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeybindBtn.BackgroundTransparency = 0.5
KeybindBtn.Text = CurrentKeybind.Name
KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindBtn.TextSize = 12
KeybindBtn.Font = Enum.Font.GothamBlack
KeybindBtn.AutoButtonColor = false
KeybindBtn.Parent = KeybindRow
Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 6)

local function setToggle(knob, bg, enabled)
    TweenService:Create(knob, TweenInfo.new(0.15), {
        Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = enabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255),
    }):Play()
    TweenService:Create(bg, TweenInfo.new(0.15), {
        BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(52, 52, 58),
    }):Play()
end

local function updateStatus()
   
    local anyOn = AntiBatEnabled or InfiniteJumpEnabled
    if anyOn then
        StatusValue.Text = "ACTIVE"
        StatusValue.TextColor3 = Color3.fromRGB(80, 255, 100)
        StatusDot.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
    else
        StatusValue.Text = "INACTIVE"
        StatusValue.TextColor3 = Color3.fromRGB(255, 70, 90)
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
    end
end

local function setAntiBat(on)
    AntiBatEnabled = on == true
    if AntiBatEnabled then
        startAntiBat()
    else
        stopAntiBat()
    end
    setToggle(ToggleDot, ToggleBg, AntiBatEnabled)
    updateStatus()
    saveConfig()
end

local function setInfJump(on)
    InfiniteJumpEnabled = on == true
    InfiniteJumpHoldEnabled = InfiniteJumpEnabled
    if not InfiniteJumpHoldEnabled then IsJumpingHold = false end
    setToggle(InfToggleDot, InfToggleBg, InfiniteJumpEnabled)
    updateStatus()
    saveConfig()
end

AntiBatClick.MouseButton1Click:Connect(function()
    setAntiBat(not AntiBatEnabled)
end)

InfJumpClick.MouseButton1Click:Connect(function()
    setInfJump(not InfiniteJumpEnabled)
end)

KeybindBtn.MouseButton1Click:Connect(function()
    if WaitingForKeybind then return end
    WaitingForKeybind = true
    KeybindBtn.Text = "..."
    KeybindBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if WaitingForKeybind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            CurrentKeybind = input.KeyCode
            WaitingForKeybind = false
            KeybindBtn.Text = CurrentKeybind.Name
            KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            saveConfig()
        end
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == CurrentKeybind then
        setAntiBat(not AntiBatEnabled)
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentHolder.Visible = false
        Main.Size = UDim2.new(0, 270, 0, 48)
        MinBtn.Text = "+"
    else
        ContentHolder.Visible = true
        Main.Size = UDim2.new(0, 270, 0, 260)
        MinBtn.Text = "-"
    end
end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)


startAntiRagdoll()
startJumpHoldLoop()
setToggle(ToggleDot, ToggleBg, AntiBatEnabled)
setToggle(InfToggleDot, InfToggleBg, InfiniteJumpEnabled)
updateStatus()
if AntiBatEnabled then startAntiBat() end
KeybindBtn.Text = CurrentKeybind.Name

print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
print("[NOXA DUELS DEOBFS Space X Hook] Anti Bat ")
