local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Size = UDim2.new(0, 420, 0, 270)
borderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
borderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
borderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
borderFrame.BorderSizePixel = 0
borderFrame.Parent = screenGui

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 16)
borderCorner.Parent = borderFrame

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, -10, 1, -10)
mainFrame.Position = UDim2.new(0, 5, 0, 5)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0
mainFrame.Parent = borderFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local rightFrame = Instance.new("Frame")
rightFrame.Name = "RightFrame"
rightFrame.Size = UDim2.new(0, 120, 1, 0)
rightFrame.Position = UDim2.new(1, -120, 0, 0)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = mainFrame

local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "Logo"
imageLabel.Size = UDim2.new(0, 80, 0, 80)
imageLabel.Position = UDim2.new(0.5, -40, 0.5, -40)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://131031762663602"
imageLabel.ScaleType = Enum.ScaleType.Fit
imageLabel.Parent = rightFrame

local leftFrame = Instance.new("Frame")
leftFrame.Name = "LeftFrame"
leftFrame.Size = UDim2.new(1, -140, 1, -40)
leftFrame.Position = UDim2.new(0, 20, 0, 20)
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = mainFrame

local textLabel = Instance.new("TextLabel")
textLabel.Name = "InstructionText"
textLabel.Size = UDim2.new(1, 0, 0, 50)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "加QQ群 1038139085 获取卡密"
textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextSize = 25
textLabel.TextWrapped = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.Parent = leftFrame

local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(1, 0, 0, 40)
inputFrame.Position = UDim2.new(0, 0, 0, 60)
inputFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = leftFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputFrame

local textBox = Instance.new("TextBox")
textBox.Name = "KeyInput"
textBox.Size = UDim2.new(1, -20, 1, -10)
textBox.Position = UDim2.new(0, 10, 0, 5)
textBox.BackgroundTransparency = 1
textBox.PlaceholderText = "在此输入卡密..."
textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
textBox.TextSize = 16
textBox.ClearTextOnFocus = false
textBox.Parent = inputFrame

local button = Instance.new("TextButton")
button.Name = "VerifyButton"
button.Size = UDim2.new(1, 0, 0, 45)
button.Position = UDim2.new(0, 0, 0, 120)
button.BackgroundColor3 = Color3.fromRGB(74, 144, 226)
button.Text = "验证卡密"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.SourceSansBold
button.Parent = leftFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, -5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
closeButton.TextSize = 30
closeButton.Font = Enum.Font.SourceSansBold
closeButton.ZIndex = 2
closeButton.Parent = mainFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Name = "MessageLabel"
messageLabel.Size = UDim2.new(1, 0, 0, 30)
messageLabel.Position = UDim2.new(0, 0, 0, 175)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = ""
messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
messageLabel.TextSize = 14
messageLabel.Font = Enum.Font.SourceSans
messageLabel.Parent = leftFrame

-- 修复复制到剪贴板功能 - 使用多种方法确保复制成功
local function copyToClipboard(text)
    local success = false
    
    -- 方法1: 使用setclipboard (最常用)
    if setclipboard then
        pcall(function()
            setclipboard(text)
            success = true
        end)
    end
    
    -- 方法2: 使用writeclipboard
    if not success and writeclipboard then
        pcall(function()
            writeclipboard(text)
            success = true
        end)
    end
    
    -- 方法3: 使用syn库
    if not success and syn and syn.write_clipboard then
        pcall(function()
            syn.write_clipboard(text)
            success = true
        end)
    end
    
    -- 方法4: 使用StarterGui:SetClipboard (最后尝试)
    if not success then
        pcall(function()
            StarterGui:SetClipboard(text)
            success = true
        end)
    end
    
    return success
end

button.MouseButton1Click:Connect(function()
    local inputKey = textBox.Text
    local correctKey = "X Bi NB 666"
    
    if inputKey == correctKey then
        messageLabel.Text = "卡密正确！验证成功！"
        messageLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
        wait(2)
        screenGui:Destroy()
    else
        local copySuccess = copyToClipboard("1038139085")
        if copySuccess then
            messageLabel.Text = "卡密错误！已自动复制QQ群号：1038139085"
        else
            messageLabel.Text = "卡密错误！请手动复制QQ群号：1038139085"
        end
        messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.MouseEnter:Connect(function()
    TweenService:Create(
        closeButton,
        TweenInfo.new(0.2),
        {TextColor3 = Color3.fromRGB(100, 100, 100)}
    ):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(
        closeButton,
        TweenInfo.new(0.2),
        {TextColor3 = Color3.fromRGB(0, 0, 0)}
    ):Play()
end)
