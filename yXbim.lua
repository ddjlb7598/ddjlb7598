local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.03, 0)
UICorner.Parent = mainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 180, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3
UIStroke.Parent = mainFrame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.6, 0, 0.15, 0)
button.Position = UDim2.new(0.2, 0, 0.7, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 80, 120)
button.BackgroundTransparency = 0.5
button.BorderSizePixel = 0
button.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0.2, 0)
buttonCorner.Parent = button

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(0, 200, 255)
buttonStroke.Thickness = 1.5
buttonStroke.Parent = button

local glow = Instance.new("ImageLabel")
glow.Size = UDim2.new(1.2, 0, 1.2, 0)
glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
glow.Image = "rbxassetid://8992231221"
glow.ImageTransparency = 0.8
glow.ScaleType = Enum.ScaleType.Fit
glow.BackgroundTransparency = 1
glow.Parent = mainFrame

local function animateButton()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.3})
    tween:Play()
end

animateButton()

local function onButtonClick()
    local pulse = Instance.new("Frame")
    pulse.Size = UDim2.new(1, 0, 1, 0)
    pulse.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    pulse.BackgroundTransparency = 0.7
    pulse.BorderSizePixel = 0
    pulse.Parent = button
    
    local tween = TweenService:Create(pulse, TweenInfo.new(0.5), {
        Size = UDim2.new(1.5, 0, 1.5, 0),
        Position = UDim2.new(-0.25, 0, -0.25, 0),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        pulse:Destroy()
    end)
end

button.MouseButton1Click:Connect(onButtonClick)
