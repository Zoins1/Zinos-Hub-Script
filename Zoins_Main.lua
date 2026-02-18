-- ==========================================================
-- 1. نظام المقدمة (Intro System)
-- ==========================================================
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local function PlayIntro(onFinished)
    local IntroGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    IntroGui.DisplayOrder = 3000
    
    local Blur = Instance.new("BlurEffect", Lighting)
    Blur.Size = 0
    TweenService:Create(Blur, TweenInfo.new(1.2), {Size = 25}):Play()

    local MainContainer = Instance.new("Frame", IntroGui)
    MainContainer.Size = UDim2.new(1, 0, 1, 0)
    MainContainer.BackgroundTransparency = 1

    local function CreateText(text)
        local label = Instance.new("TextLabel", MainContainer)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 215, 0) -- لون ذهبي
        label.Font = Enum.Font.FredokaOne
        label.TextSize = 60
        label.TextTransparency = 1
        local stroke = Instance.new("UIStroke", label)
        stroke.Thickness = 3
        stroke.Transparency = 1
        return label, stroke
    end

    -- عرض النص الأول: Zoins Hub
    local HubLabel, HubStroke = CreateText("Zoins Hub")
    TweenService:Create(HubLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(HubStroke, TweenInfo.new(1), {Transparency = 0.4}):Play()
    task.wait(2.2)
    TweenService:Create(HubLabel, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(HubStroke, TweenInfo.new(0.8), {Transparency = 1}):Play()
    task.wait(0.8)

    HubLabel:Destroy()

    -- عرض النص الثاني: Ramadan event
    local EventLabel, EventStroke = CreateText("Ramadan event")
    TweenService:Create(EventLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(EventStroke, TweenInfo.new(1), {Transparency = 0.4}):Play()
    task.wait(2.2)
    
    TweenService:Create(EventLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(EventStroke, TweenInfo.new(1), {Transparency = 1}):Play()
    
    local blurOut = TweenService:Create(Blur, TweenInfo.new(1.2), {Size = 0})
    blurOut:Play()
    
    blurOut.Completed:Connect(function()
        Blur:Destroy()
        IntroGui:Destroy()
        if onFinished then onFinished() end
    end)
end

-- ==========================================================
-- 2. تشغيل السكربت الأصلي بعد انتهاء المقدمة
-- ==========================================================

PlayIntro(function()

-- [[ هنا يبدأ سكربتك الأصلي بالكامل مع التعديل المطلوب ]] --

local UserInputService = game:GetService("UserInputService")
local UIS = UserInputService
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local IsPC = UIS.KeyboardEnabled and UIS.MouseEnabled
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ===================================
-- ميزة تزييف السلاسة (Visual Smoothness Spoofing)
-- ===================================
task.spawn(function()
    local Camera = workspace.CurrentCamera
    RunService:BindToRenderStep("ZoinsSmoothness", Enum.RenderPriority.Camera.Value + 1, function()
        if Camera then
            Camera.InterpolationThrottling = Enum.InterpolationThrottlingMode.Disabled
        end
    end)
    settings().Network.IncomingReplicationLag = 0
    if setfpscap then setfpscap(999) end
end)

-- ===================================
-- نظام الإشعارات المخصص (رمضان كريم)
-- ===================================
local function ShowNotification(text)
    local NotifyGui = game:GetService("CoreGui"):FindFirstChild("ZoinsNotification")
    if not NotifyGui then
        NotifyGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        NotifyGui.Name = "ZoinsNotification"
        NotifyGui.DisplayOrder = 999
    end

    local NotifyFrame = Instance.new("Frame", NotifyGui)
    NotifyFrame.Size = UDim2.new(0, 280, 0, 70)
    NotifyFrame.Position = UDim2.new(1, 10, 0, 20) 
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(10, 40, 30) -- أخضر رمضاني
    NotifyFrame.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner", NotifyFrame)
    Corner.CornerRadius = UDim.new(0, 10)
    
    local Stroke = Instance.new("UIStroke", NotifyFrame)
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(255, 215, 0) -- ذهبي
    
    local Label = Instance.new("TextLabel", NotifyFrame)
    Label.Size = UDim2.new(1, -10, 1, -10)
    Label.Position = UDim2.new(0, 5, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = "🌙 " .. text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextWrapped = true

    NotifyFrame:TweenPosition(UDim2.new(1, -290, 0, 20), "Out", "Back", 0.5, true)
    
    task.delay(4, function()
        NotifyFrame:TweenPosition(UDim2.new(1, 10, 0, 20), "In", "Back", 0.5, true)
        task.wait(0.5)
        NotifyFrame:Destroy()
    end)
end

-- ===============================
-- Anti Lag / Delay Protection
-- ===============================
local function AntiLagWrap(func)
    task.spawn(function()
        RunService.Heartbeat:Wait()
        local ok, err = pcall(func)
        if not ok then warn("Zoins Hub | Script Error:", err) end
        task.delay(0.2, function()
            if collectgarbage then collectgarbage("step", 200) end
        end)
    end)
end

-- ===================================
-- دالة السحب المطورة (Smooth Dragging)
-- ===================================
function MakeDraggable(gui)
    local dragging = false
    local dragStart, startPos, dragInput
    local moved = false

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = gui.Position
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > 2 or math.abs(delta.Y) > 2 then moved = true end
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input) if input == dragInput then dragging = false end end)
    return function() return moved end
end

-- ===================================
-- Zoins V5 - Gold Edition Function (Ramadan)
-- ===================================
local function LoadGoldEdition()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrameG = Instance.new("Frame")
    local UICorner_Main = Instance.new("UICorner")
    local UIStroke_Main = Instance.new("UIStroke")
    local Title = Instance.new("TextLabel")
    local UIGradient_Title = Instance.new("UIGradient")
    local ContentFrame = Instance.new("ScrollingFrame")
    local CloseBtnG = Instance.new("TextButton")
    local MiniBtn = Instance.new("TextButton")
    local MiniCorner = Instance.new("UICorner")
    local MiniStroke = Instance.new("UIStroke")
    local MiniGradient = Instance.new("UIGradient")
    local MiniLabel = Instance.new("TextLabel")

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "Zoins_V5_Updated"
    ScreenGui.DisplayOrder = 1 

    MainFrameG.Name = "MainFrame"
    MainFrameG.Parent = ScreenGui
    MainFrameG.BackgroundColor3 = Color3.fromRGB(10, 25, 20) -- لمسة رمضانية
    MainFrameG.Position = UDim2.new(0.5, -140, 0.4, -200) 
    MainFrameG.Size = UDim2.new(0, 280, 0, 420)
    MainFrameG.Active = true

    UICorner_Main.CornerRadius = UDim.new(0, 20)
    UICorner_Main.Parent = MainFrameG
    UIStroke_Main.Thickness = 2.5
    UIStroke_Main.Parent = MainFrameG
    UIStroke_Main.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke_Main.Color = Color3.fromRGB(255, 255, 255)
    local StrokeGradient = Instance.new("UIGradient", UIStroke_Main)
    StrokeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(218, 165, 32)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 100))}

    task.spawn(function()
        while true do StrokeGradient.Rotation = StrokeGradient.Rotation + 1 MiniGradient.Rotation = MiniGradient.Rotation + 1 task.wait(0.02) end
    end)

    CloseBtnG.Name = "CloseBtn"
    CloseBtnG.Parent = MainFrameG
    CloseBtnG.BackgroundTransparency = 1
    CloseBtnG.Position = UDim2.new(1, -40, 0, 10)
    CloseBtnG.Size = UDim2.new(0, 30, 0, 30)
    CloseBtnG.Text = "X"
    CloseBtnG.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtnG.TextSize = 22
    CloseBtnG.Font = Enum.Font.FredokaOne

    Title.Name = "Title"
    Title.Parent = MainFrameG
    Title.Size = UDim2.new(1, 0, 0, 70)
    Title.Text = "🌙 ZOINS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 35
    Title.BackgroundTransparency = 1
    UIGradient_Title.Color = StrokeGradient.Color
    UIGradient_Title.Parent = Title

    ContentFrame.Parent = MainFrameG
    ContentFrame.Size = UDim2.new(1, 0, 1, -80)
    ContentFrame.Position = UDim2.new(0, 0, 0, 75)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 0
    local UIListLayout = Instance.new("UIListLayout", ContentFrame)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 12)

    MiniBtn.Name = "MiniBtn"
    MiniBtn.Parent = ScreenGui
    MiniBtn.BackgroundColor3 = Color3.fromRGB(10, 25, 20)
    MiniBtn.Position = UDim2.new(0.9, -10, 0.1, 0) 
    MiniBtn.Size = UDim2.new(0, 60, 0, 60)
    MiniBtn.Visible = false
    MiniBtn.Active = true
    MiniCorner.CornerRadius = UDim.new(1, 0)
    MiniCorner.Parent = MiniBtn
    MiniStroke.Thickness = 2.5
    MiniStroke.Parent = MiniBtn
    MiniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MiniStroke.Color = Color3.fromRGB(255, 255, 255)
    MiniGradient.Color = StrokeGradient.Color
    MiniGradient.Parent = MiniStroke
    MiniLabel.Parent = MiniBtn
    MiniLabel.Size = UDim2.new(1, 0, 1, 0)
    MiniLabel.Text = "🌙"
    MiniLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    MiniLabel.Font = Enum.Font.FredokaOne
    MiniLabel.TextSize = 30
    MiniLabel.BackgroundTransparency = 1

    local wasDragged = MakeDraggable(MainFrameG)
    local wasMiniDragged = MakeDraggable(MiniBtn)
    
    MiniBtn.MouseButton1Up:Connect(function() if not wasMiniDragged() then MainFrameG.Visible = true MiniBtn.Visible = false end end)
    CloseBtnG.MouseButton1Click:Connect(function() MainFrameG.Visible = false MiniBtn.Visible = true end)

    local function CreateElement(class, text)
        local obj = Instance.new(class)
        obj.Size = UDim2.new(0.88, 0, 0, 42)
        obj.BackgroundColor3 = Color3.fromRGB(15, 35, 25)
        obj.TextColor3 = Color3.fromRGB(255, 255, 255)
        obj.Font = Enum.Font.SourceSansSemibold
        obj.TextSize = 15
        obj.BorderSizePixel = 0
        if class == "TextBox" then obj.PlaceholderText = text obj.Text = "" else obj.Text = text end
        Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 12)
        local s = Instance.new("UIStroke", obj) s.Thickness = 1 s.Color = Color3.fromRGB(218, 165, 32)
        obj.Parent = ContentFrame
        return obj
    end

    local SpeedInput = CreateElement("TextBox", "⚡ Walk Speed (1-9999)")
    local JumpInput = CreateElement("TextBox", "🚀 Jump Power (1-9999)")
    local FlySpeedInput = CreateElement("TextBox", "✈️ Fly Speed")
    FlySpeedInput.Text = "50"
    local FlyBtn = CreateElement("TextButton", "ACTIVATE FLY")
    local NoclipBtn = CreateElement("TextButton", "ACTIVATE NOCLIP")
    local ResetBtn = CreateElement("TextButton", "SYSTEM RESET")

    local lp = game.Players.LocalPlayer
    local flying, noclip = false, false
    local noclipConn

    local function SetState(btn, state, onText, offText)
        btn.Text = state and onText or offText
        btn.UIStroke.Color = state and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 50, 50)
        btn.BackgroundColor3 = state and Color3.fromRGB(30, 60, 40) or Color3.fromRGB(15, 35, 25)
    end

    NoclipBtn.MouseButton1Click:Connect(function()
        noclip = not noclip
        SetState(NoclipBtn, noclip, "NOCLIP: ACTIVE", "ACTIVATE NOCLIP")
        if noclip then
            noclipConn = game:GetService("RunService").Stepped:Connect(function()
                if noclip and lp.Character then
                    for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then lp.Character.HumanoidRootPart.CanCollide = true end
        end
    end)

    FlyBtn.MouseButton1Click:Connect(function()
        flying = not flying
        SetState(FlyBtn, flying, "FLY: ON", "ACTIVATE FLY")
        local char = lp.Character
        if not char then return end
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        local cam = workspace.CurrentCamera
        if flying then
            for _,v in pairs(root:GetChildren()) do if v:IsA("Sound") then v.Volume = 0 end end
            local bv = Instance.new("BodyVelocity", root) bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local bg = Instance.new("BodyGyro", root) bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) bg.P = 15000
            task.spawn(function()
                while flying do task.wait()
                    local speed = tonumber(FlySpeedInput.Text) or 50
                    if hum.MoveDirection.Magnitude > 0 then
                        bv.Velocity = hum.MoveDirection * speed + Vector3.new(0, cam.CFrame.LookVector.Y * speed * hum.MoveDirection.Magnitude, 0)
                    else bv.Velocity = Vector3.new(0, 0, 0) end
                    bg.CFrame = cam.CFrame hum.PlatformStand = true
                end
                bv:Destroy() bg:Destroy() hum.PlatformStand = false
                for _,v in pairs(root:GetChildren()) do if v:IsA("Sound") then v.Volume = 0.5 end end
            end)
        end
    end)

    SpeedInput.FocusLost:Connect(function() if lp.Character then lp.Character.Humanoid.WalkSpeed = tonumber(SpeedInput.Text) or 16 end end)
    JumpInput.FocusLost:Connect(function() if lp.Character then lp.Character.Humanoid.JumpPower = tonumber(JumpInput.Text) or 50 lp.Character.Humanoid.UseJumpPower = true end end)
    ResetBtn.MouseButton1Click:Connect(function()
        if lp.Character then lp.Character.Humanoid.WalkSpeed = 16 lp.Character.Humanoid.JumpPower = 50 end
        flying, noclip = false, false
        SetState(FlyBtn, false, "", "ACTIVATE FLY") SetState(NoclipBtn, false, "", "ACTIVATE NOCLIP")
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end)
end

-- ===================================
-- Main Zoins Hub Logic (Ramadan Theme)
-- ===================================
local MapIDs = {
    ["Escape Tsunami For Brainrots!"] = 18451336104,
    ["MM2"] = 142823291,
    ["BROOKHAVEN"] = 4924922222,
    ["Steal a Brainrot"] = 109983668079237,
    ["Blox Fruits"] = 2753915549,
    ["فعاليات الرسم للعرب"] = 17453916834, 
    ["99 Nights"] = 17653775463,
    ["RIVALS"] = 17625359962
}

local MyMaps = {
    {
        English = "All Maps كل مابات", 
        Arabic = "كل المابات", 
        Keywords = "all maps universal speed fly noclip jump hack كل مابات aimbot ايم بوت", 
        Scripts = {
            {Name = "Script 1", CustomAction = LoadGoldEdition},
            {Name = "Script 2", Link = "https://rawscripts.net/raw/Universal-Script-VR7-45290"},
            {Name = "Smart aiming / ايم بوت", Link = "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile"},
            {Name = "Smart aiming 2 / ايم بوت 2", Link = "https://raw.githubusercontent.com/Joshingtonn123/JoshScript/refs/heads/main/SyrexhubSniperOrDie"}
        }
    },
    {English = "RIVALS", Arabic = "رايفلز", Keywords = "rivals رايفلز ريفلز منافسين", Scripts = {{Name = "Smart aiming / ايم بوت", Link = "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile"}}},
    {English = "99 Nights", Arabic = "99 ليلة", Keywords = "99 nights ليله ليلة forest", Scripts = {{Link = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua"}}},
    {English = "Steal a Brainrot", Arabic = "ماب سرقة", Keywords = "سرقة سرقه brainrot", Scripts = {{Link = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"}}},
    {English = "Escape Tsunami For Brainrots!", Arabic = "هروب من التسونامي", Keywords = "تسونامي تسوناني هروب من التسونامي brainrots برين روت", Scripts = {{Link = "https://raw.githubusercontent.com/gumanba/Scripts/main/EscapeTsunamiForBrainrots"}}},
    {English = "MM2", Arabic = "جريمة قتل غامضة", Keywords = "mm2 مم مم2 م م 2 ممردر", Scripts = {{Link = "https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/source/yarhm/1.19/yarhm.lua"}}},
    {
        English = "BROOKHAVEN", 
        Arabic = "بروخافن", 
        Keywords = "بروخافن بيوت ماب البيوت ماب بيوت", 
        Scripts = {
            {Name = "Script 1", Link = "https://rawscripts.net/raw/Universal-Script-Rael-Hub-27610"}, 
            {Name = "Script 2", Link = "https://rawscripts.net/raw/Brookhaven-RP-Rael-Hub-58126"}
        }
    },
    {English = "Blox Fruits", Arabic = "بلوكس فروتس", Keywords = "بلوكس", Scripts = {{Link = "https://rawscripts.net/raw/Universal-Script-Working-redz-hub-80278"}}},
    {English = "فعاليات الرسم للعرب", Arabic = "فعاليات الرسم للعرب", Keywords = "رسم", Scripts = {{Link = "https://rawscripts.net/raw/Universal-Script-HD-copying-LOSKY-59113"}}}
}

-- ==========================================================
-- [[ ميزة الذاكرة الذكية المحدثة ]] --
-- ==========================================================
local FileName = "ZoinsLastMap.txt"

local function SaveLastMap(mapName)
    if writefile then pcall(function() writefile(FileName, mapName) end) end
end

local function GetSavedMap()
    if isfile and isfile(FileName) then return readfile(FileName) end
    return nil
end

local SortedMaps = {}
local CurrentPlaceId = game.PlaceId
local SavedMapName = GetSavedMap()
local ActiveMapData = nil

local function FindCurrentMapData()
    if game.GameId == 444163659 then
        for _, data in ipairs(MyMaps) do if data.English == "Blox Fruits" then return data end end
    end
    for _, data in ipairs(MyMaps) do
        if MapIDs[data.English] == CurrentPlaceId then return data end
    end
    if CurrentPlaceId == 17625359962 or CurrentPlaceId == 6035872082 then
        for _, data in ipairs(MyMaps) do if data.English == "RIVALS" then return data end end
    end
    local MarketplaceService = game:GetService("MarketplaceService")
    local success, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if success and info then
        local gameName = info.Name:lower()
        if gameName:find("tsunami") or gameName:find("تسونامي") or gameName:find("brainrots") then
            for _, data in ipairs(MyMaps) do if data.English == "Escape Tsunami For Brainrots!" then return data end end
        elseif gameName:find("steal a brainrot") or gameName:find("سرقة") then
            for _, data in ipairs(MyMaps) do if data.English == "Steal a Brainrot" then return data end end
        elseif gameName:find("99 nights") or gameName:find("99 ليله") then
             for _, data in ipairs(MyMaps) do if data.English == "99 Nights" then return data end end
        elseif gameName:find("rivals") or gameName:find("رايفلز") then
             for _, data in ipairs(MyMaps) do if data.English == "RIVALS" then return data end end
        elseif gameName:find("blox fruits") then
             for _, data in ipairs(MyMaps) do if data.English == "Blox Fruits" then return data end end
        elseif gameName:find("فعاليات الرسم") then
             for _, data in ipairs(MyMaps) do if data.English == "فعاليات الرسم للعرب" then return data end end
        end
    end
    return nil
end

ActiveMapData = FindCurrentMapData()
local allMaps = MyMaps[1]

if ActiveMapData then
    table.insert(SortedMaps, ActiveMapData)
    SaveLastMap(ActiveMapData.English)
    if ActiveMapData.English ~= allMaps.English then table.insert(SortedMaps, allMaps) end
else
    table.insert(SortedMaps, allMaps)
    if SavedMapName and SavedMapName ~= allMaps.English then
        for _, data in ipairs(MyMaps) do if data.English == SavedMapName then table.insert(SortedMaps, data) break end end
    end
end

for _, data in ipairs(MyMaps) do
    local alreadyAdded = false
    for _, added in ipairs(SortedMaps) do if added.English == data.English then alreadyAdded = true break end end
    if not alreadyAdded then table.insert(SortedMaps, data) end
end

-- ==========================================================

local sgui = Instance.new("ScreenGui", game:GetService("CoreGui"))
sgui.DisplayOrder = 10 

local MainFrame = Instance.new("Frame", sgui)
if IsPC then MainFrame.Size = UDim2.new(0, 380, 0, 490); MainFrame.Position = UDim2.new(0.5, -190, 0.5, -245)
elseif IsMobile then MainFrame.Size = UDim2.new(0, 320, 0, 490); MainFrame.Position = UDim2.new(0.5, -160, 0.5, -245)
else MainFrame.Size = UDim2.new(0, 350, 0, 490); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -245) end
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 20, 15); MainFrame.BorderSizePixel = 0; MainFrame.Active = true; Instance.new("UICorner", MainFrame)
MakeDraggable(MainFrame)

local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Thickness = 3
FrameStroke.Color = Color3.fromRGB(218, 165, 32)

local SubFrame = Instance.new("Frame", MainFrame)
SubFrame.Size = UDim2.new(1, 0, 1, 0); SubFrame.BackgroundColor3 = Color3.fromRGB(10, 30, 20); SubFrame.Visible = false; SubFrame.ZIndex = 20; Instance.new("UICorner", SubFrame)

local SubTitle = Instance.new("TextLabel", SubFrame)
SubTitle.Size = UDim2.new(1, 0, 0, 60); SubTitle.BackgroundTransparency = 1; SubTitle.Font = Enum.Font.GothamBlack; SubTitle.TextSize = 22; SubTitle.TextColor3 = Color3.new(1, 1, 1); SubTitle.ZIndex = 21

local SubScroll = Instance.new("ScrollingFrame", SubFrame)
SubScroll.Size = UDim2.new(1, -20, 1, -100); SubScroll.Position = UDim2.new(0, 10, 0, 70); SubScroll.BackgroundTransparency = 1; SubScroll.ZIndex = 21; SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; SubScroll.CanvasSize = UDim2.new(0,0,0,20)
local subLayout = Instance.new("UIListLayout", SubScroll); subLayout.Padding = UDim.new(0, 10); subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local BackArrow = Instance.new("TextButton", SubFrame)
BackArrow.Size = UDim2.new(0, 40, 0, 40); BackArrow.Position = UDim2.new(0, 5, 0, 5); BackArrow.Text = "←"; BackArrow.TextColor3 = Color3.new(1, 1, 1); BackArrow.TextSize = 30; BackArrow.BackgroundTransparency = 1; BackArrow.ZIndex = 22
BackArrow.MouseButton1Click:Connect(function() SubFrame.Visible = false end)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 55); TitleLabel.Text = "🌙 Zoins Hub ✨"; TitleLabel.TextColor3 = Color3.new(1, 1, 1); TitleLabel.Font = Enum.Font.GothamBlack; TitleLabel.TextSize = 28; TitleLabel.BackgroundTransparency = 1
local titleGrad = Instance.new("UIGradient", TitleLabel); titleGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(218, 165, 32)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 250, 240)), ColorSequenceKeypoint.new(1, Color3.fromRGB(218, 165, 32))})

local SearchBar = Instance.new("TextBox", MainFrame)
SearchBar.Size = UDim2.new(1, -40, 0, 40); SearchBar.Position = UDim2.new(0, 20, 0, 75); 
SearchBar.PlaceholderText = "🌙 English/عربي"
SearchBar.Text = "" 
SearchBar.BackgroundColor3 = Color3.fromRGB(20, 45, 35); SearchBar.TextColor3 = Color3.new(1, 1, 1); SearchBar.Font = Enum.Font.GothamBold; SearchBar.TextSize = 16; Instance.new("UICorner", SearchBar)
Instance.new("UIStroke", SearchBar).Color = Color3.fromRGB(218, 165, 32)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -160); Scroll.Position = UDim2.new(0, 10, 0, 145); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; Scroll.CanvasSize = UDim2.new(0,0,0,60)
local layout = Instance.new("UIListLayout", Scroll); layout.Padding = UDim.new(0, 10)
local UIPadding = Instance.new("UIPadding", Scroll); UIPadding.PaddingTop = UDim.new(0, 8)

local OpenBtn = Instance.new("TextButton", sgui)
OpenBtn.Name = "ZoinsFloatingBtn"
OpenBtn.Size = IsMobile and UDim2.new(0, 100, 0, 100) or UDim2.new(0, 90, 0, 90)
OpenBtn.Position = UDim2.new(0.9, -85, 0.5, -45)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 35, 25)
OpenBtn.Text = "" 
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local OpenLabel = Instance.new("TextLabel", OpenBtn)
OpenLabel.Size = UDim2.new(1, 0, 1, 0)
OpenLabel.BackgroundTransparency = 1
OpenLabel.Text = "🌙 Zoins ✨️"
OpenLabel.TextColor3 = Color3.new(1, 1, 1)
OpenLabel.Font = Enum.Font.FredokaOne
OpenLabel.TextSize = 20
OpenLabel.TextWrapped = true

local wasBtnDragged = MakeDraggable(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() if not wasBtnDragged() then MainFrame.Visible = true; OpenBtn.Visible = false end end)

local btnStroke = Instance.new("UIStroke", OpenBtn); btnStroke.Thickness = 3; 
local strokeGrad = Instance.new("UIGradient", btnStroke); strokeGrad.Color = titleGrad.Color; 
local btnTextGrad = Instance.new("UIGradient", OpenLabel); btnTextGrad.Color = titleGrad.Color

task.spawn(function()
    while true do
        TweenService:Create(titleGrad, TweenInfo.new(2), {Offset = Vector2.new(1, 0)}):Play()
        TweenService:Create(btnTextGrad, TweenInfo.new(2), {Offset = Vector2.new(1, 0)}):Play()
        TweenService:Create(strokeGrad, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 360}):Play()
        task.wait(2); titleGrad.Offset = Vector2.new(-1, 0); btnTextGrad.Offset = Vector2.new(-1, 0); strokeGrad.Rotation = 0
    end
end)

local function CleanText(str) if not str then return "" end str = str:lower():gsub("ة", "ه"):gsub("ى", "ي") return str end

function AddMap(data)
    local f = Instance.new("Frame", Scroll); f.Size = UDim2.new(1, -10, 0, 65); f.BackgroundColor3 = Color3.fromRGB(15, 35, 25); Instance.new("UICorner", f)
    local smartTags = CleanText(data.English .. " " .. (data.Arabic or "") .. " " .. (data.Keywords or ""))
    
    local displayName = "✨ " .. data.English
    if data.English == "فعاليات الرسم للعرب" then
        displayName = "فعاليات الرسم للعرب ✨"
    end
    
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, -100, 1, 0); t.Position = UDim2.new(0, 15, 0, 0); t.Text = displayName; t.TextColor3 = Color3.new(1, 1, 1); t.BackgroundTransparency = 1; t.Font = Enum.Font.GothamBold; t.TextSize = 16
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 80, 0, 35)
    btn.Position = UDim2.new(1, -90, 0.5, -17)
    btn.Text = "Start"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(10, 60, 30)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = Color3.fromRGB(218, 165, 32)
    bStroke.Thickness = 1.5

    task.spawn(function()
        while true do
            TweenService:Create(bStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(255, 215, 0)}):Play()
            TweenService:Create(btn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(40, 90, 50)}):Play()
            task.wait(1.5)
            TweenService:Create(bStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(180, 140, 10)}):Play()
            TweenService:Create(btn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(10, 60, 30)}):Play()
            task.wait(1.5)
        end
    end)

    if ActiveMapData and data.English == ActiveMapData.English then
        f.BackgroundColor3 = Color3.fromRGB(20, 50, 40)
        local s = Instance.new("UIStroke", f); s.Color = Color3.fromRGB(255, 215, 0); s.Thickness = 1.5
    end

    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(SubScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        SubTitle.Text = "🌙 " .. data.English
        for _, scr in ipairs(data.Scripts) do
            local sf = Instance.new("Frame", SubScroll); sf.Size = UDim2.new(1, -10, 0, 65); sf.BackgroundColor3 = Color3.fromRGB(15, 35, 25); sf.ZIndex = 21; Instance.new("UICorner", sf)
            local st = Instance.new("TextLabel", sf); st.Size = UDim2.new(1, -100, 1, 0); st.Position = UDim2.new(0, 15, 0, 0); st.Text = "✨ " .. (scr.Name or data.English); st.TextColor3 = Color3.new(1, 1, 1); st.BackgroundTransparency = 1; st.Font = Enum.Font.GothamBold; st.TextSize = 16; st.ZIndex = 22
            local sbtn = Instance.new("TextButton", sf); sbtn.Size = UDim2.new(0, 80, 0, 35); sbtn.Position = UDim2.new(1, -90, 0.5, -17); sbtn.Text = "Start"; sbtn.Font = Enum.Font.GothamBold; sbtn.ZIndex = 22; Instance.new("UICorner", sbtn)
            sbtn.BackgroundColor3 = Color3.fromRGB(10, 60, 30); sbtn.TextColor3 = Color3.new(1,1,1)
            local ss = Instance.new("UIStroke", sbtn); ss.Color = Color3.fromRGB(218, 165, 32); ss.Thickness = 1.2
            
            sbtn.MouseButton1Click:Connect(function()
                ShowNotification("جاري التشغيل... / Loading...")
                local oldClipboard = setclipboard
                if oldClipboard then setclipboard = function() end end
                if scr.CustomAction then scr.CustomAction()
                else task.spawn(function()
                    local success, code = pcall(game.HttpGet, game, scr.Link, true)
                    if success then loadstring(code)() else warn("Zoins Hub | Error") end
                end) end
                task.delay(5, function() setclipboard = oldClipboard end)
                sbtn.Text = "Done ✓"; sbtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
                task.delay(2, function() sbtn.Text = "Start"; sbtn.BackgroundColor3 = Color3.fromRGB(10, 60, 30) end)
            end)
        end
        SubFrame.Visible = true
    end)
    return {frame = f, smartTags = smartTags}
end

local MapFrames = {}
for _, data in ipairs(SortedMaps) do table.insert(MapFrames, AddMap(data)) end

local ComingSoon = Instance.new("TextLabel", Scroll)
ComingSoon.Size = UDim2.new(1, 0, 0, 50); 
ComingSoon.Text = "✨️ قريبا/Coming soon 🌙"; 
ComingSoon.TextColor3 = Color3.fromRGB(218, 165, 32); 
ComingSoon.Font = Enum.Font.GothamBold; 
ComingSoon.TextSize = 14; 
ComingSoon.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 28, 0, 28); CloseBtn.Position = UDim2.new(1, -35, 0, 12); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.ZIndex = 50
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true; SubFrame.Visible = false end)

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local input = CleanText(SearchBar.Text)
    ComingSoon.Visible = (input == "")
    for _, item in ipairs(MapFrames) do item.frame.Visible = (input == "" or item.smartTags:find(input, 1, true)) end
end)

ShowNotification("رمضان مبارك / Ramadan Mubarak")

end)
