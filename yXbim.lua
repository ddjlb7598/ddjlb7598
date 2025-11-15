local HttpService = cloneref(game:GetService("HttpService"))

local isfunctionhooked = clonefunction(isfunctionhooked)
if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then 
    return 
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SUNXIAOCHUAN-DEV/-/refs/heads/main/乱码牛逼"))()

local lp = game:GetService("Players").LocalPlayer
local Character = lp.Character
local hrp = Character.HumanoidRootPart

local function getDeviceType()
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        if UserInputService.KeyboardEnabled then
            return "平板"
        else
            return "手机"
        end
    else
        return "电脑"
    end
end

local deviceType = getDeviceType()
local uiSize, uiPosition

if deviceType == "手机" then
    uiSize = UDim2.fromOffset(500, 400)
elseif deviceType == "平板" then
    uiSize = UDim2.fromOffset(550, 450)
else
    uiSize = UDim2.fromOffset(600, 500)
end
uiPosition = UDim2.new(0.5, 0, 0.5, 0)

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local displayName = game.Players.LocalPlayer.DisplayName

WindUI:Notify({
    Title = "德与中山",
    Content = "德与中山--自然灾害加载完成",
    Duration = 2
})

local Window = WindUI:CreateWindow({
    Title = "德与中山--自然灾害",
    Icon = "crown",
    Author = "作者：各大脚本作者",
    Folder = "OrangeCHub",
    Size = uiSize,
    Position = uiPosition,
    Theme = "Dark",
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Username = playerName,
        DisplayName = displayName,
        UserId = game.Players.LocalPlayer.UserId,
        ThumbnailType = "AvatarBust",
        Callback = function()
            WindUI:Notify({
                Title = "用户信息",
                Content = "玩家:" .. game.Players.LocalPlayer.Name,
                Duration = 3
            })
        end
    },
    SideBarWidth = deviceType == "手机" and 150 or 180,
    ScrollBarEnabled = true
})

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "提示",
        Content = "当前主题: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

Window:EditOpenButton({
    Title = "打开德与中山-自然灾害",
    Icon = "crown",
})

local Tabs = {
    Pl = Window:Section({ Title = "玩家", Opened = false, Icon = "user"}),
    ZN = Window:Section({ Title = "灾难", Opened = false, Icon = "package-open"}),
    Auto = Window:Section({ Title = "自动", Opened = false, Icon = "pocket-knife"})
}

local TabHandles = {
    Announcement = Tabs.Pl:Tab({ Title = "公告", Icon = "folder"}),
    Player = Tabs.Pl:Tab({ Title = "玩家", Icon = "folder"}),
    ZN1 = Tabs.ZN:Tab({ Title = "预测灾难", Icon = "folder"}),
    
}

TabHandles.Announcement:Paragraph({
    Title = "欢迎尊贵的用户",
    Desc = "此脚本会一直更新 感谢白名单使用者",
    Image = "info",
    ImageSize = 15
})

TabHandles.Announcement:Paragraph({
    Title = "玩家",
    Desc = "尊敬的用户: " .. game.Players.LocalPlayer.Name .. "欢迎使用",
    Image = "user",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "设备",
    Desc = "你的使用设备: " .. deviceType,
    Image = "gamepad",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "设备",
    Desc = "你的注入器: " .. identifyexecutor(),
    Image = "syringe",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "卡密",
    Desc = "你的卡密: " .. readfile("DyzhKey.json"),
    Image = "key",
    ImageSize = 12
})

TabHandles.Player:Slider({
    Title = "玩家速度",
    Desc = "玩家的速度",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
            game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

TabHandles.Player:Slider({
    Title = "玩家跳跃高度",
    Desc = "玩家的跳跃高度",
    Step = 1,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
            game:GetService("Players").LocalPlayer.Character.Humanoid.JumpHeight = value
        end
    end
})

TabHandles.Player:Slider({
    Title = "玩家镜头FOV",
    Desc = "玩家的镜头",
    Step = 1,
    Value = {
        Min = 70,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        if camera then
            camera.FieldOfView = value
        end
    end
})

TabHandles.Player:Button({
    Title = "删除摔落伤害",
    Desc = "删除",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character.FallDamageScript:Destroy()
        game:GetService("Players").LocalPlayer.Character.ChildAdded:Connect(function()
            if v.Name == "FallDamageScript" then
                v:Destroy()
            end
        end)
    end
})

TabHandles.Player:Toggle({
    Title = "锁定玩家血量",
    Desc = "锁血",
    Value = false,
    Callback = function(state)
        local gm = getrawmetatable(game)
        local old = gm.__newindex
        setreadonly(gm, false)
