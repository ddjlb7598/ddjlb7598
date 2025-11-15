-- Roblox跨平台娱乐辅助脚本（修正版，仅私人服务器使用）
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

--████████ 配置区域 ██████████
local LOCK_KEY = Enum.KeyCode.RightShift    -- PC触发键
local TARGET_PART = "Head"                  -- 瞄准部位
local ACTIVATE_RADIUS = 100                 -- 移动端触控半径
local GAMEPAD_TRIGGER = Enum.KeyCode.ButtonL2 -- 手柄左扳机
local TRIGGER_THRESHOLD = 0.3               -- 扳机触发阈值
local ALLOWED_GAMES = {"MyPrivateGame"}     -- 仅允许运行的游戏名称（合规限制）

-- 动态平滑配置
local DYNAMIC_SMOOTHING = {
    Enabled = true,
    MinDistance = 10,
    MaxDistance = 50,
    CloseSmooth = 0.15,
    FarSmooth = 0.4,
    CurveFactor = 2.5
}

--████████ 初始化 ██████████
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local target = nil
local currentSmoothness = DYNAMIC_SMOOTHING.CloseSmooth
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimAssistUI"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

--████████ 合规校验 ██████████
if not table.find(ALLOWED_GAMES, game.Name) then
    warn("❌ 本脚本仅允许在私人服务器使用，已自动禁用！")
    return
end

--████████ UI系统（修正层级） ██████████
local tutorialFrame = Instance.new("Frame")
tutorialFrame.Size = UDim2.new(0.35, 0, 0.25, 0)
tutorialFrame.Position = UDim2.new(0.65, 0, 0.7, 0)
tutorialFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tutorialFrame.BackgroundTransparency = 0.8
tutorialFrame.Visible = false
tutorialFrame.Parent = screenGui -- 修正层级

local hintTexts = {
    Mobile = "📱 长按右侧区域锁定目标",
    Gamepad = "🎮 按住左扳机(LT)锁定+压力感应",
    Desktop = "🖱️ 按住右键拖动瞄准"
}

local deviceHint = Instance.new("TextLabel")
deviceHint.Text = "设备检测中..."
deviceHint.TextColor3 = Color3.new(1,1,1)
deviceHint.Size = UDim2.new(1, 0, 1, 0)
deviceHint.Font = Enum.Font.GothamMedium
deviceHint.TextScaled = true
deviceHint.Parent = tutorialFrame

-- 移动端触控区域
local touchFrame = Instance.new("Frame")
touchFrame.Size = UDim2.new(0.3, 0, 0.6, 0)
touchFrame.Position = UDim2.new(0.7, 0, 0.2, 0)
touchFrame.BackgroundTransparency = 1
touchFrame.Parent = screenGui

--████████ 工具函数 ██████████
local function getDeviceType()
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then return "Mobile" end
    if UIS:GetLastInputType().Name:find("Gamepad") then return "Gamepad" end
    return "Desktop"
end

-- 目标筛选逻辑（核心修正：筛选其他玩家角色）
local function getValidTargets()
    local targets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(TARGET_PART)
            if targetPart and targetPart:IsA("BasePart") then
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    table.insert(targets, {
                        Player = player,
                        Part = targetPart,
                        ScreenPos = Vector2.new(screenPos.X, screenPos.Y),
                        WorldPos = targetPart.Position
                    })
                end
            end
        end
    end
    return targets
end

local function findBestTarget()
    local closest = nil
    local minDistance = math.huge
    local centerPos = camera.ViewportSize / 2
    for _, targetData in ipairs(getValidTargets()) do
        local screenDistance = (targetData.ScreenPos - centerPos).Magnitude
        if screenDistance < minDistance then
            closest = targetData
            minDistance = screenDistance
        end
    end
    return closest
end

-- 动态平滑计算
local function calculateDynamicSmoothness(targetWorldPos)
    if not DYNAMIC_SMOOTHING.Enabled then return currentSmoothness end
    local distance = (targetWorldPos - camera.CFrame.Position).Magnitude
    distance = math.clamp(distance, DYNAMIC_SMOOTHING.MinDistance, DYNAMIC_SMOOTHING.MaxDistance)
    local t = (distance - DYNAMIC_SMOOTHING.MinDistance) / (DYNAMIC_SMOOTHING.MaxDistance - DYNAMIC_SMOOTHING.MinDistance)
    return DYNAMIC_SMOOTHING.CloseSmooth + (DYNAMIC_SMOOTHING.FarSmooth - DYNAMIC_SMOOTHING.CloseSmooth) * math.pow(t, DYNAMIC_SMOOTHING.CurveFactor)
end

-- 平滑瞄准
local function smoothAim(targetWorldPos)
    local dynamicSmooth = calculateDynamicSmoothness(targetWorldPos)
    local targetCFrame = CFrame.lookAt(camera.CFrame.Position, targetWorldPos)
    camera.CFrame = camera.CFrame:Lerp(targetCFrame, dynamicSmooth)
end

--████████ 输入处理（修正错误） ██████████
-- 移动端触控
local activeTouchId = nil
UIS.TouchStarted:Connect(function(touch)
    if getDeviceType() ~= "Mobile" then return end
    local touchPos = touch.Position
    local framePos = touchFrame.AbsolutePosition
    local frameSize = touchFrame.AbsoluteSize
    if touchPos.X >= framePos.X and touchPos.X <= framePos.X + frameSize.X and
       touchPos.Y >= framePos.Y and touchPos.Y <= framePos.Y + frameSize.Y then
        activeTouchId = touch.Id
        target = findBestTarget()
    end
end)

UIS.TouchEnded:Connect(function(touch)
    if touch.Id == activeTouchId then
        target = nil
        activeTouchId = nil
    end
end)

-- 手柄输入
UIS.InputChanged:Connect(function(input)
    if getDeviceType() ~= "Gamepad" then return end
    if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == GAMEPAD_TRIGGER then
        local triggerValue = input.Position.Z
        if triggerValue > TRIGGER_THRESHOLD then
            target = target or findBestTarget()
            currentSmoothness = DYNAMIC_SMOOTHING.CloseSmooth * (1 - (triggerValue - TRIGGER_THRESHOLD)/(1 - TRIGGER_THRESHOLD)*0.5)
        else
            target = nil
        end
    end
end)

-- PC输入
UIS.InputBegan:Connect(function(input)
    if getDeviceType() == "Desktop" then
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            target = findBestTarget()
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if getDeviceType() == "Desktop" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        target = nil
    end
end)

--████████ 主循环 ██████████
RunService.Heartbeat:Connect(function()
    -- 更新设备提示
    local deviceType = getDeviceType()
    tutorialFrame.Visible = true
    deviceHint.Text = hintTexts[deviceType]

    -- 目标有效性检查
    if target then
        if not target.Part:IsDescendantOf(workspace) or not target.Player.Character then
            target = nil
        end
    end

    -- 执行瞄准
    if target then
        smoothAim(target.WorldPos)
    end
end)

--████████ 安全警告 ██████████
warn([[⚠ 本脚本仅限私人服务器娱乐使用！
禁止在公开游戏中使用，违者账号可能被封禁！]])
