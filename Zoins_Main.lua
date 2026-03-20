-- =================================================================
-- Zoins Hub - Eid Edition (Final Custom Version - Modified Names)
-- =================================================================

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
-- نظام الإشعارات المخصص
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
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 30)
    NotifyFrame.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner", NotifyFrame)
    Corner.CornerRadius = UDim.new(0, 10)
    
    local Stroke = Instance.new("UIStroke", NotifyFrame)
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(255, 215, 0)
    
    local Label = Instance.new("TextLabel", NotifyFrame)
    Label.Size = UDim2.new(1, -10, 1, -10)
    Label.Position = UDim2.new(0, 5, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = "🎉 " .. text
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
-- Main Zoins Hub Logic 
-- ===================================
local MyMaps = {
    {
        English = "🎆All Maps🎉", 
        Arabic = "كل المابات", 
        Keywords = "all maps universal speed fly noclip jump hack كل مابات aimbot ايم بوت", 
        Scripts = {
            {Name = "Script 1", Link = "https://raw.githubusercontent.com/Zoins1/Zinos-Hub-Script/refs/heads/main/Zoins_v5cc.lua"},
            {Name = "Script 2", Link = "https://rawscripts.net/raw/Universal-Script-VR7-45290"},
            {Name = "Smart aiming / ايم بوت", Link = "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile"},
            {Name = "Smart aiming 2 / ايم بوت 2", Link = "https://raw.githubusercontent.com/Joshingtonn123/JoshScript/refs/heads/main/SyrexhubSniperOrDie", Protect = true}
        }
    },
    {English = "🎆RIVALS🎉", Arabic = "رايفلز", Keywords = "rivals رايفلز ريفلز منافسين", Scripts = {{Link = "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile", Protect = true}}},
    {English = "🎆99 Nights🎉", Arabic = "99 ليلة", Keywords = "99 nights ليله ليلة forest", Scripts = {{Link = "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua"}}},
    {English = "🎆Steal a Brainrot🎉", Arabic = "ماب سرقة", Keywords = "سرقة سرقه brainrot", Scripts = {{Link = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"}}},
    {English = "🎆Escape Tsunami For Brainrots🎉", Arabic = "هروب من التسونامي", Keywords = "تسونامي تسوناني هروب من التسونامي brainrots برين روت", Scripts = {{Link = "https://raw.githubusercontent.com/gumanba/Scripts/main/EscapeTsunamiForBrainrots"}}},
    {English = "🎆MM2🎉", Arabic = "جريمة قتل غامضة", Keywords = "mm2 مم مم2 م م 2 ممردر", Scripts = {{Link = "https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/source/yarhm/1.19/yarhm.lua"}}},
    {English = "🎆Brookhaven🎉", Arabic = "بروخافن", Keywords = "بروخافن بيوت ماب البيوت ماب بيوت brookhaven", Scripts = {{Name = "Script 1", Link = "https://rawscripts.net/raw/Universal-Script-Rael-Hub-27610"}, {Name = "Script 2", Link = "https://rawscripts.net/raw/Universal-Script-VR7-45290"}}},
    {English = "🎆Blox Fruits🎉", Arabic = "بلوكس فروتس", Keywords = "بلوكس", Scripts = {{Link = "https://rawscripts.net/raw/Universal-Script-Working-redz-hub-80278"}}},
    {English = "🎉فعاليات الرسم للعرب🎆", Arabic = "🎉فعاليات الرسم للعرب🎆", Keywords = "رسم", Scripts = {{Name = "فعاليات الرسم للعرب🎉", Link = "https://raw.githubusercontent.com/Zoins1/Zinos-Hub-Script/refs/heads/main/Zoins_zoins.lua"}}}
}

-- [واجهة المستخدم]
local sgui = Instance.new("ScreenGui", game:GetService("CoreGui"))
sgui.DisplayOrder = 10 

local MainFrame = Instance.new("Frame", sgui)
if IsPC then MainFrame.Size = UDim2.new(0, 380, 0, 490); MainFrame.Position = UDim2.new(0.5, -190, 0.5, -245)
elseif IsMobile then MainFrame.Size = UDim2.new(0, 320, 0, 490); MainFrame.Position = UDim2.new(0.5, -160, 0.5, -245)
else MainFrame.Size = UDim2.new(0, 350, 0, 490); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -245) end
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 15); MainFrame.BorderSizePixel = 0; MainFrame.Active = true; Instance.new("UICorner", MainFrame)
MakeDraggable(MainFrame)

local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Thickness = 3
FrameStroke.Color = Color3.fromRGB(218, 165, 32)

local SubFrame = Instance.new("Frame", MainFrame)
SubFrame.Size = UDim2.new(1, 0, 1, 0); SubFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 20); SubFrame.Visible = false; SubFrame.ZIndex = 20; Instance.new("UICorner", SubFrame)

local SubTitle = Instance.new("TextLabel", SubFrame)
SubTitle.Size = UDim2.new(1, 0, 0, 60); SubTitle.BackgroundTransparency = 1; SubTitle.Font = Enum.Font.GothamBlack; SubTitle.TextSize = 22; SubTitle.TextColor3 = Color3.new(1, 1, 1); SubTitle.ZIndex = 21

local SubScroll = Instance.new("ScrollingFrame", SubFrame)
SubScroll.Size = UDim2.new(1, -20, 1, -100); SubScroll.Position = UDim2.new(0, 10, 0, 70); SubScroll.BackgroundTransparency = 1; SubScroll.ZIndex = 21; SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; SubScroll.CanvasSize = UDim2.new(0,0,0,20)
local subLayout = Instance.new("UIListLayout", SubScroll); subLayout.Padding = UDim.new(0, 10); subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local BackArrow = Instance.new("TextButton", SubFrame)
BackArrow.Size = UDim2.new(0, 40, 0, 40); BackArrow.Position = UDim2.new(0, 5, 0, 5); BackArrow.Text = "←"; BackArrow.TextColor3 = Color3.new(1, 1, 1); BackArrow.TextSize = 30; BackArrow.BackgroundTransparency = 1; BackArrow.ZIndex = 22
BackArrow.MouseButton1Click:Connect(function() SubFrame.Visible = false end)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 55); TitleLabel.Text = "✨ Zoins Hub ✨"; TitleLabel.TextColor3 = Color3.new(1, 1, 1); TitleLabel.Font = Enum.Font.GothamBlack; TitleLabel.TextSize = 28; TitleLabel.BackgroundTransparency = 1
local titleGrad = Instance.new("UIGradient", TitleLabel); titleGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(218, 165, 32)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 250, 240)), ColorSequenceKeypoint.new(1, Color3.fromRGB(218, 165, 32))})

local SearchBar = Instance.new("TextBox", MainFrame)
SearchBar.Size = UDim2.new(1, -40, 0, 40); SearchBar.Position = UDim2.new(0, 20, 0, 75); 
SearchBar.PlaceholderText = "عربي/English"
SearchBar.Text = "" 
SearchBar.BackgroundColor3 = Color3.fromRGB(45, 20, 35); SearchBar.TextColor3 = Color3.new(1, 1, 1); SearchBar.Font = Enum.Font.GothamBold; SearchBar.TextSize = 16; Instance.new("UICorner", SearchBar)
Instance.new("UIStroke", SearchBar).Color = Color3.fromRGB(218, 165, 32)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -160); Scroll.Position = UDim2.new(0, 10, 0, 145); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; Scroll.CanvasSize = UDim2.new(0,0,0,60)
local layout = Instance.new("UIListLayout", Scroll); layout.Padding = UDim.new(0, 10)
local UIPadding = Instance.new("UIPadding", Scroll); UIPadding.PaddingTop = UDim.new(0, 8)

local OpenBtn = Instance.new("TextButton", sgui)
OpenBtn.Name = "ZoinsFloatingBtn"
OpenBtn.Size = IsMobile and UDim2.new(0, 100, 0, 100) or UDim2.new(0, 90, 0, 90)
OpenBtn.Position = UDim2.new(0.9, -85, 0.5, -45)
OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 10, 25)
OpenBtn.Text = "" 
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local OpenLabel = Instance.new("TextLabel", OpenBtn)
OpenLabel.Size = UDim2.new(1, 0, 1, 0)
OpenLabel.BackgroundTransparency = 1
OpenLabel.Text = "🎉Z🎇ins🎉" 
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
    local f = Instance.new("Frame", Scroll); f.Size = UDim2.new(1, -10, 0, 65); f.BackgroundColor3 = Color3.fromRGB(35, 15, 25); Instance.new("UICorner", f)
    local smartTags = CleanText(data.English .. " " .. (data.Arabic or "") .. " " .. (data.Keywords or ""))
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, -100, 1, 0); t.Position = UDim2.new(0, 15, 0, 0); t.Text = data.English; t.TextColor3 = Color3.new(1, 1, 1); t.BackgroundTransparency = 1; t.Font = Enum.Font.GothamBold; t.TextSize = 16
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 80, 0, 35); btn.Position = UDim2.new(1, -90, 0.5, -17); btn.Text = "Start"; btn.Font = Enum.Font.GothamBold; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.BackgroundColor3 = Color3.fromRGB(60, 10, 30); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", btn); bStroke.Color = Color3.fromRGB(218, 165, 32); bStroke.Thickness = 1.5

    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(SubScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        SubTitle.Text = data.English
        for _, scr in ipairs(data.Scripts) do
            local sf = Instance.new("Frame", SubScroll); sf.Size = UDim2.new(1, -10, 0, 65); sf.BackgroundColor3 = Color3.fromRGB(35, 15, 25); sf.ZIndex = 21; Instance.new("UICorner", sf)
            local st = Instance.new("TextLabel", sf); st.Size = UDim2.new(1, -100, 1, 0); st.Position = UDim2.new(0, 15, 0, 0); st.Text = "🎉 " .. (scr.Name or data.English); st.TextColor3 = Color3.new(1, 1, 1); st.BackgroundTransparency = 1; st.Font = Enum.Font.GothamBold; st.TextSize = 16; st.ZIndex = 22
            local sbtn = Instance.new("TextButton", sf); sbtn.Size = UDim2.new(0, 80, 0, 35); sbtn.Position = UDim2.new(1, -90, 0.5, -17); sbtn.Text = "Start"; sbtn.Font = Enum.Font.GothamBold; sbtn.ZIndex = 22; Instance.new("UICorner", sbtn)
            sbtn.BackgroundColor3 = Color3.fromRGB(60, 10, 30); sbtn.TextColor3 = Color3.new(1,1,1)
            
            sbtn.MouseButton1Click:Connect(function()
                ShowNotification("...Lodeng/جاري تشغيل")
                if scr.Protect then
                    local oldClipboard = setclipboard
                    setclipboard = function() end
                    task.spawn(function()
                        local success, code = pcall(game.HttpGet, game, scr.Link, true)
                        if success then loadstring(code)() end
                    end)
                    task.delay(5, function() setclipboard = oldClipboard end)
                else
                    task.spawn(function()
                        local success, code = pcall(game.HttpGet, game, scr.Link, true)
                        if success then loadstring(code)() end
                    end)
                end
                sbtn.Text = "Done ✓"; sbtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
                task.delay(2, function() sbtn.Text = "Start"; sbtn.BackgroundColor3 = Color3.fromRGB(60, 10, 30) end)
            end)
        end
        SubFrame.Visible = true
    end)
    return {frame = f, smartTags = smartTags}
end

local MapFrames = {}
for _, data in ipairs(MyMaps) do table.insert(MapFrames, AddMap(data)) end

local ComingSoon = Instance.new("TextLabel", Scroll)
ComingSoon.Size = UDim2.new(1, 0, 0, 50); 
ComingSoon.Text = "✨️قريبا/Coming soon✨️"; 
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

ShowNotification("عيد مبارك سعيد / Eid Mubarak")
