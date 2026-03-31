-- Zoins Smart Spam V5 (Integrated Ultra Protect & Anti Disconnect)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
_G.UltraProtectRunning = false
local hooksApplied = false

---------------------------------------
-- Section: Anti Disconnect & Lag Fix (Auto-Run)
---------------------------------------
-- تقليل اللاغ
settings().Rendering.QualityLevel = "Level01"

-- تعطيل المؤثرات الثقيلة
task.spawn(function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            end
        end
    end)
end)

-- نشاط الشبكة الوهمي
task.spawn(function()
    while task.wait(1) do
        RunService.Heartbeat:Wait()
    end
end)

-- منع الـ Idle (Anti-AFK)
player.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- تحسين Ping
task.spawn(function()
    while task.wait(2) do
        pcall(function() ReplicatedStorage:GetChildren() end)
    end
end)

---------------------------------------
-- UI Setup
---------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ZoinsHub_Integrated"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 240) 
frame.Position = UDim2.new(0.5, -170, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local mainStroke = Instance.new("UIStroke", frame)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 255, 170)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Zoins Smart Spam V5 + Protection"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 170)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 0, 70)
box.Position = UDim2.new(0, 10, 0, 40)
box.PlaceholderText = ";logs hb\n;nv hb"
box.Text = ""
box.ClearTextOnFocus = false
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
box.MultiLine = true
box.TextWrapped = true 
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", box)

-- Start Button
local start = Instance.new("TextButton", frame)
start.Size = UDim2.new(0.48, -5, 0, 35)
start.Position = UDim2.new(0, 10, 0, 120)
start.Text = "Start"
start.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
start.TextColor3 = Color3.fromRGB(255, 255, 255)
start.Font = Enum.Font.GothamBold
Instance.new("UICorner", start)

-- Stop Button
local stop = Instance.new("TextButton", frame)
stop.Size = UDim2.new(0.48, -5, 0, 35)
stop.Position = UDim2.new(0.52, 0, 0, 120)
stop.Text = "Stop"
stop.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
stop.TextColor3 = Color3.fromRGB(255, 255, 255)
stop.Font = Enum.Font.GothamBold
Instance.new("UICorner", stop)

-- Protect Button
local protectBtn = Instance.new("TextButton", frame)
protectBtn.Size = UDim2.new(0.96, 0, 0, 35)
protectBtn.Position = UDim2.new(0.02, 0, 0, 165)
protectBtn.Text = "تفعيل الحماية"
protectBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
protectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
protectBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", protectBtn)
local pStroke = Instance.new("UIStroke", protectBtn)
pStroke.Color = Color3.fromRGB(255, 50, 50)
pStroke.Thickness = 1.5

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 1, -25)
status.BackgroundTransparency = 1
status.Text = "Idle"
status.TextColor3 = Color3.fromRGB(200, 200, 200)

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
Instance.new("UICorner", close)

local circle = Instance.new("TextButton", gui)
circle.Size = UDim2.new(0, 45, 0, 45)
circle.Position = UDim2.new(1, -60, 0.5, -25)
circle.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
circle.Text = "Z"
circle.Visible = false
circle.TextColor3 = Color3.fromRGB(255, 255, 255)
circle.Font = Enum.Font.GothamBold
circle.Draggable = true
Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

---------------------------------------
-- Logic Section (Anti-Fling & Protection)
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
                            if _G.UltraProtectRunning then return nil end
                            return old(...)
                        end)
                        break
                    end
                end
            end
        end
    end
end

local lastSafePosition = CFrame.new()
RunService.Heartbeat:Connect(function()
    if _G.UltraProtectRunning then
        local lp = Players.LocalPlayer
        if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            if root.Velocity.Magnitude > 150 then
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
                root.CFrame = lastSafePosition
            else
                lastSafePosition = root.CFrame
            end
        end
    end
end)

local function toggleProtect()
    if _G.UltraProtectRunning then
        _G.UltraProtectRunning = false
        protectBtn.Text = "تفعيل الحماية"
        pStroke.Color = Color3.fromRGB(255, 50, 50)
    else
        _G.UltraProtectRunning = true
        applyHooks()
        protectBtn.Text = "الحماية تعمل ✅"
        pStroke.Color = Color3.fromRGB(0, 255, 100)
        
        task.spawn(function()
            while _G.UltraProtectRunning do
                pcall(function()
                    local char = Players.LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum.Sit = false; hum.PlatformStand = false end
                        for _, p in pairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.Anchored = false end
                            if p:IsA("BodyMover") then p:Destroy() end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end

---------------------------------------
-- Spam Logic (Invisible Universal Patch)
---------------------------------------

local spam = false
local function fire(cmd)
    pcall(function()
        ReplicatedStorage.HDAdminHDClient.Signals.CreateLog:FireServer({
            Message = cmd,
            Player = player,
            LogType = "chatLogs"
        })
    end)
    pcall(function()
        ReplicatedStorage.HDAdminHDClient.Signals.RequestCommandModification:InvokeServer(cmd)
    end)
end

local function startSpam(text)
    local commands = {}
    for cmd in string.gmatch(text, "%S+") do
        table.insert(commands, cmd)
    end
    
    if #commands == 0 then return end
    
    spam = true
    status.Text = "Spamming..."
    task.spawn(function()
        while spam do
            for _, cmd in pairs(commands) do
                if not spam then break end
                task.spawn(function() fire(cmd) end)
            end
            task.wait(1)
        end
    end)
end

-- Buttons Events
start.MouseButton1Click:Connect(function() startSpam(box.Text) end)
stop.MouseButton1Click:Connect(function() spam = false status.Text = "Stopped" end)
protectBtn.MouseButton1Click:Connect(toggleProtect)
close.MouseButton1Click:Connect(function() frame.Visible = false circle.Visible = true end)
circle.MouseButton1Click:Connect(function() frame.Visible = true circle.Visible = false end)
