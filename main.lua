-- [[ TRXSH HUB V3 - FULL SOURCE ]] --
-- [[ CREATED BY HENRIQSZ7 ]] --

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

-- [[ IDENTIFICADOR ÚNICO DA MÁQUINA (HWID) ]] --
-- Esse ID é único para você.
local MyID = RbxAnalyticsService:GetClientId() 

-- [[ URL DATABASE - SCRIPTS EXTERNOS ]] --
local _U = {
    CLOUD = "https://raw.githubusercontent.com/cloudman4416/scripts/main/Loader.lua",
    FIRE = "https://raw.githubusercontent.com/projectslayersf/FireHub/main/Loader.lua",
    FROST = "https://raw.githubusercontent.com/cattercatty/Scripts/main/Loader.lua",
    IY = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
}

-- DETERMINA O PARENT
local TargetParent = (gethui and gethui()) or (CoreGui:FindFirstChild("RobloxGui") and CoreGui.RobloxGui) or PlayerGui

-- LIMPEZA DE INSTÂNCIAS ANTIGAS
if TargetParent:FindFirstChild("TRXSH_HUB_V3_ULTIMATE") then
	TargetParent:FindFirstChild("TRXSH_HUB_V3_ULTIMATE"):Destroy()
end

local TRXSH_HUB = Instance.new("ScreenGui")
TRXSH_HUB.Name = "TRXSH_HUB_V3_ULTIMATE"
TRXSH_HUB.Parent = TargetParent
TRXSH_HUB.ResetOnSpawn = false
TRXSH_HUB.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ CONFIGURAÇÕES DO USUÁRIO ]] --
local Settings = {
	AutoExecute = false,
	HideKey = Enum.KeyCode.LeftControl,
	IsVisible = true,
	DiscordLink = "https://discord.gg/3JSw8fDQbu",
	AccentColor = Color3.fromRGB(90, 50, 200),
	SecondaryColor = Color3.fromRGB(15, 15, 18)
}

-- [[ FUNÇÕES DE UTILIDADE ]] --
local function ExecuteScript(url)
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        local func = loadstring(content)
        if func then task.spawn(func) end
    end
end

local function SmoothTween(obj, time, prop)
	local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local tween = TweenService:Create(obj, info, prop)
	tween:Play()
	return tween
end

local function ApplyHover(btn, normalColor, hoverColor, stroke)
	btn.MouseEnter:Connect(function()
		SmoothTween(btn, 0.3, {BackgroundColor3 = hoverColor})
		if stroke then SmoothTween(stroke, 0.3, {Transparency = 0, Color = Settings.AccentColor}) end
	end)
	btn.MouseLeave:Connect(function()
		SmoothTween(btn, 0.3, {BackgroundColor3 = normalColor})
		if stroke then SmoothTween(stroke, 0.3, {Transparency = 0.7, Color = Color3.fromRGB(60, 60, 60)}) end
	end)
end

local function ApplyCloseHover(btn)
	btn.MouseEnter:Connect(function() SmoothTween(btn, 0.3, {TextColor3 = Color3.fromRGB(255, 60, 60)}) end)
	btn.MouseLeave:Connect(function() SmoothTween(btn, 0.3, {TextColor3 = Color3.fromRGB(200, 200, 200)}) end)
end

local function MakeDraggable(frame)
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true dragStart = input.Position startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- [[ TELA DE LOGIN ]] --
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = TRXSH_HUB
KeyFrame.BackgroundColor3 = Settings.SecondaryColor
KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
KeyFrame.Size = UDim2.new(0, 360, 0, 280)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Settings.AccentColor
KeyStroke.Thickness = 1.8

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 70)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.Michroma
KeyTitle.Text = "TRXSH HUB"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 25

local CloseKey = Instance.new("TextButton")
CloseKey.Parent = KeyFrame
CloseKey.Size = UDim2.new(0, 30, 0, 30)
CloseKey.Position = UDim2.new(1, -35, 0, 5)
CloseKey.BackgroundTransparency = 1
CloseKey.Text = "X"
CloseKey.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseKey.Font = Enum.Font.GothamBold
CloseKey.TextSize = 18
ApplyCloseHover(CloseKey)
CloseKey.MouseButton1Click:Connect(function() TRXSH_HUB:Destroy() end)

local KeyInput = Instance.new("TextBox")
KeyInput.Parent = KeyFrame
KeyInput.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.PlaceholderText = "Paste Key Here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

local AuthBtn = Instance.new("TextButton")
AuthBtn.Parent = KeyFrame
AuthBtn.BackgroundColor3 = Settings.AccentColor
AuthBtn.Position = UDim2.new(0.1, 0, 0.58, 0)
AuthBtn.Size = UDim2.new(0.8, 0, 0, 45)
AuthBtn.Font = Enum.Font.GothamBold
AuthBtn.Text = "AUTHENTICATE"
AuthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AuthBtn.TextSize = 14
Instance.new("UICorner", AuthBtn).CornerRadius = UDim.new(0, 6)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = KeyFrame
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.78, 0)
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 40)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
GetKeyBtn.TextSize = 12
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)
ApplyHover(GetKeyBtn, Color3.fromRGB(25, 25, 30), Color3.fromRGB(35, 35, 40))

MakeDraggable(KeyFrame)

-- [[ PAINEL PRINCIPAL ]] --
local MainHub = Instance.new("Frame")
MainHub.Name = "MainHub"
MainHub.Parent = TRXSH_HUB
MainHub.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainHub.Position = UDim2.new(0.5, -350, 0.5, -225)
MainHub.Size = UDim2.new(0, 700, 0, 450)
MainHub.Visible = false
MainHub.ClipsDescendants = true
Instance.new("UICorner", MainHub).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainHub)
MainStroke.Thickness = 1.5
MainStroke.Color = Settings.AccentColor

local SideMenu = Instance.new("Frame")
SideMenu.Parent = MainHub
SideMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
SideMenu.Size = UDim2.new(0, 180, 1, 0)
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 12)

local CloseMain = Instance.new("TextButton")
CloseMain.Parent = MainHub
CloseMain.Size = UDim2.new(0, 30, 0, 30)
CloseMain.Position = UDim2.new(1, -35, 0, 5)
CloseMain.BackgroundTransparency = 1
CloseMain.Text = "X"
CloseMain.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseMain.Font = Enum.Font.GothamBold
CloseMain.TextSize = 18
CloseMain.ZIndex = 10
ApplyCloseHover(CloseMain)
CloseMain.MouseButton1Click:Connect(function() TRXSH_HUB:Destroy() end)

local Logo = Instance.new("TextLabel")
Logo.Parent = SideMenu
Logo.Size = UDim2.new(1, 0, 0, 70)
Logo.BackgroundTransparency = 1
Logo.Font = Enum.Font.Michroma
Logo.Text = "TRXSH HUB"
Logo.TextColor3 = Settings.AccentColor
Logo.TextSize = 18

-- [[ USER PROFILE SECTION ]] --
local UserProfile = Instance.new("Frame")
UserProfile.Name = "UserProfile"
UserProfile.Parent = SideMenu
UserProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
UserProfile.Position = UDim2.new(0, 10, 1, -60)
UserProfile.Size = UDim2.new(0, 160, 0, 50)
Instance.new("UICorner", UserProfile).CornerRadius = UDim.new(0, 8)

local UserImage = Instance.new("ImageLabel")
UserImage.Parent = UserProfile
UserImage.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
UserImage.Position = UDim2.new(0, 5, 0, 5)
UserImage.Size = UDim2.new(0, 40, 0, 40)
UserImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png"
Instance.new("UICorner", UserImage).CornerRadius = UDim.new(1, 0)

local UserName = Instance.new("TextLabel")
UserName.Parent = UserProfile
UserName.Position = UDim2.new(0, 50, 0, 5)
UserName.Size = UDim2.new(0, 100, 0, 40)
UserName.BackgroundTransparency = 1
UserName.Font = Enum.Font.GothamBold
UserName.Text = Player.DisplayName or Player.Name
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.TextSize = 12
UserName.TextXAlignment = Enum.TextXAlignment.Left

local TabList = Instance.new("ScrollingFrame")
TabList.Parent = SideMenu
TabList.Position = UDim2.new(0, 0, 0, 70)
TabList.Size = UDim2.new(1, 0, 1, -140)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
local TLL = Instance.new("UIListLayout", TabList)
TLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
TLL.Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainHub
ContentArea.Position = UDim2.new(0, 195, 0, 45)
ContentArea.Size = UDim2.new(1, -210, 1, -60)
ContentArea.BackgroundTransparency = 1

MakeDraggable(MainHub)

-- [[ SISTEMA DE ABAS E COMPONENTES ]] --
local function CreateTab(name, layoutOrder)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Parent = TabList
	TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	TabBtn.Size = UDim2.new(0.9, 0, 0, 38)
	TabBtn.Font = Enum.Font.GothamMedium
	TabBtn.Text = name
	TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	TabBtn.TextSize = 12
	TabBtn.LayoutOrder = layoutOrder
	Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
	local TS = Instance.new("UIStroke", TabBtn)
	TS.Color = Color3.fromRGB(60, 60, 60)
	TS.Transparency = 0.7

	local Page = Instance.new("ScrollingFrame")
	Page.Parent = ContentArea
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.ZIndex = 2
	Page.ScrollBarThickness = 2
	Page.ScrollBarImageColor3 = Settings.AccentColor
	local PL = Instance.new("UIListLayout", Page)
	PL.Padding = UDim.new(0, 10)
	PL.HorizontalAlignment = Enum.HorizontalAlignment.Center

	ApplyHover(TabBtn, Color3.fromRGB(20, 20, 24), Color3.fromRGB(30, 30, 35), TS)

	TabBtn.MouseButton1Click:Connect(function()
		for _, p in pairs(ContentArea:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
		for _, b in pairs(TabList:GetChildren()) do 
			if b:IsA("TextButton") then 
				SmoothTween(b, 0.3, {BackgroundColor3 = Color3.fromRGB(20, 20, 24), TextColor3 = Color3.fromRGB(150, 150, 150)})
			end 
		end
		Page.Visible = true
		SmoothTween(TabBtn, 0.3, {BackgroundColor3 = Settings.AccentColor, TextColor3 = Color3.fromRGB(255, 255, 255)})
	end)
	return Page
end

local function AddBasicButton(page, name, callback)
	local Btn = Instance.new("TextButton")
	Btn.Parent = page
	Btn.Size = UDim2.new(0.95, 0, 0, 42)
	Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	Btn.Font = Enum.Font.GothamBold
	Btn.Text = name
	Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	Btn.TextSize = 13
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
	local BS = Instance.new("UIStroke", Btn)
	BS.Color = Color3.fromRGB(60, 60, 60)
	BS.Transparency = 0.7
	ApplyHover(Btn, Color3.fromRGB(18, 18, 22), Color3.fromRGB(25, 25, 30), BS)
	Btn.MouseButton1Click:Connect(callback)
	return Btn
end

local function AddScriptButton(page, name, line1, line2, btnText, callback)
	local Container = Instance.new("Frame")
	Container.Parent = page
	Container.Size = UDim2.new(0.95, 0, 0, 70)
	Container.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
	local CS = Instance.new("UIStroke", Container)
	CS.Color = Color3.fromRGB(60, 60, 60)
	CS.Transparency = 0.7

	local Title = Instance.new("TextLabel")
	Title.Parent = Container
	Title.Size = UDim2.new(1, 0, 0, 25)
	Title.Position = UDim2.new(0, 10, 0, 5)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.Text = name
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Desc1 = Instance.new("TextLabel")
	Desc1.Parent = Container
	Desc1.Size = UDim2.new(1, -100, 0, 15)
	Desc1.Position = UDim2.new(0, 10, 0, 30)
	Desc1.BackgroundTransparency = 1
	Desc1.Font = Enum.Font.Gotham
	Desc1.Text = line1
	Desc1.TextColor3 = Color3.fromRGB(150, 150, 150)
	Desc1.TextSize = 11
	Desc1.TextXAlignment = Enum.TextXAlignment.Left

	local Desc2 = Instance.new("TextLabel")
	Desc2.Parent = Container
	Desc2.Size = UDim2.new(1, -100, 0, 15)
	Desc2.Position = UDim2.new(0, 10, 0, 45)
	Desc2.BackgroundTransparency = 1
	Desc2.Font = Enum.Font.GothamMedium
	Desc2.Text = line2
	Desc2.TextColor3 = Color3.fromRGB(200, 60, 60)
	Desc2.TextSize = 10
	Desc2.TextXAlignment = Enum.TextXAlignment.Left

	if btnText then
		local ExecBtn = Instance.new("TextButton")
		ExecBtn.Parent = Container
		ExecBtn.Size = UDim2.new(0, 80, 0, 30)
		ExecBtn.Position = UDim2.new(1, -90, 0.5, -15)
		ExecBtn.BackgroundColor3 = Settings.AccentColor
		ExecBtn.Text = btnText
		ExecBtn.Font = Enum.Font.GothamBold
		ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		ExecBtn.TextSize = 12
		Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)
		ExecBtn.MouseButton1Click:Connect(callback)
	end
end

-- [[ CRIAÇÃO DAS ABAS ]] --
local ProjectSlayers = CreateTab("PROJECT SLAYERS", 1)
local WestBound = CreateTab("WESTBOUND", 2)
local Universal = CreateTab("UNIVERSAL", 98)
local ConfigTab = CreateTab("SETTINGS", 99)
local DiscordTab = CreateTab("DISCORD", 100)
local CreditsTab = CreateTab("CREDITS", 101)

-- [[ SCRIPTS PROJECT SLAYERS ]] --
AddScriptButton(ProjectSlayers, "CLOUD HUB", "Auto farm everything", "Needs Key", "Execute", function() ExecuteScript(_U.CLOUD) end)
AddScriptButton(ProjectSlayers, "FIRE HUB", "Auto farm everything", "Needs Key", "Execute", function() ExecuteScript(_U.FIRE) end)
AddScriptButton(ProjectSlayers, "FROSTIES HUB", "Auto farm everything", "Needs Key", "Execute", function() ExecuteScript(_U.FROST) end)

-- [[ SCRIPTS UNIVERSAL ]] --
AddScriptButton(Universal, "INFINITE YIELD", "Universal script commands", "", "Execute", function() ExecuteScript(_U.IY) end)

-- [[ WESTBOUND - DIABLO HUB ]] --
AddScriptButton(WestBound, "DIABLO HUB", "Auto farm money", "", "Execute", function()
    -- FONTE DIABLO HUB INTEGRADO
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local VirtualUser = game:GetService("VirtualUser")
    local StatsService = game:GetService("Stats")
    local SoundService = game:GetService("SoundService")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local bag = localPlayer:WaitForChild("States"):WaitForChild("Bag")
    local bagSizeLevel = localPlayer:WaitForChild("Stats"):WaitForChild("BagSizeLevel"):WaitForChild("CurrentAmount")
    local robEvent = ReplicatedStorage:WaitForChild("GeneralEvents"):WaitForChild("Rob")
    local targetPosition = CFrame.new(1636.62537, 104.349976, -1736.184)

    local function ensureAntiDeath(char)
        local ok, h = pcall(function()
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not hum then return end
            local cloned = hum:Clone()
            cloned.Parent = char
            localPlayer.Character = nil
            cloned:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            cloned:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            cloned:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum:Destroy()
            localPlayer.Character = char
            local cam = Workspace.CurrentCamera
            cam.CameraSubject = cloned
            cam.CFrame = cam.CFrame
            cloned.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            local animate = char:FindFirstChild("Animate")
            if animate then
                animate.Disabled = true
                task.wait(0.07)
                animate.Disabled = false
            end
            cloned.Health = cloned.MaxHealth
            humanoid = cloned
            humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        end)
        return ok
    end

    ensureAntiDeath(character)

    localPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    if getgenv().AntiAfkExecuted and game.CoreGui:FindFirstChild("DiabloAutoFarmUI") then
        getgenv().AntiAfkExecuted = false
        getgenv().AutoFarmActive = false
        game.CoreGui.DiabloAutoFarmUI:Destroy()
    end

    getgenv().AntiAfkExecuted = true
    getgenv().AutoFarmActive = false
    local FAST_LOOP_INTERVAL = 0.08

    local function formatNumber(n)
        local s = tostring(n)
        while true do
            local k
            s, k = string.gsub(s, "^(-?%d+)(%d%d%d)", "%1,%2")
            if k == 0 then break end
        end
        return s
    end

    local cashRegisters = {}
    local safes = {}

    local function clearTable(t)
        for i = 1, #t do t[i] = nil end
    end

    local function updateCaches()
        clearTable(cashRegisters)
        clearTable(safes)
        for _, child in ipairs(Workspace:GetChildren()) do
            if child:IsA("Model") then
                if child.Name == "CashRegister" then
                    table.insert(cashRegisters, child)
                elseif child.Name == "Safe" then
                    table.insert(safes, child)
                end
            end
        end
    end

    updateCaches()

    Workspace.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            if child.Name == "CashRegister" then table.insert(cashRegisters, child)
            elseif child.Name == "Safe" then table.insert(safes, child) end
        end
    end)

    Workspace.ChildRemoved:Connect(function(child)
        if child:IsA("Model") then
            if child.Name == "CashRegister" then
                for i = #cashRegisters, 1, -1 do if cashRegisters[i] == child then table.remove(cashRegisters, i) end end
            elseif child.Name == "Safe" then
                for i = #safes, 1, -1 do if safes[i] == child then table.remove(safes, i) end end
            end
        end
    end)

    local function moveTo(cf)
        if humanoidRootPart and cf then humanoidRootPart.CFrame = cf end
    end

    local function findNearestCashRegister()
        if not humanoidRootPart then return nil end
        local best, bestDist = nil, math.huge
        for _, reg in ipairs(cashRegisters) do
            if reg and reg.Parent and reg:IsDescendantOf(Workspace) then
                local openPart = reg:FindFirstChild("Open")
                if openPart then
                    local d = (humanoidRootPart.Position - openPart.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = {model = reg, openPart = openPart}
                    end
                end
            end
        end
        return best
    end

    local function findNearestSafe()
        if not humanoidRootPart then return nil end
        local best, bestDist = nil, math.huge
        for _, s in ipairs(safes) do
            if s and s.Parent and s:IsDescendantOf(Workspace) and s:FindFirstChild("Amount") and s.Amount.Value > 0 then
                local safePart = s:FindFirstChild("Safe")
                if safePart then
                    local d = (humanoidRootPart.Position - safePart.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = {model = s, safePart = safePart}
                    end
                end
            end
        end
        return best
    end

    local function attemptRegister(regData)
        if not regData or not regData.model then return false end
        local ok = pcall(function()
            moveTo(regData.openPart.CFrame)
            robEvent:FireServer("Register", {
                Part = regData.model:FindFirstChild("Union"),
                OpenPart = regData.openPart,
                ActiveValue = regData.model:FindFirstChild("Active"),
                Active = true
            })
        end)
        return ok
    end

    local function attemptSafe(sData)
        if not sData or not sData.model then return false end
        local ok = pcall(function()
            moveTo(sData.safePart.CFrame)
            local openFlag = sData.model:FindFirstChild("Open")
            if openFlag and openFlag.Value then
                robEvent:FireServer("Safe", sData.model)
            else
                local openSafe = sData.model:FindFirstChild("OpenSafe")
                if openSafe then openSafe:FireServer("Completed") end
                robEvent:FireServer("Safe", sData.model)
            end
        end)
        return ok
    end

    local function farmOnce()
        if bag.Value >= bagSizeLevel.Value then
            moveTo(targetPosition)
            return false
        end
        local reg = findNearestCashRegister()
        if reg then if attemptRegister(reg) then return true end end
        local s = findNearestSafe()
        if s then if attemptSafe(s) then return true end end
        return false
    end

    local function createNotifierGUI()
        local gui = Instance.new("ScreenGui")
        gui.Name = "DiabloNotifier"
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui
        local container = Instance.new("Frame")
        container.Name = "Container"
        container.AnchorPoint = Vector2.new(0.5, 0)
        container.Position = UDim2.new(0.5, 0, 0, 6)
        container.Size = UDim2.new(0, 380, 0, 0)
        container.BackgroundTransparency = 1
        container.Parent = gui
        return gui, container
    end

    local notifierGui, notifierContainer = createNotifierGUI()
    local activeNotifiers = {}

    local function repositionNotifiers()
        for i, v in ipairs(activeNotifiers) do
            if v and v.frame then
                local targetY = 6 + (i - 1) * 56
                TweenService:Create(v.frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, targetY)}):Play()
            end
        end
    end

    local function notify(text, timeSec)
        timeSec = timeSec or 3
        if not notifierContainer or notifierContainer.Parent == nil then
            notifierGui, notifierContainer = createNotifierGUI()
        end
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 340, 0, 50)
        frame.Position = UDim2.new(0.5, 0, 0, -60)
        frame.AnchorPoint = Vector2.new(0.5, 0)
        frame.BackgroundTransparency = 1
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        frame.BorderSizePixel = 0
        frame.Parent = notifierContainer
        local uic = Instance.new("UICorner", frame)
        uic.CornerRadius = UDim.new(0, 10)
        local uistroke = Instance.new("UIStroke", frame)
        uistroke.Thickness = 1
        uistroke.Color = Color3.fromRGB(100, 100, 100)
        uistroke.Transparency = 0.5
        local txt = Instance.new("TextLabel", frame)
        txt.Size = UDim2.new(1, -20, 1, 0)
        txt.Position = UDim2.new(0, 10, 0, 0)
        txt.BackgroundTransparency = 1
        txt.Text = tostring(text)
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 16
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.TextTransparency = 1
        local snd = Instance.new("Sound", frame)
        snd.SoundId = "rbxassetid://3442983711"
        snd.Volume = 1
        snd.PlayOnRemove = false
        snd:Play()
        table.insert(activeNotifiers, {frame = frame})
        repositionNotifiers()
        local appearTween = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 6 + (#activeNotifiers - 1) * 56), BackgroundTransparency = 0})
        appearTween:Play()
        TweenService:Create(txt, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        task.spawn(function()
            task.wait(timeSec)
            local disappearTween = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -60), BackgroundTransparency = 1})
            disappearTween:Play()
            TweenService:Create(txt, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
            disappearTween.Completed:Wait()
            frame:Destroy()
            for i = #activeNotifiers, 1, -1 do if activeNotifiers[i] and activeNotifiers[i].frame == frame then table.remove(activeNotifiers, i) end end
            repositionNotifiers()
        end)
    end

    local AutoFarmUI = Instance.new("ScreenGui")
    AutoFarmUI.Name = "DiabloAutoFarmUI"
    AutoFarmUI.Parent = game.CoreGui
    AutoFarmUI.ResetOnSpawn = false
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 320, 0, 160)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundTransparency = 0
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = AutoFarmUI
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 14)
    local Accent = Instance.new("Frame", MainFrame)
    Accent.Size = UDim2.new(1, 0, 0, 40)
    Accent.Position = UDim2.new(0, 0, 0, 0)
    Accent.BackgroundTransparency = 0
    Accent.BackgroundColor3 = Color3.fromRGB(45, 10, 90)
    Accent.BorderSizePixel = 0
    local g = Instance.new("UIGradient", Accent)
    g.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 25, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 10, 140)) }
    g.Rotation = 45
    local Title = Instance.new("TextLabel", Accent)
    Title.Size = UDim2.new(0.75, 0, 1, 0)
    Title.Position = UDim2.new(0.02, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Diablo Hub W.B"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    local credit = Instance.new("TextLabel", Accent)
    credit.Size = UDim2.new(0.23, -10, 1, 0)
    credit.Position = UDim2.new(0.75, 0, 0, 0)
    credit.BackgroundTransparency = 1
    credit.Text = "Made by Diablo"
    credit.TextColor3 = Color3.fromRGB(200, 200, 200)
    credit.Font = Enum.Font.Gotham
    credit.TextSize = 12
    credit.TextXAlignment = Enum.TextXAlignment.Right
    local content = Instance.new("Frame", MainFrame)
    content.Size = UDim2.new(1, -16, 1, -56)
    content.Position = UDim2.new(0, 8, 0, 48)
    content.BackgroundTransparency = 1
    local contentCorner = Instance.new("UICorner", content)
    contentCorner.CornerRadius = UDim.new(0, 12)
    local statsList = Instance.new("Frame", content)
    statsList.Size = UDim2.new(0.6, 0, 1, 0)
    statsList.Position = UDim2.new(0, 0, 0, 0)
    statsList.BackgroundTransparency = 1

    local function makeStatLabel(txt, y)
        local lbl = Instance.new("TextLabel", statsList)
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.Position = UDim2.new(0, 0, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
        lbl.Text = txt
        return lbl
    end

    local PingLabel = makeStatLabel("Ping: Calculating...", 0)
    local CashLabel = makeStatLabel("Earnings: $0", 22)
    local FPSLabel = makeStatLabel("FPS: Calculating...", 44)
    local TimerLabel = makeStatLabel("Time: 00:00:00", 66)
    local StatusLabel = makeStatLabel("Status: Stopped", 88)
    local controls = Instance.new("Frame", content)
    controls.Size = UDim2.new(0.4, 0, 1, 0)
    controls.Position = UDim2.new(0.6, 0, 0, 0)
    controls.BackgroundTransparency = 1
    local StartBtn = Instance.new("TextButton", controls)
    StartBtn.Size = UDim2.new(1, -10, 0, 36)
    StartBtn.Position = UDim2.new(0, 5, 0, 0)
    StartBtn.Text = "START"
    StartBtn.Font = Enum.Font.GothamBlack
    StartBtn.TextSize = 14
    StartBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
    StartBtn.BackgroundColor3 = Color3.fromRGB(120, 25, 200)
    StartBtn.AutoButtonColor = true
    StartBtn.BorderSizePixel = 0
    local StartCorner = Instance.new("UICorner", StartBtn)
    StartCorner.CornerRadius = UDim.new(0, 8)
    local StopBtn = Instance.new("TextButton", controls)
    StopBtn.Size = UDim2.new(1, -10, 0, 28)
    StopBtn.Position = UDim2.new(0, 5, 0, 44)
    StopBtn.Text = "STOP"
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextSize = 13
    StopBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    StopBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    StopBtn.AutoButtonColor = true
    StopBtn.BorderSizePixel = 0
    local StopCorner = Instance.new("UICorner", StopBtn)
    StopCorner.CornerRadius = UDim.new(0, 8)
    local pulse = Instance.new("Frame", Accent)
    pulse.Size = UDim2.new(0, 10, 0, 10)
    pulse.Position = UDim2.new(0.98, -20, 0.5, -5)
    pulse.AnchorPoint = Vector2.new(1, 0.5)
    pulse.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    pulse.BorderSizePixel = 0
    local pulseCorner = Instance.new("UICorner", pulse)
    pulseCorner.CornerRadius = UDim.new(0, 10)

    task.spawn(function()
        while AutoFarmUI.Parent and AutoFarmUI.Parent ~= nil do
            TweenService:Create(pulse, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.3, Size = UDim2.new(0, 14, 0, 14)}):Play()
            task.wait(1.8)
        end
    end)

    do
        local dragging, dragStart, startPos
        local currentTween
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true dragStart = input.Position startPos = MainFrame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        MainFrame.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local target = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                if currentTween then currentTween:Cancel() end
                currentTween = TweenService:Create(MainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = target})
                currentTween:Play()
            end
        end)
    end

    task.spawn(function()
        while true do
            local dt = RunService.RenderStepped:Wait()
            FPSLabel.Text = "FPS: " .. tostring(math.floor(1 / dt))
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.8)
            local perfStats = StatsService:FindFirstChild("PerformanceStats")
            if perfStats and perfStats:FindFirstChild("Ping") then PingLabel.Text = "Ping: " .. tostring(math.floor(perfStats.Ping:GetValue())) .. "ms" end
        end
    end)

    local leaderstats = localPlayer:WaitForChild("leaderstats")
    local cashStat = leaderstats:WaitForChild("$$")
    local initialCash = cashStat.Value
    local seconds, minutes, hours = 0, 0, 0

    task.spawn(function()
        while true do
            task.wait(0.9)
            local earned = cashStat.Value - initialCash
            CashLabel.Text = "Earnings: $" .. formatNumber(earned)
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            seconds = seconds + 1
            if seconds >= 60 then seconds = 0 minutes = minutes + 1 end
            if minutes >= 60 then minutes = 0 hours = hours + 1 end
            TimerLabel.Text = string.format("Time: %02d:%02d:%02d", hours, minutes, seconds)
        end
    end)

    local farmThread
    local function startFarming()
        if getgenv().AutoFarmActive then return end
        getgenv().AutoFarmActive = true
        StatusLabel.Text = "Status: Running"
        notify("AutoFarm started — Diablo & Westbound", 2.5)
        farmThread = coroutine.create(function()
            while getgenv().AutoFarmActive do
                local ok = pcall(function() farmOnce() end)
                task.wait(FAST_LOOP_INTERVAL)
            end
        end)
        coroutine.resume(farmThread)
    end

    local function resetProgress()
        initialCash = cashStat.Value
        seconds, minutes, hours = 0, 0, 0
        CashLabel.Text = "Earnings: $0"
        TimerLabel.Text = "Time: 00:00:00"
    end

    local function stopFarming()
        if not getgenv().AutoFarmActive then resetProgress() return end
        getgenv().AutoFarmActive = false
        StatusLabel.Text = "Status: Stopped"
        notify("AutoFarm stopped", 1.8)
        resetProgress()
    end

    StartBtn.MouseButton1Click:Connect(function() startFarming() end)
    StopBtn.MouseButton1Click:Connect(function() stopFarming() end)

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            AutoFarmUI:Destroy()
            notifierGui:Destroy()
            getgenv().AutoFarmActive = false
            resetProgress()
        end
    end)

    AutoFarmUI.AncestryChanged:Connect(function(_, parent) if not parent then getgenv().AutoFarmActive = false resetProgress() end end)

    localPlayer.CharacterAdded:Connect(function(char)
        character = char
        task.wait(0.2)
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        ensureAntiDeath(character)
    end)
end)

-- [[ DISCORD ]] --
AddScriptButton(DiscordTab, "TRXSH COMMUNITY", "Join for latest updates", "", "Copy", function() 
	if setclipboard then setclipboard(Settings.DiscordLink) end 
end)

-- [[ CREDITS ]] --
AddScriptButton(CreditsTab, "DEVELOPER", "Created by: henriqsz7", "Panel Owner", nil, nil)
AddScriptButton(CreditsTab, "LEGAL", "Rights reserved to henriqsz7", "Full Control", nil, nil)
AddScriptButton(CreditsTab, "VERSION", "3.1.0", "", nil, nil)

-- [[ SETTINGS ]] --
local AutoExeBtn = AddBasicButton(ConfigTab, "Auto Execute: OFF", function()
	Settings.AutoExecute = not Settings.AutoExecute
	AutoExeBtn.Text = "Auto Execute: " .. (Settings.AutoExecute and "ON" or "OFF")
end)

local BindBtn = AddBasicButton(ConfigTab, "Hide Bind: LeftControl", function() end)
local listening = false
BindBtn.MouseButton1Click:Connect(function() 
	listening = true 
	BindBtn.Text = "..." 
end)

-- [[ SISTEMA DE LOGIN COM WHITELIST HWID ]] --
local _K1 = "7b806f90-6d7e-4ea5-939e-be698aa6e629" -- Key Comum (24h)
local _KA = "henriqsz7" -- Sua Key Mestra

-- VOCÊ PRECISA COLOCAR O SEU ID AQUI PARA A KEY MESTRA FUNCIONAR
-- Execute o script uma vez e veja o seu ID no Console do Roblox (F9)
local MyPrivateID = "COLOQUE_SEU_ID_AQUI" 

AuthBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    local currentHardware = RbxAnalyticsService:GetClientId()
    
    local authenticated = false

    -- 1. Verifica se é a sua Key Mestra e se é o SEU computador
    if input == _KA then
        if currentHardware == MyPrivateID then
            authenticated = true
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "UNAUTHORIZED DEVICE!"
        end
    -- 2. Verifica se é a Key comum de 24h
    elseif input == _K1 then
        authenticated = true
    end

    if authenticated then
        SmoothTween(KeyFrame, 0.6, {Position = UDim2.new(0.5, -180, -1, 0), BackgroundTransparency = 1})
        task.wait(0.6)
        KeyFrame.Visible = false
        MainHub.Visible = true
        MainHub.Size = UDim2.new(0, 0, 0, 0)
        SmoothTween(MainHub, 0.5, {Size = UDim2.new(0, 700, 0, 450)})
    else
        -- Efeito de Erro
        if KeyInput.PlaceholderText ~= "UNAUTHORIZED DEVICE!" then
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "WRONG KEY!"
        end
        SmoothTween(KeyFrame, 0.1, {Position = UDim2.new(0.5, -175, 0.5, -140)})
        task.wait(0.1)
        SmoothTween(KeyFrame, 0.1, {Position = UDim2.new(0.5, -185, 0.5, -140)})
        task.wait(0.1)
        SmoothTween(KeyFrame, 0.1, {Position = UDim2.new(0.5, -180, 0.5, -140)})
    end
end)

-- COMANDO PARA VOCÊ DESCOBRIR SEU ID (Aparece no F9)
print("------------------------------------------")
print("SEU ID ÚNICO: " .. RbxAnalyticsService:GetClientId())
print("COPIE O ID ACIMA E COLOQUE NA VARIAVEL 'MyPrivateID' NO SCRIPT")
print("------------------------------------------")

GetKeyBtn.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard("https://work.ink/24Qe/key") end
end)

-- [[ LÓGICA DE TECLAS ]] --
UserInputService.InputBegan:Connect(function(input)
	if listening and input.UserInputType == Enum.UserInputType.Keyboard then
		Settings.HideKey = input.KeyCode
		BindBtn.Text = "Hide Bind: "..tostring(input.KeyCode.Name)
		listening = false
	elseif input.KeyCode == Settings.HideKey then
		Settings.IsVisible = not Settings.IsVisible
		MainHub.Visible = Settings.IsVisible
	end
end)

print("TRXSH HUB V3.1.0 - WHITELIST SYSTEM ACTIVE")
