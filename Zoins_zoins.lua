-- Zoins Hub - Pure Neon Edition (Integrated Anti-Fling)
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("ZoinsHub_NeonPure") then CoreGui.ZoinsHub_NeonPure:Destroy() end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ZoinsHub_NeonPure"

_G.UltraProtectRunning = false
local hooksApplied = false

--// الواجهة الرئيسية
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

local mainStroke = Instance.new("UIStroke", frame)
mainStroke.Thickness = 2.5
mainStroke.Color = Color3.fromRGB(80, 0, 255)
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "Zoins"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24

local copyBtn = Instance.new("TextButton", frame)
copyBtn.Size = UDim2.new(0.85, 0, 0, 40)
copyBtn.Position = UDim2.new(0.075, 0, 0.32, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
copyBtn.Text = "نسخ"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 18
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 10)
local cStroke = Instance.new("UIStroke", copyBtn)
cStroke.Color = Color3.fromRGB(0, 150, 255)
cStroke.Thickness = 1.5

local protectBtn = Instance.new("TextButton", frame)
protectBtn.Size = UDim2.new(0.85, 0, 0, 40)
protectBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
protectBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
protectBtn.Text = "حماية"
protectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
protectBtn.Font = Enum.Font.GothamBold
protectBtn.TextSize = 18
Instance.new("UICorner", protectBtn).CornerRadius = UDim.new(0, 10)
local pStroke = Instance.new("UIStroke", protectBtn)
pStroke.Color = Color3.fromRGB(255, 50, 50)
pStroke.Thickness = 1.5

local openCircle = Instance.new("TextButton", gui)
openCircle.Size = UDim2.new(0, 55, 0, 55)
openCircle.Position = UDim2.new(1, -70, 0.5, -27)
openCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
openCircle.Text = "Z"
openCircle.TextColor3 = Color3.fromRGB(255, 255, 255)
openCircle.Font = Enum.Font.GothamBold
openCircle.TextSize = 28
openCircle.Visible = false
openCircle.Draggable = true
Instance.new("UICorner", openCircle).CornerRadius = UDim.new(1, 0)
local circStroke = Instance.new("UIStroke", openCircle)
circStroke.Color = Color3.fromRGB(80, 0, 255)
circStroke.Thickness = 2.5

-- تأثير النيون
task.spawn(function()
    while true do
        local info = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local color1 = Color3.fromRGB(0, 150, 255)
        local color2 = Color3.fromRGB(150, 0, 255)
        local t1 = TweenService:Create(mainStroke, info, {Color = color1})
        local t2 = TweenService:Create(circStroke, info, {Color = color1})
        t1:Play() t2:Play()
        task.wait(2)
        local t3 = TweenService:Create(mainStroke, info, {Color = color2})
        local t4 = TweenService:Create(circStroke, info, {Color = color2})
        t3:Play() t4:Play()
        task.wait(2)
    end
end)

--- Logic & Anti-Fling Integration ---

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

-- إعدادات Anti-Fling
local lastSafePosition = CFrame.new()
local maxVelocity = 150

RunService.Heartbeat:Connect(function()
    if _G.UltraProtectRunning then
        local lp = Players.LocalPlayer
        if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            if root.Velocity.Magnitude > maxVelocity then
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
        protectBtn.Text = "حماية"
        pStroke.Color = Color3.fromRGB(255, 50, 50)
    else
        _G.UltraProtectRunning = true
        applyHooks()
        protectBtn.Text = "حماية (مفعل)"
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

copyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-HD-copying-LOSKY-59113"))()
end)

protectBtn.MouseButton1Click:Connect(toggleProtect)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openCircle.Visible = true
end)

openCircle.MouseButton1Click:Connect(function()
    frame.Visible = true
    openCircle.Visible = false
end)
