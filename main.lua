-- [[ TRXSH HUB V3.9.0 - FINAL PERFORMANCE & FIXES ]] --
-- [[ CREATED BY HENRIQSZ7 ]] --

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- [[ IDENTIFICADOR PRIVADO ]] --
local CurrentDeviceID = RbxAnalyticsService:GetClientId() 
local ADMIN_HWID = "43A96369-B46A-4A3F-A171-4DCB9A27F615"

-- [[ URL DATABASE ]] --
local _U = {
    CLOUD = "https://raw.githubusercontent.com/cloudman4416/scripts/main/Loader.lua",
    FIRE = "https://raw.githubusercontent.com/projectslayersf/FireHub/main/Loader.lua",
    FROST = "https://raw.githubusercontent.com/cattercatty/Scripts/main/Loader.lua",
    IY = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
    WEST = "https://raw.githubusercontent.com/TRXSH-DMN/TRXSH-HUB-WESTBOUND/refs/heads/main/main.lua",
    AIM_UNIVERSAL = "https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Aimbot%20V2%20GUI.lua"
}

local TargetParent = (gethui and gethui()) or (CoreGui:FindFirstChild("RobloxGui") and CoreGui.RobloxGui) or PlayerGui

if TargetParent:FindFirstChild("TRXSH_HUB_V3_ULTIMATE") then
	TargetParent:FindFirstChild("TRXSH_HUB_V3_ULTIMATE"):Destroy()
end

local TRXSH_HUB = Instance.new("ScreenGui")
TRXSH_HUB.Name = "TRXSH_HUB_V3_ULTIMATE"
TRXSH_HUB.Parent = TargetParent
TRXSH_HUB.ResetOnSpawn = false
TRXSH_HUB.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Settings = {
	AutoExecute = false,
	HideKey = Enum.KeyCode.LeftControl,
	IsVisible = true,
	DiscordLink = "https://discord.gg/D84MJ2rHSp",
	AccentColor = Color3.fromRGB(90, 50, 200),
	SecondaryColor = Color3.fromRGB(15, 15, 18),
    RainbowUI = false,
    PerformanceMode = false
}

-- [[ VARIÁVEIS DE ESTADO ]] --
getgenv().EspNameEnabled = false
getgenv().EspCorpoEnabled = false
getgenv().AimbotEnabled = false
getgenv().AimbotKey = Enum.KeyCode.E
getgenv().AimbotFOV = 150
getgenv().AimbotSmoothing = 0.15

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = getgenv().AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Settings.AccentColor

-- [[ FUNÇÕES AUXILIARES ]] --
local function ExecuteScript(url)
    local success, content = pcall(function() return game:HttpGet(url) end)
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

-- [[ LÓGICA DE ESP OTIMIZADA PARA ZERO LAG ]] --
local function UpdateEsp()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local char = plr.Character
            
            local existingName = char:FindFirstChild("TrxshName")
            if getgenv().EspNameEnabled then
                if not existingName then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "TrxshName"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 100, 0, 20)
                        billboard.Adornee = head
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.Parent = char

                        local label = Instance.new("TextLabel")
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = plr.Name
                        label.Font = Enum.Font.GothamBold
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextSize = 12
                        label.Parent = billboard
                    end
                end
            else
                if existingName then existingName:Destroy() end
            end

            local existingBody = char:FindFirstChild("TrxshEspCorpo")
            if getgenv().EspCorpoEnabled then
                if not existingBody then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "TrxshEspCorpo"
                    highlight.FillColor = Settings.AccentColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = char
                end
            else
                if existingBody then existingBody:Destroy() end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        UpdateEsp()
    end
end)

-- [[ SISTEMA DE AIMBOT WESTBOUND FIX ]] --
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = getgenv().AimbotFOV
    local mouseLocation = UserInputService:GetMouseLocation()

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - mouseLocation).Magnitude
                if distance < shortestDistance then
                    closest = v
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if getgenv().AimbotEnabled then
        FOVCircle.Visible = true
        FOVCircle.Position = UserInputService:GetMouseLocation()
        
        if UserInputService:IsKeyDown(getgenv().AimbotKey) then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = target.Character.HumanoidRootPart
                local targetPos = targetPart.Position
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), getgenv().AimbotSmoothing)
            end
        end
    else
        FOVCircle.Visible = false
    end
end)

-- [[ UI - KEY SYSTEM ]] --
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

-- [[ MAIN HUB ]] --
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

-- [[ COMPONENTES ]] --
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
		for _, b in pairs(TabList:GetChildren()) do if b:IsA("TextButton") then SmoothTween(b, 0.3, {BackgroundColor3 = Color3.fromRGB(20, 20, 24), TextColor3 = Color3.fromRGB(150, 150, 150)}) end end
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

local function AddScriptButton(page, name, line1, line2, btnText, callback, specialLine, descColor)
	local Container = Instance.new("Frame")
	Container.Parent = page
    local containerHeight = specialLine and 110 or 75
	Container.Size = UDim2.new(0.95, 0, 0, containerHeight)
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
	Desc1.TextColor3 = descColor or Color3.fromRGB(150, 150, 150)
	Desc1.TextSize = 11
	Desc1.TextXAlignment = Enum.TextXAlignment.Left

	local Desc2 = Instance.new("TextLabel")
	Desc2.Parent = Container
	Desc2.Size = UDim2.new(1, -100, 0, 15)
	Desc2.Position = UDim2.new(0, 10, 0, 45)
	Desc2.BackgroundTransparency = 1
	Desc2.Font = Enum.Font.GothamMedium
	Desc2.Text = line2
    Desc2.TextColor3 = (line2 == "PATCHED" or line2 == "Needs Key" or line2 == "Latest Version" or line2 == "OPTIMIZED FOR WESTBOUND" or line2 == "Universal" or line2 == "BY HENRIQSZ7") and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(150, 150, 150)
    
    -- Ajuste específico para o texto branco do Universal
    if name == "AIMBOT + ESP" and line2 == "Universal" then
        Desc1.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

	Desc2.TextXAlignment = Enum.TextXAlignment.Left
    
    if specialLine then
        local Desc3 = Instance.new("TextLabel")
        Desc3.Parent = Container
        Desc3.Size = UDim2.new(1, -15, 0, 40)
        Desc3.Position = UDim2.new(0, 10, 0, 63)
        Desc3.BackgroundTransparency = 1
        Desc3.Font = Enum.Font.GothamBold
        Desc3.Text = specialLine
        Desc3.TextColor3 = Color3.fromRGB(255, 50, 50)
        Desc3.TextSize = 10
        Desc3.TextXAlignment = Enum.TextXAlignment.Left
        Desc3.TextWrapped = true
    end

	if btnText then
		local ExecBtn = Instance.new("TextButton")
		ExecBtn.Parent = Container
		ExecBtn.Size = UDim2.new(0, 85, 0, 32)
		ExecBtn.Position = UDim2.new(1, -95, 0, 20)
		ExecBtn.BackgroundColor3 = Settings.AccentColor
		ExecBtn.Text = btnText
		ExecBtn.Font = Enum.Font.GothamBold
		ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		ExecBtn.TextSize = 12
		Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)
        local ES = Instance.new("UIStroke", ExecBtn)
        ES.Color = Color3.fromRGB(255,255,255)
        ES.Transparency = 0.8
		ExecBtn.MouseButton1Click:Connect(function()
            if btnText == "Copy Link" then
                callback()
                ExecBtn.Text = "COPIED!"
                ExecBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
                task.wait(2)
                ExecBtn.Text = "Copy Link"
                ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                callback()
            end
        end)
        ApplyHover(ExecBtn, Settings.AccentColor, Color3.fromRGB(110, 70, 220), ES)
	end
end

-- [[ ABAS ]] --
local ProjectSlayers = CreateTab("PROJECT SLAYERS", 1)
local WestBound = CreateTab("WESTBOUND", 2)
local Universal = CreateTab("UNIVERSAL", 98)
local ConfigTab = CreateTab("SETTINGS", 99)
local DiscordTab = CreateTab("DISCORD", 100)
local CreditsTab = CreateTab("CREDITS", 101)

-- [[ ABA SLAYERS ]] --
AddScriptButton(ProjectSlayers, "FROSTIES HUB", "Auto farm everything", "Needs Key", "Execute", function() ExecuteScript(_U.FROST) end)
AddScriptButton(ProjectSlayers, "CLOUD HUB", "Auto farm everything", "Needs Key", "Execute", function() ExecuteScript(_U.CLOUD) end)
AddScriptButton(ProjectSlayers, "FIRE HUB", "Auto farm everything", "PATCHED", "Execute", function() ExecuteScript(_U.FIRE) end)

-- [[ ABA WESTBOUND ]] --
AddScriptButton(WestBound, "TRXSH HUB", "Auto farm money", "Latest Version", "Execute", function() ExecuteScript(_U.WEST) end, "YOU NEED TO EXECUTE BEFORE SPAWNING.")
AddScriptButton(WestBound, "ESP NAME INFO", "See names through walls", "BY HENRIQSZ7", "Execute", function() getgenv().EspNameEnabled = not getgenv().EspNameEnabled end)
AddScriptButton(WestBound, "ESP CORPO", "Highlight player bodies", "BY HENRIQSZ7", "Execute", function() getgenv().EspCorpoEnabled = not getgenv().EspCorpoEnabled end)
AddScriptButton(WestBound, "AIMBOT (FIXED)", "Lock-on Body (Key: E)", "BY HENRIQSZ7", "Execute", function() getgenv().AimbotEnabled = not getgenv().AimbotEnabled end)

-- [[ ABA UNIVERSAL ]] --
AddScriptButton(Universal, "AIMBOT + ESP", "Works in almost all games", "Universal", "Execute", function() ExecuteScript(_U.AIM_UNIVERSAL) end)
AddScriptButton(Universal, "INFINITE YIELD", "Universal script commands", "", "Execute", function() ExecuteScript(_U.IY) end)

-- [[ SETTINGS ]] --
AddBasicButton(ConfigTab, "Full Bright", function() Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false end)
AddBasicButton(ConfigTab, "Unlock FPS", function() if setfpscap then setfpscap(999) end end)
AddBasicButton(ConfigTab, "Rejoin Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end)
AddBasicButton(ConfigTab, "Anti-Afk", function() 
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
end)

AddBasicButton(ConfigTab, "Auto Execute: " .. (Settings.AutoExecute and "ON" or "OFF"), function(btn)
    Settings.AutoExecute = not Settings.AutoExecute
    btn.Text = "Auto Execute: " .. (Settings.AutoExecute and "ON" or "OFF")
end)

AddBasicButton(ConfigTab, "Change Hide Key (Bind)", function(btn)
    btn.Text = "Press any key..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Settings.HideKey = input.KeyCode
            btn.Text = "Hide Key: " .. input.KeyCode.Name
            connection:Disconnect()
        end
    end)
end)

AddBasicButton(ConfigTab, "Rainbow UI: " .. (Settings.RainbowUI and "ON" or "OFF"), function(btn)
    Settings.RainbowUI = not Settings.RainbowUI
    btn.Text = "Rainbow UI: " .. (Settings.RainbowUI and "ON" or "OFF")
end)

AddBasicButton(ConfigTab, "Performance Mode (No Textures)", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
    end
end)

local FpsCounter = Instance.new("TextLabel", MainHub)
FpsCounter.Size = UDim2.new(0, 100, 0, 20)
FpsCounter.Position = UDim2.new(0, 195, 0, 10)
FpsCounter.BackgroundTransparency = 1
FpsCounter.TextColor3 = Color3.fromRGB(200, 200, 200)
FpsCounter.Font = Enum.Font.GothamBold
FpsCounter.TextSize = 12
FpsCounter.TextXAlignment = Enum.TextXAlignment.Left
FpsCounter.Visible = false

AddBasicButton(ConfigTab, "Show FPS Counter", function()
    FpsCounter.Visible = not FpsCounter.Visible
end)

-- Loop FPS & Rainbow
task.spawn(function()
    local lastUpdate = tick()
    local frames = 0
    while task.wait() do
        frames = frames + 1
        if tick() - lastUpdate >= 1 then
            FpsCounter.Text = "FPS: " .. frames
            frames = 0
            lastUpdate = tick()
        end
        if Settings.RainbowUI then
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 0.8, 1)
            MainStroke.Color = color
            Logo.TextColor3 = color
            FOVCircle.Color = color
        else
            MainStroke.Color = Settings.AccentColor
            Logo.TextColor3 = Settings.AccentColor
            FOVCircle.Color = Settings.AccentColor
        end
    end
end)

-- [[ DISCORD ]] --
AddScriptButton(DiscordTab, "TRXSH HUB COMMUNITY", "Join official community", "Get News", "Copy Link", function() if setclipboard then setclipboard(Settings.DiscordLink) end end)

-- [[ CREDITS ]] --
AddScriptButton(CreditsTab, "PROJECT OWNER", "henriqsz7", "All UI/Logic", nil, nil)
AddScriptButton(CreditsTab, "UI DESIGNER", "henriqsz7", "Modern Dark Theme", nil, nil)
AddScriptButton(CreditsTab, "VERSION", "3.9.0", "Aimbot & ESP Fix", nil, nil)
AddScriptButton(CreditsTab, "DEVELOPMENT STATUS", "Stable", "Optimized for performance", nil, nil)

-- [[ SISTEMA DE AUTH ]] --
local function Decode(t)
    local s = ""
    for _, b in ipairs(t) do s = s .. string.char(b) end
    return s
end
local _V1 = {55,98,56,48,54,102,57,48,45,54,100,55,101,45,52,101,97,53,45,57,51,57,101,45,98,101,54,57,56,97,97,54,101,54,50,57}
local _V2 = {104,101,110,114,105,113,115,122,55}

local function OpenHub()
    KeyFrame.Visible = false
    MainHub.Visible = true
    MainHub.Size = UDim2.new(0, 0, 0, 0)
    SmoothTween(MainHub, 0.5, {Size = UDim2.new(0, 700, 0, 450)})
    if Settings.AutoExecute then
        ExecuteScript(_U.WEST)
    end
end

task.spawn(function() if CurrentDeviceID == ADMIN_HWID then OpenHub() end end)

AuthBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == Decode(_V2) or KeyInput.Text == Decode(_V1) then OpenHub() else KeyInput.Text = "WRONG KEY!" end
end)

GetKeyBtn.MouseButton1Click:Connect(function() if setclipboard then setclipboard("https://work.ink/24Qe/key") end end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Settings.HideKey then
		Settings.IsVisible = not Settings.IsVisible
		MainHub.Visible = Settings.IsVisible
	end
end)
