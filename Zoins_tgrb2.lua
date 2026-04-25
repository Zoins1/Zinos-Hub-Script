-- Zoins Ultra Protect (Hooks Only - No Character Interference)
local Players = game:GetService("Players")

local player = Players.LocalPlayer
_G.UltraProtectRunning = false
local hooksApplied = false

-- UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ZoinsHub_PureProtect"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0.5, -150, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local mainStroke = Instance.new("UIStroke", frame)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 255, 170)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Hacker Protection (No Body Logic)"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 170)
title.Font = Enum.Font.GothamBold
title.TextSize = 15

-- Protect Button
local protectBtn = Instance.new("TextButton", frame)
protectBtn.Size = UDim2.new(0.9, 0, 0, 45)
protectBtn.Position = UDim2.new(0.05, 0, 0, 50)
protectBtn.Text = "تفعيل الحماية البرمجية"
protectBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
protectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
protectBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", protectBtn)

local pStroke = Instance.new("UIStroke", protectBtn)
pStroke.Color = Color3.fromRGB(255, 50, 50)
pStroke.Thickness = 1.5

-- Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
Instance.new("UICorner", close)

-- Open Circle (Z)
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
-- Logic Section (Software Hooks Only)
---------------------------------------

local function applyHooks()
    if hooksApplied then return end
    hooksApplied = true
    
    -- كلمات دلالية للسكربتات التي سيتم تعطيل وظائفها
    local blocked = {"logs", "clogs", "re", "nv", "uncmdbar2", "mute", "res", "kill", "fling", "fly", "giant", "size"}
    
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and islclosure(f) and not isexecutorclosure(f) then
            local env = getfenv(f)
            if env and env.script then
                local name = tostring(env.script):lower()
                for _, word in pairs(blocked) do
                    if name:find(word) then
                        local old; old = hookfunction(f, function(...)
                            if _G.UltraProtectRunning then 
                                return nil -- تعطيل الوظيفة تماماً عند تفعيل الحماية
                            end
                            return old(...)
                        end)
                        break
                    end
                end
            end
        end
    end
end

local function toggleProtect()
    if _G.UltraProtectRunning then
        _G.UltraProtectRunning = false
        protectBtn.Text = "تفعيل الحماية البرمجية"
        pStroke.Color = Color3.fromRGB(255, 50, 50)
    else
        _G.UltraProtectRunning = true
        applyHooks()
        protectBtn.Text = "الحماية تعمل (Hooks Only) ✅"
        pStroke.Color = Color3.fromRGB(0, 255, 100)
    end
end

-- Events
protectBtn.MouseButton1Click:Connect(toggleProtect)
close.MouseButton1Click:Connect(function() frame.Visible = false circle.Visible = true end)
circle.MouseButton1Click:Connect(function() frame.Visible = true circle.Visible = false end)
