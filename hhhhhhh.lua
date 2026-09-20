--MMA steal OMGGGGGGGGG what fackkkk
--discord.gg/kastorhub
--LEKAD BY FRNK33.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ------------------------------------------------------------
-- EARLY CONFIG LOAD (for intro sound setting)
-- ------------------------------------------------------------
local introSoundEnabled = true
if isfile and isfile("MMA_Mobile.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("MMA_Mobile.json")) end)
    if ok and type(data) == "table" and data.introSoundEnabled ~= nil then
        introSoundEnabled = data.introSoundEnabled
    end
end
-- Load Cyber extras from saved config
if isfile and isfile("MMA_Mobile.json") then
    local ok2, d2 = pcall(function() return HS:JSONDecode(readfile("MMA_Mobile.json")) end)
    if ok2 and type(d2)=="table" then
        if type(d2.animEnabled)=="boolean" then animEnabled=d2.animEnabled end
        if type(d2.backgroundEnabled)=="boolean" then backgroundEnabled=d2.backgroundEnabled end
        if type(d2.backgroundIndex)=="number" then backgroundIndex=d2.backgroundIndex end
    end
end

-- ------------------------------------------------------------
-- INTRO SOUND (only if enabled)
-- ------------------------------------------------------------
local introSoundInstance = nil
if introSoundEnabled then
    local urlIntro = "https://files.catbox.moe/hg5cr4.mp3"
    local numeFisier = "movee_intro.mp3"

    local ok, data = pcall(function() return game:HttpGet(urlIntro) end)
    if ok and data then
        pcall(function() writefile(numeFisier, data) end)
    end

    introSoundInstance = Instance.new("Sound")
    pcall(function()
        introSoundInstance.SoundId = getcustomasset(numeFisier)
        introSoundInstance.Volume = 3
        introSoundInstance.Looped = false
        introSoundInstance.Parent = game:GetService("CoreGui")
        introSoundInstance:Play()
    end)
end

repeat task.wait() until game:IsLoaded()

-- ============================================================
-- SKY THEME SYSTEM
-- ============================================================
local CANDY_SKY_TAG = "MoveeSkyTheme"
local currentSkyTheme = "Night"
local CANDY_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- STATE
-- ============================================================
TS=TweenService
LP=Players.LocalPlayer
local NS,CS=59,29
local LAGGER_SPEED=30
local LAGGER_CARRY_SPEED=15
local antiDropEnabled = false
local antiDropActive = false
local antiDropMT = nil
local antiDropOldIdx, antiDropOldNewIdx
local spoofedVelocity = Vector3.zero
local carrySpeedActive = false
local laggerModeEnabled = false

-- MMA Server Lagger (IIFE = own register pool)
local mmaServerLaggerEnabled = false
local setMmaServerLagger, openMmaLaggerPanel, destroyMmaLaggerPanel
;(function()
local _mmaLaggerThread = nil
function mmaLaggerGetMax(val)
    local mainvalueifonetable = 180000
    if type(val) ~= "number" then return nil end
    return mainvalueifonetable / (val + 2)
end
function mmaLaggerBomb(tableincrease, tries)
    local maintable, spammedtable = {}, {{}}
    local z = spammedtable[1]
    for i = 1, tableincrease do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maximum = mmaLaggerGetMax(tableincrease) or 999999
    for i = 1, maximum do
        table.insert(maintable, spammedtable)
    end
    for i = 1, tries do
        pcall(function()
            game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(maintable)
        end)
    end
end
function mmaLaggerStartLoop()
    if _mmaLaggerThread then return end
    _mmaLaggerThread = task.spawn(function()
        while mmaServerLaggerEnabled do
            pcall(function()
                game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
            end)
            pcall(mmaLaggerBomb, 95, 1)
            task.wait(0.5)
        end
        _mmaLaggerThread = nil
    end)
end
local _mmaLaggerGui = nil
local _mmaLaggerStatusLbl = nil
local _mmaLaggerMainBtn = nil
local _mmaLaggerStroke = nil

function refreshMmaLaggerUI()
    if _mmaLaggerStatusLbl then
        _mmaLaggerStatusLbl.Text = mmaServerLaggerEnabled and "STATUS  ·  ACTIVE" or "STATUS  ·  IDLE"
        _mmaLaggerStatusLbl.TextColor3 = mmaServerLaggerEnabled and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(160, 160, 170)
    end
    if _mmaLaggerMainBtn then
        _mmaLaggerMainBtn.Text = mmaServerLaggerEnabled and "DISABLE LAGGER" or "ENABLE LAGGER"
        _mmaLaggerMainBtn.BackgroundColor3 = mmaServerLaggerEnabled and Color3.fromRGB(220, 50, 60) or Color3.fromRGB(255, 255, 255)
        _mmaLaggerMainBtn.TextColor3 = mmaServerLaggerEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(12, 12, 16)
    end
    if _mmaLaggerStroke then
        _mmaLaggerStroke.Color = mmaServerLaggerEnabled and Color3.fromRGB(220, 50, 60) or Color3.fromRGB(255, 255, 255)
        _mmaLaggerStroke.Transparency = mmaServerLaggerEnabled and 0.15 or 0.45
    end
end

setMmaServerLagger = function(on)
    mmaServerLaggerEnabled = on == true
    if mmaServerLaggerEnabled then
        mmaLaggerStartLoop()
    end
    refreshMmaLaggerUI()
end

destroyMmaLaggerPanel = function()
    if _mmaLaggerGui then
        pcall(function() _mmaLaggerGui:Destroy() end)
    end
    _mmaLaggerGui, _mmaLaggerStatusLbl, _mmaLaggerMainBtn, _mmaLaggerStroke = nil, nil, nil, nil
end

openMmaLaggerPanel = function()
    if _mmaLaggerGui and _mmaLaggerGui.Parent then
        _mmaLaggerGui.Enabled = true
        local mf = _mmaLaggerGui:FindFirstChild("Main")
        if mf then mf.Visible = true end
        refreshMmaLaggerUI()
        return
    end
    destroyMmaLaggerPanel()

    local sg = Instance.new("ScreenGui")
    sg.Name = "MMA_LaggerPanel"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 60
    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 3)
    if pg then sg.Parent = pg else pcall(function() sg.Parent = game:GetService("CoreGui") end) end
    _mmaLaggerGui = sg

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 280, 0, 168)
    main.Position = UDim2.new(0.5, -140, 0.72, -84)
    main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    main.BackgroundTransparency = 0.08
    main.BorderSizePixel = 0
    main.Active = true
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local outer = Instance.new("UIStroke", main)
    outer.Color = Color3.fromRGB(255, 255, 255)
    outer.Thickness = 1
    outer.Transparency = 0.7
    _mmaLaggerStroke = outer

    -- top accent bar
    local accent = Instance.new("Frame", main)
    accent.Size = UDim2.new(1, 0, 0, 3)
    accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    accent.BorderSizePixel = 0
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 14)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, -50, 0, 28)
    title.Position = UDim2.new(0, 14, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "منو انت"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -34, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
    end)

    local status = Instance.new("TextLabel", main)
    status.Size = UDim2.new(1, -28, 0, 18)
    status.Position = UDim2.new(0, 14, 0, 44)
    status.BackgroundTransparency = 1
    status.Text = "STATUS  ·  IDLE"
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 11
    status.TextColor3 = Color3.fromRGB(160, 160, 170)
    status.TextXAlignment = Enum.TextXAlignment.Left
    _mmaLaggerStatusLbl = status

    local sub = Instance.new("TextLabel", main)
    sub.Size = UDim2.new(1, -28, 0, 16)
    sub.Position = UDim2.new(0, 14, 0, 64)
    sub.BackgroundTransparency = 1
    sub.Text = "Medium power  ·  pulse 0.5s"
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.TextColor3 = Color3.fromRGB(100, 100, 110)
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local mainBtn = Instance.new("TextButton", main)
    mainBtn.Size = UDim2.new(1, -28, 0, 44)
    mainBtn.Position = UDim2.new(0, 14, 1, -58)
    mainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.BorderSizePixel = 0
    mainBtn.Text = "ENABLE LAGGER"
    mainBtn.Font = Enum.Font.GothamBlack
    mainBtn.TextSize = 13
    mainBtn.TextColor3 = Color3.fromRGB(12, 12, 16)
    mainBtn.AutoButtonColor = false
    Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 10)
    _mmaLaggerMainBtn = mainBtn

    mainBtn.MouseButton1Click:Connect(function()
        setMmaServerLagger(not mmaServerLaggerEnabled)
        pcall(saveConfig)
    end)

    -- drag
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    refreshMmaLaggerUI()
end

end)()



local antiRagdollEnabled,infJumpEnabled=false,false
_G.MMA_WantedState=_G.MMA_WantedState or {antiRag=false,autoSteal=false,infJump=false}
local streamerModeEnabled=false
_G.MMA_StreamerMode=false
local medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
local medusaDebounce,medusaLastUsed,dropActive=false,0,false
local autoLeftEnabled,autoRightEnabled=false,false
local autoLeftSetVisual,autoRightSetVisual=nil,nil
local speedLabel=nil
local autoBatEnabled=false
local autoSwingEnabled=true
local autoMoveSwingEnabled=false
local autoMoveSwingInterval=0.3
local _alSwingDebounce=false
local _arSwingDebounce=false
local autoBatSetVisual=nil
local resetAutoBatMotion=nil
local setBatCounterVisual=nil
local startBatCounter,stopBatCounter
local antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
local stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
local unwalkSavedAnimate,_anyKeyListening=nil,false
local autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,20,nil,nil
local cursedResetRemote=nil
local CURSED_RESET_GUID="f888ee6e-c86d-46e1-93d7-0639d6635d42"
local guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,true
local mobileButtonsSize=80
local circleButtonsEnabled=false
local stealBarFrame
local mobBtnRefs={}
local mobGuiRef=nil
local fovValue=80
local fovOptions={80,120,180}
local fovIndex=1
local laggerModePillRef=nil
local carryModePillRef=nil
local autoSwitchSpeedEnabled=false
local mobBtnTransparencyEnabled=false
local perButtonDragEnabled=false
local brainrotDetected=false
local activeBatBillboard=nil
local activeMedusaBillboard=nil
-- Noxa-style TP Bat settings (keeps MMA's existing public function names)
local tpBatVersion="V1"
local tpBatCameraLock=false
local tpBatSwingCooldown=0.12
local tpBatAutoDisableOnHit=false
-- E01 carry warning state
local e01Enabled=true
local e01WasCarrying=false
local e01ScanConn=nil
local e01CountdownConn=nil
local e01Billboard=nil
local e01SetVisual=nil
local setE01Enabled,startE01Watch,stopE01Watch
local ragdollGuiEnabled=true
local persistentRagdollGui=nil
local uiLocked=true
local infJumpMode="manual"
local holdInfJumpConn=nil
local DROP_ASCEND_DURATION=0.2
local DROP_ASCEND_SPEED=150
local _GuiKeys = nil -- referinta catre Keys din GUI closure, pentru saveConfig

-- ============================================================
-- CYBER EXTRAS: BACKGROUND + ZOMBIE ANIMATIONS (din Cyber)
-- ============================================================
local animEnabled = false
local backgroundEnabled = false
local backgroundIndex = 0
local bgImageRef = nil

local BG_IMAGES = {
    [1] = "82570501613757",
    [2] = "89455917077259",
    [3] = "140011519343966",
    [4] = "122541342511357",
    [5] = "91186886252449",
    [6] = "121087678749100",
    [7] = "113351045442552",
    [8] = "123175449101989",
    [9] = "113133243302321"
}

function applyBackgroundImage(index)
    backgroundIndex = index or 0
    if not bgImageRef then return end
    if backgroundIndex == 0 then
        bgImageRef.Visible = false
        backgroundEnabled = false
    else
        local imgId = BG_IMAGES[backgroundIndex]
        if imgId then
            bgImageRef.Image = "rbxassetid://" .. imgId
            bgImageRef.Visible = true
            backgroundEnabled = true
        end
    end
end

-- ANIMATII REMBEMBI (Zombie Mode) din Cyber
local RembembiAnims = {
    WalkAnim  = 73718308412641,
    RunAnim   = 135515454877967,
    JumpAnim  = 78508480717326,
    FallAnim  = 78147885297412,
    SwimIdle  = 129183123083281,
    Swim      = 110657013921774,
    ClimbAnim = 129447497744818,
    Animation1 = 92849173543269,
    Animation2 = 132238900951109,
}

local AnimRefs = { heartbeat=nil, savedAnimate=nil, originalAnims=nil }
local startAnimToggle, stopAnimToggle

do
    local LP_anim = Players.LocalPlayer
    local function isRembembiAnim(id)
        if not id then return false end
        for _,v in pairs(RembembiAnims) do if v == id then return true end end
        return false
    end
    local function saveOriginalAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function g(obj) return obj and obj.AnimationId or nil end
        local ids = {
            walk=g(animate.walk and animate.walk.WalkAnim),
            run=g(animate.run and animate.run.RunAnim),
            jump=g(animate.jump and animate.jump.JumpAnim),
            fall=g(animate.fall and animate.fall.FallAnim),
            climb=g(animate.climb and animate.climb.ClimbAnim),
            swim=g(animate.swim and animate.swim.Swim),
            swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),
            idle1=g(animate.idle and animate.idle.Animation1),
            idle2=g(animate.idle and animate.idle.Animation2),
        }
        if not isRembembiAnim(ids.walk) then AnimRefs.originalAnims = ids end
    end
    local function applyRembembiAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj then obj.AnimationId = "rbxassetid://" .. id end end
        s(animate.walk and animate.walk.WalkAnim, RembembiAnims.WalkAnim)
        s(animate.run and animate.run.RunAnim, RembembiAnims.RunAnim)
        s(animate.jump and animate.jump.JumpAnim, RembembiAnims.JumpAnim)
        s(animate.fall and animate.fall.FallAnim, RembembiAnims.FallAnim)
        s(animate.climb and animate.climb.ClimbAnim, RembembiAnims.ClimbAnim)
        s(animate.swim and animate.swim.Swim, RembembiAnims.Swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, RembembiAnims.SwimIdle)
        s(animate.idle and animate.idle.Animation1, RembembiAnims.Animation1)
        s(animate.idle and animate.idle.Animation2, RembembiAnims.Animation2)
    end
    local function restoreOriginalAnims(char)
        local orig = AnimRefs.originalAnims
        if not orig then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj and id then obj.AnimationId = id end end
        s(animate.walk and animate.walk.WalkAnim, orig.walk)
        s(animate.run and animate.run.RunAnim, orig.run)
        s(animate.jump and animate.jump.JumpAnim, orig.jump)
        s(animate.fall and animate.fall.FallAnim, orig.fall)
        s(animate.climb and animate.climb.ClimbAnim, orig.climb)
        s(animate.swim and animate.swim.Swim, orig.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, orig.swimidle)
        s(animate.idle and animate.idle.Animation1, orig.idle1)
        s(animate.idle and animate.idle.Animation2, orig.idle2)
    end
    function startAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then saveOriginalAnims(char); applyRembembiAnims(char) end
        AnimRefs.heartbeat = RunService.Heartbeat:Connect(function()
            if not animEnabled then return end
            local c = LP_anim.Character
            if c then applyRembembiAnims(c) end
        end)
    end
    function stopAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then restoreOriginalAnims(char) end
    end
end


local MOB_POS_FILE="Spectrum_BtnPos.json"
function loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end; return {}
end
function saveBtnPositions()
    if not writefile then return end; if not mobGuiRef then return end
    local out={}
    for _,child in ipairs(mobGuiRef:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1,5)=="SBtn_" then
            local lbl=child.Name:sub(6)
            out[lbl]={xs=child.Position.X.Scale,xo=child.Position.X.Offset,ys=child.Position.Y.Scale,yo=child.Position.Y.Offset}
        end
    end
    local lockFr=mobGuiRef:FindFirstChild("SBtnLock")
    if lockFr then out["__lock"]={xs=lockFr.Position.X.Scale,xo=lockFr.Position.X.Offset,ys=lockFr.Position.Y.Scale,yo=lockFr.Position.Y.Offset} end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
end
task.spawn(function() while true do task.wait(3);pcall(saveBtnPositions) end end)

local refreshSpeedModeLabel,saveConfig
local startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter
local startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag,enableStretchRez,disableStretchRez
local startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor,cursedInstaReset
local startAutoSteal,stopAutoSteal,toggleCarryMode,toggleLaggerMode

function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(200,200,200))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
local fovConn=nil
function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=fovValue end end)
end
applyFOV()

function createRagdollBillboard(duration,labelText,color)
    if not ragdollGuiEnabled then return nil end
    local WHITE = Color3.fromRGB(255,255,255)
    local BG    = Color3.fromRGB(12,5,10)
    local W,H   = 210,80
    local guiName="MoveeRagdollTimer_"..labelText
    pcall(function()
        local cg=game:GetService("CoreGui");local old=cg:FindFirstChild(guiName);if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(guiName);if o then o:Destroy() end end
    end)
    local sg=Instance.new("ScreenGui")
    sg.Name=guiName;sg.ResetOnSpawn=false;sg.IgnoreGuiInset=false;sg.DisplayOrder=5
    pcall(function() sg.ClipToDeviceSafeArea=true end)
    local pg=LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui",5)
    if pg then sg.Parent=pg end
    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,W,0,H);card.Position=UDim2.new(0.5,-W/2,0,58)
    card.BackgroundColor3=BG;card.BackgroundTransparency=1
    card.BorderSizePixel=0;card.ZIndex=30;card.Active=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local stroke=Instance.new("UIStroke",card)
    stroke.Color=WHITE;stroke.Thickness=3;stroke.Transparency=1
    task.spawn(function()
        local t=0
        while stroke and stroke.Parent do
            t=t+0.05
            stroke.Transparency=0.02+math.abs(math.sin(t*2.5))*0.25
            stroke.Color=Color3.fromRGB(255,255,255)
            task.wait(0.04)
        end
    end)
    local titleLbl=Instance.new("TextLabel",card)
    titleLbl.Size=UDim2.new(1,-16,0,28);titleLbl.Position=UDim2.new(0,8,0,6)
    titleLbl.BackgroundTransparency=1
    titleLbl.Text=(labelText=="RAGDOLL" and "RAGDOLL TIMER" or (labelText=="STONE" and "STONE TIMER" or labelText.." TIMER"))
    titleLbl.TextColor3=WHITE;titleLbl.Font=Enum.Font.GothamBlack;titleLbl.TextSize=13
    titleLbl.TextXAlignment=Enum.TextXAlignment.Center;titleLbl.ZIndex=32
    local divider=Instance.new("Frame",card)
    divider.Size=UDim2.new(1,-20,0,1);divider.Position=UDim2.new(0,10,0,34)
    divider.BackgroundColor3=WHITE;divider.BackgroundTransparency=0.5;divider.BorderSizePixel=0;divider.ZIndex=31
    local timerLbl=Instance.new("TextLabel",card)
    timerLbl.Size=UDim2.new(1,0,0,H-38);timerLbl.Position=UDim2.new(0,0,0,36)
    timerLbl.BackgroundTransparency=1;timerLbl.Text=string.format("%.1f",duration).."s"
    timerLbl.TextColor3=WHITE;timerLbl.Font=Enum.Font.GothamBlack;timerLbl.TextSize=24
    timerLbl.TextXAlignment=Enum.TextXAlignment.Center;timerLbl.ZIndex=32
    local shimmer=addShimmerToLabel(timerLbl,WHITE,WHITE)
    task.spawn(function() local t=0;while timerLbl and timerLbl.Parent do t=t+0.04;shimmer.Offset=Vector2.new(math.sin(t)*0.5,0);task.wait(0.04) end end)
    local dragStart,dragStartPos,dragging=nil,nil,false
    card.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true;dragStart=inp.Position;dragStartPos=card.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-dragStart
            card.Position=UDim2.new(dragStartPos.X.Scale,dragStartPos.X.Offset+d.X,dragStartPos.Y.Scale,dragStartPos.Y.Offset+d.Y)
        end
    end)
    local startTime=tick();local conn
    conn=RunService.Heartbeat:Connect(function()
        local remaining=math.max(0,duration-(tick()-startTime))
        if remaining<=0 then conn:Disconnect();pcall(function() sg:Destroy() end)
        elseif timerLbl and timerLbl.Parent then timerLbl.Text=string.format("%.1f",remaining).."s" end
    end)
    return sg
end
function onHumanoidStateChanged(old,new)
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not activeBatBillboard then
        activeBatBillboard=createRagdollBillboard(2.6,"RAGDOLL",Color3.fromRGB(255,255,255))
        task.delay(2.6,function() if activeBatBillboard then pcall(function() activeBatBillboard:Destroy() end);activeBatBillboard=nil end end)
    end
end
function onMedusaStateChanged()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not activeMedusaBillboard then
        activeMedusaBillboard=createRagdollBillboard(4.5,"STONE",Color3.fromRGB(255,255,255))
        task.delay(4.5,function() if activeMedusaBillboard then pcall(function() activeMedusaBillboard:Destroy() end);activeMedusaBillboard=nil end end)
    end
end
function setupRagdollTriggers()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then hum.StateChanged:Connect(onHumanoidStateChanged);hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged) end
end
function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeSpeedBB") then head.MoveeSpeedBB:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="MoveeSpeedBB"; bb.Size=UDim2.new(0,110,0,36)
    bb.StudsOffset=Vector3.new(0,2.6,0); bb.AlwaysOnTop=true
    speedLabel=Instance.new("TextLabel",bb)
    speedLabel.Size=UDim2.new(1,0,1,0); speedLabel.BackgroundTransparency=1
    speedLabel.Text="0"; speedLabel.TextColor3=Color3.fromRGB(255,255,255)
    speedLabel.Font=Enum.Font.GothamBlack; speedLabel.TextScaled=true
    speedLabel.TextStrokeTransparency=0.25; speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
    local gr1=addShimmerToLabel(speedLabel,Color3.fromRGB(255,255,255),Color3.fromRGB(230,230,230))
    task.spawn(function()
        local t=0
        while bb and bb.Parent do t=t+0.03; gr1.Offset=Vector2.new(math.sin(t)*0.4,0); task.wait(0.04) end
    end)
end
-- Safe near enemy base: soft-cap speed while carrying (optional in settings)
local safeSpeedNearBaseEnabled = false
local SAFE_NEAR_BASE_SPEED = 28
local NEAR_ENEMY_BASE_RANGE = 28
function isNearEnemyPlot(range)
    range = range or NEAR_ENEMY_BASE_RANGE
    local ok, result = pcall(function()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return false end
        local myPos = hrp.Position
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then
                local isMine = false
                if isMyPlotByName then
                    isMine = isMyPlotByName(plot.Name) == true
                end
                if not isMine then
                    local pos = nil
                    local sign = plot:FindFirstChild("PlotSign")
                    if sign then
                        if sign:IsA("BasePart") then
                            pos = sign.Position
                        else
                            local pp = sign:FindFirstChildWhichIsA("BasePart", true)
                            if pp then pos = pp.Position end
                        end
                    end
                    if pos then
                        local flat = Vector3.new(myPos.X - pos.X, 0, myPos.Z - pos.Z)
                        if flat.Magnitude <= range then return true end
                    end
                end
            end
        end
        return false
    end)
    return ok and result == true
end


-- ============================================================
-- ANTI DROP (integrated with Speed / Lagger Carry)
-- Keeps the local HumanoidRootPart velocity reads/writes spoofed
-- while allowing the speed system to continue setting velocity.
-- ============================================================
function startAntiDrop()
    if antiDropActive then return end

    local ok, mt = pcall(getrawmetatable, game)
    if not ok or not mt then return end

    antiDropMT = mt
    antiDropOldIdx = mt.__index
    antiDropOldNewIdx = mt.__newindex

    local okReadonly = pcall(setreadonly, mt, false)
    if not okReadonly then
        antiDropMT = nil
        antiDropOldIdx = nil
        antiDropOldNewIdx = nil
        return
    end

    mt.__index = newcclosure(function(self, key)
        if not checkcaller()
            and (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LP.Character
            and self:IsDescendantOf(LP.Character) then
            return spoofedVelocity
        end
        return antiDropOldIdx(self, key)
    end)

    mt.__newindex = newcclosure(function(self, key, value)
        if not checkcaller()
            and (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LP.Character
            and self:IsDescendantOf(LP.Character) then
            spoofedVelocity = value
            return
        end
        return antiDropOldNewIdx(self, key, value)
    end)

    pcall(setreadonly, mt, true)
    antiDropActive = true
end

function stopAntiDrop()
    if not antiDropActive then return end

    local mt = antiDropMT
    if mt and antiDropOldIdx then
        pcall(setreadonly, mt, false)
        mt.__index = antiDropOldIdx
        mt.__newindex = antiDropOldNewIdx
        pcall(setreadonly, mt, true)
    end

    antiDropMT = nil
    antiDropOldIdx = nil
    antiDropOldNewIdx = nil
    antiDropActive = false
end

function syncAutoAntiDrop()
    -- Anti Drop ALWAYS on (automatic) — prevents brainrot drop detection
    antiDropEnabled = true
    startAntiDrop()
end


-- ============================================================
-- HARD HIT (from Vynx) — visual hit radius ring around you
-- Shows the range where your bat/hits are most effective
-- ============================================================
local hardHitEnabled = false
local hardHitRadius = 10
local _hardHitRing = nil
local _hardHitConn = nil

local function hideHardHitRing()
    if _hardHitRing then pcall(function() _hardHitRing:Destroy() end); _hardHitRing = nil end
end

local function showHardHitRing()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hideHardHitRing()
    local cyl = Instance.new("CylinderHandleAdornment")
    cyl.Name = "MenoHardHitRing"
    cyl.Adornee = hrp
    cyl.AlwaysOnTop = true
    cyl.ZIndex = 5
    cyl.Height = 0.15
    cyl.Radius = hardHitRadius
    cyl.InnerRadius = math.max(0.1, hardHitRadius - 0.35)
    cyl.Color3 = Color3.fromRGB(220, 40, 50)
    cyl.Transparency = 0.45
    cyl.CFrame = CFrame.new(0, -2.8, 0) * CFrame.Angles(0, 0, math.rad(90))
    cyl.Parent = hrp
    _hardHitRing = cyl
end

local function startHardHit()
    hardHitEnabled = true
    if _hardHitConn then return end
    _hardHitConn = RunService.Heartbeat:Connect(function()
        if not hardHitEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not _hardHitRing or not _hardHitRing.Parent then showHardHitRing() end
        if _hardHitRing then
            local r = tonumber(hardHitRadius) or 10
            _hardHitRing.Radius = r
            _hardHitRing.InnerRadius = math.max(0.1, r - 0.35)
            if _hardHitRing.Adornee ~= root then
                _hardHitRing.Adornee = root
                _hardHitRing.Parent = root
            end
        end
    end)
    showHardHitRing()
end

local function stopHardHit()
    hardHitEnabled = false
    if _hardHitConn then pcall(function() _hardHitConn:Disconnect() end); _hardHitConn = nil end
    hideHardHitRing()
end

function getActiveMoveSpeed()
    -- Vynx-style selection (manual move only — L/R use getAutoPathSpeed)
    local spd
    if laggerModeEnabled then
        spd = (carrySpeedActive and LAGGER_CARRY_SPEED) or (LAGGER_SPEED or 30)
    elseif carrySpeedActive then
        spd = CS
    else
        spd = NS
    end
    if safeSpeedNearBaseEnabled and carrySpeedActive and isNearEnemyPlot and isNearEnemyPlot(NEAR_ENEMY_BASE_RANGE) then
        if spd > (SAFE_NEAR_BASE_SPEED or 28) then
            spd = SAFE_NEAR_BASE_SPEED or 28
        end
    end
    return spd
end
function getAutoPathSpeed()
    -- Auto Left/Right always Normal Speed (ignore carry / lagger)
    return NS
end
local _autoSwitchWasSteal=false
function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local char=LP.Character;if not char then return end
    local h=char:FindFirstChildOfClass("Humanoid");if not h then return end
    local isStealSpeed=h.WalkSpeed<25
    if isStealSpeed==_autoSwitchWasSteal then return end
    _autoSwitchWasSteal=isStealSpeed
    if isStealSpeed then
        carrySpeedActive = true
    else
        carrySpeedActive = false
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
end
task.spawn(function() while true do task.wait(0.1);updateAutoSwitchSpeed() end end)
-- Infinite Jump (PERMANENT - never dies on respawn/round)
-- Source of truth: _G.MMA_InfJumpOn (only user toggle changes it)
_G.MMA_InfJumpOn = _G.MMA_InfJumpOn == true
if _G.MMA_WantedState then
    if _G.MMA_WantedState.infJump then _G.MMA_InfJumpOn = true end
end

function startHoldInfJump()
    infJumpEnabled = true
    _G.MMA_InfJumpOn = true
    if _G.MMA_WantedState then _G.MMA_WantedState.infJump = true end
    if setInfJumpVisual then pcall(setInfJumpVisual, true) end
end

function stopHoldInfJump()
    -- ONLY called when user turns OFF — do not call on death/cleanup
    -- (no-op connection clear kept for compatibility)
    if holdInfJumpConn then
        pcall(function() holdInfJumpConn:Disconnect() end)
        holdInfJumpConn = nil
    end
end

function setInfJumpInternal(on)
    on = on and true or false
    infJumpEnabled = on
    _G.MMA_InfJumpOn = on
    if _G.MMA_WantedState then _G.MMA_WantedState.infJump = on end
    if not on then stopHoldInfJump() end
    if setInfJumpVisual then pcall(setInfJumpVisual, on) end
end

-- One forever loop for the whole session (survives death / new round)
if not _G.MMA_InfJumpLoopStarted then
    _G.MMA_InfJumpLoopStarted = true
    task.spawn(function()
        while true do
            task.wait(0.03)
            if not _G.MMA_InfJumpOn then
                -- still honor WantedState in case flag desynced
                if _G.MMA_WantedState and _G.MMA_WantedState.infJump then
                    _G.MMA_InfJumpOn = true
                    infJumpEnabled = true
                else
                    continue
                end
            end
            infJumpEnabled = true
            local char = LP.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then continue end
            local isJumpHeld = false
            pcall(function()
                isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space)
                    or UIS:IsKeyDown(Enum.KeyCode.ButtonA)
                    or UIS:IsKeyDown(Enum.KeyCode.ButtonX)
                    or (hum.Jump == true)
            end)
            if isJumpHeld then
                local vy = root.AssemblyLinearVelocity.Y
                if vy < 55 then
                    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 55, root.AssemblyLinearVelocity.Z)
                    root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
                end
            end
            if root.AssemblyLinearVelocity.Y < -120 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -120, root.AssemblyLinearVelocity.Z)
            end
        end
    end)
    -- JumpRequest (mobile) always active; gated by _G.MMA_InfJumpOn
    pcall(function()
        if not _G.MMA_InfJumpRequestBound then
            _G.MMA_InfJumpRequestBound = true
            UIS.JumpRequest:Connect(function()
                if not _G.MMA_InfJumpOn then return end
                local char = LP.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 then
                    hum.Jump = true
                    if root then
                        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 55, root.AssemblyLinearVelocity.Z)
                        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
                    end
                end
            end)
        end
    end)
end


-- Keep Roblox's native mobile jump request working.  The custom mobile
-- button container is drawn over the right side of the screen, so explicitly
-- forwarding JumpRequest prevents it from swallowing the normal jump tap.
pcall(function()
    if not _G.MMA_BaseJumpRequestBound then
        _G.MMA_BaseJumpRequestBound = true
        UIS.JumpRequest:Connect(function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not hum.PlatformStand then
                hum.Jump = true
            end
        end)
    end
end)
task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    while task.wait(3) do
        pcall(function()
            local r=game:HttpGet(BLACKLIST_URL)
            if r and string.find(r,tostring(LP.UserId),1,true) then LP:Kick("You have been removed for cheating | CODE: BAC-1633") end
        end)
    end
end)

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then cursedResetRemote=self end
            return oldFire(self,...)
        end))
    end
end)
task.spawn(function()
    task.wait(2);if cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
    end
end)
cursedInstaReset=function()
    if not cursedResetRemote then
        for _,desc in ipairs(game:GetDescendants()) do if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end end
    end
    if not cursedResetRemote then return end
    local character=LP.Character;local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health<=0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return end
    local resetDetected=false;local conns={}
    if humanoid then table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end)) end
    if character then table.insert(conns,character.AncestryChanged:Connect(function(_,parent) if not parent then resetDetected=true end end)) end
    task.spawn(function()
        for _=1,50 do if resetDetected then break end;pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);task.wait() end
        for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},InstaReset={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil}}
local AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal={AutoStealEnabled=false,StealRadius=61,StealDuration=1.3,Data={},Mode="Rave",CompleteRadius=9,LastSteal=0}
local isStealing,stealStartTime=false,nil
local _stealBarPct=0
local _stealBarPhase="idle"
autoStealEnabled = false
autoStealRadius = 61
autoStealDelayRadius = 9
ConnsAutoSteal = { autoSteal = nil }
autoStealSetVisual = nil
autoStealProgressGui = nil
autoStealProgressFill = nil
autoStealProgressPct = nil
autoStealProgressRadLbl = nil

local Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
local MEDUSA_COOLDOWN=25;local batCounterDebounce=false
local modeValLbl;local lastMoveDir=Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
function isRagdollState(hum)
    if not hum then return false end
    -- Do NOT treat FallingDown / Freefall as ragdoll (blocks movement while jumping)
    if hum.PlatformStand then return true end
    local st=hum:GetState()
    return st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll
end
function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    local plot=plots:FindFirstChild(plotName);if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end
function isNearPodiumWithPrompt()
    local char=LP.Character;local hrpL=char and char:FindFirstChild("HumanoidRootPart");if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums");if not podiums then continue end
        for _,podium in ipairs(podiums:GetChildren()) do
            local base=podium:FindFirstChild("Base");if not base then continue end
            local sp=base:FindFirstChild("Spawn");if not sp then continue end
            local d=(hrpL.Position-sp.Position).Magnitude;if d>Steal.StealRadius then continue end
            local att=sp:FindFirstChild("PromptAttachment");if not att then continue end
            for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
        end
    end
    return false,math.huge
end

-- ===== Rave Hub Auto Steal (EXACT copy from rave hub) =====
;(function()
    local getconnections = getconnections or (getgenv and getgenv().getconnections) or get_signal_cons
    -- sync MMA settings into rave vars
    autoStealEnabled = Steal.AutoStealEnabled and true or false
    autoStealRadius = Steal.StealRadius or 61
    autoStealDelayRadius = Steal.CompleteRadius or 9
    if not ConnsAutoSteal then ConnsAutoSteal = { autoSteal = nil } end

local RaveAutoStealConfig = {
    HOLD_MIN = 1.3,
    HOLD_MAX = 2.6,
    ENTRY_DELAY = 0.3,
    COOLDOWN = 0.05,
    STEAL_RANGE = autoStealDelayRadius or 9,
    PRIME_RANGE = autoStealRadius or 61,
}

local RaveStealState = {
    active = false,
    startTime = 0,
    phase = "idle",
    label = "",
    lastResult = "",
    lastResultTime = 0,
    totalSteals = 0,
    failedSteals = 0,
}

local ravePlots = workspace:WaitForChild("Plots")
local RaveAnimalsData = {}
local raveSyncRemotes = nil
local ravePlotAnimalSync = { caches = {}, connections = {} }
local raveAllAnimalsCache = {}
local ravePromptMemoryCache = {}
local raveInternalStealCache = {}

local function raveSplitSyncPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function raveResolveSyncPath(path, root)
    local current, parent, key = root, nil, nil
    for _, part in ipairs(raveSplitSyncPath(path)) do
        parent, key = current, part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function raveApplyPlotSyncDiff(channelName, packet)
    local cache = ravePlotAnimalSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = raveResolveSyncPath(path, cache)
    if action == "Changed" then
        if parent ~= nil then parent[key] = a end
    elseif action == "ArrayInsert" then
        if current ~= nil then table.insert(current, b, a) end
    elseif action == "ArrayRemoved" then
        if current ~= nil then table.remove(current, b) end
    elseif action == "DictionaryInsert" then
        if current ~= nil then current[b] = a end
    elseif action == "DictionaryRemoved" then
        if current ~= nil then current[b] = nil end
    end
end

local function raveAttachPlotChannel(remote)
    if ravePlotAnimalSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not ravePlots:FindFirstChild(channelName) then return end

    if raveSyncRemotes.requestData and ravePlotAnimalSync.caches[channelName] == nil then
        local ok, data = pcall(function()
            return raveSyncRemotes.requestData:InvokeServer(channelName)
        end)
        ravePlotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif ravePlotAnimalSync.caches[channelName] == nil then
        ravePlotAnimalSync.caches[channelName] = {}
    end

    ravePlotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do
            raveApplyPlotSyncDiff(channelName, packet)
        end
    end)
end

local function raveDetachPlotChannel(channelName)
    for remote, conn in pairs(ravePlotAnimalSync.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            ravePlotAnimalSync.connections[remote] = nil
            ravePlotAnimalSync.caches[tostring(channelName)] = nil
            break
        end
    end
end

local function raveGetPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function raveIsMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = ravePlots:FindFirstChild(animalData.plot)
    return plot and raveGetPlotOwner(plot) == LP.DisplayName or false
end

local function raveFindPrompt(animalData)
    if not animalData then return nil end
    local cached = ravePromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end

    local plot = ravePlots:FindFirstChild(animalData.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(animalData.slot)
    local base = podium and podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end

    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            ravePromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    return nil
end

local function raveAnimalPosition(animalData)
    local plot = ravePlots:FindFirstChild(animalData.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(animalData.slot)
    return podium and podium:GetPivot().Position or nil
end

local function raveDistanceToAnimal(animalData)
    local character = LP.Character
    local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso"))
    local pos = raveAnimalPosition(animalData)
    if not hrp or not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

local function ravePickClosest()
    local character = LP.Character
    local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso"))
    if not hrp then return nil end

    RaveAutoStealConfig.PRIME_RANGE = autoStealRadius or RaveAutoStealConfig.PRIME_RANGE
    RaveAutoStealConfig.STEAL_RANGE = autoStealDelayRadius or RaveAutoStealConfig.STEAL_RANGE

    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(raveAllAnimalsCache) do
        if not raveIsMyBaseAnimal(animalData) then
            local pos = raveAnimalPosition(animalData)
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                if dist <= RaveAutoStealConfig.PRIME_RANGE and dist < bestDist then
                    best, bestDist = animalData, dist
                end
            end
        end
    end
    return best
end

local function raveScanAllPlots()
    local newCache = {}
    for _, plot in ipairs(ravePlots:GetChildren()) do
        local cache = ravePlotAnimalSync.caches[plot.Name]
        local animalList = cache and cache.AnimalList
        if typeof(animalList) == "table" then
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local animalInfo = RaveAnimalsData[animalName]
                    if animalInfo then
                        table.insert(newCache, {
                            name = animalInfo.DisplayName or animalName,
                            plot = plot.Name,
                            slot = tostring(slot),
                            uid = plot.Name .. "_" .. tostring(slot),
                        })
                    end
                end
            end
        end
    end
    raveAllAnimalsCache = newCache
end

local function raveBuildStealCallbacks(prompt)
    if raveInternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
        end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        raveInternalStealCache[prompt] = data
    end
end

local function createAutoStealProgressBar()
    if autoStealProgressGui then pcall(function() autoStealProgressGui:Destroy() end) end
    -- kill legacy second bar if still around
    for _, n in ipairs({"MoveeStealBar", "YassinAutoStealBar", "RaveHubAutoStealBar"}) do
        pcall(function()
            local cg = game:GetService("CoreGui"):FindFirstChild(n)
            if cg then cg:Destroy() end
        end)
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            local o = pg and pg:FindFirstChild(n)
            if o then o:Destroy() end
        end)
    end
    stealBarFrame = nil
    local gui = Instance.new("ScreenGui")
    gui.Name = "MMAStealOMGBar"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true
    local CoreGui = game:GetService("CoreGui")
    if not pcall(function() gui.Parent = CoreGui end) then gui.Parent = LP:WaitForChild("PlayerGui") end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 56)
    mainFrame.Position = UDim2.new(0.5, -160, 0.82, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 10
    mainFrame.Parent = gui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local border = Instance.new("UIStroke", mainFrame)
    border.Color = Color3.fromRGB(255, 255, 255)
    border.Thickness = 1.5
    border.Transparency = 0.35

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, -110, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "منو انت"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.ZIndex = 12

    autoStealProgressRadLbl = Instance.new("TextLabel", mainFrame)
    autoStealProgressRadLbl.Size = UDim2.new(0, 90, 0, 16)
    autoStealProgressRadLbl.Position = UDim2.new(1, -100, 0, 6)
    autoStealProgressRadLbl.BackgroundTransparency = 1
    autoStealProgressRadLbl.Text = string.format("R: %.0f", autoStealRadius or 0)
    autoStealProgressRadLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    autoStealProgressRadLbl.Font = Enum.Font.GothamBold
    autoStealProgressRadLbl.TextSize = 11
    autoStealProgressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
    autoStealProgressRadLbl.ZIndex = 12

    local barBg = Instance.new("Frame", mainFrame)
    barBg.Size = UDim2.new(1, -20, 0, 14)
    barBg.Position = UDim2.new(0, 10, 0, 30)
    barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 11
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    autoStealProgressFill = Instance.new("Frame", barBg)
    autoStealProgressFill.Size = UDim2.new(0, 0, 1, 0)
    autoStealProgressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    autoStealProgressFill.BorderSizePixel = 0
    autoStealProgressFill.ZIndex = 12
    Instance.new("UICorner", autoStealProgressFill).CornerRadius = UDim.new(1, 0)

    autoStealProgressPct = Instance.new("TextLabel", mainFrame)
    autoStealProgressPct.Size = UDim2.new(0, 50, 0, 14)
    autoStealProgressPct.Position = UDim2.new(0.5, -25, 0, 30)
    autoStealProgressPct.BackgroundTransparency = 1
    autoStealProgressPct.Text = "0%"
    autoStealProgressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoStealProgressPct.Font = Enum.Font.GothamBlack
    autoStealProgressPct.TextSize = 11
    autoStealProgressPct.ZIndex = 13

    autoStealProgressGui = gui
    gui.Enabled = false
    return gui
end

local function setAutoStealProgress(pct)
    pct = math.clamp(pct or 0, 0, 1)
    if autoStealProgressFill then autoStealProgressFill.Size = UDim2.new(pct, 0, 1, 0) end
    if autoStealProgressPct then autoStealProgressPct.Text = math.floor(pct * 100) .. "%" end
end

local function showAutoStealBar(show)
    if not autoStealProgressGui then createAutoStealProgressBar() end
    if autoStealProgressGui then autoStealProgressGui.Enabled = show and true or false end
    if show and autoStealProgressRadLbl then autoStealProgressRadLbl.Text = string.format("R: %.0f", autoStealRadius or 0) end
    if not show then setAutoStealProgress(0) end
end

local function raveExecuteStealAsync(prompt, animalData)
    local data = raveInternalStealCache[prompt]
    if not data or not data.ready then return false end

    data.ready = false
    RaveStealState.active = true
    RaveStealState.startTime = tick()
    RaveStealState.phase = "holding"
    RaveStealState.label = animalData.name or "Animal"
    isStealing = true
    showAutoStealBar(true)
    setAutoStealProgress(0)

    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        local holdStart = tick()
        while autoStealEnabled and RaveStealState.active do
            local elapsed = tick() - holdStart
            setAutoStealProgress(math.min(elapsed / math.max(RaveAutoStealConfig.HOLD_MIN, 0.01), 1) * 0.75)
            if elapsed >= RaveAutoStealConfig.HOLD_MIN then break end
            task.wait()
        end

        RaveStealState.phase = "waitingRange"
        setAutoStealProgress(0.75)
        local alreadyInRange = raveDistanceToAnimal(animalData) <= RaveAutoStealConfig.STEAL_RANGE
        local fired = false

        while autoStealEnabled and RaveStealState.active do
            local elapsed = tick() - RaveStealState.startTime
            if elapsed > RaveAutoStealConfig.HOLD_MAX or not prompt.Parent then break end
            if raveDistanceToAnimal(animalData) <= RaveAutoStealConfig.STEAL_RANGE then
                if not alreadyInRange then task.wait(RaveAutoStealConfig.ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end

        if fired then
            RaveStealState.totalSteals = RaveStealState.totalSteals + 1
            RaveStealState.lastResult = "Stole " .. RaveStealState.label
            setAutoStealProgress(1)
        else
            RaveStealState.failedSteals = RaveStealState.failedSteals + 1
            RaveStealState.lastResult = "Missed window: " .. RaveStealState.label
        end

        task.wait(RaveAutoStealConfig.COOLDOWN)
        RaveStealState.active = false
        RaveStealState.phase = "idle"
        RaveStealState.lastResultTime = tick()
        isStealing = false
        data.ready = true
        if not autoStealEnabled then
            setAutoStealProgress(0)
            showAutoStealBar(false)
        end
    end)
    return true
end

local function raveAttemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    raveBuildStealCallbacks(prompt)
    if not raveInternalStealCache[prompt] then return false end
    return raveExecuteStealAsync(prompt, animalData)
end

function startAutoSteal()
    if ConnsAutoSteal.autoSteal then
        pcall(function() ConnsAutoSteal.autoSteal:Disconnect() end)
        ConnsAutoSteal.autoSteal = nil
    end
    ConnsAutoSteal.autoSteal = RunService.Heartbeat:Connect(function()
        if not autoStealEnabled or RaveStealState.active then return end
        local target = ravePickClosest()
        if not target then return end
        local prompt = raveFindPrompt(target)
        if prompt then raveAttemptSteal(prompt, target) end
    end)
end

function stopAutoSteal()
    if ConnsAutoSteal.autoSteal then
        pcall(function() ConnsAutoSteal.autoSteal:Disconnect() end)
        ConnsAutoSteal.autoSteal = nil
    end
    RaveStealState.active = false
    RaveStealState.phase = "idle"
    isStealing = false
    setAutoStealProgress(0)
end

function toggleAutoSteal(on)
    autoStealEnabled = on and true or false
    if autoStealEnabled then
        if not autoStealProgressGui then createAutoStealProgressBar() end
        showAutoStealBar(true)
        startAutoSteal()
    else
        stopAutoSteal()
        showAutoStealBar(false)
    end
    if autoStealSetVisual then autoStealSetVisual(autoStealEnabled) end
end

-- Initialize the new Auto Steal data synchronizer without importing its standalone menu.
task.spawn(function()
    local ok, err = pcall(function()
        local Packages = ReplicatedStorage:WaitForChild("Packages")
        local Datas = ReplicatedStorage:WaitForChild("Datas")
        RaveAnimalsData = require(Datas:WaitForChild("Animals"))
        local folder = Packages:WaitForChild("Synchronizer")
        raveSyncRemotes = {
            channelFolder = folder:WaitForChild("Channel"),
            routeRemote = folder:WaitForChild("CommunicationRoute"),
            requestData = folder:FindFirstChild("RequestData"),
        }
        for _, child in ipairs(raveSyncRemotes.channelFolder:GetChildren()) do
            if child:IsA("RemoteEvent") then raveAttachPlotChannel(child) end
        end
        raveSyncRemotes.channelFolder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") then raveAttachPlotChannel(child) end
        end)
        raveSyncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
            for _, action in ipairs(actions) do
                local kind, channelName = action[1], tostring(action[2])
                if not ravePlots:FindFirstChild(channelName) then continue end
                if kind == "ListenerAdded" then
                    local remote = raveSyncRemotes.channelFolder:FindFirstChild(channelName)
                    if remote and remote:IsA("RemoteEvent") then raveAttachPlotChannel(remote) end
                elseif kind == "ListenerRemoved" then
                    raveDetachPlotChannel(channelName)
                end
            end
        end)
        raveScanAllPlots()
        while task.wait(5) do raveScanAllPlots() end
    end)
    if not ok then warn("Rave Hub Auto Steal init failed:", err) end
end)



    local _oldSet = setAutoStealProgress
    setAutoStealProgress = function(pct)
        pct = math.clamp(pct or 0, 0, 1)
        _stealBarPct = pct
        if pct <= 0 then _stealBarPhase = "idle"
        elseif pct < 0.75 then _stealBarPhase = "holding"
        elseif pct == 0.75 or (pct >= 0.74 and pct < 1) then _stealBarPhase = "waitingRange"
        else _stealBarPhase = "done" end
        if _oldSet then _oldSet(pct) end
    end
    -- keep MMA Steal.AutoStealEnabled in sync
    local _start = startAutoSteal
    local _stop = stopAutoSteal
    startAutoSteal = function()
        Steal.AutoStealEnabled = true
        autoStealEnabled = true
        _G.MMA_WantedState.autoSteal = true
        autoStealRadius = Steal.StealRadius or 61
        autoStealDelayRadius = Steal.CompleteRadius or 9
        showAutoStealBar(true)
        return _start()
    end
    stopAutoSteal = function(keepFlag)
        if not keepFlag then
            Steal.AutoStealEnabled = false
            autoStealEnabled = false
            _G.MMA_WantedState.autoSteal = false
        end
        local r = _stop()
        _stealBarPct = 0
        _stealBarPhase = "idle"
        return r
    end
end)()




RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then for _,part in ipairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end end end
end)
-- Original MMA velocity speed system
RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");local hrp=char:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
        local md=hum.MoveDirection;local spd=getActiveMoveSpeed()
        if md.Magnitude>0 then
            lastMoveDir=md
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
            local anyHeld=false
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld=true; break end
            end
            if anyHeld then
                hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd)
            end
        end
    end
    if speedLabel then
        speedLabel.Text=string.format("%.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude)
    end
end)
-- Speed counter above head (restore)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    pcall(setupSpeedIndicator, char)
    pcall(setupRagdollTriggers)
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end)
if LP.Character then
    pcall(setupSpeedIndicator, LP.Character)
    pcall(setupRagdollTriggers)
end

local alConn,arConn=nil,nil;local alPhase,arPhase=1,1
stopAutoLeft=function()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end
startAutoLeft=function()
    if alConn then alConn:Disconnect() end;alPhase=1
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then alPhase=2;local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end;alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;return end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _alSwingDebounce then
            _alSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _alSwingDebounce=false end)
        end
    end)
end
startAutoRight=function()
    if arConn then arConn:Disconnect() end;arPhase=1
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then arPhase=2;local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd);return end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false);hrp.Velocity=Vector3.zero;autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end;arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;return end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit;hum:Move(mv,false);hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _arSwingDebounce then
            _arSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _arSwingDebounce=false end)
        end
    end)
end

-- External remote script disabled: it may intercept Roblox Core UI input.
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
-- ============================================================
-- DROP BRAINROT
-- ============================================================
local _wfConns={}
function runDrop()
    if dropActive then return end
    if autoBatEnabled then autoBatEnabled=false; if resetAutoBatMotion then resetAutoBatMotion() end; if autoBatSetVisual then autoBatSetVisual(false) end end
    dropActive=true
    local colConn=RunService.Stepped:Connect(function()
        if not dropActive then return end
        for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end end end
    end)
    table.insert(_wfConns,colConn)
    local flingThread=coroutine.create(function()
        while dropActive do RunService.Heartbeat:Wait(); local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart"); if not root then break end; local vel=root.Velocity; root.Velocity=vel*10000+Vector3.new(0,10000,0); RunService.RenderStepped:Wait(); if root and root.Parent then root.Velocity=vel end; RunService.Stepped:Wait(); if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end end
    end)
    table.insert(_wfConns,flingThread); coroutine.resume(flingThread)
    task.delay(0.1,function()
        dropActive=false
        for _,c in ipairs(_wfConns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() elseif type(c)=="thread" then pcall(coroutine.close,c) end end
        _wfConns={}
    end)
end
function doAutoTPDown(force)
    local char=LP.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end
startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function() while autoTPEnabled do task.wait(0.1);pcall(function() doAutoTPDown(false) end) end end)
end
stopAutoTP=function() autoTPEnabled=false;if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end
local STRETCH_NAME="Movee_Stretch"
enableStretchRez=function()
    stretchRezEnabled=true;if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function() RunService:BindToRenderStep(STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end
disableStretchRez=function() stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end) end
local defLightBrightness,defLightClock,defLightAmbient
function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end

-- ============================================================
-- NUKE OPTIMIZER (from ANAS HUB)
-- ============================================================
local nukeEnabled = false
local nukeConns = {}
local nukeThreads = {}

local function nukeStart()
    if nukeEnabled then return end
    nukeEnabled = true

    local XMin, XMax = -560, -240
    local ClothingClasses = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
    local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}

    local function SafeDestroy(obj)
        if obj and obj.Name == "Overhead" then return end
        pcall(function() obj:Destroy() end)
    end

    local function IsClothing(obj)
        for _, c in ipairs(ClothingClasses) do
            if obj:IsA(c) then return true end
        end
        return false
    end

    local function IsCharacterPart(obj)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and obj:IsDescendantOf(plr.Character) then
                return true
            end
        end
        return false
    end

    local function IsOutOfRange(obj)
        if obj:IsA("BasePart") then
            local x = obj.Position.X
            return x < XMin or x > XMax
        end
        return false
    end

    local function IsBase(obj)
        if not obj:IsA("BasePart") then return false end
        local nl = obj.Name:lower()
        for _, n in ipairs(BASE_NAMES) do
            if nl:find(n, 1, true) then return true end
        end
        return false
    end

    local function IsInBase(obj)
        local p = obj.Parent
        while p and p ~= workspace do
            if IsBase(p) then return true end
            p = p.Parent
        end
        return false
    end

    local function MakeTransparent(obj)
        pcall(function()
            if IsBase(obj) and not IsCharacterPart(obj) then
                obj.Transparency = 1
                obj.CastShadow = false
            end
        end)
    end

    local function StripObject(obj)
        pcall(function()
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
                SafeDestroy(obj)
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function() obj.Enabled = false end)
                SafeDestroy(obj)
            elseif obj:IsA("Explosion") then
                SafeDestroy(obj)
            elseif IsClothing(obj) and not IsCharacterPart(obj) then
                SafeDestroy(obj)
            elseif obj:IsA("BasePart") then
                if IsOutOfRange(obj) and not IsCharacterPart(obj) and not IsInBase(obj) then
                    SafeDestroy(obj)
                else
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                    MakeTransparent(obj)
                end
            end
        end)
    end

    local function OptimizeCharacter(char)
        if not char then return end
        pcall(function()
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    pcall(function() obj.Enabled = false end)
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                end
            end
        end)
    end

    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e9
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect")
                or e:IsA("DepthOfFieldEffect") or e:IsA("ColorCorrectionEffect") then
                e.Enabled = false
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "_NukeSky"
        sky.CelestialBodiesShown = false
        sky.StarCount = 0
        sky.Parent = Lighting
    end)

    table.insert(nukeThreads, task.spawn(function()
        local list = workspace:GetDescendants()
        for i, obj in ipairs(list) do
            if not nukeEnabled then return end
            StripObject(obj)
            if i % 80 == 0 then task.wait() end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            OptimizeCharacter(plr.Character)
        end
    end))

    table.insert(nukeConns, workspace.DescendantAdded:Connect(function(obj)
        if not nukeEnabled then return end
        task.defer(function()
            if nukeEnabled then StripObject(obj) end
        end)
    end))

    table.insert(nukeConns, Lighting.DescendantAdded:Connect(function(obj)
        if not nukeEnabled then return end
        pcall(function()
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") then
                obj.Enabled = false
            end
        end)
    end))

    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(nukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
    end
    table.insert(nukeConns, Players.PlayerAdded:Connect(function(plr)
        table.insert(nukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
    end))
end

local function nukeStop()
    nukeEnabled = false
    for _, c in ipairs(nukeConns) do
        pcall(function() c:Disconnect() end)
    end
    nukeConns = {}
    nukeThreads = {}
    pcall(function()
        local s = Lighting:FindFirstChild("_NukeSky")
        if s then s:Destroy() end
    end)
end

enableAntiLag=function()
    removeAccessoriesEnabled=true;antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness;defLightClock=defLightClock or Lighting.ClockTime;defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1;Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end end) end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end)
end
disableAntiLag=function()
    removeAccessoriesEnabled=false;antiLagEnabled=false;if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
    pcall(function() if defLightBrightness then Lighting.Brightness=defLightBrightness end;if defLightClock then Lighting.ClockTime=defLightClock end;if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end;Lighting.ExposureCompensation=0 end)
end
function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function useMedusaCounter()
    if medusaDebounce then return end;if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if medusaCounterEnabled then
                useMedusaCounter()
            end
        end
    end)
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char=LP.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true;task.spawn(function() local bat=findBatForCounter();if bat then swingBatForCounter(bat,char) end;task.wait(0.5);batCounterDebounce=false end)
        end
    end)
end
stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end;batCounterDebounce=false end
local aimbotConn=nil
local BAT_AIMBOT_SPEED=58
local findBat, getClosestTarget, swingCurrentBat
;(function()
-- ── Bat Aimbot (Envy logic) ───────────────────────────────────────────────
local _predBall=nil
findBat = function()
    local char=LP.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end
getClosestTarget = function()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart");local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude;if dist<minDist then minDist=dist;closest=tRoot end end
        end
    end
    return closest
end
swingCurrentBat = function()
    if not autoSwingEnabled then return end;local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end
startBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect() end;autoBatEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    local hum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate=false end
    -- Fast auto TP Down when bat aimbot starts
    task.spawn(function()
        for _=1,6 do
            if not autoBatEnabled then break end
            pcall(function() if runTPFloor then runTPFloor() elseif doAutoTPDown then doAutoTPDown(true) end end)
            task.wait(0.05)
        end
    end)
    aimbotConn=RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c=LP.Character;if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart");if not root then return end
        local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end
        if not c:FindFirstChildOfClass("Tool") then
            local bat=findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target=getClosestTarget()
        if not target then swingCurrentBat();return end
        local targetVel=target.AssemblyLinearVelocity
        local myPos=root.Position
        local targetPos=target.Position
        local predictPos=targetPos+targetVel*0.14
        predictPos=predictPos+target.CFrame.LookVector*0.3
        local direction=predictPos-myPos
        local flatDir=Vector3.new(direction.X,0,direction.Z)
        if flatDir.Magnitude<0.01 then swingCurrentBat(); return end
        flatDir=flatDir.Unit
        local chaseSpeed=math.clamp(tonumber(BAT_AIMBOT_SPEED) or 58, 10, 200)
        local desiredHeight=targetPos.Y+3.7
        local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8
        if hum.FloorMaterial~=Enum.Material.Air then
            yVel=math.max(yVel,13)
        end
        yVel=math.clamp(yVel,-70,110)
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
        local speed3=targetVel.Magnitude
        local predictTime=math.clamp(speed3/150,0.05,0.2)
        local predictedPos=targetPos+targetVel*predictTime
        local toPredict=predictedPos-myPos
        if toPredict.Magnitude>0.1 then
            local goalCF=CFrame.lookAt(myPos,predictedPos)
            local curCF=root.CFrame
            local diffCF=curCF:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-2.5,2.5)
            ry=math.clamp(ry,-2.5,2.5)
            rz=math.clamp(rz,-2.5,2.5)
            local tiltSpeed=42
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(
                Vector3.new(rx*tiltSpeed,ry*tiltSpeed,rz*tiltSpeed)
            )
        end
        swingCurrentBat()
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect();aimbotConn=nil end;autoBatEnabled=false
    if _predBall then _predBall:Destroy();_predBall=nil end
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end
    if autoTPEnabled then startAutoTP() end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
queueAutoBatStart=function()
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end


end)()
-- Extras from ANAS (IIFE = own register pool)
headlessEnabled=false; korbloxEnabled=false
startTPBat=nil; stopTPBat=nil; toggleTPBat=nil
applyHeadlessToChar=nil; applyKorbloxToChar=nil; applyAvatarCosmetics=nil
tpBatSetVisual=nil
;(function()
    local HMID,KMID,KTID="rbxassetid://1095708","rbxassetid://101851696","rbxassetid://101851254"
    local KC=Color3.fromRGB(64,64,64)
    applyHeadlessToChar=function(char,on)
        local head=char and char:FindFirstChild("Head"); if not head then return end
        if on then
            head.Transparency=1; head.CanCollide=false
            local f=head:FindFirstChild("face"); if f then f:Destroy() end
            for _,c in ipairs(head:GetChildren()) do if c:IsA("SpecialMesh") and c.Name=="HeadlessMesh" then c:Destroy() end end
            local m=Instance.new("SpecialMesh"); m.Name="HeadlessMesh"; m.MeshType=Enum.MeshType.FileMesh
            m.MeshId=HMID; m.Scale=Vector3.new(0.001,0.001,0.001); m.Parent=head
        else
            head.Transparency=0; head.CanCollide=true
            for _,c in ipairs(head:GetChildren()) do if c.Name=="HeadlessMesh" then c:Destroy() end end
        end
    end
    applyKorbloxToChar=function(char,on)
        local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if hum.RigType==Enum.HumanoidRigType.R6 then
            local leg=char:FindFirstChild("Right Leg"); if not leg then return end
            if on then
                for _,c in ipairs(leg:GetChildren()) do if c:IsA("SpecialMesh") or c:IsA("CharacterMesh") then c:Destroy() end end
                leg.Color=KC
                local m=Instance.new("SpecialMesh"); m.Name="KorbloxMesh"; m.MeshType=Enum.MeshType.FileMesh
                m.MeshId=KMID; m.TextureId=KTID; m.Parent=leg
            else
                for _,c in ipairs(leg:GetChildren()) do if c.Name=="KorbloxMesh" then c:Destroy() end end
                leg.Color=Color3.fromRGB(255,255,255)
            end
        else
            local u=char:FindFirstChild("RightUpperLeg"); if not u then return end
            local lo,ft,old=char:FindFirstChild("RightLowerLeg"),char:FindFirstChild("RightFoot"),char:FindFirstChild("KorbloxLeg")
            if on then
                u.Transparency=1; if lo then lo.Transparency=1 end; if ft then ft.Transparency=1 end; if old then old:Destroy() end
                local p=Instance.new("Part"); p.Name="KorbloxLeg"; p.Size=Vector3.new(1,2,1); p.CanCollide=false; p.Color=KC; p.Parent=char
                local m=Instance.new("SpecialMesh"); m.Name="KorbloxMesh"; m.MeshType=Enum.MeshType.FileMesh; m.MeshId=KMID; m.TextureId=KTID; m.Parent=p
                local w=Instance.new("Weld"); w.Name="KorbloxWeld"; w.Part0=u; w.Part1=p; w.C0=CFrame.new(0,-0.8,0); w.Parent=p
            else
                u.Transparency=0; if lo then lo.Transparency=0 end; if ft then ft.Transparency=0 end; if old then old:Destroy() end
            end
        end
    end
    applyAvatarCosmetics=function(char)
        if not char then return end
        applyHeadlessToChar(char,headlessEnabled==true)
        applyKorbloxToChar(char,korbloxEnabled==true)
    end
    forceCosmeticsPersistent=nil
    forceCosmeticsPersistent=function(char)
        if not char then return end
        -- re-apply several times because game reloads avatar after spawn
        for _,delay in ipairs({0.2,0.6,1.2,2.0,3.5}) do
            task.delay(delay,function()
                if not char.Parent then return end
                if headlessEnabled then pcall(applyHeadlessToChar,char,true) end
                if korbloxEnabled then pcall(applyKorbloxToChar,char,true) end
            end)
        end
    end


    
    -- ===== Void.VS Anti Desync / TP Bat (from Void.Vs) =====
    tpBatEnabled = false
    tpBatConn = nil
    tpBatHittingCD = false
    local _voidTp = {
        hitCD = false,
        lockedRoot = nil,
        hitDone = false,
        targetHealth = nil,
        targetHum = nil,
        shieldConn = nil,
        antiDieConn = nil,
        charConn = nil,
    }

    -- Noxa-compatible melee lookup: prefer bat/slap, then support other
    -- melee tools used by variants of the game without stealing unrelated tools.
    local function voidFindBat()
        local char = LP.Character
        if not char then return nil end
        local function isMelee(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n = tool.Name:lower()
            return n:find("bat") or n:find("slap") or n:find("sword")
                or n:find("knife") or n:find("blade") or n:find("mace")
                or tool:FindFirstChildWhichIsA("RemoteEvent") ~= nil
                or tool:FindFirstChild("Activate") ~= nil
        end
        local tool = char:FindFirstChild("Bat")
        if isMelee(tool) then return tool end
        local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if bp then
            tool = bp:FindFirstChild("Bat")
            if isMelee(tool) then return tool end
        end
        if type(BAT_COUNTER_SLAP_LIST) == "table" then
            for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
                tool = char:FindFirstChild(name)
                if isMelee(tool) then return tool end
                if bp then
                    tool = bp:FindFirstChild(name)
                    if isMelee(tool) then return tool end
                end
            end
        end
        for _, child in ipairs(char:GetChildren()) do
            if isMelee(child) then return child end
        end
        if bp then
            for _, child in ipairs(bp:GetChildren()) do
                if isMelee(child) then return child end
            end
        end
        return nil
    end

    local function voidClosestRoot()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, 1e9 end
        local best, bestDist = nil, 1e9
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if tr and hum and hum.Health > 0 then
                    local d = (tr.Position - hrp.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = tr
                    end
                end
            end
        end
        return best, bestDist
    end

    local function voidTpHit()
        if _voidTp.hitCD then return end
        _voidTp.hitCD = true
        pcall(function()
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local bat = voidFindBat()
            if not bat then return end
            if bat.Parent ~= char and hum then
                pcall(function() hum:EquipTool(bat) end)
            end
            pcall(function() bat:Activate() end)
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then pcall(function() d:FireServer() end) end
            end
        end)
        task.delay(math.max(0.04, tonumber(tpBatSwingCooldown) or 0.12), function()
            _voidTp.hitCD = false
        end)
    end

    local function voidStopAntiDie()
        if _voidTp.antiDieConn then
            pcall(function() _voidTp.antiDieConn:Disconnect() end)
            _voidTp.antiDieConn = nil
        end
    end

    local function voidBindAntiDie(char)
        voidStopAntiDie()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
        if not hum then return end
        _voidTp.antiDieConn = hum.HealthChanged:Connect(function(h)
            if not tpBatEnabled and not _G.AceAntiDesyncAimbotOn then return end
            if h <= 0 then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
        end)
    end

    startTPBat = function()
        if autoBatEnabled and stopBatAimbot then stopBatAimbot() end
        if autoLeftEnabled then autoLeftEnabled=false; if stopAutoLeft then stopAutoLeft() end end
        if autoRightEnabled then autoRightEnabled=false; if stopAutoRight then stopAutoRight() end end

        if tpBatConn then pcall(function() tpBatConn:Disconnect() end); tpBatConn = nil end
        if _voidTp.shieldConn then pcall(function() _voidTp.shieldConn:Disconnect() end); _voidTp.shieldConn = nil end
        if _voidTp.charConn then pcall(function() _voidTp.charConn:Disconnect() end); _voidTp.charConn = nil end

        tpBatEnabled = true
        _G.AceAntiDesyncAimbotOn = true
        _voidTp.hitDone = false
        _voidTp.targetHealth = nil
        _voidTp.targetHum = nil
        _voidTp.lockedRoot = nil

        voidBindAntiDie(LP.Character)
        _voidTp.charConn = LP.CharacterAdded:Connect(function(c)
            if not tpBatEnabled then return end
            task.wait(0.1)
            voidBindAntiDie(c)
        end)

        -- Main desync + stick loop (Void style)
        tpBatConn = RunService.Heartbeat:Connect(function()
            if not tpBatEnabled then return end
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                pcall(function() hum.Health = hum.MaxHealth end)
            end

            local locked = _voidTp.lockedRoot
            if tpBatVersion == "V2" then
                -- V2 follows the nearest live target every frame, like Noxa V2.
                locked = voidClosestRoot()
                _voidTp.lockedRoot = locked
            elseif not locked or not locked.Parent or not locked.Parent.Parent then
                locked = voidClosestRoot()
                _voidTp.lockedRoot = locked
            else
                local th = locked.Parent and locked.Parent:FindFirstChildOfClass("Humanoid")
                if not th or th.Health <= 0 then
                    locked = voidClosestRoot()
                    _voidTp.lockedRoot = locked
                end
            end

            if locked then
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", locked) end)
                end

                local vel = locked.AssemblyLinearVelocity or Vector3.zero
                if tpBatVersion == "V2" then
                    local aimPos = locked.Position + Vector3.new(0, 0.9, 0)
                        + Vector3.new(vel.X, 0, vel.Z) * 0.05
                    local look = Vector3.new(locked.CFrame.LookVector.X, 0, locked.CFrame.LookVector.Z)
                    if look.Magnitude < 0.01 then
                        look = Vector3.new(locked.Position.X - hrp.Position.X, 0, locked.Position.Z - hrp.Position.Z)
                    end
                    if look.Magnitude > 0.05 then
                        hrp.CFrame = CFrame.lookAt(aimPos, aimPos + look.Unit)
                    else
                        hrp.CFrame = CFrame.new(aimPos)
                    end
                else
                    local pred = locked.Position + vel * 0.05 + Vector3.new(0, 0.35, 0)
                    local aimPos = pred + Vector3.new(0, 0.2, 0)
                    local look = Vector3.new(vel.X, 0, vel.Z)
                    if look.Magnitude < 0.15 then
                        look = Vector3.new(locked.Position.X - hrp.Position.X, 0, locked.Position.Z - hrp.Position.Z)
                    end
                    if look.Magnitude > 0.05 then
                        hrp.CFrame = CFrame.lookAt(aimPos, aimPos + look.Unit)
                    else
                        hrp.CFrame = CFrame.new(aimPos)
                    end
                end
                if (hrp.Position - locked.Position).Magnitude > 3.5 then
                    hrp.CFrame = CFrame.lookAt(locked.Position + Vector3.new(0, 0.4, 0), locked.Position)
                end
                hrp.AssemblyLinearVelocity = vel
                hrp.AssemblyAngularVelocity = Vector3.zero

                local cam = workspace.CurrentCamera
                if cam and (tpBatVersion == "V1" or tpBatCameraLock) then
                    cam.CFrame = CFrame.lookAt(cam.CFrame.Position, locked.Position + Vector3.new(0, 1, 0))
                end

                if autoSwingEnabled or tpBatAutoDisableOnHit
                    or (hrp.Position - locked.Position).Magnitude < 4 then
                    voidTpHit()
                end

                local th = locked.Parent and locked.Parent:FindFirstChildOfClass("Humanoid")
                if th then
                    if th == _voidTp.targetHum and _voidTp.targetHealth
                        and tpBatAutoDisableOnHit
                        and (th.PlatformStand or th.Health < _voidTp.targetHealth - 0.5) then
                        -- Optional Noxa behavior: stop after a confirmed hit.
                        stopTPBat()
                        return
                    end
                    _voidTp.targetHum = th
                    _voidTp.targetHealth = th.Health
                end
            end
        end)

        -- Shield: dodge other bat users nearby (Void style)
        _voidTp.shieldConn = RunService.Heartbeat:Connect(function()
            if not tpBatEnabled then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            local closest = voidClosestRoot()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local oroot = p.Character:FindFirstChild("HumanoidRootPart")
                    local tool = p.Character:FindFirstChildWhichIsA("Tool")
                    if oroot and tool then
                        local lower = tool.Name:lower()
                        if (lower:find("bat") or lower:find("slap"))
                            and (hrp.Position - oroot.Position).Magnitude < 8
                            and oroot ~= closest then
                            local a = math.rad(tick() * 500)
                            hrp.CFrame = hrp.CFrame * CFrame.new(math.sin(a) * 3, 0, math.cos(a) * 3)
                        end
                    end
                end
            end
        end)

        if tpBatSetVisual then tpBatSetVisual(true) end
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(true) end
    end

    stopTPBat = function()
        tpBatEnabled = false
        _G.AceAntiDesyncAimbotOn = false
        _voidTp.hitDone = false
        _voidTp.targetHealth = nil
        _voidTp.targetHum = nil
        _voidTp.lockedRoot = nil
        if tpBatConn then pcall(function() tpBatConn:Disconnect() end); tpBatConn = nil end
        if _voidTp.shieldConn then pcall(function() _voidTp.shieldConn:Disconnect() end); _voidTp.shieldConn = nil end
        if _voidTp.charConn then pcall(function() _voidTp.charConn:Disconnect() end); _voidTp.charConn = nil end
        voidStopAntiDie()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if sethiddenproperty and hrp then
            pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", nil) end)
        end
        if hrp then
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam and cam.CameraType == Enum.CameraType.Scriptable then
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
        if tpBatSetVisual then tpBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
    end

    toggleTPBat = function()
        if tpBatEnabled or _G.AceAntiDesyncAimbotOn then stopTPBat() else startTPBat() end
    end

    -- ===== E01 CARRY GUARD (MMA-styled, based on Fix E01) =====
    local function e01IsCarrying()
        local char = LP.Character
        if not char then return false end
        if brainrotDetected == true then return true end

        for _, child in ipairs(char:GetChildren()) do
            local name = child.Name:lower()
            if name:find("brainrot") or name:find("brain") or name:find("animal")
                or name:find("carry") or name:find("stolen")
                or name:find("held") or name:find("steal") then
                return true
            end
        end

        for attrName, attrValue in pairs(char:GetAttributes()) do
            local name = attrName:lower()
            if attrValue == true and (name:find("carrying") or name:find("carry")
                or name:find("stealing") or name:find("isstealing")
                or name:find("hasbrainrot")) then
                return true
            end
        end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed > 0 and hum.WalkSpeed <= 25 and hum.WalkSpeed ~= 16 then
            return true
        end
        return false
    end

    local function e01ClearNotice()
        if e01CountdownConn then
            pcall(function() e01CountdownConn:Disconnect() end)
            e01CountdownConn = nil
        end
        if e01Billboard then
            pcall(function() e01Billboard:Destroy() end)
            e01Billboard = nil
        end
        local char = LP.Character
        local head = char and char:FindFirstChild("Head")
        local old = head and head:FindFirstChild("MMAE01Guard")
        if old then pcall(function() old:Destroy() end) end
    end

    local function e01StartNotice()
        e01ClearNotice()
        local char = LP.Character
        local head = char and char:FindFirstChild("Head")
        if not head then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MMAE01Guard"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 260, 0, 82)
        billboard.StudsOffset = Vector3.new(0, 5.6, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 260
        billboard.Parent = head
        e01Billboard = billboard

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 1, 0)
        card.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
        card.BackgroundTransparency = 0.08
        card.BorderSizePixel = 0
        card.Parent = billboard
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Color3.fromRGB(255, 94, 144)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.12

        local eyebrow = Instance.new("TextLabel", card)
        eyebrow.Size = UDim2.new(1, -24, 0, 16)
        eyebrow.Position = UDim2.new(0, 12, 0, 7)
        eyebrow.BackgroundTransparency = 1
        eyebrow.Text = "MMA  //  E01 GUARD"
        eyebrow.TextColor3 = Color3.fromRGB(255, 132, 174)
        eyebrow.TextSize = 10
        eyebrow.Font = Enum.Font.GothamBold
        eyebrow.TextXAlignment = Enum.TextXAlignment.Left

        local status = Instance.new("TextLabel", card)
        status.Name = "Status"
        status.Size = UDim2.new(1, -24, 0, 25)
        status.Position = UDim2.new(0, 12, 0, 22)
        status.BackgroundTransparency = 1
        status.Text = "SECURE CARRY  3.0s"
        status.TextColor3 = Color3.fromRGB(245, 247, 255)
        status.TextSize = 16
        status.Font = Enum.Font.GothamBlack
        status.TextXAlignment = Enum.TextXAlignment.Left

        local track = Instance.new("Frame", card)
        track.Size = UDim2.new(1, -24, 0, 5)
        track.Position = UDim2.new(0, 12, 1, -17)
        track.BackgroundColor3 = Color3.fromRGB(48, 51, 66)
        track.BorderSizePixel = 0
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 94, 144)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local duration = 3
        local started = tick()
        e01CountdownConn = RunService.RenderStepped:Connect(function()
            if not billboard.Parent or not status.Parent then
                e01ClearNotice()
                return
            end
            local remaining = math.max(0, duration - (tick() - started))
            local progress = math.clamp((tick() - started) / duration, 0, 1)
            fill.Size = UDim2.new(progress, 0, 1, 0)
            if remaining > 0 then
                status.Text = string.format("SECURE CARRY  %.1fs", remaining)
            else
                if e01CountdownConn then
                    e01CountdownConn:Disconnect()
                    e01CountdownConn = nil
                end
                status.Text = "STEAL WINDOW OPEN"
                status.TextColor3 = Color3.fromRGB(92, 255, 171)
                fill.BackgroundColor3 = Color3.fromRGB(92, 255, 171)
                stroke.Color = Color3.fromRGB(92, 255, 171)
                task.delay(2, function()
                    if billboard and billboard.Parent then
                        local fade = TweenService:Create(card, TweenInfo.new(0.45), {
                            BackgroundTransparency = 1
                        })
                        local fadeText = TweenService:Create(status, TweenInfo.new(0.45), {
                            TextTransparency = 1
                        })
                        fade:Play()
                        fadeText:Play()
                        fade.Completed:Connect(function()
                            if billboard and billboard.Parent then billboard:Destroy() end
                            if e01Billboard == billboard then e01Billboard = nil end
                        end)
                    end
                end)
            end
        end)
    end

    stopE01Watch = function()
        if e01ScanConn then
            pcall(function() e01ScanConn:Disconnect() end)
            e01ScanConn = nil
        end
        e01WasCarrying = false
        e01ClearNotice()
    end

    startE01Watch = function()
        if e01ScanConn then return end
        e01ScanConn = RunService.Heartbeat:Connect(function()
            if not e01Enabled then return end
            local carrying = e01IsCarrying()
            if carrying and not e01WasCarrying then
                e01StartNotice()
            elseif not carrying and e01WasCarrying then
                e01ClearNotice()
            end
            e01WasCarrying = carrying
        end)
    end

    setE01Enabled = function(on)
        e01Enabled = on == true
        if e01Enabled then
            startE01Watch()
        else
            stopE01Watch()
        end
        if e01SetVisual then pcall(e01SetVisual, e01Enabled) end
    end

    startE01Watch()

    -- full cleanup so player can leave the map without being stuck
    local function mmaFullCleanup()
        -- CharacterRemoving is also fired during a normal respawn.
        -- Stop character-bound connections, but NEVER lose the user's ON/OFF state.
        local saved = {
            tpBat = _G.AceAntiDesyncAimbotOn == true,
            autoBat = autoBatEnabled == true,
            antiRag = antiRagdollEnabled == true,
            autoLeft = autoLeftEnabled == true,
            autoRight = autoRightEnabled == true,
            autoSteal = Steal.AutoStealEnabled == true,
            autoTP = autoTPEnabled == true,
            infJump = (infJumpEnabled == true) or (_G.MMA_InfJumpOn == true) or (_G.MMA_WantedState and _G.MMA_WantedState.infJump == true),
            medusa = medusaCounterEnabled == true,
            batCounter = batCounterEnabled == true,
            headless = headlessEnabled == true,
            korblox = korbloxEnabled == true,
            unwalk = unwalkEnabled == true,
            carry = carrySpeedActive == true,
            lagger = laggerModeEnabled == true,
        }
        pcall(function() if stopTPBat then stopTPBat() end end)
        e01WasCarrying = false
        e01ClearNotice()
        pcall(function() if stopBatAimbot then stopBatAimbot() end end)
        pcall(function()
            if Conns and Conns.antiRag then
                Conns.antiRag:Disconnect(); Conns.antiRag=nil
            end
        end)
        pcall(function() if stopAutoLeft then stopAutoLeft() end end)
        pcall(function() if stopAutoRight then stopAutoRight() end end)
        -- Disconnect steal loop only — flags + WantedState stay ON
        pcall(function()
            if ConnsAutoSteal and ConnsAutoSteal.autoSteal then
                ConnsAutoSteal.autoSteal:Disconnect()
                ConnsAutoSteal.autoSteal = nil
            end
            if Conns and Conns.autoSteal then
                Conns.autoSteal:Disconnect()
                Conns.autoSteal = nil
            end
            isStealing = false
        end)
        -- Inf Jump: NEVER stop on death (permanent loop uses _G.MMA_InfJumpOn)
        pcall(function() if stopAutoTP then stopAutoTP() end end)
        -- Restore state flags immediately so the settings UI never flips OFF on death.
        autoBatEnabled=saved.autoBat
        antiRagdollEnabled=saved.antiRag or (_G.MMA_WantedState and _G.MMA_WantedState.antiRag) or false
        autoLeftEnabled=saved.autoLeft
        autoRightEnabled=saved.autoRight
        Steal.AutoStealEnabled=saved.autoSteal or (_G.MMA_WantedState and _G.MMA_WantedState.autoSteal) or false
        autoStealEnabled=Steal.AutoStealEnabled
        autoTPEnabled=saved.autoTP
        infJumpEnabled=saved.infJump or (_G.MMA_WantedState and _G.MMA_WantedState.infJump) or (_G.MMA_InfJumpOn == true) or false
        if infJumpEnabled then _G.MMA_InfJumpOn = true; if _G.MMA_WantedState then _G.MMA_WantedState.infJump = true end end
        medusaCounterEnabled=saved.medusa
        batCounterEnabled=saved.batCounter
        unwalkEnabled=saved.unwalk
        carrySpeedActive=saved.carry
        laggerModeEnabled=saved.lagger
        _G.MMA_PendingRespawnState=saved
        local char=LP.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if sethiddenproperty and hrp then
            pcall(function() sethiddenproperty(hrp,"PhysicsRepRootPart",nil) end)
        end
        if hrp then
            pcall(function()
                hrp.Anchored=false
                hrp.AssemblyLinearVelocity=Vector3.zero
                hrp.AssemblyAngularVelocity=Vector3.zero
            end)
        end
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.PlatformStand=false;hum.Sit=false;hum.AutoRotate=true end)
        end
    end
    _G.MMAFullCleanup = mmaFullCleanup

    LP.CharacterRemoving:Connect(function()
        pcall(mmaFullCleanup)
    end)
    LP.CharacterAdded:Connect(function(char)
        e01WasCarrying = false
        e01ClearNotice()
        task.wait(0.35)
        pcall(applyAvatarCosmetics,char)
        pcall(forceCosmeticsPersistent,char)
        _G.AceAntiDesync.h=char:FindFirstChildOfClass("Humanoid")
        _G.AceAntiDesync.hrp=char:FindFirstChild("HumanoidRootPart")
        local pending=_G.MMA_PendingRespawnState
        local want=_G.MMA_WantedState or {}
        -- Reconnect every character-dependent feature that was ON before death.
        if pending then
            _G.AceAntiDesyncAimbotOn=pending.tpBat==true
            autoBatEnabled=pending.autoBat==true
            antiRagdollEnabled=(pending.antiRag==true) or (want.antiRag==true)
            autoLeftEnabled=pending.autoLeft==true
            autoRightEnabled=pending.autoRight==true
            Steal.AutoStealEnabled=(pending.autoSteal==true) or (want.autoSteal==true)
            autoStealEnabled=Steal.AutoStealEnabled
            autoTPEnabled=pending.autoTP==true
            infJumpEnabled=(pending.infJump==true) or (want.infJump==true)
            medusaCounterEnabled=pending.medusa==true
            batCounterEnabled=pending.batCounter==true
            if pending.headless~=nil then headlessEnabled=pending.headless==true end
            if pending.korblox~=nil then korbloxEnabled=pending.korblox==true end
            unwalkEnabled=pending.unwalk==true
            carrySpeedActive=pending.carry==true
            laggerModeEnabled=pending.lagger==true
            _G.MMA_PendingRespawnState=nil
        else
            -- New round / no CharacterRemoving: still honor wanted state
            if want.antiRag then antiRagdollEnabled=true end
            if want.autoSteal then Steal.AutoStealEnabled=true; autoStealEnabled=true end
            if want.infJump then infJumpEnabled=true end
        end
        pcall(function() if setupSpeedIndicator then setupSpeedIndicator(char) end end)
        pcall(function() if setupRagdollTriggers then setupRagdollTriggers() end end)
        if medusaCounterEnabled then task.spawn(function() pcall(function() setupMedusa(char) end) end) end
        if batCounterEnabled then task.spawn(function() pcall(startBatCounter) end) end
        if unwalkEnabled then task.spawn(function() task.wait(0.4);pcall(startUnwalk) end) end
        -- Force re-apply from WantedState (source of truth)
        do
            local want = _G.MMA_WantedState or {}
            if want.antiRag then antiRagdollEnabled = true end
            if want.autoSteal then Steal.AutoStealEnabled = true; autoStealEnabled = true end
            if want.infJump then infJumpEnabled = true end
        end
        if antiRagdollEnabled or (_G.MMA_WantedState and _G.MMA_WantedState.antiRag) then
            task.spawn(function()
                for _,delay in ipairs({0.2, 0.8, 1.5}) do
                    task.wait(delay)
                    antiRagdollEnabled = true
                    pcall(function()
                        if startAntiRagdoll then startAntiRagdoll()
                        elseif _G.startAntiRagdoll then _G.startAntiRagdoll() end
                    end)
                    if setAntiRagVisual then pcall(setAntiRagVisual, true) end
                end
            end)
        end
        if infJumpEnabled or (_G.MMA_WantedState and _G.MMA_WantedState.infJump) then
            task.spawn(function()
                for _,delay in ipairs({0.2, 0.7, 1.4}) do
                    task.wait(delay)
                    infJumpEnabled = true
                    if _G.MMA_WantedState then _G.MMA_WantedState.infJump = true end
                    pcall(startHoldInfJump)
                    if setInfJumpVisual then pcall(setInfJumpVisual, true) end
                end
            end)
        end
        if antiDropEnabled or carrySpeedActive or laggerModeEnabled then task.spawn(function() task.wait(0.2);pcall(startAntiDrop) end) end
        if autoTPEnabled then task.spawn(function() task.wait(0.25);pcall(startAutoTP) end) end
        if autoBatEnabled then task.spawn(function() task.wait(0.35);pcall(startBatAimbot) end) end
        if autoLeftEnabled then task.spawn(function() task.wait(0.35);pcall(startAutoLeft) end) end
        if autoRightEnabled then task.spawn(function() task.wait(0.35);pcall(startAutoRight) end) end
        if Steal.AutoStealEnabled or (_G.MMA_WantedState and _G.MMA_WantedState.autoSteal) then
            task.spawn(function()
                for _,delay in ipairs({0.4, 1.0, 2.0}) do
                    task.wait(delay)
                    Steal.AutoStealEnabled = true
                    autoStealEnabled = true
                    _G.MMA_WantedState.autoSteal = true
                    pcall(startAutoSteal)
                end
            end)
        end
        if _G.AceAntiDesyncAimbotOn then task.wait(0.3); pcall(startTPBat) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    end)
    if LP.Character then pcall(applyAvatarCosmetics,LP.Character); pcall(forceCosmeticsPersistent,LP.Character) end
end)()

saveConfig=function()
    local function ks(e)
        if type(e)~="table" then return {kb=nil,gp=nil} end
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
    local keyTbl={}
    local srcKeys = _GuiKeys or Keys
    if type(srcKeys)=="table" then
        for k,v in pairs(srcKeys) do
            if typeof(v)=="EnumItem" then keyTbl[k]=v.Name
            elseif type(v)=="string" then keyTbl[k]=v end
        end
    end
    local ctrlTbl={}
    if type(ControllerKeys)=="table" then
        for k,v in pairs(ControllerKeys) do
            if typeof(v)=="EnumItem" then ctrlTbl[k]=v.Name
            elseif type(v)=="string" then ctrlTbl[k]=v end
        end
    end
    local cfg={
        normalSpeed=NS, carrySpeed=CS, batAimbotSpeed=BAT_AIMBOT_SPEED,
        grabRadius=Steal.StealRadius, stealDuration=Steal.StealDuration,
        completeRadius=Steal.CompleteRadius, stealMode=Steal.Mode,
        antiRagdoll=antiRagdollEnabled, antiDrop=antiDropEnabled, autoStealEnabled=Steal.AutoStealEnabled,
        infiniteJump=(infJumpEnabled==true) or (_G.MMA_InfJumpOn==true), infJumpMode=infJumpMode,
        streamerMode=streamerModeEnabled,
        medusaCounter=medusaCounterEnabled, batCounter=batCounterEnabled,
        carrySpeedActive=carrySpeedActive, laggerModeEnabled=laggerModeEnabled,
        laggerCarrySpeed=LAGGER_CARRY_SPEED,
        autoBat=autoBatEnabled, autoSwing=autoSwingEnabled, unwalkEnabled=unwalkEnabled,
        antiLag=antiLagEnabled, stretchRez=stretchRezEnabled, nuke=nukeEnabled,
        autoTPEnabled=autoTPEnabled, autoTPHeight=autoTPHeight,
        guiTransparencyEnabled=guiTransparencyEnabled,
        mobileButtonsEnabled=true, mobileButtonsLocked=mobileButtonsLocked,
        mobileButtonsSize=mobileButtonsSize, circleButtonsEnabled=circleButtonsEnabled,
        autoSwitchSpeed=autoSwitchSpeedEnabled, fovValue=fovValue,
        perButtonDrag=perButtonDragEnabled, skyTheme=currentSkyTheme,
        medusaReset=medusaResetEnabled, autoMoveSwing=autoMoveSwingEnabled,
        autoMoveSwingInterval=autoMoveSwingInterval, ragdollGui=ragdollGuiEnabled,
        introSoundEnabled=introSoundEnabled, animEnabled=animEnabled,
        backgroundEnabled=backgroundEnabled, backgroundIndex=backgroundIndex,
        safeSpeedNearBaseEnabled=safeSpeedNearBaseEnabled==true,
        mmaServerLaggerEnabled=mmaServerLaggerEnabled==true,
        headlessEnabled=headlessEnabled==true, korbloxEnabled=korbloxEnabled==true,
        tpBatVersion=tpBatVersion, tpBatCameraLock=tpBatCameraLock,
        tpBatAutoDisableOnHit=tpBatAutoDisableOnHit, e01Enabled=e01Enabled,
        keys=keyTbl, controllerKeys=ctrlTbl,
    }
    local ok, encoded = pcall(function() return HS:JSONEncode(cfg) end)
    if not ok or not encoded then return end
    -- try multiple save methods so settings persist
    pcall(function() if writefile then writefile("MMA_Mobile.json", encoded) end end)
    pcall(function() if writefile then writefile("MMA_Config.json", encoded) end end)
    pcall(function()
        if setclipboard then -- no-op, just keep encoded available
        end
    end)
    _G.MMA_LastConfig = cfg
end
task.spawn(function() while task.wait(3) do pcall(saveConfig) end end)
local resetAllSettings
resetAllSettings = function()
    NS=59;CS=29;LAGGER_CARRY_SPEED=15;antiDropEnabled=false;antiDropActive=false;carrySpeedActive=false;laggerModeEnabled=false
    autoSwitchSpeedEnabled=false;antiRagdollEnabled=false;infJumpEnabled=false;infJumpMode="manual"
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;autoSwingEnabled=true;autoMoveSwingEnabled=false
    autoTPEnabled=false;autoTPHeight=20;antiLagEnabled=false;stretchRezEnabled=false;pcall(nukeStop)
    Steal.AutoStealEnabled=false;Steal.StealRadius=60;Steal.StealDuration=1.4;Steal.CompleteRadius=9;Steal.Mode="V1"
    BAT_AIMBOT_SPEED=58
    tpBatVersion="V1";tpBatCameraLock=false;tpBatAutoDisableOnHit=false;e01Enabled=true
    if setE01Enabled then pcall(setE01Enabled,true) end
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsSize=80
    circleButtonsEnabled=false;uiLocked=false;fovValue=80;fovIndex=1
    introSoundEnabled=true
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil};KB.InstaReset={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopAutoTP();stopHoldInfJump();stopAntiDrop()
    if stretchRezEnabled then disableStretchRez() end;if antiLagEnabled then disableAntiLag() end;saveConfig()
end
-- REGISTER-LIMIT FIX: split + global funcs to stay under 200 locals
function __spectrumBoot_core()
local setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual
local _persistentConns={}
local function trackConn(conn) table.insert(_persistentConns,conn);return conn end
local function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerModeEnabled then
            modeValLbl.Text = "Lagger Carry"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local WHITE=Color3.fromRGB(200,30,40);local OFF=Color3.fromRGB(0,0,0);local GRAY=Color3.fromRGB(80,80,85)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local WHITE=Color3.fromRGB(200,30,40);local OFF=Color3.fromRGB(0,0,0);local GRAY=Color3.fromRGB(80,80,85)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
end
local _prevCarryBeforeLagger = false
toggleCarryMode=function()
    -- Toggle between Normal Speed and Carry Speed (exit lagger if active)
    if laggerModeEnabled then
        laggerModeEnabled = false
    end
    carrySpeedActive = not carrySpeedActive
    syncAutoAntiDrop()
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end
toggleLaggerMode=function()
    -- Dedicated Lagger Carry toggle. Uses the configured Lagger Carry speed.
    if not laggerModeEnabled then
        _prevCarryBeforeLagger = carrySpeedActive
        laggerModeEnabled = true
        carrySpeedActive = false
    else
        laggerModeEnabled = false
        carrySpeedActive = _prevCarryBeforeLagger
    end
    if syncAutoAntiDrop then syncAutoAntiDrop() end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    saveConfig()
end
local function speedToggleAction()
    -- Q key: does nothing (carry toggle is only on customizable carryMode keybind)
end

-- Anti Ragdoll (EXACT from rave hub AntiRagdollV2)
;(function()
    local AntiRagdollV2 = {
        Enabled = false,
        Connection = nil,
        ResetCooldown = 0,
    }

    startAntiRagdoll = function()
        if AntiRagdollV2.Connection then
            pcall(function() AntiRagdollV2.Connection:Disconnect() end)
            AntiRagdollV2.Connection = nil
        end
        AntiRagdollV2.Enabled = true
        antiRagdollEnabled = true
        if _G.MMA_WantedState then _G.MMA_WantedState.antiRag = true end
        AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
            if not AntiRagdollV2.Enabled then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end
            if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
            local state = hum:GetState()
            local now = tick()
            if state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown then
                if now - AntiRagdollV2.ResetCooldown > 0.15 then
                    AntiRagdollV2.ResetCooldown = now
                    pcall(function()
                        if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        root.Velocity = Vector3.zero
                        root.RotVelocity = Vector3.zero
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        for _, obj in ipairs(char:GetDescendants()) do
                            if obj:IsA("Motor6D") then obj.Enabled = true end
                            if obj:IsA("Constraint") then obj.Enabled = true end
                        end
                        if workspace.CurrentCamera then
                            workspace.CurrentCamera.CameraSubject = hum
                        end
                        local ps = LP:FindFirstChild("PlayerScripts")
                        local PM = ps and ps:FindFirstChild("PlayerModule")
                        if PM then
                            local cm = PM:FindFirstChild("ControlModule")
                            if cm then
                                local ok, CM = pcall(require, cm)
                                if ok and CM and CM.Enable then
                                    pcall(function() CM:Enable() end)
                                end
                            end
                        end
                        hum.AutoRotate = true
                        hum.PlatformStand = false
                        hum.Sit = false
                    end)
                end
            end
        end)
        Conns.antiRag = AntiRagdollV2.Connection
        if setAntiRagVisual then pcall(setAntiRagVisual, true) end
    end

    stopAntiRagdoll = function(keepFlag)
        AntiRagdollV2.Enabled = false
        if AntiRagdollV2.Connection then
            pcall(function() AntiRagdollV2.Connection:Disconnect() end)
            AntiRagdollV2.Connection = nil
        end
        AntiRagdollV2.ResetCooldown = 0
        if Conns.antiRag then Conns.antiRag = nil end
        if not keepFlag then
            antiRagdollEnabled = false
            if _G.MMA_WantedState then _G.MMA_WantedState.antiRag = false end
            if setAntiRagVisual then pcall(setAntiRagVisual, false) end
        end
    end

    -- rave-style: restart after respawn if still enabled
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if antiRagdollEnabled or (_G.MMA_WantedState and _G.MMA_WantedState.antiRag) then
            antiRagdollEnabled = true
            -- force new connection for new character
            if AntiRagdollV2.Connection then
                pcall(function() AntiRagdollV2.Connection:Disconnect() end)
                AntiRagdollV2.Connection = nil
            end
            startAntiRagdoll()
        end
    end)

    _G.startAntiRagdoll = function() startAntiRagdoll() end
    _G.stopAntiRagdoll = function(k) stopAntiRagdoll(k) end
end)()




startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end


-- ============================================================
end
pcall(__spectrumBoot_core)

function __spectrumBoot_stealBar()
-- OLD steal bar REMOVED (duplicate). Only MMAStealOMGBar remains.
createStealBar = function()
    for _, n in ipairs({"MoveeStealBar", "YassinAutoStealBar", "RaveHubAutoStealBar"}) do
        pcall(function()
            local cg = game:GetService("CoreGui"):FindFirstChild(n)
            if cg then cg:Destroy() end
        end)
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then
                local o = pg:FindFirstChild(n)
                if o then o:Destroy() end
            end
        end)
    end
    stealBarFrame = nil
end
createStealBar()
end
pcall(__spectrumBoot_stealBar)


function __spectrumBoot_mobile()
-- MOBILE BUTTONS  (Spectrum stack-button style)
-- ============================================================
destroyMobileButtons = function()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"SpectrumMobileButtons","MoveeMobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
buildMobileButtons = function()
    destroyMobileButtons(); if not mobileButtonsEnabled then return end

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "MMAMobileButtons"
    mobGui.ResetOnSpawn = false
    -- LOW DisplayOrder + PlayerGui so Roblox menu/logo stays clickable
    mobGui.DisplayOrder = 1
    mobGui.IgnoreGuiInset = false
    pcall(function() mobGui.ClipToDeviceSafeArea = true end)
    -- Prefer PlayerGui so we never cover Roblox top-bar / leave menu
    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    if pg then
        mobGui.Parent = pg
    else
        pcall(function() mobGui.Parent = game:GetService("CoreGui") end)
    end
    mobGuiRef = mobGui

    -- ===== PLAIN STYLE (no pink accent line) =====
    local QS = 62
    local QG = 8
    local QR = 12
    local Q_OFF        = Color3.fromRGB(0, 0, 0)
    local Q_ON         = Color3.fromRGB(200, 30, 40)
    local Q_BORDER     = Color3.fromRGB(40, 40, 40)
    local Q_BORDER_ON  = Color3.fromRGB(255, 60, 70)
    local Q_TEXT       = Color3.fromRGB(255, 255, 255)
    local Q_TEXT_ON    = Color3.fromRGB(255, 255, 255)

    -- Grid container (3 cols x 3 rows)
    local QW = QS * 3 + QG * 2
    local QH = QS * 3 + QG * 2
    local mbGroup = Instance.new("Frame", mobGui)
    mbGroup.Name = "MobileButtons"
    mbGroup.Size = UDim2.new(0, QW + 20, 0, QH + 20)
    mbGroup.Position = UDim2.new(1, -QW - 34, 0.5, -QH/2 - 10)
    mbGroup.BackgroundTransparency = 1
    mbGroup.BorderSizePixel = 0
    -- Do not let the transparent container block Roblox's native jump icon.
    -- Only the individual custom buttons below should receive touch input.
    mbGroup.Active = false
    mbGroup.ZIndex = 100

    local function makeMobileBtn(label, col, rowN, isToggle, onAction)
        local relX = 10 + col * (QS + QG)
        local relY = 10 + rowN * (QS + QG)

        local frame = Instance.new("Frame", mbGroup)
        frame.Size = UDim2.new(0, QS, 0, QS)
        frame.Position = UDim2.new(0, relX, 0, relY)
        frame.BackgroundColor3 = Q_OFF
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ZIndex = 102
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, QR)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Q_BORDER
        stroke.Thickness = 1.2
        stroke.Transparency = 0.2

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -4, 1, -4)
        btn.Position = UDim2.new(0, 2, 0, 2)
        btn.BackgroundTransparency = 1
        btn.Text = label
        btn.TextColor3 = Q_TEXT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextWrapped = true
        btn.LineHeight = 1.15
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.ZIndex = 103

        local isOn = false

        local function applyVisual(s)
            isOn = s
            TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = s and Q_ON or Q_OFF}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Color = s and Q_BORDER_ON or Q_BORDER, Transparency = s and 0 or 0.2}):Play()
            btn.TextColor3 = s and Q_TEXT_ON or Q_TEXT
        end

        local function setter(s)
            applyVisual(s)
        end

        btn.MouseButton1Click:Connect(function()
            if isToggle then
                applyVisual(not isOn)
                if onAction then onAction(isOn) end
            else
                applyVisual(true)
                task.delay(0.22, function() applyVisual(false) end)
                if onAction then onAction() end
            end
        end)

        -- Drag support
        local _dn, _sp, _fp, _li, _wd = false, nil, nil, nil, false
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                _dn = true; _wd = false; _sp = i.Position; _fp = frame.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then _dn = false end end)
            end
        end)
        btn.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then _li = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i == _li and _dn and _sp and _fp then
                if uiLocked or mobileButtonsLocked then return end
                local dx = i.Position.X - _sp.X; local dy = i.Position.Y - _sp.Y
                if math.abs(dx) > 6 or math.abs(dy) > 6 then
                    _wd = true
                    frame.Position = UDim2.new(_fp.X.Scale, _fp.X.Offset + dx, _fp.Y.Scale, _fp.Y.Offset + dy)
                end
            end
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if _wd then pcall(saveBtnPositions) end
                _dn = false; _wd = false
            end
        end)

        return frame, setter
    end

    -- ===== DEFINIRE BUTOANE (col, row, 0-indexed) =====
    local _, refDrop = makeMobileBtn("DROP\nBR", 0, 0, false, function()
        runDrop()
    end)
    mobBtnRefs["drop"] = refDrop

    local _, refAutoLeft = makeMobileBtn("AUTO\nLEFT", 1, 0, true, function(on)
        if on then
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled = true; startAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(true) end
        else
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
        end
    end)
    mobBtnRefs["autoLeft"] = refAutoLeft

    local _, refAutoBat = makeMobileBtn("BAT\nAIMBOT", 2, 0, true, function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart()
            if autoBatSetVisual then autoBatSetVisual(true) end
        else
            stopBatAimbot()
            if autoBatSetVisual then autoBatSetVisual(false) end
        end
    end)
    mobBtnRefs["autoBat"] = refAutoBat

    local _, refAutoRight = makeMobileBtn("AUTO\nRIGHT", 0, 1, true, function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled = true; startAutoRight()
            if autoRightSetVisual then autoRightSetVisual(true) end
        else
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
        end
    end)
    mobBtnRefs["autoRight"] = refAutoRight

    -- Row 3 (index 2): LAGGER + TP BAT
    local _, refLagger = makeMobileBtn("LAGGER\nCARRY", 1, 1, true, function(on)
        toggleLaggerMode()
        if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        saveConfig()
    end)
    mobBtnRefs["lagger"] = refLagger

    local _, refTPBat = makeMobileBtn("TP\nBAT", 2, 1, true, function(on)
        if on then
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            if startTPBat then startTPBat() end
        else
            if stopTPBat then stopTPBat() end
        end
    end)
    mobBtnRefs["tpBat"] = refTPBat

    -- Row 4 (index 3): TP DOWN + CARRY
    local _, refTP = makeMobileBtn("TP\nDOWN", 0, 2, false, function()
        runTPFloor()
    end)
    mobBtnRefs["tpDown"] = refTP

    local _, refCarry = makeMobileBtn("CARRY\nSPD", 1, 2, true, function(on)
        toggleCarryMode()
        if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
        saveConfig()
    end)
    mobBtnRefs["carrySpeed"] = refCarry

    -- Sync stari curente
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(_G.AceAntiDesyncAimbotOn==true) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end

-- ============================================================

-- ============================================================
end
pcall(__spectrumBoot_mobile)

function __spectrumBoot_config()
-- FULL CONFIG LOAD (inainte de build GUI, pentru ca GUI sa citeasca valorile corecte)
-- ============================================================
pcall(function()
    local d=nil
    if isfile and isfile("MMA_Mobile.json") then
        local ok,tmp=pcall(function() return HS:JSONDecode(readfile("MMA_Mobile.json")) end)
        if ok and type(tmp)=="table" then d=tmp end
    end
    if not d and isfile and isfile("MMA_Config.json") then
        local ok,tmp=pcall(function() return HS:JSONDecode(readfile("MMA_Config.json")) end)
        if ok and type(tmp)=="table" then d=tmp end
    end
    if type(d)~="table" then return end
    if type(d.normalSpeed)=="number" and d.normalSpeed>0 then NS=d.normalSpeed end
    if type(d.batAimbotSpeed)=="number" and d.batAimbotSpeed>=10 then BAT_AIMBOT_SPEED=math.clamp(d.batAimbotSpeed,10,200) end
    if type(d.carrySpeed)=="number" and d.carrySpeed>0 then CS=d.carrySpeed end
    if type(d.laggerCarrySpeed)=="number" and d.laggerCarrySpeed>0 then LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
    if type(d.carrySpeedActive)=="boolean" then carrySpeedActive=d.carrySpeedActive end
    if type(d.laggerModeEnabled)=="boolean" then laggerModeEnabled=d.laggerModeEnabled end
    -- Backward compatibility: old laggerModeEnabled now means Lagger Carry.
    if laggerModeEnabled then carrySpeedActive=false end
    if type(d.antiRagdoll)=="boolean" then antiRagdollEnabled=d.antiRagdoll; _G.MMA_WantedState.antiRag=d.antiRagdoll end
    if type(d.antiDrop)=="boolean" then antiDropEnabled=d.antiDrop end
    if type(d.infiniteJump)=="boolean" then infJumpEnabled=d.infiniteJump; _G.MMA_InfJumpOn=d.infiniteJump; if _G.MMA_WantedState then _G.MMA_WantedState.infJump=d.infiniteJump end end
    if type(d.streamerMode)=="boolean" and d.streamerMode then task.defer(function() setStreamerMode(true) end) end
    if type(d.infJumpMode)=="string" then infJumpMode=d.infJumpMode end
    if type(d.medusaCounter)=="boolean" then medusaCounterEnabled=d.medusaCounter end
    if type(d.batCounter)=="boolean" then batCounterEnabled=d.batCounter end
    if type(d.autoStealEnabled)=="boolean" then Steal.AutoStealEnabled=d.autoStealEnabled; autoStealEnabled=d.autoStealEnabled; _G.MMA_WantedState.autoSteal=d.autoStealEnabled end
    if type(d.grabRadius)=="number" then Steal.StealRadius=d.grabRadius end
    if type(d.stealDuration)=="number" then Steal.StealDuration=d.stealDuration end
    if type(d.completeRadius)=="number" then Steal.CompleteRadius=d.completeRadius end
    if type(d.stealMode)=="string" and (d.stealMode=="V1" or d.stealMode=="V3") then Steal.Mode=d.stealMode end
    if type(d.autoSwing)=="boolean" then autoSwingEnabled=d.autoSwing end
    if type(d.unwalkEnabled)=="boolean" then unwalkEnabled=d.unwalkEnabled end
    if type(d.antiLag)=="boolean" then antiLagEnabled=d.antiLag end
    if type(d.nuke)=="boolean" and d.nuke==true then task.defer(function() pcall(nukeStart) end) end
    if type(d.stretchRez)=="boolean" then stretchRezEnabled=d.stretchRez end
    if type(d.autoTPEnabled)=="boolean" then autoTPEnabled=d.autoTPEnabled end
    if type(d.autoTPHeight)=="number" then autoTPHeight=d.autoTPHeight end
    if type(d.fovValue)=="number" then fovValue=d.fovValue end
    if type(d.fovIndex)=="number" then fovIndex=d.fovIndex end
    if type(d.skyTheme)=="string" then currentSkyTheme=d.skyTheme end
    if type(d.autoMoveSwing)=="boolean" then autoMoveSwingEnabled=d.autoMoveSwing end
    if type(d.autoMoveSwingInterval)=="number" then autoMoveSwingInterval=d.autoMoveSwingInterval end
    if type(d.ragdollGui)=="boolean" then ragdollGuiEnabled=d.ragdollGui end
    mobileButtonsEnabled = true
    if type(d.mobileButtonsLocked)=="boolean" then
        mobileButtonsLocked=d.mobileButtonsLocked
        uiLocked=mobileButtonsLocked
    end
    if type(d.mobileButtonsSize)=="number" then mobileButtonsSize=d.mobileButtonsSize end
    if type(d.circleButtonsEnabled)=="boolean" then circleButtonsEnabled=d.circleButtonsEnabled end
    if type(d.introSoundEnabled)=="boolean" then introSoundEnabled=d.introSoundEnabled end
    if type(d.animEnabled)=="boolean" then animEnabled=d.animEnabled end
    if type(d.backgroundEnabled)=="boolean" then backgroundEnabled=d.backgroundEnabled end
    if type(d.backgroundIndex)=="number" then backgroundIndex=d.backgroundIndex end
    if type(d.autoSwitchSpeed)=="boolean" then autoSwitchSpeedEnabled=d.autoSwitchSpeed end
    if type(d.safeSpeedNearBaseEnabled)=="boolean" then safeSpeedNearBaseEnabled=d.safeSpeedNearBaseEnabled end
    if type(d.mmaServerLaggerEnabled)=="boolean" then setMmaServerLagger(d.mmaServerLaggerEnabled) end
    if type(d.headlessEnabled)=="boolean" then headlessEnabled=d.headlessEnabled end
    if type(d.korbloxEnabled)=="boolean" then korbloxEnabled=d.korbloxEnabled end
    if d.tpBatVersion=="V1" or d.tpBatVersion=="V2" then tpBatVersion=d.tpBatVersion end
    if type(d.tpBatCameraLock)=="boolean" then tpBatCameraLock=d.tpBatCameraLock end
    if type(d.tpBatAutoDisableOnHit)=="boolean" then tpBatAutoDisableOnHit=d.tpBatAutoDisableOnHit end
    if type(d.e01Enabled)=="boolean" then
        e01Enabled=d.e01Enabled
        if setE01Enabled then setE01Enabled(e01Enabled) end
    end
    -- re-apply after config load (flags were false at first CharacterAdded)
    if LP.Character then
        task.spawn(function()
            task.wait(0.3)
            pcall(applyAvatarCosmetics,LP.Character)
            if forceCosmeticsPersistent then pcall(forceCosmeticsPersistent,LP.Character) end
        end)
    end
end)

-- ============================================================
-- APPLY CONFIG — porneste sistemele dupa ce valorile au fost incarcate
-- ============================================================
pcall(function()
    -- Zombie Animations
    if animEnabled then
        task.spawn(function()
            task.wait(1)
            if startAnimToggle then startAnimToggle() end
        end)
    end
    -- Anti Lag
    if antiLagEnabled then
        task.spawn(function()
            task.wait(1)
            if enableAntiLag then enableAntiLag() end
        end)
    end
    -- Stretch Rez (FOV)
    if stretchRezEnabled then
        task.spawn(function()
            task.wait(0.5)
            if enableStretchRez then enableStretchRez() end
        end)
    end
    -- Anti Ragdoll
    if antiRagdollEnabled then
        task.spawn(function()
            task.wait(0.5)
            if startAntiRagdoll then startAntiRagdoll() end
            if setAntiRagVisual then pcall(setAntiRagVisual, true) end
        end)
    end
    -- Infinite Jump
    if infJumpEnabled then
        task.spawn(function()
            task.wait(0.5)
            if setInfJumpInternal then setInfJumpInternal(true)
            elseif startHoldInfJump then startHoldInfJump() end
            if setInfJumpVisual then pcall(setInfJumpVisual, true) end
        end)
    end
    -- Anti Drop
    if antiDropEnabled then
        task.spawn(function()
            task.wait(0.5)
            if startAntiDrop then startAntiDrop() end
        end)
    end
    -- Auto Steal
    if Steal.AutoStealEnabled then
        task.spawn(function()
            task.wait(1)
            if startAutoSteal then startAutoSteal() end
        end)
    end
    -- Bat Counter
    if batCounterEnabled then
        task.spawn(function()
            task.wait(1)
            if startBatCounter then startBatCounter() end
        end)
    end
    -- Medusa Counter
    if medusaCounterEnabled then
        task.spawn(function()
            task.wait(1)
            local char = LP.Character
            if char and setupMedusa then setupMedusa(char) end
        end)
    end
    -- Auto TP
    if autoTPEnabled then
        task.spawn(function()
            task.wait(0.5)
            if startAutoTP then startAutoTP() end
        end)
    end
    -- Sky Theme
    if currentSkyTheme and currentSkyTheme ~= "" then
        task.spawn(function()
            task.wait(1)
            if CandyApplyCustomSky then CandyApplyCustomSky(currentSkyTheme) end
        end)
    end
end)

-- ============================================================
end
pcall(__spectrumBoot_config)

-- CYBER GUI — rulat in functie proprie ca sa evite limita 200 locals
-- ============================================================
;(function()

local PlayerGui = LP:WaitForChild("PlayerGui")

local function makeDraggable_cyber(dragTarget, moveTarget)
    moveTarget = moveTarget or dragTarget
    local dragging, dragInput, dragStart, startPos = false
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=moveTarget.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            local delta=input.Position-dragStart
            moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local C={
    bg=Color3.fromRGB(0, 0, 0),
    bgDark=Color3.fromRGB(0, 0, 0),
    row=Color3.fromRGB(6, 6, 6),
    input=Color3.fromRGB(10, 10, 10),
    blue=Color3.fromRGB(255, 255, 255),
    blueDim=Color3.fromRGB(170, 170, 175),
    blueDark=Color3.fromRGB(14, 14, 14),
    text=Color3.fromRGB(255, 255, 255),
    textDim=Color3.fromRGB(170, 170, 175),
    textMuted=Color3.fromRGB(110, 110, 115),
    white=Color3.fromRGB(255, 255, 255),
    divider=Color3.fromRGB(28, 28, 28),
    green=Color3.fromRGB(200, 255, 220),
}
local function guiCorner(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 10);c.Parent=p;return c end
local function guiStroke(p,col,t) local s=Instance.new("UIStroke");s.Color=col or Color3.fromRGB(60,60,70);s.Thickness=t or 1;s.Parent=p;return s end
local function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.12),props):Play() end

local GuiToggleSetters={}
local GuiRefs={}
local LeftPanel=nil

local Keys={
    circle=Enum.KeyCode.E,
    speed=Enum.KeyCode.Q,
    carryMode=Enum.KeyCode.C,
    laggerToggle=Enum.KeyCode.K,
    guiHide=Enum.KeyCode.RightControl,
    dropBrainrot=Enum.KeyCode.H,
    tpDown=Enum.KeyCode.T,
    instaReset=Enum.KeyCode.B,
    autoLeft=Enum.KeyCode.J,
    autoRight=Enum.KeyCode.L,
    tpBat=Enum.KeyCode.V,
}
-- Aplica keybind-urile salvate (KB + PS) si inregistreaza referinta pentru saveConfig
pcall(function()
    local raw=nil
    if isfile and isfile("MMA_Mobile.json") then
        local ok,d=pcall(function() return HS:JSONDecode(readfile("MMA_Mobile.json")) end)
        if ok then raw=d end
    end
    if not raw and isfile and isfile("MMA_Config.json") then
        local ok,d=pcall(function() return HS:JSONDecode(readfile("MMA_Config.json")) end)
        if ok then raw=d end
    end
    if type(raw)~="table" then return end
    if type(raw.keys)=="table" then
        for k,v in pairs(raw.keys) do
            local ok2,kc=pcall(function() return Enum.KeyCode[v] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then Keys[k]=kc end
        end
    end
    if type(raw.controllerKeys)=="table" then
        ControllerKeys = ControllerKeys or {}
        for k,v in pairs(raw.controllerKeys) do
            local ok2,kc=pcall(function() return Enum.KeyCode[v] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then ControllerKeys[k]=kc end
        end
    end
end)
_GuiKeys = Keys

-- BUILD HUB GUI
;(function()
    local GuiHub=Instance.new("ScreenGui")
    GuiHub.Name="MenoEnta"; GuiHub.ResetOnSpawn=false
    GuiHub.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    GuiHub.DisplayOrder=1
    GuiHub.IgnoreGuiInset=false
    pcall(function() GuiHub.ClipToDeviceSafeArea=true end)
    GuiHub.Parent=PlayerGui
    GuiRefs.hub=GuiHub
    pcall(function() GuiHub:SetAttribute("MMA_SCRIPT_UI", true) end)

    local Outer=Instance.new("Frame")
    Outer.Name="Outer"; Outer.Size=UDim2.new(0,290,0,420); Outer.Position=UDim2.new(0.5,-145,0.5,-210)
    Outer.BackgroundTransparency=1; Outer.BorderSizePixel=0; Outer.ClipsDescendants=false; Outer.Parent=GuiHub
    GuiRefs.outer=Outer

    local Inner=Instance.new("Frame")
    Inner.Name="Inner"; Inner.ClipsDescendants=false; Inner.Size=UDim2.new(1,0,1,0)
    Inner.BackgroundColor3=Color3.fromRGB(0,0,0); Inner.BackgroundTransparency=0; Inner.BorderSizePixel=0; Inner.Parent=Outer
    guiCorner(Inner,24); guiStroke(Inner,Color3.fromRGB(40,40,48),1.2); GuiRefs.inner=Inner

    local BgCont=Instance.new("Frame")
    BgCont.Name="BackgroundContainer"; BgCont.Size=UDim2.new(1,0,1,0)
    BgCont.BackgroundTransparency=1; BgCont.ZIndex=0; BgCont.Parent=Inner

    local BgGrad=Instance.new("Frame")
    BgGrad.Name="BgGrad"; BgGrad.Size=UDim2.new(1,0,1,0); BgGrad.BackgroundColor3=C.bgDark
    BgGrad.BorderSizePixel=0; BgGrad.ZIndex=0; BgGrad.Parent=BgCont; guiCorner(BgGrad,24)
    local grad=Instance.new("UIGradient")
    grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(4,4,4)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(7,7,7)),ColorSequenceKeypoint.new(1,Color3.fromRGB(4,4,4))})
    grad.Rotation=135; grad.Parent=BgGrad; GuiRefs.bgGrad=BgGrad

    local BgImg=Instance.new("ImageLabel")
    BgImg.Name="BackgroundImage"; BgImg.Size=UDim2.new(1,0,1,0); BgImg.BackgroundTransparency=1
    BgImg.Image=""; BgImg.ScaleType=Enum.ScaleType.Crop; BgImg.ZIndex=0; BgImg.Visible=false
    BgImg.Parent=BgCont; guiCorner(BgImg,24); GuiRefs.backgroundImage=BgImg; bgImageRef=BgImg
    backgroundIndex=0; backgroundEnabled=false

    local Wm=Instance.new("TextLabel")
    Wm.Name="MMA_Watermark"
    Wm.Size=UDim2.new(1,0,1,0)
    Wm.BackgroundTransparency=1
    Wm.Text="MMA"
    Wm.TextColor3=Color3.fromRGB(255,255,255)
    Wm.TextTransparency=0.88
    Wm.Font=Enum.Font.GothamBlack
    Wm.TextSize=92
    Wm.TextXAlignment=Enum.TextXAlignment.Center
    Wm.TextYAlignment=Enum.TextYAlignment.Center
    Wm.ZIndex=1
    Wm.Rotation=-18
    Wm.Parent=BgCont
    local Wm2=Instance.new("TextLabel")
    Wm2.Name="MMA_WatermarkSub"
    Wm2.Size=UDim2.new(1,0,0,28)
    Wm2.Position=UDim2.new(0,0,0.62,0)
    Wm2.BackgroundTransparency=1
    Wm2.Text="MOBILE"
    Wm2.TextColor3=Color3.fromRGB(200,200,210)
    Wm2.TextTransparency=0.82
    Wm2.Font=Enum.Font.GothamBold
    Wm2.TextSize=16
    Wm2.TextXAlignment=Enum.TextXAlignment.Center
    Wm2.ZIndex=1
    Wm2.Rotation=-18
    Wm2.Parent=BgCont

    local HF=Instance.new("Frame")
    HF.Name="HeaderFrame"; HF.Size=UDim2.new(1,0,0,62); HF.BackgroundTransparency=1
    HF.BorderSizePixel=0; HF.Parent=Inner; HF.ZIndex=2
    makeDraggable_cyber(HF, Outer)

    local TL=Instance.new("TextLabel")
    TL.Position=UDim2.new(0,14,0,8); TL.Size=UDim2.new(1,-90,0,22); TL.BackgroundTransparency=1
    TL.Text="منو انت"; TL.TextColor3=Color3.fromRGB(220,35,45); TL.TextSize=14; TL.Font=Enum.Font.GothamBlack
    TL.TextXAlignment=Enum.TextXAlignment.Left; TL.Parent=HF; TL.ZIndex=3

    local ML=Instance.new("TextLabel")
    ML.Position=UDim2.new(0,14,0,32); ML.Size=UDim2.new(0,200,0,14); ML.BackgroundTransparency=1
    ML.Text="منو انت  •  موبايل"; ML.TextColor3=C.textDim; ML.TextSize=10; ML.Font=Enum.Font.GothamBold
    ML.TextXAlignment=Enum.TextXAlignment.Left; ML.Parent=HF; ML.ZIndex=3

    -- MINIMIZE BUTTON
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Size=UDim2.new(0,28,0,28); CloseBtn.Position=UDim2.new(1,-38,0,8)
    CloseBtn.BackgroundColor3=C.bgDark; CloseBtn.BorderSizePixel=0
    CloseBtn.Text="-"; CloseBtn.TextColor3=C.textMuted; CloseBtn.Font=Enum.Font.GothamBlack; CloseBtn.TextSize=22
    CloseBtn.ZIndex=5; CloseBtn.Parent=HF
    guiCorner(CloseBtn,7); guiStroke(CloseBtn,Color3.fromRGB(45,45,45),1)
    CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(28,28,28),TextColor3=C.text}) end)
    CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.bgDark,TextColor3=C.textMuted}) end)

    -- MINI RESTORE BUTTON
    local MiniBtn=Instance.new("TextButton")
    MiniBtn.Size=UDim2.new(0,110,0,28); MiniBtn.Position=Outer.Position
    MiniBtn.BackgroundColor3=Color3.fromRGB(0,0,0); MiniBtn.BorderSizePixel=0
    MiniBtn.Text="منو انت"; MiniBtn.TextColor3=Color3.fromRGB(220,35,45); MiniBtn.Font=Enum.Font.GothamBlack; MiniBtn.TextSize=11
    MiniBtn.ZIndex=20; MiniBtn.Visible=false; MiniBtn.Parent=GuiRefs.hub
    guiCorner(MiniBtn,8); guiStroke(MiniBtn,Color3.fromRGB(45,45,45),1.2)
    makeDraggable_cyber(MiniBtn, MiniBtn)
    MiniBtn.MouseEnter:Connect(function() tw(MiniBtn,{BackgroundColor3=Color3.fromRGB(22,22,22)}) end)
    MiniBtn.MouseLeave:Connect(function() tw(MiniBtn,{BackgroundColor3=C.bgDark}) end)

    local function showGui()
        -- always open settings in the center of the screen
        Outer.Position=UDim2.new(0.5,-145,0.5,-210)
        Outer.Visible=true; MiniBtn.Visible=false
    end
    local function hideGui() Outer.Visible=false; MiniBtn.Visible=true end
    CloseBtn.MouseButton1Click:Connect(hideGui)
    MiniBtn.MouseButton1Click:Connect(showGui)

    local HSep=Instance.new("Frame")
    HSep.Position=UDim2.new(0,14,0,62); HSep.Size=UDim2.new(1,-28,0,1); HSep.BackgroundColor3=C.blue
    HSep.BackgroundTransparency=0.7; HSep.BorderSizePixel=0; HSep.Parent=Inner; HSep.ZIndex=2

    -- Bottom tab bar
    LeftPanel=Instance.new("Frame")
    LeftPanel.Name="LeftPanel"
    LeftPanel.Size=UDim2.new(1,-16,0,52)
    LeftPanel.Position=UDim2.new(0,8,1,-60)
    LeftPanel.BackgroundColor3=Color3.fromRGB(0,0,0)
    LeftPanel.BackgroundTransparency=0
    LeftPanel.BorderSizePixel=0
    LeftPanel.Parent=Inner
    guiCorner(LeftPanel,10)
    LeftPanel.ZIndex=2
    local lpStroke=Instance.new("UIStroke")
    lpStroke.Color=Color3.fromRGB(40,40,40)
    lpStroke.Thickness=1
    lpStroke.Parent=LeftPanel

    local CatList=Instance.new("ScrollingFrame")
    CatList.Name="CategoryList"
    CatList.Size=UDim2.new(1,0,1,0)
    CatList.BackgroundTransparency=1
    CatList.BorderSizePixel=0
    CatList.ScrollBarThickness=0
    CatList.ScrollingDirection=Enum.ScrollingDirection.X
    CatList.CanvasSize=UDim2.new(0,0,0,0)
    CatList.AutomaticCanvasSize=Enum.AutomaticSize.X
    CatList.Active=true
    CatList.Parent=LeftPanel
    local CatLay=Instance.new("UIListLayout")
    CatLay.FillDirection=Enum.FillDirection.Horizontal
    CatLay.SortOrder=Enum.SortOrder.LayoutOrder
    CatLay.Padding=UDim.new(0,4)
    CatLay.VerticalAlignment=Enum.VerticalAlignment.Center
    CatLay.HorizontalAlignment=Enum.HorizontalAlignment.Center
    CatLay.Parent=CatList
    CatLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        CatList.CanvasSize = UDim2.new(0, CatLay.AbsoluteContentSize.X + 16, 0, 0)
    end)
    local CatPad=Instance.new("UIPadding")
    CatPad.PaddingLeft=UDim.new(0,6)
    CatPad.PaddingRight=UDim.new(0,6)
    CatPad.PaddingTop=UDim.new(0,6)
    CatPad.PaddingBottom=UDim.new(0,6)
    CatPad.Parent=CatList
    GuiRefs.categoryList=CatList

    local CF=Instance.new("ScrollingFrame")
    CF.Name="ContentFrame"; CF.Size=UDim2.new(1,-16,1,-140); CF.Position=UDim2.new(0,8,0,63)
    CF.BackgroundTransparency=1; CF.BorderSizePixel=0; CF.ScrollBarThickness=6; CF.ScrollBarImageColor3=C.blue
    CF.CanvasSize=UDim2.new(0,0,0,0); CF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    CF.ScrollingDirection=Enum.ScrollingDirection.Y; CF.ScrollingEnabled=true; CF.Active=true
    CF.ElasticBehavior=Enum.ElasticBehavior.Never; CF.Parent=Inner; GuiRefs.contentFrame=CF
    local CLay=Instance.new("UIListLayout"); CLay.SortOrder=Enum.SortOrder.LayoutOrder; CLay.Padding=UDim.new(0,6); CLay.Parent=CF
    CLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() CF.CanvasSize = UDim2.new(0, 0, 0, CLay.AbsoluteContentSize.Y + 25) end)
    local CPad=Instance.new("UIPadding"); CPad.PaddingLeft=UDim.new(0,12); CPad.PaddingRight=UDim.new(0,12)
    CPad.PaddingTop=UDim.new(0,10); CPad.PaddingBottom=UDim.new(0,8); CPad.Parent=CF

    local BotSep=Instance.new("Frame")
    BotSep.Position=UDim2.new(0,8,1,-68); BotSep.Size=UDim2.new(1,-16,0,1); BotSep.BackgroundColor3=C.blue
    BotSep.BackgroundTransparency=0.65; BotSep.BorderSizePixel=0; BotSep.Parent=Inner; BotSep.ZIndex=2
end)()

-- KEYBIND SYSTEM
local KeyListen={cb=nil,label=nil,active=false,disabledBoxes=nil,sinkBound=false}
local CAS = game:GetService("ContextActionService")
local KEY_ALIASES={
    ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonR1="RB",ButtonR2="RT",ButtonL1="LB",ButtonL2="LT",
    DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",ButtonStart="▶",ButtonSelect="◀",
    LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",
    LeftSuper="LSuper",RightSuper="RSuper",Return="Enter",BackSpace="Backspace",Tab="Tab",CapsLock="CapsLock",
    Escape="Esc",Space="Space",PageUp="PgUp",PageDown="PgDn",End="End",Home="Home",Insert="Ins",Delete="Del",
    Up="↑",Down="↓",Left="←",Right="→",F1="F1",F2="F2",F3="F3",F4="F4",F5="F5",F6="F6",F7="F7",F8="F8",
    F9="F9",F10="F10",F11="F11",F12="F12",Print="PrtScn",ScrollLock="ScrLk",Pause="Pause",
    Minus="-",Equals="=",LeftBracket="[",RightBracket="]",BackSlash="\\",Semicolon=";",Quote="'",
    Comma=",",Period=".",Slash="/",Backquote="`"
}
local function prettyKey(kc) return KEY_ALIASES[kc.Name] or kc.Name end
local function klUnfocusAndLockBoxes()
    pcall(function()
        local tb = UIS:GetFocusedTextBox()
        if tb then tb:ReleaseFocus(false) end
    end)
    KeyListen.disabledBoxes = {}
    local roots = {}
    if GuiRefs and GuiRefs.hub then table.insert(roots, GuiRefs.hub) end
    if GuiRefs and GuiRefs.outer then table.insert(roots, GuiRefs.outer) end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then table.insert(roots, pg) end
    for _,root in ipairs(roots) do
        pcall(function()
            for _,d in ipairs(root:GetDescendants()) do
                if d:IsA("TextBox") and d.TextEditable ~= false then
                    d.TextEditable = false
                    table.insert(KeyListen.disabledBoxes, d)
                end
            end
        end)
    end
end
local function klRestoreBoxes()
    if KeyListen.disabledBoxes then
        for _,d in ipairs(KeyListen.disabledBoxes) do
            pcall(function() if d and d.Parent then d.TextEditable = true end end)
        end
        KeyListen.disabledBoxes = nil
    end
end
local function klUnbindSink()
    if KeyListen.sinkBound then
        pcall(function() CAS:UnbindAction("MMA_KeyListenSink") end)
        KeyListen.sinkBound = false
    end
end
local function klBindSink()
    klUnbindSink()
    pcall(function()
        CAS:BindActionAtPriority("MMA_KeyListenSink", function()
            if KeyListen.active then
                return Enum.ContextActionResult.Sink
            end
            return Enum.ContextActionResult.Pass
        end, false, 3000,
            Enum.KeyCode.A, Enum.KeyCode.B, Enum.KeyCode.C, Enum.KeyCode.D, Enum.KeyCode.E, Enum.KeyCode.F,
            Enum.KeyCode.G, Enum.KeyCode.H, Enum.KeyCode.I, Enum.KeyCode.J, Enum.KeyCode.K, Enum.KeyCode.L,
            Enum.KeyCode.M, Enum.KeyCode.N, Enum.KeyCode.O, Enum.KeyCode.P, Enum.KeyCode.Q, Enum.KeyCode.R,
            Enum.KeyCode.S, Enum.KeyCode.T, Enum.KeyCode.U, Enum.KeyCode.V, Enum.KeyCode.W, Enum.KeyCode.X,
            Enum.KeyCode.Y, Enum.KeyCode.Z,
            Enum.KeyCode.Zero, Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four,
            Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine,
            Enum.KeyCode.Space, Enum.KeyCode.Return, Enum.KeyCode.BackSpace, Enum.KeyCode.Tab,
            Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift, Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl
        )
        KeyListen.sinkBound = true
    end)
end
local function cancelKL()
    klRestoreBoxes()
    klUnbindSink()
    if KeyListen.label then KeyListen.label.BackgroundColor3=C.blue; KeyListen.label.BackgroundTransparency=0.5 end
    KeyListen.cb=nil; KeyListen.label=nil; KeyListen.active=false
end
local function startKL(lbl,onSet)
    cancelKL()
    klUnfocusAndLockBoxes()
    klBindSink()
    KeyListen.cb=onSet
    KeyListen.label=lbl
    KeyListen.active=true
    KeyListen.prevText=lbl.Text
    lbl.Text="PRESS KEY..."
    lbl.BackgroundColor3=Color3.fromRGB(80,220,120)
    lbl.BackgroundTransparency=0.3
    local cap=lbl
    task.delay(10,function()
        if KeyListen.label==cap and KeyListen.active then
            local prev=KeyListen.prevText
            cancelKL()
            if lbl and lbl.Parent then
                lbl.Text=prev or "..."
                lbl.BackgroundColor3=C.blue
                lbl.BackgroundTransparency=0.5
            end
        end
    end)
end
-- Capture key while listening — block typing into any TextBox
UIS.InputBegan:Connect(function(inp,_gameProcessed)
    if not KeyListen.active then return end
    -- force unfocus every key while listening
    pcall(function()
        local tb = UIS:GetFocusedTextBox()
        if tb then tb:ReleaseFocus(false) end
    end)
    local ut=inp.UserInputType
    if ut~=Enum.UserInputType.Keyboard and ut~=Enum.UserInputType.Gamepad1 and ut~=Enum.UserInputType.Gamepad2 then return end
    local k=inp.KeyCode
    if k==Enum.KeyCode.Unknown then return end
    if k==Enum.KeyCode.Escape then
        local lb=KeyListen.label
        local prev=KeyListen.prevText
        cancelKL()
        if lb and lb.Parent then lb.Text=prev or "..."; lb.BackgroundColor3=C.blue; lb.BackgroundTransparency=0.5 end
        return
    end
    local cb=KeyListen.cb
    local lb=KeyListen.label
    cancelKL()
    if lb and lb.Parent then
        lb.Text=prettyKey(k)
        lb.BackgroundColor3=C.blue
        lb.BackgroundTransparency=0.5
    end
    if cb then
        task.spawn(function()
            cb(k)
            if saveConfig then saveConfig() end
        end)
    end
end)

-- ROW BUILDERS
local function addSectLbl(parent,text,order)
    local w=Instance.new("Frame",parent); w.Size=UDim2.new(1,0,0,22); w.BackgroundTransparency=1; w.LayoutOrder=order
    local L=Instance.new("TextLabel",w); L.Size=UDim2.new(1,0,0,16); L.BackgroundTransparency=1
    L.Text=text; L.TextColor3=C.textDim; L.TextSize=10; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
    return L
end
local function addInputRow(parent,label,value,order,cb)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,36); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local BC=Instance.new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-58,0.5,-10); BC.Size=UDim2.new(0,48,0,20)
    BC.BackgroundColor3=C.input; BC.BackgroundTransparency=0.5; BC.BorderSizePixel=0; guiCorner(BC,6); guiStroke(BC,Color3.fromRGB(55,55,60),1)
    local Box=Instance.new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
    Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=11; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=false
    Box.FocusLost:Connect(function() local n=tonumber(Box.Text); if n and n>0 then cb(n) else Box.Text=tostring(value) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,Box
end
local function addToggleRow(parent,label,enabled,order,kbKey,onToggle)
    -- Keybind picking is ONLY in Keys tab (no startKL here)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,36,0,18); Track.Position=UDim2.new(1,-46,0,10)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,14,0,14)
    Knob.Position=enabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.3 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,7)
    local st=enabled
    local function setV(on) st=on; tw(Knob,{Position=on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)}); tw(Knob,{BackgroundTransparency=on and 0.3 or 0.5}) end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,36,0,18); Btn.Position=UDim2.new(1,-46,0,10); Btn.BackgroundTransparency=1; Btn.Text=""
    Btn.MouseButton1Click:Connect(function() st=not st; setV(st); if onToggle then onToggle(st) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    if kbKey then GuiToggleSetters[kbKey]=setV end
    return Row,setV
end
local function addActionRow(parent,label,kbKey,onAction,order)
    -- No keybind picker here — Keys tab only
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.55,0,0,16); Lb.Position=UDim2.new(0,12,0,8)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local AB=Instance.new("TextButton",Row); AB.Size=UDim2.new(0.55,0,1,0); AB.BackgroundTransparency=1; AB.Text=""; AB.MouseButton1Click:Connect(onAction)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row
end
local function addCycleRow(parent,label,value,order,onCycle)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local CB=Instance.new("TextButton",Row); CB.Size=UDim2.new(0,60,0,22); CB.Position=UDim2.new(1,-72,0.5,-11)
    CB.BackgroundColor3=C.blue; CB.BackgroundTransparency=0.5; CB.BorderSizePixel=0; CB.Text=value
    CB.TextColor3=C.white; CB.TextSize=10; CB.Font=Enum.Font.GothamBold; guiCorner(CB,5)
    CB.MouseButton1Click:Connect(function() local nv=onCycle(); CB.Text=nv end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end); hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,CB
end

-- CATEGORY SETUP
local Categories={"Speed","Combat","Steal","Movement","Visual","Keys"}
local CategoryRefs={contents={},btnsSide={},active="Speed"}
;(function()
    for _,name in pairs(Categories) do
        local page=Instance.new("Frame"); page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
        page.Visible=(name=="Speed"); page.Parent=GuiRefs.contentFrame; CategoryRefs.contents[name]=page
        local lay=Instance.new("UIListLayout"); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,6); lay.Parent=page
    end
    for i,name in ipairs(Categories) do
        local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,58,0,36); btn.BackgroundColor3=C.blueDark
        btn.BackgroundTransparency=0.15; btn.Text=name; btn.TextColor3=(name=="Speed") and C.white or C.textMuted
        btn.TextSize=9; btn.Font=Enum.Font.GothamBold; btn.BorderSizePixel=0; btn.LayoutOrder=i; btn.Parent=GuiRefs.categoryList; guiCorner(btn,8)
        local ind=Instance.new("Frame"); ind.Name="indicator"; ind.Size=UDim2.new(0.7,0,0,2); ind.Position=UDim2.new(0.15,0,1,-3)
        ind.BackgroundColor3=C.blue; ind.BackgroundTransparency=(name=="Speed") and 0 or 1; ind.BorderSizePixel=0; ind.Parent=btn
        CategoryRefs.btnsSide[name]=btn
        btn.MouseButton1Click:Connect(function()
            for _,f in pairs(CategoryRefs.contents) do f.Visible=false end
            local selectedPage = CategoryRefs.contents[name]
            selectedPage.Visible=true; CategoryRefs.active=name
            for n,b in pairs(CategoryRefs.btnsSide) do
                local ac=(n==name); b.TextColor3=C.white; b.BackgroundColor3=ac and Color3.fromRGB(180,25,35) or C.blueDark; b.BackgroundTransparency=ac and 0.05 or 0.15
                local i2=b:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency=ac and 0.3 or 1 end
            end
            local lay = selectedPage:FindFirstChildOfClass("UIListLayout")
            if lay then GuiRefs.contentFrame.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 25) end
        end)
        btn.MouseEnter:Connect(function() if CategoryRefs.active~=name then btn.TextColor3=C.textDim; btn.BackgroundTransparency=0.25 end end)
        btn.MouseLeave:Connect(function() if CategoryRefs.active~=name then btn.TextColor3=C.textMuted; btn.BackgroundTransparency=0.3 end end)
    end
    local spBtn=CategoryRefs.btnsSide["Speed"]
    if spBtn then spBtn.TextColor3=C.white; spBtn.BackgroundColor3=Color3.fromRGB(180,25,35); spBtn.BackgroundTransparency=0.05; local i2=spBtn:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency=0.3 end end
end)()

-- SPEED PAGE
;(function()
    local sp=CategoryRefs.contents["Speed"]
    addSectLbl(sp,"SPEED CONFIGURATION",0)
    addInputRow(sp,"Normal Speed",NS,1,function(v) NS=v; saveConfig() end)
    addInputRow(sp,"Carry Speed",CS,2,function(v) CS=v; saveConfig() end)
    addSectLbl(sp,"LAGGER CARRY",3)
    addInputRow(sp,"Lagger Carry",LAGGER_CARRY_SPEED,4,function(v) LAGGER_CARRY_SPEED=v; saveConfig() end)
    addSectLbl(sp,"CONTROLS",5)
    addToggleRow(sp,"Safe Speed Near Base",safeSpeedNearBaseEnabled,6,nil,function(on)
        safeSpeedNearBaseEnabled=on==true
        saveConfig()
    end)
    addToggleRow(sp,"Carry Mode",carrySpeedActive,7,"carryMode",function(on)
        carrySpeedActive = on
        if syncAutoAntiDrop then syncAutoAntiDrop() end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        saveConfig()
    end)
    addToggleRow(sp,"Lagger Carry",laggerModeEnabled,8,"laggerToggle",function(on)
        laggerModeEnabled=on
        if on then carrySpeedActive=false end
        if syncAutoAntiDrop then syncAutoAntiDrop() end
        if mobBtnRefs.lagger then mobBtnRefs.lagger(on) end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        saveConfig()
    end)
    -- Auto Carry: when game forces low WalkSpeed (steal), auto-enable Carry Speed
    addToggleRow(sp,"Auto Carry",autoSwitchSpeedEnabled,9,nil,function(on)
        autoSwitchSpeedEnabled=on==true
        saveConfig()
    end)
    addToggleRow(sp,"Anti Drop (Auto ON)",true,10,nil,function(on)
        -- Always stays ON automatically
        antiDropEnabled = true
        startAntiDrop()
        saveConfig()
    end)
end)()


-- COMBAT PAGE
;(function()
    local cp=CategoryRefs.contents["Combat"]
    addSectLbl(cp,"BAT CONTROLS",0)
    addToggleRow(cp,"Hard Hit (نطاق الضرب)",hardHitEnabled,0,nil,function(on)
        if on then startHardHit() else stopHardHit() end
        saveConfig()
    end)
    addInputRow(cp,"Hard Hit Radius",hardHitRadius,0,function(v)
        local n=tonumber(v); if n and n>=3 and n<=40 then hardHitRadius=n end
        saveConfig()
    end)
    addInputRow(cp,"Aimbot Chase Speed",BAT_AIMBOT_SPEED,1,function(v)
        local n=tonumber(v)
        if n and n>=10 and n<=200 then BAT_AIMBOT_SPEED=n end
        saveConfig()
    end)
    local _,svAutoBat=addToggleRow(cp,"Bat Aimbot",autoBatEnabled,2,"circle",function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
        else stopBatAimbot();if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        saveConfig()
    end)
    autoBatSetVisual=svAutoBat
    local _,svTPBat=addToggleRow(cp,"Anti Desync (TP Bat)",_G.AceAntiDesyncAimbotOn==true,3,nil,function(on)
        if on then if startTPBat then startTPBat() end else if stopTPBat then stopTPBat() end end
    end)
    tpBatSetVisual=svTPBat
    local _,tpModeBtn=addCycleRow(cp,"TP Bat Engine",tpBatVersion,4,function()
        tpBatVersion=(tpBatVersion=="V1") and "V2" or "V1"
        if _G.AceAntiDesyncAimbotOn then
            if stopTPBat then stopTPBat() end
            task.defer(function() if startTPBat then startTPBat() end end)
        end
        saveConfig()
        return tpBatVersion
    end)
    local _,svTPCamera=addToggleRow(cp,"TP Bat Camera Lock",tpBatCameraLock,5,nil,function(on)
        tpBatCameraLock=on==true
        saveConfig()
    end)
    local _,svAutoSwing=addToggleRow(cp,"Auto Swing",autoSwingEnabled,6,nil,function(on) autoSwingEnabled=on;saveConfig() end)
    local _,svBatCounter=addToggleRow(cp,"Bat Counter",batCounterEnabled,7,nil,function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    setBatCounterVisual=svBatCounter
    addSectLbl(cp,"RAGDOLL",8)
    local _,svRagdoll=addToggleRow(cp,"Anti Ragdoll",antiRagdollEnabled,9,nil,function(on)
        if on then
            _G.MMA_WantedState.antiRag = true
            antiRagdollEnabled=true
            if startAntiRagdoll then startAntiRagdoll() elseif _G.startAntiRagdoll then _G.startAntiRagdoll() end
        else
            _G.MMA_WantedState.antiRag = false
            if stopAntiRagdoll then stopAntiRagdoll(false) elseif _G.stopAntiRagdoll then _G.stopAntiRagdoll(false) end
            antiRagdollEnabled=false
        end
        saveConfig()
    end)
    setAntiRagVisual=svRagdoll
    if antiRagdollEnabled then svRagdoll(true) end
    local _,svMedusa=addToggleRow(cp,"Medusa Counter",medusaCounterEnabled,10,nil,function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setMedusaVisual=svMedusa
    local _,svUnwalk=addToggleRow(cp,"Unwalk",unwalkEnabled,11,nil,function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)
    addSectLbl(cp,"SERVER LAGGER",12)
    addToggleRow(cp,"MMA Server Lagger",mmaServerLaggerEnabled,13,nil,function(on)
        setMmaServerLagger(on)
        if on then openMmaLaggerPanel() end
        saveConfig()
    end)
    -- Open panel button
    do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        row.BorderSizePixel = 0
         row.LayoutOrder = 14
        row.Parent = cp
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local b = Instance.new("TextButton", row)
        b.Size = UDim2.new(1, -12, 1, -8)
        b.Position = UDim2.new(0, 6, 0, 4)
        b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        b.BorderSizePixel = 0
        b.Text = "OPEN LAGGER PANEL"
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.TextColor3 = Color3.fromRGB(12, 12, 16)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function()
            openMmaLaggerPanel()
        end)
    end

    setUnwalkVisual=svUnwalk
     addSectLbl(cp,"ACTIONS",15)
     addActionRow(cp,"Drop Brainrot","dropBrainrot",function() runDrop() end,16)
     addActionRow(cp,"TP Down","tpDown",function() runTPFloor() end,17)
     addActionRow(cp,"Unstick (Leave Safe)",nil,function()
        if _G.MMAFullCleanup then _G.MMAFullCleanup() end
        pcall(function()
            local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and sethiddenproperty then sethiddenproperty(hrp,"PhysicsRepRootPart",nil) end
            if hrp then hrp.Anchored=false end
        end)
     end,18)
end)()

-- STEAL PAGE (Rave Hub exact)
;(function()
    local st=CategoryRefs.contents["Steal"]
    addSectLbl(st,"منو انت",0)
    addToggleRow(st,"Auto Steal",Steal.AutoStealEnabled,1,nil,function(on)
        if on then
            _G.MMA_WantedState.autoSteal = true
            Steal.AutoStealEnabled=true
            autoStealEnabled=true
            autoStealRadius=Steal.StealRadius
            autoStealDelayRadius=Steal.CompleteRadius
            startAutoSteal()
        else
            _G.MMA_WantedState.autoSteal = false
            Steal.AutoStealEnabled=false
            autoStealEnabled=false
            stopAutoSteal(false)
        end
        saveConfig()
    end)
    addInputRow(st,"Steal Radius",Steal.StealRadius,2,function(v)
        Steal.StealRadius=tonumber(v) or 61
        autoStealRadius=Steal.StealRadius
        saveConfig()
    end)
    addInputRow(st,"Complete Radius",Steal.CompleteRadius,3,function(v)
        Steal.CompleteRadius=tonumber(v) or 9
        autoStealDelayRadius=Steal.CompleteRadius
        saveConfig()
    end)
    addSectLbl(st,"E01 CARRY GUARD",4)
    local _,svE01=addToggleRow(st,"E01 Countdown",e01Enabled,5,nil,function(on)
        if setE01Enabled then setE01Enabled(on==true) else e01Enabled=on==true end
        saveConfig()
    end)
    e01SetVisual=svE01
    if e01Enabled then svE01(true) end
end)()

-- MOVEMENT PAGE
;(function()
    local mv=CategoryRefs.contents["Movement"]
    addSectLbl(mv,"AUTO PATHS",0)
    local _,svAutoLeft=addToggleRow(mv,"Auto Left",autoLeftEnabled,1,"autoLeft",function(on)
        if on then
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true;startAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
        else autoLeftEnabled=false;stopAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        saveConfig()
    end)
    autoLeftSetVisual=svAutoLeft
    local _,svAutoRight=addToggleRow(mv,"Auto Right",autoRightEnabled,2,"autoRight",function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true;startAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
        else autoRightEnabled=false;stopAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        saveConfig()
    end)
    autoRightSetVisual=svAutoRight
    addSectLbl(mv,"SETTINGS",3)
    local _,svAutoTP=addToggleRow(mv,"Auto TP",autoTPEnabled,4,nil,function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
    setAutoTPVisual=svAutoTP
    addInputRow(mv,"TP Height",autoTPHeight,5,function(v) if v>=0 and v<=500 then autoTPHeight=v end;saveConfig() end)
    local _,svInfJump=addToggleRow(mv,"Infinite Jump",infJumpEnabled,6,nil,function(on)
        infJumpEnabled=on
        _G.MMA_InfJumpOn = on and true or false
        _G.MMA_WantedState.infJump = on and true or false
        if on then startHoldInfJump() else
            _G.MMA_InfJumpOn = false
            stopHoldInfJump()
        end
        saveConfig()
    end)
    setInfJumpVisual=svInfJump
end)()


-- MMA ESP (Box + Line + Skeleton)
local espEnabled=false
local espObjects={}
local ESP_COL=Color3.fromRGB(255,255,255)
local ESP_BONE=Color3.fromRGB(180,220,255)
local BONE_R15={
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local BONE_R6={{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
local DrawingOK=(typeof(Drawing)=="function" or typeof(Drawing)=="table")

local function espClear(plr)
    local o=espObjects[plr]
    if not o then return end
    for _,v in pairs(o) do
        pcall(function()
            if typeof(v)=="Instance" then v:Destroy()
            elseif type(v)=="table" and v.Remove then v:Remove()
            elseif type(v)=="userdata" and v.Remove then v:Remove()
            elseif type(v)=="table" then
                for _,b in ipairs(v) do pcall(function() if typeof(b)=="Instance" then b:Destroy() end end) end
            end
        end)
    end
    espObjects[plr]=nil
end

local function espBones(char)
    local lines={}
    local pairsList=char:FindFirstChild("UpperTorso") and BONE_R15 or BONE_R6
    for _,pair in ipairs(pairsList) do
        local a=char:FindFirstChild(pair[1],true)
        local b=char:FindFirstChild(pair[2],true)
        if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
            local att0=a:FindFirstChild("MMA_ESP_A0") or Instance.new("Attachment")
            att0.Name="MMA_ESP_A0"; att0.Parent=a
            local att1=b:FindFirstChild("MMA_ESP_A1") or Instance.new("Attachment")
            att1.Name="MMA_ESP_A1"; att1.Parent=b
            local beam=Instance.new("Beam")
            beam.Name="MMA_ESP_Bone"
            beam.Attachment0=att0
            beam.Attachment1=att1
            beam.Color=ColorSequence.new(ESP_BONE)
            beam.Width0=0.06; beam.Width1=0.06
            beam.FaceCamera=true
            beam.LightEmission=1
            beam.Transparency=NumberSequence.new(0.15)
            beam.Parent=a
            table.insert(lines,beam)
        end
    end
    return lines
end

local function ensureEsp(plr)
    if plr==LP or not espEnabled then return end
    local char=plr.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health<=0 then espClear(plr); return end
    local o=espObjects[plr]
    if not o then
        o={}
        local hl=Instance.new("Highlight")
        hl.Name="MMA_ESP_HL"
        hl.FillColor=ESP_COL
        hl.OutlineColor=ESP_COL
        hl.FillTransparency=0.82
        hl.OutlineTransparency=0
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee=char
        hl.Parent=char
        o.hl=hl
        local head=char:FindFirstChild("Head")
        if head then
            local bb=Instance.new("BillboardGui")
            bb.Name="MMA_ESP_BB"
            bb.Size=UDim2.new(0,140,0,18)
            bb.StudsOffset=Vector3.new(0,2.6,0)
            bb.AlwaysOnTop=true
            bb.MaxDistance=600
            bb.Adornee=head
            bb.Parent=head
            local tl=Instance.new("TextLabel",bb)
            tl.Size=UDim2.fromScale(1,1)
            tl.BackgroundTransparency=1
            tl.Text=plr.DisplayName or plr.Name
            tl.TextColor3=ESP_COL
            tl.TextStrokeTransparency=0.3
            tl.Font=Enum.Font.GothamBold
            tl.TextSize=12
            o.bb=bb; o.tl=tl
        end
        o.bones=espBones(char)
        if DrawingOK then
            local ok,ln=pcall(function()
                local l=Drawing.new("Line")
                l.Thickness=1.5; l.Color=ESP_COL; l.Transparency=1; l.Visible=false
                return l
            end)
            if ok then o.line=ln end
        end
        espObjects[plr]=o
    end
    if o.line then
        local cam=workspace.CurrentCamera
        if cam then
            local sp,onScreen=cam:WorldToViewportPoint(hrp.Position)
            local vp=cam.ViewportSize
            if onScreen and sp.Z>0 then
                o.line.From=Vector2.new(vp.X/2, vp.Y)
                o.line.To=Vector2.new(sp.X, sp.Y)
                o.line.Visible=true
            else
                o.line.Visible=false
            end
        end
    end
end

local _espConn=nil
local function startESP()
    espEnabled=true
    if _espConn then return end
    _espConn=RunService.RenderStepped:Connect(function()
        if not espEnabled then return end
        for _,plr in ipairs(Players:GetPlayers()) do pcall(ensureEsp,plr) end
        for plr,_ in pairs(espObjects) do
            if not plr.Parent then espClear(plr) end
        end
    end)
end
local function stopESP()
    espEnabled=false
    if _espConn then pcall(function() _espConn:Disconnect() end); _espConn=nil end
    for plr,_ in pairs(espObjects) do espClear(plr) end
end

-- VISUAL PAGE
;(function()
    local vi=CategoryRefs.contents["Visual"]

    addSectLbl(vi,"VISUAL",0)
    addToggleRow(vi,"ESP (Box+Line+Skeleton)",espEnabled,0,nil,function(on)
        if on then startESP() else stopESP() end
        saveConfig()
    end)
    addToggleRow(vi,"Headless",headlessEnabled,1,nil,function(on)
        headlessEnabled=on==true
        if LP.Character and applyHeadlessToChar then applyHeadlessToChar(LP.Character,headlessEnabled) end
        saveConfig()
    end)
    addToggleRow(vi,"Korblox",korbloxEnabled,2,nil,function(on)
        korbloxEnabled=on==true
        if LP.Character and applyKorbloxToChar then applyKorbloxToChar(LP.Character,korbloxEnabled) end
        saveConfig()
    end)
    addToggleRow(vi,"Zombie Anims (Rembembi)",animEnabled,3,nil,function(on)
        animEnabled=on; if on then startAnimToggle() else stopAnimToggle() end; saveConfig()
    end)
    addToggleRow(vi,"Intro Song",introSoundEnabled,4,nil,function(on)
        introSoundEnabled=on
        if not on and introSoundInstance and introSoundInstance.IsPlaying then pcall(function() introSoundInstance:Stop() end) end
        saveConfig()
    end)
    addToggleRow(vi,"Anti Lag",antiLagEnabled,5,nil,function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
    addToggleRow(vi,"Nuke Optimizer",nukeEnabled,10,nil,function(on)
        if on then nukeStart() else nukeStop() end
        saveConfig()
    end)
    addToggleRow(vi,"Stretch Rez",stretchRezEnabled,6,nil,function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
    addToggleRow(vi,"Ragdoll GUI",ragdollGuiEnabled,7,nil,function(on) ragdollGuiEnabled=on;saveConfig() end)
    addSectLbl(vi,"STREAMER",7)
    local _,svStream=addToggleRow(vi,"Streamer Mode (Hide All UI)",streamerModeEnabled,8,nil,function(on)
        setStreamerMode(on)
        saveConfig()
    end)
    setStreamerModeVisual=svStream
    addSectLbl(vi,"SIDE BUTTONS",9)
    addToggleRow(vi,"Move Side Buttons",not mobileButtonsLocked,9,nil,function(on)
        -- ON = can drag/move buttons, OFF = fixed in place
        mobileButtonsLocked = not on
        uiLocked = mobileButtonsLocked
        saveConfig()
    end)

    addSectLbl(vi,"EXTRAS",11)
    do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 40)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        row.BorderSizePixel = 0
        row.LayoutOrder = 12
        row.Parent = vi
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", row)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1
        stroke.Transparency = 0.55
        local b = Instance.new("TextButton", row)
        b.Size = UDim2.new(1, -12, 1, -8)
        b.Position = UDim2.new(0, 6, 0, 4)
        b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        b.BorderSizePixel = 0
        b.Text = "LOAD ZLPV PREVIEW"
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(0, 0, 0)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local busy = false
        b.MouseButton1Click:Connect(function()
            if busy then return end
            busy = true
            local prev = b.Text
            b.Text = "LOADING..."
            task.spawn(function()
                local ok, err = pcall(function()
                    local src = game:HttpGet("https://raw.githubusercontent.com/xspeedHub0/Zlhub/main/ZLPVPreview.lua")
                    local fn = loadstring(src)
                    if type(fn) ~= "function" then
                        error("loadstring failed")
                    end
                    fn()
                end)
                if ok then
                    b.Text = "LOADED!"
                else
                    b.Text = "FAILED"
                    warn("[MMA] ZLPV Preview load failed:", err)
                end
                task.wait(1.2)
                b.Text = prev
                busy = false
            end)
        end)
    end

    -- background images removed (clean settings)
    backgroundIndex=0; backgroundEnabled=false
    if GuiRefs.backgroundImage then GuiRefs.backgroundImage.Visible=false end
    if GuiRefs.bgGrad then GuiRefs.bgGrad.Visible=true end

    addSectLbl(vi,"SKY THEME",6)
    local skyIdx=1; for i,t in ipairs(SkyOrder) do if t==currentSkyTheme then skyIdx=i;break end end
    local skyRow=Instance.new("Frame"); skyRow.Size=UDim2.new(1,0,0,38); skyRow.BackgroundColor3=C.row
    skyRow.BackgroundTransparency=0.5; skyRow.BorderSizePixel=0; skyRow.LayoutOrder=9; skyRow.Parent=vi
    guiCorner(skyRow,10); guiStroke(skyRow,C.divider,1)
    local skyLbl=Instance.new("TextLabel",skyRow); skyLbl.Size=UDim2.new(0.45,0,0,16); skyLbl.Position=UDim2.new(0,12,0,6)
    skyLbl.BackgroundTransparency=1; skyLbl.Text="Sky Theme"; skyLbl.TextColor3=C.text; skyLbl.TextSize=11; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextXAlignment=Enum.TextXAlignment.Left
    local skyVal=Instance.new("TextLabel",skyRow); skyVal.Size=UDim2.new(0,80,0,16); skyVal.Position=UDim2.new(1,-130,0,6)
    skyVal.BackgroundTransparency=1; skyVal.Text=currentSkyTheme; skyVal.TextColor3=C.textDim; skyVal.TextSize=9; skyVal.Font=Enum.Font.GothamBold; skyVal.TextXAlignment=Enum.TextXAlignment.Right
    local skyBtn=Instance.new("TextButton",skyRow); skyBtn.Size=UDim2.new(0,44,0,22); skyBtn.Position=UDim2.new(1,-52,0.5,-11)
    skyBtn.BackgroundColor3=C.blue; skyBtn.BackgroundTransparency=0.5; skyBtn.BorderSizePixel=0; skyBtn.Text="Next"
    skyBtn.TextColor3=C.white; skyBtn.TextSize=9; skyBtn.Font=Enum.Font.GothamBold; guiCorner(skyBtn,5)
    skyBtn.MouseButton1Click:Connect(function()
        skyIdx=skyIdx%#SkyOrder+1; currentSkyTheme=SkyOrder[skyIdx]; skyVal.Text=currentSkyTheme; CandyApplyCustomSky(currentSkyTheme); saveConfig()
    end)
    local hov2=Instance.new("TextButton",skyRow); hov2.Size=UDim2.new(1,0,1,0); hov2.BackgroundTransparency=1; hov2.Text=""; hov2.ZIndex=0
    hov2.MouseEnter:Connect(function() tw(skyRow,{BackgroundTransparency=0.3}) end); hov2.MouseLeave:Connect(function() tw(skyRow,{BackgroundTransparency=0.5}) end)

    addSectLbl(vi,"FOV",10)
    local fovRow=Instance.new("Frame"); fovRow.Size=UDim2.new(1,0,0,38); fovRow.BackgroundColor3=C.row
    fovRow.BackgroundTransparency=0.5; fovRow.BorderSizePixel=0; fovRow.LayoutOrder=11; fovRow.Parent=vi
    guiCorner(fovRow,10); guiStroke(fovRow,C.divider,1)
    local fovLbl=Instance.new("TextLabel",fovRow); fovLbl.Size=UDim2.new(0.5,0,0,16); fovLbl.Position=UDim2.new(0,12,0,6)
    fovLbl.BackgroundTransparency=1; fovLbl.Text="FOV"; fovLbl.TextColor3=C.text; fovLbl.TextSize=11; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextXAlignment=Enum.TextXAlignment.Left
    local fovBtn=Instance.new("TextButton",fovRow); fovBtn.Size=UDim2.new(0,52,0,22); fovBtn.Position=UDim2.new(1,-60,0.5,-11)
    fovBtn.BackgroundColor3=C.blue; fovBtn.BackgroundTransparency=0.5; fovBtn.BorderSizePixel=0
    fovBtn.Text=tostring(fovValue); fovBtn.TextColor3=C.white; fovBtn.TextSize=11; fovBtn.Font=Enum.Font.GothamBold; guiCorner(fovBtn,5)
    fovBtn.MouseButton1Click:Connect(function()
        fovIndex=fovIndex%#fovOptions+1; fovValue=fovOptions[fovIndex]; fovBtn.Text=tostring(fovValue); applyFOV(); saveConfig()
    end)
    local hov3=Instance.new("TextButton",fovRow); hov3.Size=UDim2.new(1,0,1,0); hov3.BackgroundTransparency=1; hov3.Text=""; hov3.ZIndex=0
    hov3.MouseEnter:Connect(function() tw(fovRow,{BackgroundTransparency=0.3}) end); hov3.MouseLeave:Connect(function() tw(fovRow,{BackgroundTransparency=0.5}) end)

    addSectLbl(vi,"RESET",14)
    local resetRow=Instance.new("Frame"); resetRow.Size=UDim2.new(1,0,0,38); resetRow.BackgroundColor3=C.row
    resetRow.BackgroundTransparency=0.5; resetRow.BorderSizePixel=0; resetRow.LayoutOrder=15; resetRow.Parent=vi
    guiCorner(resetRow,10); guiStroke(resetRow,C.divider,1)
    local resetLbl=Instance.new("TextLabel",resetRow); resetLbl.Size=UDim2.new(0.55,0,0,16); resetLbl.Position=UDim2.new(0,12,0,6)
    resetLbl.BackgroundTransparency=1; resetLbl.Text="Reset Settings"; resetLbl.TextColor3=C.text; resetLbl.TextSize=11; resetLbl.Font=Enum.Font.GothamBold; resetLbl.TextXAlignment=Enum.TextXAlignment.Left
    local resetBtn=Instance.new("TextButton",resetRow); resetBtn.Size=UDim2.new(0,52,0,22); resetBtn.Position=UDim2.new(1,-60,0.5,-11)
    resetBtn.BackgroundColor3=Color3.fromRGB(150,30,40); resetBtn.BackgroundTransparency=0.2; resetBtn.BorderSizePixel=0
    resetBtn.Text="RESET"; resetBtn.TextColor3=C.white; resetBtn.TextSize=9; resetBtn.Font=Enum.Font.GothamBold; guiCorner(resetBtn,5)
    resetBtn.MouseButton1Click:Connect(function() resetAllSettings() end)
    local hov4=Instance.new("TextButton",resetRow); hov4.Size=UDim2.new(1,0,1,0); hov4.BackgroundTransparency=1; hov4.Text=""; hov4.ZIndex=0
    hov4.MouseEnter:Connect(function() tw(resetRow,{BackgroundTransparency=0.3}) end); hov4.MouseLeave:Connect(function() tw(resetRow,{BackgroundTransparency=0.5}) end)
end)()


-- ============================================================
-- STREAMER MODE: hide ALL script GUIs (features keep running)
-- Note: OBS/Discord capture the game window — true "invisible to
-- stream while you still see UI" is not possible from Roblox Lua.
-- This mode hides every MMA UI so nothing script-related shows.
-- Toggle: Visual page OR RightShift (default)
-- ============================================================
local STREAMER_GUI_NAMES = {
    "MoveeStealBar", "MMAStealOMGBar", "RaveHubAutoStealBar",
    "SpectrumMobileButtons", "MoveeMobileButtons", "BloodHoundsMobilePanel",
    "MMA_LaggerPanel", "MoveeRagdollTimer_RAGDOLL", "MoveeRagdollTimer_STONE",
    "YassinOnTopSpeedIndicator", "YassinAutoStealBar",
}

local function mmaCollectScriptGuis()
    local list = {}
    local function add(g)
        if g and g:IsA("ScreenGui") then table.insert(list, g) end
    end
    if GuiRefs and GuiRefs.hub then add(GuiRefs.hub) end
    if mobGuiRef then add(mobGuiRef) end
    if autoStealProgressGui then add(autoStealProgressGui) end
    if stealBarFrame and stealBarFrame.Parent and stealBarFrame.Parent:IsA("ScreenGui") then
        add(stealBarFrame.Parent)
    end
    for _, parent in ipairs({
        game:GetService("CoreGui"),
        LP:FindFirstChild("PlayerGui"),
    }) do
        if parent then
            for _, name in ipairs(STREAMER_GUI_NAMES) do
                local g = parent:FindFirstChild(name)
                if g then add(g) end
            end
            -- catch any ScreenGui tagged by us
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("ScreenGui") and child:GetAttribute("MMA_SCRIPT_UI") == true then
                    add(child)
                end
            end
        end
    end
    -- speed head billboard
    pcall(function()
        local char = LP.Character
        local head = char and char:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("YassinOnTopSpeedIndicator")
            if bb then table.insert(list, bb) end
        end
    end)
    return list
end

function setStreamerMode(on)
    streamerModeEnabled = on and true or false
    _G.MMA_StreamerMode = streamerModeEnabled
    -- When streamer mode ON: force-hide everything
    -- When OFF: restore (unless Roblox menu is open)
    if streamerModeEnabled then
        for _, g in ipairs(mmaCollectScriptGuis()) do
            pcall(function()
                g:SetAttribute("MMA_PrevEnabled", g:IsA("LayerCollector") and g.Enabled or true)
                if g:IsA("LayerCollector") then
                    g.Enabled = false
                elseif g:IsA("BillboardGui") then
                    g.Enabled = false
                end
            end)
        end
        -- also hide MiniBtn / Outer if present
        pcall(function()
            if GuiRefs and GuiRefs.hub then GuiRefs.hub.Enabled = false end
        end)
    else
        if not _G.MMA_CoreMenuOpen then
            for _, g in ipairs(mmaCollectScriptGuis()) do
                pcall(function()
                    if g:IsA("LayerCollector") or g:IsA("BillboardGui") then
                        local prev = g:GetAttribute("MMA_PrevEnabled")
                        if prev == nil then prev = true end
                        g.Enabled = prev and true or false
                    end
                end)
            end
            pcall(function()
                if GuiRefs and GuiRefs.hub then GuiRefs.hub.Enabled = true end
                if mobGuiRef and mobileButtonsEnabled ~= false then mobGuiRef.Enabled = true end
            end)
        end
    end
    if setStreamerModeVisual then pcall(setStreamerModeVisual, streamerModeEnabled) end
end

function toggleStreamerMode()
    setStreamerMode(not streamerModeEnabled)
end

_G.MMA_SetStreamerMode = setStreamerMode
_G.MMA_ToggleStreamerMode = toggleStreamerMode


-- CORE UI FIX: never disable/sink Roblox topbar, chat, or ESC.
pcall(function()
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
end)
pcall(function()
    local TCS = game:GetService("TextChatService")
    local cw = TCS:FindFirstChildOfClass("ChatWindowConfiguration")
    if cw then cw.Enabled = true end
    local ci = TCS:FindFirstChildOfClass("ChatInputBarConfiguration")
    if ci then ci.Enabled = true end
end)

-- ROBLOX CORE UI SAFETY
-- Never let this script's UI compete with the Roblox ESC/menu or chat controls.
pcall(function()
    local GuiService=game:GetService("GuiService")
    GuiService.MenuOpened:Connect(function()
        _G.MMA_CoreMenuOpen=true
        if GuiRefs and GuiRefs.hub then GuiRefs.hub.Enabled=false end
        if mobGuiRef then mobGuiRef.Enabled=false end
        if stealBarFrame and stealBarFrame.Parent then
            local sg=stealBarFrame.Parent
            if sg:IsA("ScreenGui") then sg.Enabled=false end
        end
    end)
    GuiService.MenuClosed:Connect(function()
        _G.MMA_CoreMenuOpen=false
        if streamerModeEnabled or _G.MMA_StreamerMode then
            setStreamerMode(true)
            return
        end
        if GuiRefs and GuiRefs.hub then GuiRefs.hub.Enabled=true end
        if mobGuiRef and mobileButtonsEnabled then mobGuiRef.Enabled=true end
        if stealBarFrame and stealBarFrame.Parent then
            local sg=stealBarFrame.Parent
            if sg:IsA("ScreenGui") then sg.Enabled=true end
        end
    end)
end)

UIS.TextBoxFocused:Connect(function()
    _G.MMA_ChatFocused=true
end)
UIS.TextBoxFocusReleased:Connect(function()
    _G.MMA_ChatFocused=false
end)

-- KEYBOARD + PLAYSTATION SHORTCUTS

-- Streamer Mode hotkey (RightShift)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe or UIS:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleStreamerMode()
    end
end)

ControllerKeys = ControllerKeys or {
    dropBrainrot=Enum.KeyCode.ButtonX,
    autoLeft=Enum.KeyCode.ButtonL1,
    autoRight=Enum.KeyCode.ButtonR1,
    autoBat=Enum.KeyCode.ButtonY,
    tpDown=Enum.KeyCode.ButtonB,
    carryMode=Enum.KeyCode.DPadDown,
    laggerToggle=Enum.KeyCode.DPadUp,
    tpBat=Enum.KeyCode.ButtonR2,
    guiHide=Enum.KeyCode.ButtonSelect,
    instaReset=Enum.KeyCode.ButtonL2,
}
UIS.InputBegan:Connect(function(inp,gpe)
    if _G.MMA_CoreMenuOpen then return end
    if KeyListen and KeyListen.active then return end
    if _G.MMA_ChatFocused or UIS:GetFocusedTextBox() then return end
    local isKb = inp.UserInputType==Enum.UserInputType.Keyboard
    local isGp = inp.UserInputType==Enum.UserInputType.Gamepad1 or inp.UserInputType==Enum.UserInputType.Gamepad2
    if not isKb and not isGp then return end
    if isKb and gpe then return end
    local k=inp.KeyCode
    local function hit(kbKey, gpKey)
        if isKb and Keys[kbKey] and k==Keys[kbKey] then return true end
        if isGp and ControllerKeys and ControllerKeys[gpKey] and k==ControllerKeys[gpKey] then return true end
        return false
    end
    if hit("guiHide","guiHide") then if GuiRefs.outer then GuiRefs.outer.Visible=not GuiRefs.outer.Visible end
    elseif hit("speed","speed") then speedToggleAction(); saveConfig()
    elseif hit("carryMode","carryMode") then toggleCarryMode(); saveConfig()
    elseif hit("laggerToggle","laggerToggle") then toggleLaggerMode(); saveConfig()
    elseif hit("circle","autoBat") then
        autoBatEnabled=not autoBatEnabled
        if autoBatEnabled then startBatAimbot() else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
        saveConfig()
    elseif hit("dropBrainrot","dropBrainrot") then runDrop()
    elseif hit("tpDown","tpDown") then runTPFloor()
    elseif hit("instaReset","instaReset") then cursedInstaReset()
    elseif hit("tpBat","tpBat") then
        if toggleTPBat then toggleTPBat() end
        saveConfig()
    elseif hit("autoLeft","autoLeft") then
        if autoLeftEnabled then
            autoLeftEnabled=false; stopAutoLeft()
        else
            if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true; startAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    elseif hit("autoRight","autoRight") then
        if autoRightEnabled then
            autoRightEnabled=false; stopAutoRight()
        else
            if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true; startAutoRight()
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    end
end)


-- KEYS PAGE (Keyboard + PlayStation for every side button)
;(function()
    local kp=CategoryRefs.contents["Keys"]
    if not kp then return end
    -- dual key maps
    ControllerKeys = ControllerKeys or {
        dropBrainrot=Enum.KeyCode.ButtonX,
        autoLeft=Enum.KeyCode.ButtonL1,
        autoRight=Enum.KeyCode.ButtonR1,
        autoBat=Enum.KeyCode.ButtonY,
        tpDown=Enum.KeyCode.ButtonB,
        carryMode=Enum.KeyCode.DPadDown,
        laggerToggle=Enum.KeyCode.DPadUp,
        tpBat=Enum.KeyCode.ButtonR2,
        guiHide=Enum.KeyCode.ButtonSelect,
        instaReset=Enum.KeyCode.ButtonL2,
    }
    local function addDualKey(parent,label,kbKey,gpKey,order)
        local Row=Instance.new("Frame"); Row.Size=UDim2.new(1,0,0,42); Row.BackgroundColor3=C.row
        Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; Row.Parent=parent
        guiCorner(Row,10); guiStroke(Row,C.divider,1)
        local L=Instance.new("TextLabel",Row); L.Size=UDim2.new(0.36,0,1,0); L.Position=UDim2.new(0,10,0,0)
        L.BackgroundTransparency=1; L.Text=label; L.TextColor3=C.text; L.TextSize=11; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
        local kbBtn=Instance.new("TextButton",Row); kbBtn.Size=UDim2.new(0,54,0,24); kbBtn.Position=UDim2.new(1,-120,0.5,-12)
        kbBtn.BackgroundColor3=C.blue; kbBtn.BackgroundTransparency=0.5; kbBtn.BorderSizePixel=0; kbBtn.Text=prettyKey(Keys[kbKey] or Enum.KeyCode.Unknown)
        kbBtn.TextColor3=C.white; kbBtn.TextSize=9; kbBtn.Font=Enum.Font.GothamBold; guiCorner(kbBtn,5)
        kbBtn.MouseButton1Click:Connect(function()
            startKL(kbBtn,function(nk) Keys[kbKey]=nk; kbBtn.Text=prettyKey(nk); saveConfig() end)
        end)
        local gpBtn=Instance.new("TextButton",Row); gpBtn.Size=UDim2.new(0,54,0,24); gpBtn.Position=UDim2.new(1,-58,0.5,-12)
        gpBtn.BackgroundColor3=C.blueDark; gpBtn.BackgroundTransparency=0.3; gpBtn.BorderSizePixel=0
        gpBtn.Text=prettyKey(ControllerKeys[gpKey] or Enum.KeyCode.Unknown)
        gpBtn.TextColor3=C.white; gpBtn.TextSize=9; gpBtn.Font=Enum.Font.GothamBold; guiCorner(gpBtn,5)
        gpBtn.MouseButton1Click:Connect(function()
            startKL(gpBtn,function(nk) ControllerKeys[gpKey]=nk; gpBtn.Text=prettyKey(nk); saveConfig() end)
        end)
        local tag=Instance.new("TextLabel",Row); tag.Size=UDim2.new(0,40,0,12); tag.Position=UDim2.new(1,-120,0,2)
        tag.BackgroundTransparency=1; tag.Text="KB"; tag.TextColor3=C.textMuted; tag.TextSize=8; tag.Font=Enum.Font.Gotham
        local tag2=Instance.new("TextLabel",Row); tag2.Size=UDim2.new(0,40,0,12); tag2.Position=UDim2.new(1,-58,0,2)
        tag2.BackgroundTransparency=1; tag2.Text="PS"; tag2.TextColor3=C.textMuted; tag2.TextSize=8; tag2.Font=Enum.Font.Gotham
    end
    addSectLbl(kp,"SIDE BUTTON KEYBINDS",0)
    local hdr=Instance.new("TextLabel",kp); hdr.Size=UDim2.new(1,-8,0,16); hdr.BackgroundTransparency=1
    hdr.Text="KB = Keyboard   |   PS = PlayStation"; hdr.TextColor3=C.textDim; hdr.TextSize=10; hdr.Font=Enum.Font.Gotham; hdr.LayoutOrder=1; hdr.TextXAlignment=Enum.TextXAlignment.Left
    addDualKey(kp,"Drop BR","dropBrainrot","dropBrainrot",2)
    addDualKey(kp,"Auto Left","autoLeft","autoLeft",3)
    addDualKey(kp,"Auto Right","autoRight","autoRight",4)
    addDualKey(kp,"Bat Aimbot","circle","autoBat",5)
    addDualKey(kp,"TP Down","tpDown","tpDown",6)
    addDualKey(kp,"Carry Speed","carryMode","carryMode",7)
    addDualKey(kp,"Lagger Carry","laggerToggle","laggerToggle",8)
    addDualKey(kp,"TP Bat","tpBat","tpBat",9)
    addDualKey(kp,"Hide GUI","guiHide","guiHide",11)
end)()


-- STARTUP
if infJumpEnabled then startHoldInfJump() end
if antiRagdollEnabled then startAntiRagdoll() end
if medusaCounterEnabled then setupMedusa(LP.Character) end
if animEnabled then startAnimToggle() end
backgroundIndex=0; backgroundEnabled=false
if GuiRefs.backgroundImage then GuiRefs.backgroundImage.Visible=false end
CandyApplyCustomSky(currentSkyTheme)
mobileButtonsEnabled=true
buildMobileButtons()
task.delay(0.5,function() mobileButtonsEnabled=true; pcall(buildMobileButtons) end)
task.delay(2,function()
    if not mobGuiRef or not mobGuiRef.Parent then
        mobileButtonsEnabled=true
        pcall(buildMobileButtons)
    end
end)

end)() -- end GUI function




-- ============================================================
-- PERSIST WATCHDOG: Anti Ragdoll + Auto Steal never stay OFF if user wants them ON
-- Survives death, respawn, and new round without relying on CharacterRemoving order.
-- ============================================================
task.spawn(function()
    while task.wait(1) do
        local want = _G.MMA_WantedState
        if type(want) ~= "table" then
            _G.MMA_WantedState = {antiRag=false,autoSteal=false,infJump=false}
            want = _G.MMA_WantedState
        end

        -- Anti Ragdoll
        if want.antiRag == true then
            if not antiRagdollEnabled then
                antiRagdollEnabled = true
            end
            local alive = Conns and Conns.antiRag
            if not alive then
                pcall(function()
                    if startAntiRagdoll then startAntiRagdoll()
                    elseif _G.startAntiRagdoll then _G.startAntiRagdoll() end
                end)
            end
            if setAntiRagVisual then pcall(setAntiRagVisual, true) end
        end

        -- Auto Steal
        if want.autoSteal == true then
            if not Steal.AutoStealEnabled then
                Steal.AutoStealEnabled = true
            end
            if not autoStealEnabled then
                autoStealEnabled = true
            end
            local stealAlive = ConnsAutoSteal and ConnsAutoSteal.autoSteal
            if not stealAlive then
                pcall(function()
                    if startAutoSteal then startAutoSteal() end
                end)
            end
        end

        -- Infinite Jump (permanent flag)
        if want.infJump == true or _G.MMA_InfJumpOn == true then
            _G.MMA_InfJumpOn = true
            want.infJump = true
            infJumpEnabled = true
            if setInfJumpVisual then pcall(setInfJumpVisual, true) end
        end
    end
end)

print("[منو انت] تم التحميل")
print("[منو انت] جاهز")

-- AUTO ANTI DROP FINAL SYNC
pcall(syncAutoAntiDrop)
