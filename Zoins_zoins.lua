-- Zoins Hub - Final Mega Edition (Fixed UI & Status)
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- إزالة النسخ السابقة
if CoreGui:FindFirstChild("ZoinsHub_Final") then CoreGui.ZoinsHub_Final:Destroy() end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ZoinsHub_Final"

-- متغيرات التحكم
_G.DefenseActive = false
_G.AlertsActive = false
_G.FlingActive = false
local hooksApplied = false
local spamActive = false

---------------------------------------
-- وظائف المساعدة (UI Helpers)
---------------------------------------
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner", parent)
    corner.CornerRadius = UDim.new(0, radius or 10)
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = color
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

---------------------------------------
-- الدائرة العائمة (Z)
---------------------------------------
local openCircle = Instance.new("TextButton", gui)
openCircle.Size = UDim2.new(0, 55, 0, 55)
openCircle.Position = UDim2.new(1, -70, 0.5, -27)
openCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
openCircle.Text = "Z"
openCircle.TextColor3 = Color3.fromRGB(255, 255, 255)
openCircle.Visible = false
openCircle.Draggable = true
openCircle.Font = Enum.Font.GothamBold
openCircle.TextSize = 28
createCorner(openCircle, 30)
local circStroke = createStroke(openCircle, Color3.fromRGB(80, 0, 255), 2.5)

---------------------------------------
-- واجهة السبام (Spam UI)
---------------------------------------
local spamFrame = Instance.new("Frame", gui)
spamFrame.Size = UDim2.new(0, 300, 0, 200)
spamFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
spamFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
spamFrame.Visible = false
spamFrame.Active = true
spamFrame.Draggable = true
createCorner(spamFrame, 15)
local sStroke = createStroke(spamFrame, Color3.fromRGB(0, 255, 170), 2.5)

local sTitle = Instance.new("TextLabel", spamFrame)
sTitle.Size = UDim2.new(1, 0, 0, 35)
sTitle.Text = "Zoins Smart Spam V5"
sTitle.TextColor3 = Color3.fromRGB(0, 255, 170)
sTitle.BackgroundTransparency = 1
sTitle.Font = Enum.Font.GothamBold

local box = Instance.new("TextBox", spamFrame)
box.Size = UDim2.new(1, -20, 0, 70)
box.Position = UDim2.new(0, 10, 0, 40)
box.PlaceholderText = ";logs hb\n;nv hb"
box.Text = ""
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
box.MultiLine = true
box.ClearTextOnFocus = false
createCorner(box, 8)

local startBtn = Instance.new("TextButton", spamFrame)
startBtn.Size = UDim2.new(0.45, 0, 0, 35)
startBtn.Position = UDim2.new(0.04, 0, 0, 120)
startBtn.Text = "Start"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createCorner(startBtn, 8)

local stopBtn = Instance.new("TextButton", spamFrame)
stopBtn.Size = UDim2.new(0.45, 0, 0, 35)
stopBtn.Position = UDim2.new(0.51, 0, 0, 120)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createCorner(stopBtn, 8)

-- شريط الحالة (Status) المطلوب
local statusLbl = Instance.new("TextLabel", spamFrame)
statusLbl.Size = UDim2.new(1, 0, 0, 20)
statusLbl.Position = UDim2.new(0, 0, 1, -25)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Idle"
statusLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLbl.Font = Enum.Font.Gotham

local sClose = Instance.new("TextButton", spamFrame)
sClose.Size = UDim2.new(0, 25, 0, 25)
sClose.Position = UDim2.new(1, -30, 0, 5)
sClose.Text = "X"
sClose.TextColor3 = Color3.fromRGB(255, 80, 80)
sClose.BackgroundTransparency = 1
sClose.TextSize = 20

---------------------------------------
-- واجهة الحماية (Protection UI)
---------------------------------------
local protectFrame = Instance.new("Frame", gui)
protectFrame.Size = UDim2.new(0, 230, 0, 220)
protectFrame.Position = UDim2.new(0.5, -115, 0.4, 0)
protectFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
protectFrame.Visible = false
protectFrame.Active = true
protectFrame.Draggable = true
createCorner(protectFrame, 15)
local pMainStroke = createStroke(protectFrame, Color3.fromRGB(80, 0, 255), 2.5)

local pTitle = Instance.new("TextLabel", protectFrame)
pTitle.Size = UDim2.new(1, 0, 0, 40)
pTitle.Text = "Security Center"
pTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
pTitle.BackgroundTransparency = 1
pTitle.Font = Enum.Font.GothamBold

local function createToggle(name, pos, callback, fontSize)
    local btn = Instance.new("TextButton", protectFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = fontSize or 14
    btn.Font = Enum.Font.GothamBold
    createCorner(btn, 10)
    local st = createStroke(btn, Color3.fromRGB(255, 50, 50), 1.5)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        st.Color = active and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        callback(active)
    end)
    return btn
end

---------------------------------------
-- الواجهة الرئيسية (Main Hub)
---------------------------------------
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.Active = true
mainFrame.Draggable = true
createCorner(mainFrame, 15)
local mStroke = createStroke(mainFrame, Color3.fromRGB(80, 0, 255), 2.5)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "Zoins"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.85, 0, 0, 40)
copyBtn.Position = UDim2.new(0.075, 0, 0.32, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
copyBtn.Text = "نسخ (Spam)"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createCorner(copyBtn, 10)
createStroke(copyBtn, Color3.fromRGB(0, 150, 255), 1.5)

local openProtectBtn = Instance.new("TextButton", mainFrame)
openProtectBtn.Size = UDim2.new(0.85, 0, 0, 40)
openProtectBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
openProtectBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
openProtectBtn.Text = "حماية"
openProtectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createCorner(openProtectBtn, 10)
createStroke(openProtectBtn, Color3.fromRGB(255, 50, 50), 1.5)

local mClose = Instance.new("TextButton", mainFrame)
mClose.Size = UDim2.new(0, 30, 0, 30)
mClose.Position = UDim2.new(1, -35, 0, 5)
mClose.Text = "×"
mClose.TextColor3 = Color3.fromRGB(255, 50, 50)
mClose.BackgroundTransparency = 1
mClose.TextSize = 24

---------------------------------------
-- منطق الحماية (Defense Logic)
---------------------------------------
local function applyHooks()
    if hooksApplied then return end
    hooksApplied = true
    local blocked = {"logs", "clogs", "re", "nv", "uncmdbar2", "mute", "res", "kill", "fling", "fly", "giant", "size"}
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and islclosure(f) and not isexecutorclosure(f) then
            local env = getfenv(f)
            if env and env.script then
                local name = tostring(env.script):lower()
                for _, word in pairs(blocked) do
                    if name:find(word) then
                        local old; old = hookfunction(f, function(...)
                            if _G.DefenseActive then return nil end
                            return old(...)
                        end)
                        break
                    end
                end
            end
        end
    end
end

createToggle("Defense/حماية Clogs logs nv", 45, function(state)
    _G.DefenseActive = state
    if state then 
        applyHooks()
        task.spawn(function()
            while _G.DefenseActive do
                pcall(function()
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum.Sit = false; hum.PlatformStand = false end
                        for _, p in pairs(char:GetChildren()) do
                            if p:IsA("BasePart") and p.Anchored then p.Anchored = false end
                            if p:IsA("BodyMover") or p:IsA("BodyVelocity") or p:IsA("BodyGyro") then p:Destroy() end
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
end, 11)

createToggle("Alerts/تنبيهات SYSTEM", 90, function(state)
    _G.AlertsActive = state
    if state then
        for _, g in pairs(player.PlayerGui:GetChildren()) do
            if g.Name == "HDAdminGui" or g.Name == "MessageGui" then g.Enabled = false end
        end
    else
        for _, g in pairs(player.PlayerGui:GetChildren()) do
            if g.Name == "HDAdminGui" or g.Name == "MessageGui" then g.Enabled = true end
        end
    end
end)

player.PlayerGui.DescendantAdded:Connect(function(desc)
    if _G.AlertsActive then
        if desc.Name == "HDAdminGui" or desc.Name == "MessageGui" then
            desc.Enabled = false
        elseif desc:IsA("TextLabel") and (desc.Text:find("System") or desc.Text:find("too fast")) then
            local container = desc.Parent
            if container and container:IsA("Frame") then container.Visible = false end
        end
    end
end)

local lastSafePos = nil
createToggle("Fling/حماية الطيران", 135, function(state)
    _G.FlingActive = state
end)

RunService.Heartbeat:Connect(function()
    if _G.FlingActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        if hrp.Velocity.Magnitude > 150 then
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.RotVelocity = Vector3.new(0,0,0)
            if lastSafePos then hrp.CFrame = lastSafePos end
        else
            lastSafePos = hrp.CFrame
        end
    end
end)

---------------------------------------
-- منطق السبام (Spam Logic)
---------------------------------------
local function fireSpam(cmd)
    pcall(function()
        ReplicatedStorage.HDAdminHDClient.Signals.CreateLog:FireServer({Message = cmd, Player = player, LogType = "chatLogs"})
    end)
    pcall(function()
        ReplicatedStorage.HDAdminHDClient.Signals.RequestCommandModification:InvokeServer(cmd)
    end)
end

startBtn.MouseButton1Click:Connect(function()
    local cmds = {}
    for c in string.gmatch(box.Text, ";[^;\n]+") do table.insert(cmds, c) end
    if #cmds == 0 then return end
    spamActive = true
    statusLbl.Text = "Spamming..."
    statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100) -- اللون الأخضر عند النسخ
    task.spawn(function()
        while spamActive do
            for i=1,3 do for _,c in pairs(cmds) do if not spamActive then break end task.spawn(function() fireSpam(c) end) end end
            task.wait(1)
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function() 
    spamActive = false 
    statusLbl.Text = "Stopped"
    statusLbl.TextColor3 = Color3.fromRGB(200, 50, 50)
end)

---------------------------------------
-- التحكم في النوافذ (Window Logic)
---------------------------------------
-- زر X في الحماية يغلق الواجهة ويظهر Z
local pClose = Instance.new("TextButton", protectFrame)
pClose.Size = UDim2.new(0, 25, 0, 25)
pClose.Position = UDim2.new(1, -30, 0, 5)
pClose.Text = "×"
pClose.TextColor3 = Color3.fromRGB(255, 50, 50)
pClose.BackgroundTransparency = 1
pClose.TextSize = 20
pClose.MouseButton1Click:Connect(function()
    protectFrame.Visible = false
    openCircle.Visible = true
end)

copyBtn.MouseButton1Click:Connect(function() spamFrame.Visible = true; mainFrame.Visible = false end)
openProtectBtn.MouseButton1Click:Connect(function() protectFrame.Visible = true; mainFrame.Visible = false end)
mClose.MouseButton1Click:Connect(function() mainFrame.Visible = false; openCircle.Visible = true end)
sClose.MouseButton1Click:Connect(function() spamFrame.Visible = false; openCircle.Visible = true end)

-- الضغط على Z يفتح الواجهة الرئيسية دائماً
openCircle.MouseButton1Click:Connect(function() 
    mainFrame.Visible = true
    spamFrame.Visible = false
    protectFrame.Visible = false
    openCircle.Visible = false 
end)

-- تأثير نبض النيون
task.spawn(function()
    while true do
        local info = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local c1, c2 = Color3.fromRGB(0, 150, 255), Color3.fromRGB(150, 0, 255)
        TweenService:Create(mStroke, info, {Color = c1}):Play()
        TweenService:Create(circStroke, info, {Color = c1}):Play()
        TweenService:Create(pMainStroke, info, {Color = c1}):Play()
        task.wait(2)
        TweenService:Create(mStroke, info, {Color = c2}):Play()
        TweenService:Create(circStroke, info, {Color = c2}):Play()
        TweenService:Create(pMainStroke, info, {Color = c2}):Play()
        task.wait(2)
    end
end)
