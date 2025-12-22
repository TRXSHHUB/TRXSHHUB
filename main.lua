-- [[ TRXSH HUB V3 - PROTECTED SOURCE ]] --
-- [[ CREATED BY HENRIQSZ7 ]] --

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- [[ STRING DECODING ENGINE ]] --
local function _X(str)
    local newStr = ""
    for i = 1, #str do
        newStr = newStr .. string.char(string.byte(str, i))
    end
    return newStr
end

-- [[ SECURE LOAD FUNCTION ]] --
local function SecureLoad(rawUrl)
    local success, result = pcall(function()
        return game:HttpGet(rawUrl)
    end)
    
    if success then
        local func, err = loadstring(result)
        if func then
            func()
        else
            warn("Error parsing script: " .. tostring(err))
        end
    else
        warn("Error downloading script: " .. tostring(result))
    end
end

-- [[ URLS EM HEXADECIMAL (PROTEÇÃO CONTRA HTTP SPY) ]] --
local _U = {
    DIABLO = _X("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x70\x61\x73\x74\x65\x62\x69\x6e\x2e\x63\x6f\x6d\x2f\x72\x61\x77\x2f\x42\x33\x30\x75\x4c\x6b\x53\x4a"), 
    CLOUD = _X("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x72\x61\x77\x2e\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6f\x6e\x74\x65\x6e\x74\x2e\x63\x6f\x6d\x2f\x63\x6c\x6f\x75\x64\x6d\x61\x6e\x34\x34\x31\x36\x2f\x73\x63\x72\x69\x70\x74\x73\x2f\x6d\x61\x69\x6e\x2f\x4c\x6f\x61\x64\x65\x72\x2e\x6c\x75\x61"),
    FIRE = _X("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x72\x61\x77\x2e\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6f\x6e\x74\x65\x6e\x74\x2e\x63\x6f\x6d\x2f\x70\x72\x6f\x6a\x65\x63\x74\x73\x6c\x61\x79\x65\x72\x73\x66\x2f\x46\x69\x72\x65\x48\x75\x62\x2f\x6d\x61\x69\x6e\x2f\x4c\x6f\x61\x64\x65\x72\x2e\x6c\x75\x61"),
    FROST = _X("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x72\x61\x77\x2e\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6f\x6e\x74\x65\x6e\x74\x2e\x63\x6f\x6d\x2f\x63\x61\x74\x74\x65\x72\x63\x61\x74\x74\x79\x2f\x53\x63\x72\x69\x70\x74\x73\x2f\x6d\x61\x69\x6e\x2f\x4c\x6f\x61\x64\x65\x72\x2e\x6c\x75\x61"),
    IY = _X("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x72\x61\x77\x2e\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6f\x6e\x74\x65\x6e\x74\x2e\x63\x6f\x6d\x2f\x45\x64\x67\x65\x49\x59\x2f\x69\x6e\x66\x69\x6e\x69\x74\x65\x79\x69\x65\x6c\x64\x2f\x6d\x61\x73\x74\x65\x72\x2f\x73\x6f\x75\x72\x63\x65")
}

-- DETERMINA O PARENT
local TargetParent = (gethui and gethui()) or (CoreGui:FindFirstChild("RobloxGui") and CoreGui.RobloxGui) or PlayerGui

-- LIMPEZA
if TargetParent:FindFirstChild("TRXSH_HUB_V3_ULTIMATE") then
	TargetParent:FindFirstChild("TRXSH_HUB_V3_ULTIMATE"):Destroy()
end

local TRXSH_HUB = Instance.new("ScreenGui")
TRXSH_HUB.Name = "TRXSH_HUB_V3_ULTIMATE"
TRXSH_HUB.Parent = TargetParent
TRXSH_HUB.ResetOnSpawn = false
TRXSH_HUB.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ CONFIGURAÇÕES ]] --
local Settings = {
	AutoExecute = false,
	HideKey = Enum.KeyCode.LeftControl,
	IsVisible = true,
	DiscordLink = "https://discord.gg/3JSw8fDQbu",
	AccentColor = Color3.fromRGB(90, 50, 200),
	SecondaryColor = Color3.fromRGB(15, 15, 18)
}

-- [[ FUNÇÕES DE ESTÉTICA ]] --
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

-- PERFIL DO USUÁRIO
local UserInfo = Instance.new("Frame")
UserInfo.Parent = SideMenu
UserInfo.Size = UDim2.new(1, 0, 0, 60)
UserInfo.Position = UDim2.new(0, 0, 1, -60)
UserInfo.BackgroundTransparency = 1

local UserImg = Instance.new("ImageLabel")
UserImg.Parent = UserInfo
UserImg.Size = UDim2.new(0, 35, 0, 35)
UserImg.Position = UDim2.new(0, 15, 0, 12)
UserImg.Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=150&h=150"
Instance.new("UICorner", UserImg).CornerRadius = UDim.new(1, 0)

local UserN = Instance.new("TextLabel")
UserN.Parent = UserInfo
UserN.Position = UDim2.new(0, 60, 0, 12)
UserN.Size = UDim2.new(1, -70, 1, -24)
UserN.BackgroundTransparency = 1
UserN.Font = Enum.Font.GothamBold
UserN.Text = Player.DisplayName
UserN.TextColor3 = Color3.fromRGB(200, 200, 200)
UserN.TextSize = 11
UserN.TextXAlignment = Enum.TextXAlignment.Left

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

local BigTitle = Instance.new("TextLabel")
BigTitle.Name = "BigTitle"
BigTitle.Parent = ContentArea
BigTitle.Size = UDim2.new(1, 0, 1, 0)
BigTitle.BackgroundTransparency = 1
BigTitle.Font = Enum.Font.Michroma
BigTitle.Text = "TRXSH"
BigTitle.TextColor3 = Color3.fromRGB(30, 30, 35)
BigTitle.TextSize = 90
BigTitle.TextTransparency = 0.5
BigTitle.ZIndex = 0

MakeDraggable(MainHub)

-- [[ SISTEMA DE ABAS ]] --
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
		BigTitle.Visible = false
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

-- [[ FUNÇÕES DE COMPONENTES ]] --
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
	else
		Desc1.Size = UDim2.new(1, -20, 0, 0)
		Desc1.AutomaticSize = Enum.AutomaticSize.Y
		Desc1.TextWrapped = true
		Container.AutomaticSize = Enum.AutomaticSize.Y
		Container.Size = UDim2.new(0.95, 0, 0, 60)
	end
end

-- [[ CRIAÇÃO DAS ABAS (ORDEM ATUALIZADA) ]] --
local ProjectSlayers = CreateTab("PROJECT SLAYERS", 1)
local WestBound = CreateTab("WESTBOUND", 2)
local Universal = CreateTab("UNIVERSAL", 98)
local ConfigTab = CreateTab("SETTINGS", 99)
local DiscordTab = CreateTab("DISCORD", 100)
local CreditsTab = CreateTab("CREDITS", 101) -- ABA DE CRÉDITOS AGORA EM BAIXO DO DISCORD

-- [[ CONTEÚDO CREDITS (VERSÃO 3.1.0) ]] --
AddScriptButton(CreditsTab, "DEVELOPER INFORMATION", "Created by: henriqsz7", "Panel: TRXSH HUB", nil, nil)
AddScriptButton(CreditsTab, "LEGAL NOTICE", "All panel rights are reserved to 'henriqsz7', the creator of the entire panel layout.", "", nil, nil)
AddScriptButton(CreditsTab, "REMOVAL REQUEST", "If you own any of the scripts and do not want me to distribute them, request removal via my Discord server by sending a DM or opening a ticket.", "", nil, nil)
AddScriptButton(CreditsTab, "VERSION CONTROL", "Current Version: 3.1.0", "Status: Undetected", nil, nil)

-- [[ CONTEÚDO WESTBOUND ]] --
AddScriptButton(WestBound, "DIABLO HUB", "Auto farm money", "", "Execute", function()
    -- Link do Diablo Hub pode ser colocado aqui futuramente
end)

-- [[ CONTEÚDO PROJECT SLAYERS ]] --
AddScriptButton(ProjectSlayers, "CLOUD HUB", "Auto farm everything in the game", "Needs Key", "Execute", function()
	SecureLoad(_U.CLOUD)
end)
AddScriptButton(ProjectSlayers, "FIRE HUB", "Auto farm everything in the game", "Needs Key", "Execute", function()
	SecureLoad(_U.FIRE)
end)
AddScriptButton(ProjectSlayers, "FROSTIES HUB", "Auto farm everything in the game", "Needs Key", "Execute", function()
	SecureLoad(_U.FROST)
end)

-- [[ CONTEÚDO UNIVERSAL ]] --
AddScriptButton(Universal, "INFINITE YIELD", "Universal script commands", "", "Execute", function() 
	SecureLoad(_U.IY)
end)

-- [[ CONTEÚDO DISCORD ]] --
AddScriptButton(DiscordTab, "TRXSH HUB COMMUNITY", "Join our discord community to stay up to date with the latest news", "", "Copy", function() 
	if setclipboard then setclipboard(Settings.DiscordLink) end 
end)

-- [[ CONTEÚDO SETTINGS ]] --
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

-- [[ LÓGICA DE INPUT ]] --
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

-- [[ LOGIN SECURITY LAYER ]] --
local _K1 = _X("\x37\x62\x38\x30\x36\x66\x39\x30\x2d\x36\x64\x37\x65\x2d\x34\x65\x61\x35\x2d\x39\x33\x39\x65\x2d\x62\x65\x36\x39\x38\x61\x61\x36\x65\x36\x32\x39")
local _KA = _X("\x68\x65\x6e\x72\x69\x71\x73\x7a")

AuthBtn.MouseButton1Click:Connect(function()
	if KeyInput.Text == _K1 or KeyInput.Text == _KA then
		SmoothTween(KeyFrame, 0.5, {Position = UDim2.new(0.5, -180, -1, 0)})
		task.wait(0.5)
		KeyFrame.Visible = false
		MainHub.Visible = true
		MainHub.Size = UDim2.new(0,0,0,0)
		SmoothTween(MainHub, 0.6, {Size = UDim2.new(0, 700, 0, 450)})
	else
		KeyInput.Text = ""
		KeyInput.PlaceholderText = "WRONG KEY!"
	end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard("https://work.ink/24Qe/key") end
end)

print(_X("\x54\x52\x58\x53\x48\x20\x48\x55\x42\x20\x4c\x4f\x41\x44\x45\x44"))
