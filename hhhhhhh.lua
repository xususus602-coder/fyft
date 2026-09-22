local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()


local UI_COLORS = {
    Background = Color3.fromRGB(8, 8, 8),
    BackgroundDark = Color3.fromRGB(5, 5, 5),
    BackgroundMedium = Color3.fromRGB(15, 15, 15),
    BackgroundInput = Color3.fromRGB(10, 10, 10),
    BackgroundButton = Color3.fromRGB(20, 20, 20),
    BackgroundButtonLight = Color3.fromRGB(30, 30, 30),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextAccent = Color3.fromRGB(0, 255, 100),
    StrokeDefault = Color3.fromRGB(80, 80, 80),
    StrokeDark = Color3.fromRGB(70, 70, 70),
    StrokeInput = Color3.fromRGB(60, 60, 60),
    Accent = Color3.fromRGB(0, 200, 80),
    EnabledColor = Color3.fromRGB(0, 255, 100),
    ActiveStroke = Color3.fromRGB(255, 0, 0),
}


local Config = {
    Enabled = false,
    PowerValue = 97000,
    DepthValue = 296,
    Mode = "PC",
    ToggleKey = Enum.KeyCode.V,
    BackgroundVisible = true,
    WindowSizeIndex = 6,
    IsVisible = true,
}


local CONFIG_FILE = "MMA_SpeedBypass.json"

local function saveConfig()
    pcall(function()
        if not writefile then return end
        local data = {
            Enabled = Config.Enabled,
            PowerValue = Config.PowerValue,
            DepthValue = Config.DepthValue,
            Mode = Config.Mode,
            ToggleKey = Config.ToggleKey and Config.ToggleKey.Name or "V",
            BackgroundVisible = Config.BackgroundVisible,
            WindowSizeIndex = Config.WindowSizeIndex,
            IsVisible = Config.IsVisible,
        }
        local encoded = game:GetService("HttpService"):JSONEncode(data)
        writefile(CONFIG_FILE, encoded)
    end)
end

local function loadConfig()
    pcall(function()
        if not (isfile and readfile) then return end
        if not isfile(CONFIG_FILE) then return end
        local raw = readfile(CONFIG_FILE)
        if not raw or raw == "" then return end
        local data = game:GetService("HttpService"):JSONDecode(raw)
        if type(data) ~= "table" then return end

        if type(data.Enabled) == "boolean" then Config.Enabled = data.Enabled end
        if type(data.PowerValue) == "number" then Config.PowerValue = data.PowerValue end
        if type(data.DepthValue) == "number" then Config.DepthValue = data.DepthValue end
        if type(data.Mode) == "string" then Config.Mode = data.Mode end
        if type(data.BackgroundVisible) == "boolean" then Config.BackgroundVisible = data.BackgroundVisible end
        if type(data.WindowSizeIndex) == "number" then
            Config.WindowSizeIndex = math.clamp(data.WindowSizeIndex, 1, 10)
        end
        if type(data.IsVisible) == "boolean" then Config.IsVisible = data.IsVisible end

        if type(data.ToggleKey) == "string" then
            pcall(function()
                Config.ToggleKey = Enum.KeyCode[data.ToggleKey] or Enum.KeyCode.V
            end)
        end
    end)
end


loadConfig()


local DEPTH = Config.DepthValue
local SPAM_DELAY = 0.12
local running = false
local bomb = nil
local spamThread = nil
local startedAt = 0


local WINDOW_SIZES = {
    { Size = UDim2.new(0, 220, 0, 180) },
    { Size = UDim2.new(0, 230, 0, 205) },
    { Size = UDim2.new(0, 250, 0, 210) },
    { Size = UDim2.new(0, 260, 0, 235) },
    { Size = UDim2.new(0, 280, 0, 240) },
    { Size = UDim2.new(0, 290, 0, 265) },
    { Size = UDim2.new(0, 310, 0, 270) },
    { Size = UDim2.new(0, 320, 0, 295) },
    { Size = UDim2.new(0, 260, 0, 235) },
    { Size = UDim2.new(0, 230, 0, 205) },
}


local BG_URL = ""
local BG_FILE = "MMA_SpeedBypassBG.png"
local BG_ASSET = nil

local function resolveBg()
    if BG_ASSET then return BG_ASSET end
    pcall(function()
        if writefile and (game.HttpGet or HttpGet) then
            local need = true
            pcall(function()
                if isfile and isfile(BG_FILE) then need = false end
            end)
            if need then
                local data = (game.HttpGet and game:HttpGet(BG_URL)) or HttpGet(BG_URL)
                if data then writefile(BG_FILE, data) end
            end
        end
    end)
    pcall(function()
        if getcustomasset and isfile and isfile(BG_FILE) then
            BG_ASSET = getcustomasset(BG_FILE)
        end
    end)
    BG_ASSET = BG_ASSET or BG_URL
    return BG_ASSET
end


task.spawn(function() pcall(resolveBg) end)


local function cleanupGUI()
    local existing = Players.LocalPlayer and Players.LocalPlayer.PlayerGui:FindFirstChild("MMA_SpeedBypass")
    if existing then
        existing:Destroy()
    end
    if running then
        stopBypass()
    end
end


local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or UI_COLORS.StrokeDefault
    stroke.Thickness = thickness or 1.5
    stroke.Parent = parent
    return stroke
end

local function createPadding(parent, left, top, right, bottom)
    local padding = Instance.new("UIPadding")
    if left then padding.PaddingLeft = UDim.new(0, left) end
    if top then padding.PaddingTop = UDim.new(0, top) end
    if right then padding.PaddingRight = UDim.new(0, right) end
    if bottom then padding.PaddingBottom = UDim.new(0, bottom) end
    padding.Parent = parent
    return padding
end

local function makeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end


local function buildBomb(power)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for i = 1, DEPTH do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maxRep = math.floor(power / (DEPTH + 2))
    for i = 1, maxRep do
        table.insert(maintable, spammedtable)
    end
    return maintable
end

local function stopBypass()
    running = false
    if spamThread then
        task.cancel(spamThread)
    end
    bomb = nil
    spamThread = nil
end

local function startBypass(power)
    stopBypass()
    running = true
    bomb = buildBomb(power)
    spamThread = task.spawn(function()
        while running do
            if bomb then
                pcall(function()
                    game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(bomb)
                end)
            end
            task.wait(SPAM_DELAY)
        end
    end)
end


local function updateUIState(ui, enabled)
    local strokeColor = enabled and UI_COLORS.ActiveStroke or UI_COLORS.StrokeDefault
    
    if ui.MainStroke then
        ui.MainStroke.Color = strokeColor
        ui.MainStroke.Thickness = enabled and 1 or 1.5
    end
    
    ui.StatusBtn.Text = enabled and "STATUS: ENABLED" or "STATUS: DISABLED"
    ui.StatusBtn.TextColor3 = enabled and UI_COLORS.ActiveStroke or UI_COLORS.TextSecondary
    
    if ui.StatusStroke then
        ui.StatusStroke.Color = strokeColor
    end
    
    if Config.Mode == "PC" then
        ui.PcBtn.BackgroundColor3 = UI_COLORS.Accent
        ui.PcBtn.BackgroundTransparency = 0.52
        if ui.PcStroke then
            ui.PcStroke.Color = strokeColor
        end
    else
        ui.MobileBtn.BackgroundColor3 = UI_COLORS.Accent
        ui.MobileBtn.BackgroundTransparency = 0.52
        if ui.MobileStroke then
            ui.MobileStroke.Color = strokeColor
        end
    end
    
    if Config.BackgroundVisible then
        ui.BgToggleBtn.BackgroundColor3 = UI_COLORS.Accent
        ui.BgToggleBtn.BackgroundTransparency = 0.52
        if ui.BgToggleStroke then
            ui.BgToggleStroke.Color = strokeColor
        end
    end
    
    if ui.KeyStroke then
        ui.KeyStroke.Color = strokeColor
    end
    
    if ui.DepthStroke then
        ui.DepthStroke.Color = strokeColor
    end
end


local function buildUI()
    cleanupGUI()
    
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MMA_SpeedBypass"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local metaValue = Instance.new("BoolValue")
    metaValue.Name = "__g"
    metaValue.Parent = screenGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Frame"
    mainFrame.ClipsDescendants = true
    mainFrame.Position = UDim2.new(0.5, -145, 0.5, -160)
    mainFrame.Size = WINDOW_SIZES[Config.WindowSizeIndex].Size
    mainFrame.BackgroundColor3 = UI_COLORS.Background
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    
    local mainCorner = createCorner(mainFrame, 12)
    local mainStroke = createStroke(mainFrame, UI_COLORS.StrokeDefault, 1.5)
    
    
    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "ImageLabel"
    bgImage.ZIndex = 0
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = resolveBg()
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.Visible = Config.BackgroundVisible
    bgImage.Parent = mainFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = bgImage
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "Frame"
    titleBar.ZIndex = 2
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = UI_COLORS.BackgroundDark
    titleBar.BackgroundTransparency = 0.5
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TextLabel"
    titleText.ZIndex = 3
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.Size = UDim2.new(1, -110, 1, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "MMA SPEED BYPASS"
    titleText.TextColor3 = UI_COLORS.TextPrimary
    titleText.TextSize = 12
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "TextButton"
    minimizeBtn.ZIndex = 5
    minimizeBtn.Position = UDim2.new(1, -28, 0.5, -10)
    minimizeBtn.Size = UDim2.new(0, 22, 0, 20)
    minimizeBtn.BackgroundColor3 = UI_COLORS.BackgroundButtonLight
    minimizeBtn.BackgroundTransparency = 0.78
    minimizeBtn.Text = "_"
    minimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    minimizeBtn.TextSize = 12
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = titleBar
    
    createCorner(minimizeBtn, 6)
    createStroke(minimizeBtn, Color3.fromRGB(90, 90, 90), 1)
    
    local resizeDownBtn = Instance.new("TextButton")
    resizeDownBtn.Name = "TextButton"
    resizeDownBtn.ZIndex = 5
    resizeDownBtn.Position = UDim2.new(1, -54, 0.5, -10)
    resizeDownBtn.Size = UDim2.new(0, 22, 0, 20)
    resizeDownBtn.BackgroundColor3 = UI_COLORS.BackgroundButtonLight
    resizeDownBtn.BackgroundTransparency = 0.78
    resizeDownBtn.Text = "-"
    resizeDownBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    resizeDownBtn.TextSize = 12
    resizeDownBtn.Font = Enum.Font.GothamBold
    resizeDownBtn.AutoButtonColor = false
    resizeDownBtn.Parent = titleBar
    
    createCorner(resizeDownBtn, 6)
    createStroke(resizeDownBtn, Color3.fromRGB(90, 90, 90), 1)
    
    local resizeUpBtn = Instance.new("TextButton")
    resizeUpBtn.Name = "TextButton"
    resizeUpBtn.ZIndex = 5
    resizeUpBtn.Position = UDim2.new(1, -80, 0.5, -10)
    resizeUpBtn.Size = UDim2.new(0, 22, 0, 20)
    resizeUpBtn.BackgroundColor3 = UI_COLORS.BackgroundButtonLight
    resizeUpBtn.BackgroundTransparency = 0.78
    resizeUpBtn.Text = "+"
    resizeUpBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    resizeUpBtn.TextSize = 12
    resizeUpBtn.Font = Enum.Font.GothamBold
    resizeUpBtn.AutoButtonColor = false
    resizeUpBtn.Parent = titleBar
    
    createCorner(resizeUpBtn, 6)
    createStroke(resizeUpBtn, Color3.fromRGB(90, 90, 90), 1)
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Frame"
    contentFrame.ZIndex = 2
    contentFrame.Position = UDim2.new(0, 10, 0, 42)
    contentFrame.Size = UDim2.new(1, -20, 1, -49)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Name = "UIListLayout"
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentFrame
    
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Name = "Frame"
    statusFrame.ZIndex = 3
    statusFrame.Size = UDim2.new(1, 0, 0, 34)
    statusFrame.BackgroundColor3 = UI_COLORS.BackgroundMedium
    statusFrame.BackgroundTransparency = 0.6
    statusFrame.Parent = contentFrame
    
    createCorner(statusFrame, 10)
    local statusStroke = createStroke(statusFrame, UI_COLORS.StrokeDark, 1)
    
    local statusBtn = Instance.new("TextButton")
    statusBtn.Name = "TextButton"
    statusBtn.ZIndex = 4
    statusBtn.Size = UDim2.new(1, 0, 1, 0)
    statusBtn.BackgroundTransparency = 1
    statusBtn.Text = "STATUS: DISABLED"
    statusBtn.TextColor3 = UI_COLORS.TextSecondary
    statusBtn.TextSize = 12
    statusBtn.Font = Enum.Font.GothamBold
    statusBtn.AutoButtonColor = false
    statusBtn.Parent = statusFrame
    
    
    local powerFrame = Instance.new("Frame")
    powerFrame.Name = "Frame"
    powerFrame.ZIndex = 3
    powerFrame.Size = UDim2.new(1, 0, 0, 32)
    powerFrame.BackgroundColor3 = UI_COLORS.BackgroundMedium
    powerFrame.BackgroundTransparency = 0.6
    powerFrame.Parent = contentFrame
    
    createCorner(powerFrame, 10)
    
    local powerLabel = Instance.new("TextLabel")
    powerLabel.Name = "TextLabel"
    powerLabel.ZIndex = 4
    powerLabel.Size = UDim2.new(0.5, 0, 1, 0)
    powerLabel.BackgroundTransparency = 1
    powerLabel.Text = "Power:"
    powerLabel.TextColor3 = UI_COLORS.TextSecondary
    powerLabel.TextSize = 11
    powerLabel.Font = Enum.Font.Gotham
    powerLabel.TextXAlignment = Enum.TextXAlignment.Left
    powerLabel.Parent = powerFrame
    
    createPadding(powerLabel, 10)
    
    local powerInput = Instance.new("TextBox")
    powerInput.Name = "TextBox"
    powerInput.ZIndex = 4
    powerInput.Position = UDim2.new(0.52, 0, 0.5, -11)
    powerInput.Size = UDim2.new(0.44, 0, 0, 22)
    powerInput.BackgroundColor3 = UI_COLORS.BackgroundInput
    powerInput.BackgroundTransparency = 0.6
    powerInput.Text = tostring(Config.PowerValue)
    powerInput.TextColor3 = UI_COLORS.TextAccent
    powerInput.TextSize = 12
    powerInput.Font = Enum.Font.GothamBold
    powerInput.PlaceholderText = "Click to edit"
    powerInput.Parent = powerFrame
    
    createCorner(powerInput, 8)
    createStroke(powerInput, UI_COLORS.StrokeInput, 1)
    
    
    local depthFrame = Instance.new("Frame")
    depthFrame.Name = "Frame"
    depthFrame.ZIndex = 3
    depthFrame.Size = UDim2.new(1, 0, 0, 32)
    depthFrame.BackgroundColor3 = UI_COLORS.BackgroundMedium
    depthFrame.BackgroundTransparency = 0.6
    depthFrame.Parent = contentFrame
    
    createCorner(depthFrame, 10)
    local depthStroke = createStroke(depthFrame, UI_COLORS.StrokeDark, 1)
    
    local depthLabel = Instance.new("TextLabel")
    depthLabel.Name = "TextLabel"
    depthLabel.ZIndex = 4
    depthLabel.Size = UDim2.new(0.5, 0, 1, 0)
    depthLabel.BackgroundTransparency = 1
    depthLabel.Text = "Depth:"
    depthLabel.TextColor3 = UI_COLORS.TextSecondary
    depthLabel.TextSize = 11
    depthLabel.Font = Enum.Font.Gotham
    depthLabel.TextXAlignment = Enum.TextXAlignment.Left
    depthLabel.Parent = depthFrame
    
    createPadding(depthLabel, 10)
    
    local depthInput = Instance.new("TextBox")
    depthInput.Name = "TextBox"
    depthInput.ZIndex = 4
    depthInput.Position = UDim2.new(0.52, 0, 0.5, -11)
    depthInput.Size = UDim2.new(0.44, 0, 0, 22)
    depthInput.BackgroundColor3 = UI_COLORS.BackgroundInput
    depthInput.BackgroundTransparency = 0.6
    depthInput.Text = tostring(Config.DepthValue)
    depthInput.TextColor3 = UI_COLORS.TextAccent
    depthInput.TextSize = 12
    depthInput.Font = Enum.Font.GothamBold
    depthInput.PlaceholderText = "Click to edit"
    depthInput.Parent = depthFrame
    
    createCorner(depthInput, 8)
    createStroke(depthInput, UI_COLORS.StrokeInput, 1)
    
    
    local modeFrame = Instance.new("Frame")
    modeFrame.Name = "Frame"
    modeFrame.ZIndex = 3
    modeFrame.Size = UDim2.new(1, 0, 0, 28)
    modeFrame.BackgroundColor3 = UI_COLORS.BackgroundMedium
    modeFrame.BackgroundTransparency = 0.6
    modeFrame.Parent = contentFrame
    
    createCorner(modeFrame, 10)
    
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Name = "TextLabel"
    modeLabel.ZIndex = 4
    modeLabel.Size = UDim2.new(0.28, 0, 1, 0)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "Mode:"
    modeLabel.TextColor3 = UI_COLORS.TextSecondary
    modeLabel.TextSize = 11
    modeLabel.Font = Enum.Font.Gotham
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    modeLabel.Parent = modeFrame
    
    createPadding(modeLabel, 10)
    
    local mobileBtn = Instance.new("TextButton")
    mobileBtn.Name = "TextButton"
    mobileBtn.ZIndex = 4
    mobileBtn.Position = UDim2.new(0.4, 0, 0.5, -10)
    mobileBtn.Size = UDim2.new(0.3, -6, 0, 20)
    mobileBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
    mobileBtn.BackgroundTransparency = 0.6
    mobileBtn.Text = "Mobile"
    mobileBtn.TextColor3 = UI_COLORS.TextSecondary
    mobileBtn.TextSize = 10
    mobileBtn.Font = Enum.Font.GothamBold
    mobileBtn.AutoButtonColor = false
    mobileBtn.Parent = modeFrame
    
    createCorner(mobileBtn, 8)
    local mobileStroke = createStroke(mobileBtn, UI_COLORS.StrokeDark, 1)
    
    local pcBtn = Instance.new("TextButton")
    pcBtn.Name = "TextButton"
    pcBtn.ZIndex = 4
    pcBtn.Position = UDim2.new(0.7, 0, 0.5, -10)
    pcBtn.Size = UDim2.new(0.3, -6, 0, 20)
    pcBtn.BackgroundColor3 = UI_COLORS.Accent
    pcBtn.BackgroundTransparency = 0.52
    pcBtn.Text = "PC"
    pcBtn.TextColor3 = UI_COLORS.TextPrimary
    pcBtn.TextSize = 10
    pcBtn.Font = Enum.Font.GothamBold
    pcBtn.AutoButtonColor = false
    pcBtn.Parent = modeFrame
    
    createCorner(pcBtn, 8)
    local pcStroke = createStroke(pcBtn, UI_COLORS.TextAccent, 1)
    
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "Frame"
    keyFrame.ZIndex = 3
    keyFrame.Size = UDim2.new(1, 0, 0, 28)
    keyFrame.BackgroundColor3 = UI_COLORS.BackgroundMedium
    keyFrame.BackgroundTransparency = 0.6
    keyFrame.Parent = contentFrame
    
    createCorner(keyFrame, 10)
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Name = "TextLabel"
    keyLabel.ZIndex = 4
    keyLabel.Size = UDim2.new(0.55, 0, 1, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "Toggle Key:"
    keyLabel.TextColor3 = UI_COLORS.TextSecondary
    keyLabel.TextSize = 11
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = keyFrame
    
    createPadding(keyLabel, 10)
    
    local keyBtn = Instance.new("TextButton")
    keyBtn.Name = "TextButton"
    keyBtn.ZIndex = 4
    keyBtn.Position = UDim2.new(0.56, 0, 0.5, -10)
    keyBtn.Size = UDim2.new(0.44, -6, 0, 20)
    keyBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
    keyBtn.BackgroundTransparency = 0.6
    keyBtn.Text = Config.ToggleKey and Config.ToggleKey.Name or "V"
    keyBtn.TextColor3 = UI_COLORS.TextPrimary
    keyBtn.TextSize = 11
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = keyFrame
    
    createCorner(keyBtn, 8)
    local keyStroke = createStroke(keyBtn, UI_COLORS.StrokeDark, 1)
    
    
    local bgToggleFrame = Instance.new("Frame")
    bgToggleFrame.Name = "Frame"
    bgToggleFrame.ZIndex = 3
    bgToggleFrame.Size = UDim2.new(1, 0, 0, 28)
    bgToggleFrame.BackgroundColor3 = UI_COLORS.BackgroundMedium
    bgToggleFrame.BackgroundTransparency = 0.6
    bgToggleFrame.Parent = contentFrame
    
    createCorner(bgToggleFrame, 10)
    
    local bgToggleLabel = Instance.new("TextLabel")
    bgToggleLabel.Name = "TextLabel"
    bgToggleLabel.ZIndex = 4
    bgToggleLabel.Size = UDim2.new(0.55, 0, 1, 0)
    bgToggleLabel.BackgroundTransparency = 1
    bgToggleLabel.Text = "Background:"
    bgToggleLabel.TextColor3 = UI_COLORS.TextSecondary
    bgToggleLabel.TextSize = 11
    bgToggleLabel.Font = Enum.Font.Gotham
    bgToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    bgToggleLabel.Parent = bgToggleFrame
    
    createPadding(bgToggleLabel, 10)
    
    local bgToggleBtn = Instance.new("TextButton")
    bgToggleBtn.Name = "TextButton"
    bgToggleBtn.ZIndex = 4
    bgToggleBtn.Position = UDim2.new(0.56, 0, 0.5, -10)
    bgToggleBtn.Size = UDim2.new(0.44, -6, 0, 20)
    bgToggleBtn.BackgroundColor3 = UI_COLORS.Accent
    bgToggleBtn.BackgroundTransparency = 0.52
    bgToggleBtn.Text = Config.BackgroundVisible and "ON" or "OFF"
    bgToggleBtn.TextColor3 = UI_COLORS.TextPrimary
    bgToggleBtn.TextSize = 11
    bgToggleBtn.Font = Enum.Font.GothamBold
    bgToggleBtn.AutoButtonColor = false
    bgToggleBtn.Parent = bgToggleFrame
    
    createCorner(bgToggleBtn, 8)
    local bgToggleStroke = createStroke(bgToggleBtn, UI_COLORS.TextAccent, 1)
    
    makeDraggable(mainFrame)
    
    local ui = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        MainStroke = mainStroke,
        StatusBtn = statusBtn,
        StatusStroke = statusStroke,
        PowerInput = powerInput,
        DepthInput = depthInput,
        DepthStroke = depthStroke,
        MobileBtn = mobileBtn,
        MobileStroke = mobileStroke,
        PcBtn = pcBtn,
        PcStroke = pcStroke,
        KeyBtn = keyBtn,
        KeyStroke = keyStroke,
        BgToggleBtn = bgToggleBtn,
        BgToggleStroke = bgToggleStroke,
        MinimizeBtn = minimizeBtn,
        ResizeDownBtn = resizeDownBtn,
        ResizeUpBtn = resizeUpBtn,
        BgImage = bgImage,
        TitleBar = titleBar,
        ContentFrame = contentFrame,
    }
    
    updateUIState(ui, Config.Enabled)
    
    return ui
end


local function setupEventHandlers(ui)
    ui.StatusBtn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        updateUIState(ui, Config.Enabled)
        saveConfig()
        if Config.Enabled then
            startedAt = os.clock()
            startBypass(Config.PowerValue)
        else
            stopBypass()
        end
    end)
    
    ui.PowerInput.FocusLost:Connect(function()
        local val = tonumber(ui.PowerInput.Text)
        if val then
            Config.PowerValue = math.clamp(math.floor(val + 0.5), 1, 999999)
            ui.PowerInput.Text = tostring(Config.PowerValue)
            saveConfig()
            if Config.Enabled then
                startBypass(Config.PowerValue)
            end
        else
            ui.PowerInput.Text = tostring(Config.PowerValue)
        end
    end)
    
    ui.DepthInput.FocusLost:Connect(function()
        local val = tonumber(ui.DepthInput.Text)
        if val then
            Config.DepthValue = math.clamp(math.floor(val + 0.5), 1, 99999)
            DEPTH = Config.DepthValue
            ui.DepthInput.Text = tostring(Config.DepthValue)
            saveConfig()
            if Config.Enabled then
                startBypass(Config.PowerValue)
            end
        else
            ui.DepthInput.Text = tostring(Config.DepthValue)
        end
    end)
    
    ui.MobileBtn.MouseButton1Click:Connect(function()
        Config.Mode = "Mobile"
        Config.PowerValue = 65000
        ui.PowerInput.Text = "65000"
        ui.MobileBtn.BackgroundColor3 = UI_COLORS.Accent
        ui.MobileBtn.BackgroundTransparency = 0.52
        ui.MobileBtn.TextColor3 = UI_COLORS.TextPrimary
        ui.MobileStroke.Color = Config.Enabled and UI_COLORS.ActiveStroke or UI_COLORS.TextAccent
        ui.PcBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
        ui.PcBtn.BackgroundTransparency = 0.78
        ui.PcBtn.TextColor3 = UI_COLORS.TextSecondary
        ui.PcStroke.Color = UI_COLORS.StrokeDark
        saveConfig()
        if Config.Enabled then
            startBypass(Config.PowerValue)
        end
    end)
    
    ui.PcBtn.MouseButton1Click:Connect(function()
        Config.Mode = "PC"
        Config.PowerValue = 97000
        ui.PowerInput.Text = "97000"
        ui.PcBtn.BackgroundColor3 = UI_COLORS.Accent
        ui.PcBtn.BackgroundTransparency = 0.52
        ui.PcBtn.TextColor3 = UI_COLORS.TextPrimary
        ui.PcStroke.Color = Config.Enabled and UI_COLORS.ActiveStroke or UI_COLORS.TextAccent
        ui.MobileBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
        ui.MobileBtn.BackgroundTransparency = 0.78
        ui.MobileBtn.TextColor3 = UI_COLORS.TextSecondary
        ui.MobileStroke.Color = UI_COLORS.StrokeDark
        saveConfig()
        if Config.Enabled then
            startBypass(Config.PowerValue)
        end
    end)
    
    ui.KeyBtn.MouseButton1Click:Connect(function()
        ui.KeyBtn.Text = "..."
        ui.KeyBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Config.ToggleKey = input.KeyCode
                ui.KeyBtn.Text = input.KeyCode.Name
                ui.KeyBtn.TextColor3 = UI_COLORS.TextPrimary
                saveConfig()
                connection:Disconnect()
            end
        end)
    end)
    
    ui.BgToggleBtn.MouseButton1Click:Connect(function()
        Config.BackgroundVisible = not Config.BackgroundVisible
        ui.BgToggleBtn.Text = Config.BackgroundVisible and "ON" or "OFF"
        ui.BgImage.Visible = Config.BackgroundVisible
        if Config.BackgroundVisible then
            ui.BgImage.Image = resolveBg()
            ui.BgToggleBtn.BackgroundColor3 = UI_COLORS.Accent
            ui.BgToggleBtn.BackgroundTransparency = 0.52
            ui.BgToggleStroke.Color = Config.Enabled and UI_COLORS.ActiveStroke or UI_COLORS.TextAccent
        else
            ui.BgToggleBtn.BackgroundColor3 = UI_COLORS.BackgroundButtonLight
            ui.BgToggleBtn.BackgroundTransparency = 0.78
            ui.BgToggleStroke.Color = UI_COLORS.StrokeDark
        end
        saveConfig()
    end)
    
    ui.MinimizeBtn.MouseButton1Click:Connect(function()
        Config.IsVisible = not Config.IsVisible
        ui.ContentFrame.Visible = Config.IsVisible
        if Config.IsVisible then
            ui.MainFrame.Size = WINDOW_SIZES[Config.WindowSizeIndex].Size
        else
            ui.MainFrame.Size = UDim2.new(0, WINDOW_SIZES[Config.WindowSizeIndex].Size.X.Offset, 0, 35)
        end
        saveConfig()
    end)
    
    ui.ResizeDownBtn.MouseButton1Click:Connect(function()
        if Config.WindowSizeIndex > 1 then
            Config.WindowSizeIndex = Config.WindowSizeIndex - 1
        else
            Config.WindowSizeIndex = #WINDOW_SIZES
        end
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(ui.MainFrame, tweenInfo, {Size = WINDOW_SIZES[Config.WindowSizeIndex].Size})
        tween:Play()
        saveConfig()
    end)
    
    ui.ResizeUpBtn.MouseButton1Click:Connect(function()
        if Config.WindowSizeIndex < #WINDOW_SIZES then
            Config.WindowSizeIndex = Config.WindowSizeIndex + 1
        else
            Config.WindowSizeIndex = 1
        end
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(ui.MainFrame, tweenInfo, {Size = WINDOW_SIZES[Config.WindowSizeIndex].Size})
        tween:Play()
        saveConfig()
    end)
end


local function setupKeybind(ui)
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Config.ToggleKey then
            Config.Enabled = not Config.Enabled
            updateUIState(ui, Config.Enabled)
            saveConfig()
            if Config.Enabled then
                startedAt = os.clock()
                startBypass(Config.PowerValue)
            else
                stopBypass()
            end
        end
    end)
end


local function setupTimer(ui)
    RunService.RenderStepped:Connect(function(dt)
        if Config.Enabled then
            ui.StatusBtn.Text = "STATUS: ENABLED"
        end
    end)
end


local function main()
    if not Players.LocalPlayer then
        Players.PlayerAdded:Wait()
    end
    local ui = buildUI()
    setupEventHandlers(ui)
    setupKeybind(ui)
end

main()
