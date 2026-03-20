-- Zoins V5 - Gold Edition (Anti-Glitch Noclip Fix)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local UIStroke_Main = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local UIGradient_Title = Instance.new("UIGradient")
local ContentFrame = Instance.new("ScrollingFrame")
local CloseBtn = Instance.new("TextButton")

local MiniBtn = Instance.new("TextButton")
local MiniCorner = Instance.new("UICorner")
local MiniStroke = Instance.new("UIStroke")
local MiniGradient = Instance.new("UIGradient")
local MiniLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Zoins_V5_Updated"

-----------------------------------------------------------
-- تصميم الواجهة (نفس الشكل الفخم)
-----------------------------------------------------------
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, -200) 
MainFrame.Size = UDim2.new(0, 280, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

UICorner_Main.CornerRadius = UDim.new(0, 20)
UICorner_Main.Parent = MainFrame

UIStroke_Main.Thickness = 2.5
UIStroke_Main.Parent = MainFrame
UIStroke_Main.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_Main.Color = Color3.fromRGB(255, 255, 255)

local StrokeGradient = Instance.new("UIGradient", UIStroke_Main)
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(58, 123, 213))
}

task.spawn(function()
    while true do
        StrokeGradient.Rotation = StrokeGradient.Rotation + 1
        MiniGradient.Rotation = MiniGradient.Rotation + 1
        task.wait(0.02)
    end
end)

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.FredokaOne

Title.Name = "Title"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 70)
Title.Text = "ZOINS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 40
Title.BackgroundTransparency = 1

UIGradient_Title.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
}
UIGradient_Title.Parent = Title

ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, 0, 1, -80)
ContentFrame.Position = UDim2.new(0, 0, 0, 75)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 0

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 12)

-----------------------------------------------------------
-- الدائرة (اليمين + منع الفتح عند السحب)
-----------------------------------------------------------
MiniBtn.Name = "MiniBtn"
MiniBtn.Parent = ScreenGui
MiniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MiniBtn.Position = UDim2.new(0.9, 0, 0.5, -30) 
MiniBtn.Size = UDim2.new(0, 60, 0, 60)
MiniBtn.Visible = false
MiniBtn.Active = true
MiniBtn.Draggable = true

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
MiniLabel.Text = "Z"
MiniLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
MiniLabel.Font = Enum.Font.FredokaOne
MiniLabel.TextSize = 35
MiniLabel.BackgroundTransparency = 1

local dragging = false
MiniBtn.MouseButton1Down:Connect(function() dragging = false end)
MiniBtn.Changed:Connect(function(prop) if prop == "Position" then dragging = true end end)
MiniBtn.MouseButton1Up:Connect(function()
    if not dragging then
        MainFrame.Visible = true
        MiniBtn.Visible = false
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBtn.Visible = true
end)

-----------------------------------------------------------
-- البرمجة (مع نظام منع الرجة عند إطفاء Noclip)
-----------------------------------------------------------
local function CreateElement(class, text)
    local obj = Instance.new(class)
    obj.Size = UDim2.new(0.88, 0, 0, 42)
    obj.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    obj.TextColor3 = Color3.fromRGB(255, 255, 255)
    obj.Font = Enum.Font.SourceSansSemibold
    obj.TextSize = 15
    obj.BorderSizePixel = 0
    if class == "TextBox" then obj.PlaceholderText = text obj.Text = "" else obj.Text = text end
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 12)
    local s = Instance.new("UIStroke", obj) s.Thickness = 1 s.Color = Color3.fromRGB(45, 45, 50)
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
    btn.UIStroke.Color = state and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(255, 50, 50)
    btn.BackgroundColor3 = state and Color3.fromRGB(15, 40, 30) or Color3.fromRGB(25, 25, 30)
end

-- اختراق الجدران (النسخة المضادة للرجة)
NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    SetState(NoclipBtn, noclip, "NOCLIP: ACTIVE", "ACTIVATE NOCLIP")
    
    if noclip then
        noclipConn = game:GetService("RunService").Stepped:Connect(function()
            if noclip and lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        -- الحل هنا: نفصل الاتصال لكن لا نجبر الأجزاء على التصادم فوراً
        -- اللعبة ستقوم بإعادتها تلقائياً بشكل أنعم عند الحركة
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        
        -- نعيد التصادم فقط للـ HumanoidRootPart لمنع السقوط
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CanCollide = true
        end
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
