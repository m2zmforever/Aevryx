local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local AevryxLib = {
	["Theme"] = {
		["Font"] = "RobotoMono",
		["AccentColor"] = Color3.fromRGB(60, 60, 60),
		["AccentColor2"] = Color3.fromRGB(120, 120, 130),
		["FontColor"] = Color3.fromRGB(255, 255, 255),
		["BackgroundColor"] = Color3.fromRGB(14, 14, 18),
		["PanelColor"] = Color3.fromRGB(22, 22, 28),
		["SectionColor"] = Color3.fromRGB(28, 28, 36),
		["HideKey"] = "LeftControl"
	},
}

local CreateModule = { reg = {} }

local function AddToReg(Instance)
	table.insert(CreateModule["reg"], Instance)
end

local function Darker(Col, coe)
	local H, S, V = Color3.toHSV(Col)
	return Color3.fromHSV(H, S, V / (coe or 1.5))
end

local function Brighter(Col, coe)
	local H, S, V = Color3.toHSV(Col)
	return Color3.fromHSV(H, S, math.clamp(V * (coe or 1.5), 0, 1))
end

local function getEnumMember(enumType, memberName)
	local ok, res = pcall(function() return enumType[memberName] end)
	if ok then return res end
	return nil
end

local function Tween(inst, props, time, style, dir)
	return TweenService:Create(inst, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
end

function AevryxLib.Main(Name, X, Y)
	X = X or 700
	Y = Y or 430
	local SIDEBAR = 168

	for i, v in next, game.CoreGui:GetChildren() do
		if v.Name == "AevryxLib" then
			v:Destroy()
		end
	end

	local ScreenGui = CreateModule.Instance("ScreenGui", {
		Name = "AevryxLib";
		Parent = game.CoreGui;
		IgnoreGuiInset = true;
		ResetOnSpawn = false;
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	})
	AevryxLib.ScreenGui = ScreenGui

	local LoadingScreen = CreateModule.Instance("Frame", {
		Name = "LoadingScreen";
		Parent = ScreenGui;
		BackgroundColor3 = Color3.fromRGB(10, 10, 14);
		BackgroundTransparency = 0;
		BorderSizePixel = 0;
		Position = UDim2.new(0.5, 0, 0.5, 0);
		Size = UDim2.new(0, 300, 0, 120);
		AnchorPoint = Vector2.new(0.5, 0.5);
		ZIndex = 100;
	})
	CreateModule.Instance("UICorner", { Parent = LoadingScreen; CornerRadius = UDim.new(0, 12) })
	local LoadingGrad = CreateModule.Instance("UIGradient", {
		Parent = LoadingScreen;
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12)),
		});
		Rotation = 90;
	})
	CreateModule.Instance("UIStroke", { Parent = LoadingScreen; Thickness = 1.5; Color = AevryxLib["Theme"]["AccentColor"]; Transparency = 0 })

	local LoadingTitle = CreateModule.Instance("ImageLabel", {
		Parent = LoadingScreen;
		Name = "Title";
		BackgroundTransparency = 1;
		Image = "rbxassetid://88607367141872";
		ImageTransparency = 0;
		ScaleType = Enum.ScaleType.Fit;
		AnchorPoint = Vector2.new(0.5, 0);
		Position = UDim2.new(0.5, 0, 0.12, 0);
		Size = UDim2.new(0, 64, 0, 64);
		ZIndex = 101;
	})

	local LoadingStatus = CreateModule.Instance("TextLabel", {
		Parent = LoadingScreen;
		Name = "Status";
		BackgroundTransparency = 1;
		Font = Enum.Font[AevryxLib["Theme"]["Font"]];
		Text = "Loading...";
		TextSize = 13;
		TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.6);
		Position = UDim2.new(0, 0, 0.74, 0);
		Size = UDim2.new(1, 0, 0.22, 0);
		ZIndex = 101;
	})

	local BannedUsers = {
		["OttomanGrandson55"] = true;
		["SeishiroHasan"] = true;
		["Hello_KkittyEy"] = true;
		["r3iyqw"] = true;
	}

	local LocalPlayer = game:GetService("Players").LocalPlayer
	local PlayerName = LocalPlayer and LocalPlayer.Name or ""

	if BannedUsers[PlayerName] then
		LoadingTitle.Visible = false
		LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
		LoadingScreen.Position = UDim2.new(0, 0, 0, 0)
		LoadingScreen.AnchorPoint = Vector2.new(0, 0)
		LoadingGrad.Color = ColorSequence.new(Color3.fromRGB(20, 0, 0), Color3.fromRGB(0, 0, 0))
		LoadingStatus.Text = "Fuck off from my script."
		LoadingStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
		LoadingStatus.TextSize = 28
		LoadingStatus.Position = UDim2.new(0, 0, 0.45, 0)
		LoadingStatus.Size = UDim2.new(1, 0, 0.1, 0)

		local GlitchSound = CreateModule.Instance("Sound", {
			Parent = ScreenGui;
			Name = "Glitch";
			SoundId = "rbxassetid://129148387097748";
			Volume = 1;
			Looped = true;
			PlayOnRemove = false;
		})
		GlitchSound:Play()

		local Banned = true
		spawn(function()
			while Banned do
				local toggle = (tick() % 0.5) < 0.25
				if toggle then
					LoadingScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					LoadingStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
				else
					LoadingScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					LoadingStatus.TextColor3 = Color3.fromRGB(0, 0, 0)
				end
				RunService.RenderStepped:Wait()
			end
		end)

		spawn(function()
			wait(5)
			if LocalPlayer then
				LocalPlayer:Kick("Get another script faggot.")
			end
		end)

		RunService.RenderStepped:Wait()
		return AevryxLib
	end

	local loadingSteps = { "Loading Modules...", "Loading UI...", "Loading Config...", "Welcome To Aevryx..." }
	for _, step in ipairs(loadingSteps) do
		LoadingStatus.Text = step
		wait(step == "Welcome To Aevryx..." and 0.5 or 0.45)
	end

	Tween(LoadingScreen, { BackgroundTransparency = 1 }):Play()
	Tween(LoadingTitle, { ImageTransparency = 1 }):Play()
	Tween(LoadingStatus, { TextTransparency = 1 }):Play()
	wait(0.35)
	LoadingScreen:Destroy()

	local MainFrame = CreateModule.Instance("Frame", {
		Name = "MainFrame";
		Parent = ScreenGui;
		BackgroundColor3 = AevryxLib["Theme"]["BackgroundColor"];
		BorderSizePixel = 0;
		Position = UDim2.new(0.5, 0, 0.5, 0);
		Size = UDim2.new(0, X, 0, Y);
		AnchorPoint = Vector2.new(0.5, 0.5);
		ClipsDescendants = true;
		ZIndex = 2;
		Visible = false;
	})
	CreateModule.Instance("UICorner", { Parent = MainFrame; CornerRadius = UDim.new(0, 10) })

	CreateModule.Instance("UIGradient", {
		Parent = MainFrame;
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
			ColorSequenceKeypoint.new(0.5, AevryxLib["Theme"]["BackgroundColor"]),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 14)),
		});
		Rotation = 35;
	})

	local Border = CreateModule.Instance("Frame", {
		Name = "Border";
		Parent = MainFrame;
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
		ZIndex = 6;
	})
	CreateModule.Instance("UICorner", { Parent = Border; CornerRadius = UDim.new(0, 10) })
	CreateModule.Instance("UIStroke", {
		Parent = Border;
		Thickness = 1.4;
		Color = AevryxLib["Theme"]["AccentColor"];
		Transparency = 0.35;
	})

	local AccentLine = CreateModule.Instance("Frame", {
		Parent = MainFrame;
		BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"];
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 0, 3);
		ZIndex = 7;
	})
	CreateModule.Instance("UIGradient", {
		Parent = AccentLine;
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, AevryxLib["Theme"]["AccentColor"]),
			ColorSequenceKeypoint.new(0.5, AevryxLib["Theme"]["AccentColor2"]),
			ColorSequenceKeypoint.new(1, AevryxLib["Theme"]["AccentColor"]),
		});
	})

	local Sidebar = CreateModule.Instance("Frame", {
		Name = "Sidebar";
		Parent = MainFrame;
		BackgroundColor3 = AevryxLib["Theme"]["PanelColor"];
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(0, SIDEBAR, 1, 0);
		ZIndex = 3;
	})
	CreateModule.Instance("UICorner", { Parent = Sidebar; CornerRadius = UDim.new(0, 10) })
	CreateModule.Instance("Frame", {
		Parent = Sidebar;
		BackgroundColor3 = AevryxLib["Theme"]["PanelColor"];
		BorderSizePixel = 0;
		Position = UDim2.new(0.86, 0, 0, 0);
		Size = UDim2.new(0.14, 0, 1, 0);
		ZIndex = 3;
	})

	local Logo = CreateModule.Instance("ImageLabel", {
		Parent = Sidebar;
		BackgroundTransparency = 1;
		Image = "rbxassetid://88607367141872";
		ScaleType = Enum.ScaleType.Fit;
		Position = UDim2.new(0.5, 0, 0.04, 0);
		AnchorPoint = Vector2.new(0.5, 0);
		Size = UDim2.new(0, 52, 0, 52);
		ZIndex = 4;
	})
	local LogoText = CreateModule.Instance("TextLabel", {
		Parent = Sidebar;
		BackgroundTransparency = 1;
		Font = Enum.Font[AevryxLib["Theme"]["Font"]];
		Text = "AEVRYX";
		TextSize = 18;
		TextColor3 = AevryxLib["Theme"]["FontColor"];
		Position = UDim2.new(0, 0, 0.17, 0);
		Size = UDim2.new(1, 0, 0.06, 0);
		ZIndex = 4;
	})
	CreateModule.Instance("Frame", {
		Parent = Sidebar;
		BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"];
		BorderSizePixel = 0;
		Position = UDim2.new(0.15, 0, 0.245, 0);
		Size = UDim2.new(0.7, 0, 0, 1);
		ZIndex = 4;
	})

	local TabsList = CreateModule.Instance("Frame", {
		Parent = Sidebar;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0.28, 0);
		Size = UDim2.new(1, 0, 0.72, -8);
		ZIndex = 4;
	})
	CreateModule.Instance("UIListLayout", {
		Parent = TabsList;
		FillDirection = Enum.FillDirection.Vertical;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = UDim.new(0, 6);
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
	})
	CreateModule.Instance("UIPadding", {
		Parent = TabsList;
		PaddingTop = UDim.new(0, 6);
		PaddingBottom = UDim.new(0, 6);
		PaddingLeft = UDim.new(0, 10);
		PaddingRight = UDim.new(0, 10);
	})

	local Content = CreateModule.Instance("Frame", {
		Name = "Content";
		Parent = MainFrame;
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0, SIDEBAR, 0, 0);
		Size = UDim2.new(1, -SIDEBAR, 1, 0);
		ClipsDescendants = true;
		ZIndex = 2;
	})

	local ParticleBG = CreateModule.Instance("Frame", {
		Parent = Content;
		Name = "ParticleBackground";
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
		ZIndex = 0;
	})

	local PARTICLE_COUNT = 30
	local PARTICLE_COLOR = Color3.fromRGB(90, 90, 100)
	local PARTICLE_MIN_SIZE = 4
	local PARTICLE_MAX_SIZE = 12
	local PARTICLE_MIN_SPEED = 8
	local PARTICLE_MAX_SPEED = 18
	local PARTICLE_MIN_ALPHA = 0.06
	local PARTICLE_MAX_ALPHA = 0.22
	local particles = {}
	for i = 1, PARTICLE_COUNT do
		local size = PARTICLE_MIN_SIZE + math.random() * (PARTICLE_MAX_SIZE - PARTICLE_MIN_SIZE)
		local alpha = PARTICLE_MIN_ALPHA + math.random() * (PARTICLE_MAX_ALPHA - PARTICLE_MIN_ALPHA)
		local dot = CreateModule.Instance("Frame", {
			Parent = ParticleBG;
			Name = "Particle" .. i;
			BackgroundColor3 = PARTICLE_COLOR;
			BackgroundTransparency = 1 - alpha;
			BorderSizePixel = 0;
			Position = UDim2.new(math.random(), 0, math.random(), 0);
			Size = UDim2.new(0, size, 0, size);
			ZIndex = 1;
		})
		CreateModule.Instance("UICorner", { Parent = dot; CornerRadius = UDim.new(1, 0) })
		table.insert(particles, {
			frame = dot,
			posX = math.random(),
			posY = math.random(),
			velX = (math.random() - 0.5) * 2,
			velY = -0.2 - math.random() * 0.8,
			speed = PARTICLE_MIN_SPEED + math.random() * (PARTICLE_MAX_SPEED - PARTICLE_MIN_SPEED),
			baseAlpha = alpha,
			pulseTime = math.random() * math.pi * 2,
			pulseSpeed = 0.3 + math.random() * 0.7,
			pulseRange = 0.08 + math.random() * 0.15,
		})
	end
	spawn(function()
		while true do
			local dt = RunService.RenderStepped:Wait()
			for _, p in ipairs(particles) do
				p.posX = p.posX + p.velX * p.speed * dt * 0.01
				p.posY = p.posY + p.velY * p.speed * dt * 0.01
				if p.posY < -0.1 then p.posY = 1.1; p.posX = math.random() end
				if p.posX < -0.1 then p.posX = 1.1 elseif p.posX > 1.1 then p.posX = -0.1 end
				p.pulseTime = p.pulseTime + p.pulseSpeed * dt
				local pulseAlpha = math.clamp(p.baseAlpha + math.sin(p.pulseTime) * p.pulseRange, 0.02, 0.25)
				if p.frame and p.frame.Parent then
					p.frame.Position = UDim2.new(p.posX, 0, p.posY, 0)
					p.frame.BackgroundTransparency = 1 - pulseAlpha
				end
			end
		end
	end)

	local Pages = CreateModule.Instance("Frame", {
		Parent = Content;
		Name = "Tabs";
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
		ZIndex = 2;
	})
	local PageLayout = CreateModule.Instance("UIPageLayout", {
		Parent = Pages;
		Name = "PagesLayout";
		Padding = UDim.new(0, 10);
		TweenTime = 0.35;
		EasingDirection = Enum.EasingDirection.Out;
		EasingStyle = Enum.EasingStyle.Sine;
		FillDirection = Enum.FillDirection.Vertical;
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		ScrollWheelInputEnabled = false;
	})

	local BannerImage = CreateModule.Instance("ImageLabel", {
		Name = "BannerImage";
		Parent = MainFrame;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Image = "rbxassetid://138902649769382";
		ImageTransparency = 0;
		ScaleType = Enum.ScaleType.Fit;
		AnchorPoint = Vector2.new(0, 1);
		Position = UDim2.new(0, 10, 1, 35);
		Size = UDim2.new(0, 200, 0, 200);
		ZIndex = 8;
	})

	local TabButtonsList = {}
	local TabCount = 0
	local IsGuiOpened = true

	local function SelectTab(TabButton, Page)
		for _, v in next, TabsList:GetChildren() do
			if v:IsA("TextButton") then
				local active = (v == TabButton)
				v.IsActive.Value = active
				if active then
					v.BackgroundColor3 = AevryxLib["Theme"]["AccentColor"]
					v.BackgroundTransparency = 0.15
					v.TextColor3 = AevryxLib["Theme"]["FontColor"]
				else
					v.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					v.BackgroundTransparency = 1
					v.TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.8)
				end
				local ind = v:FindFirstChild("Indicator")
				if ind then Tween(ind, { BackgroundTransparency = active and 0 or 1 }, 0.3):Play() end
			end
		end
		for _, v in next, Pages:GetChildren() do
			if v.Name ~= Page.Name and v:FindFirstChild("Fader") then
				Tween(v.Fader, { BackgroundTransparency = 0 }, 0.3):Play()
				spawn(function()
					wait(0.34)
					PageLayout:JumpTo(Page)
					Tween(v.Fader, { BackgroundTransparency = 1 }, 0.3):Play()
				end)
			end
		end
	end

	InputService.InputBegan:Connect(function(input, IsTyping)
		if IsTyping then return end
		local keyName = AevryxLib["Theme"]["HideKey"]
		local keyEnum = getEnumMember(Enum.KeyCode, keyName)
		local uitEnum = getEnumMember(Enum.UserInputType, keyName)
		if (keyEnum and input.KeyCode == keyEnum) or (uitEnum and input.UserInputType == uitEnum) then
			spawn(function()
				IsGuiOpened = not IsGuiOpened
				Tween(MainFrame, { BackgroundTransparency = IsGuiOpened and 0 or 1 }, 0.25):Play()
				wait(0.05)
				MainFrame.Visible = IsGuiOpened
			end)
		end
	end)

	local dragging, dragStart, startPos
	local function startDrag(input)
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		local con
		con = RunService.RenderStepped:Connect(function()
			if not dragging then con:Disconnect() end
		end)
	end
	AccentLine.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.AbsolutePosition
			local moveCon
			moveCon = InputService.InputChanged:Connect(function(m)
				if m == input then
					local delta = m.Position - dragStart
					MainFrame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
				end
			end)
			local upCon
			upCon = InputService.InputEnded:Connect(function(e)
				if e == input then
					dragging = false
					moveCon:Disconnect(); upCon:Disconnect()
				end
			end)
		end
	end)

	local InMain = {}
	local ActiveNotifications = {}
	local NotificationOffset = 0.12

	local function UpdateNotificationPositions()
		for i, notification in ipairs(ActiveNotifications) do
			local newYOffset = 0.8 - (NotificationOffset * (i - 1))
			Tween(notification, { Position = UDim2.new(0.78, 0, newYOffset, 0) }, 0.3):Play()
		end
	end

	function InMain.Notification(HeaderText, Text)
		local yOffset = 0.8 - (NotificationOffset * #ActiveNotifications)
		local Bar = CreateModule.Instance("Frame", {
			Parent = ScreenGui;
			Name = HeaderText;
			BackgroundColor3 = AevryxLib["Theme"]["PanelColor"];
			BorderSizePixel = 0;
			Position = UDim2.new(1, 20, yOffset, 0);
			Size = UDim2.new(0.2, 0, 0.12, 0);
			ClipsDescendants = true;
			BackgroundTransparency = 1;
			ZIndex = 20 + #ActiveNotifications;
		})
		CreateModule.Instance("UICorner", { Parent = Bar; CornerRadius = UDim.new(0, 8) })
		CreateModule.Instance("UIStroke", {
			Parent = Bar;
			Thickness = 1;
			Color = AevryxLib["Theme"]["AccentColor2"];
			Transparency = 0.4;
		})
		CreateModule.Instance("Frame", {
			Parent = Bar;
			BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"];
			BorderSizePixel = 0;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(0, 4, 1, 0);
			ZIndex = 21;
		})
		local HeaderLabel = CreateModule.Instance("TextLabel", {
			Parent = Bar;
			Font = Enum.Font[AevryxLib["Theme"]["Font"]];
			Text = HeaderText;
			TextSize = 16;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextXAlignment = Enum.TextXAlignment.Left;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim2.new(0.06, 0, 0.06, 0);
			Size = UDim2.new(0.9, 0, 0.25, 0);
			ZIndex = 22;
		})
		local InformationLabel = CreateModule.Instance("TextLabel", {
			Parent = Bar;
			Font = Enum.Font[AevryxLib["Theme"]["Font"]];
			Text = Text;
			TextSize = 13;
			TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.6);
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Top;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim2.new(0.06, 0, 0.34, 0);
			Size = UDim2.new(0.9, 0, 0.6, 0);
			TextWrapped = true;
			ZIndex = 22;
		})
		table.insert(ActiveNotifications, Bar)
		spawn(function()
			Tween(Bar, { Position = UDim2.new(0.78, 0, yOffset, 0), BackgroundTransparency = 0 }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
			wait(4)
			Tween(Bar, { Position = UDim2.new(1, 20, yOffset, 0), BackgroundTransparency = 1 }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In):Play()
			wait(0.5)
			for i, n in ipairs(ActiveNotifications) do
				if n == Bar then table.remove(ActiveNotifications, i); break end
			end
			UpdateNotificationPositions()
			Bar:Destroy()
		end)
	end
	InMain.Notification = InMain.Notification

	function InMain.Tab(Text)
		TabCount += 1
		local TabButton = CreateModule.Instance("TextButton", {
			Parent = TabsList;
			Name = "TabButton";
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Size = UDim2.new(1, 0, 0, 34);
			Font = Enum.Font[AevryxLib["Theme"]["Font"]];
			Text = Text;
			TextSize = 15;
			TextXAlignment = Enum.TextXAlignment.Left;
			AutoButtonColor = false;
			ZIndex = 4;
		})
		CreateModule.Instance("UICorner", { Parent = TabButton; CornerRadius = UDim.new(0, 6) })
		local Indicator = CreateModule.Instance("Frame", {
			Parent = TabButton;
			Name = "Indicator";
			BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"];
			BorderSizePixel = 0;
			Position = UDim2.new(0, 0, 0.15, 0);
			Size = UDim2.new(0, 3, 0, 0.7, 0);
			BackgroundTransparency = 1;
			ZIndex = 5;
		})
		local IsTabActive = CreateModule.Instance("BoolValue", { Parent = TabButton; Name = "IsActive"; Value = (TabCount == 1) })
		TabButton.TextColor3 = IsTabActive.Value and AevryxLib["Theme"]["FontColor"] or Darker(AevryxLib["Theme"]["FontColor"], 1.8)

		TabButton.MouseEnter:Connect(function()
			if not IsTabActive.Value then
				Tween(TabButton, { BackgroundTransparency = 0.85, TextColor3 = AevryxLib["Theme"]["FontColor"] }, 0.2):Play()
			end
		end)
		TabButton.MouseLeave:Connect(function()
			if not IsTabActive.Value then
				Tween(TabButton, { BackgroundTransparency = 1, TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.8) }, 0.2):Play()
			end
		end)
		TabButton.MouseButton1Click:Connect(function()
			SelectTab(TabButton, Page)
		end)

		local Page = CreateModule.Instance("Frame", {
			Parent = Pages;
			Name = Text;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(0.96, 0, 1, 0);
		})

		local PageList = CreateModule.Instance("Frame", {
			Parent = Page;
			Name = "PageList";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim2.new(0.012, 0, 0.02, 0);
			Size = UDim2.new(0.49, 0, 0.96, 0);
		})
		local PageList2 = CreateModule.Instance("Frame", {
			Parent = Page;
			Name = "PageList2";
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim2.new(0.51, 0, 0.02, 0);
			Size = UDim2.new(0.49, 0, 0.96, 0);
		})
		CreateModule.Instance("UIListLayout", {
			Parent = PageList;
			Padding = UDim.new(0, 12);
			HorizontalAlignment = Enum.HorizontalAlignment.Left;
			SortOrder = Enum.SortOrder.LayoutOrder;
		})
		CreateModule.Instance("UIListLayout", {
			Parent = PageList2;
			Padding = UDim.new(0, 12);
			HorizontalAlignment = Enum.HorizontalAlignment.Left;
			SortOrder = Enum.SortOrder.LayoutOrder;
		})

		local Fader = CreateModule.Instance("Frame", {
			Parent = Page;
			Name = "Fader";
			BackgroundColor3 = AevryxLib["Theme"]["BackgroundColor"];
			BorderSizePixel = 0;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(1, 0, 1, 0);
			ZIndex = 2;
		})

		if TabCount == 1 then
			PageLayout:JumpTo(Page)
			Fader.BackgroundTransparency = 1
			TabButton.BackgroundColor3 = AevryxLib["Theme"]["AccentColor"]
			TabButton.BackgroundTransparency = 0.15
			TabButton.TextColor3 = AevryxLib["Theme"]["FontColor"]
			Indicator.BackgroundTransparency = 0
		else
			Fader.BackgroundTransparency = 0
		end

		table.insert(TabButtonsList, TabButton)
		local InPage = {}

		function InPage.Section(Text)
			local InSection = {}
			local Column = PageList
			if PageList.AbsoluteContentSize.Y > PageList2.AbsoluteContentSize.Y then
				Column = PageList2
			end

			local Section = CreateModule.Instance("Frame", {
				Parent = Column;
				Name = Text;
				BackgroundColor3 = AevryxLib["Theme"]["SectionColor"];
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, 0);
				Size = UDim2.new(0.96, 0, 0, 30);
				AutomaticSize = Enum.AutomaticSize.Y;
				ZIndex = 2;
			})
			CreateModule.Instance("UICorner", { Parent = Section; CornerRadius = UDim.new(0, 6) })
			CreateModule.Instance("UIStroke", {
				Parent = Section;
				Thickness = 1;
				Color = Color3.fromRGB(40, 40, 50);
				Transparency = 0.6;
			})
			local SectionLabel = CreateModule.Instance("TextLabel", {
				Parent = Section;
				Font = Enum.Font[AevryxLib["Theme"]["Font"]];
				Text = Text;
				TextSize = 15;
				TextColor3 = AevryxLib["Theme"]["FontColor"];
				TextXAlignment = Enum.TextXAlignment.Left;
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 10, 0, 6);
				Size = UDim2.new(1, 0, 0, 22);
				ZIndex = 3;
			})
			CreateModule.Instance("Frame", {
				Parent = Section;
				BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"];
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, 30);
				Size = UDim2.new(1, 0, 0, 1);
				ZIndex = 3;
			})

			local SectionElements = CreateModule.Instance("Frame", {
				Parent = Section;
				Name = Text;
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, 34);
				Size = UDim2.new(1, 0, 1, 0);
			})
			CreateModule.Instance("UIListLayout", {
				Parent = SectionElements;
				Padding = UDim.new(0, 6);
				HorizontalAlignment = Enum.HorizontalAlignment.Center;
				SortOrder = Enum.SortOrder.LayoutOrder;
			})
			CreateModule.Instance("UIPadding", {
				Parent = SectionElements;
				PaddingLeft = UDim.new(0, 8);
				PaddingRight = UDim.new(0, 8);
				PaddingTop = UDim.new(0, 6);
				PaddingBottom = UDim.new(0, 8);
			})

			function InSection.Button(Text, func)
				local Button = CreateModule.Instance("TextButton", {
					Parent = SectionElements;
					Name = Text;
					BackgroundColor3 = Color3.fromRGB(36, 36, 44);
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(0.97, 0, 0, 30);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					Text = Text;
					TextSize = 14;
					TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.4);
					TextXAlignment = Enum.TextXAlignment.Center;
					TextYAlignment = Enum.TextYAlignment.Center;
					AutoButtonColor = false;
					ZIndex = 3;
				})
				CreateModule.Instance("UICorner", { Parent = Button; CornerRadius = UDim.new(0, 5) })
				CreateModule.Instance("UIStroke", {
					Parent = Button;
					Thickness = 1;
					Color = Color3.fromRGB(50, 50, 60);
					Transparency = 0.5;
				})
				Button.MouseEnter:Connect(function()
					Tween(Button, { BackgroundColor3 = AevryxLib["Theme"]["AccentColor"], TextColor3 = AevryxLib["Theme"]["FontColor"] }, 0.2):Play()
				end)
				Button.MouseLeave:Connect(function()
					Tween(Button, { BackgroundColor3 = Color3.fromRGB(36, 36, 44), TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.4) }, 0.2):Play()
				end)
				Button.MouseButton1Click:Connect(function()
					pcall(func)
				end)
				AddToReg(Button)
				return Button
			end

			function InSection.KeyBind(Text, func, defkey)
				local Keybind = CreateModule.Instance("TextLabel", {
					Parent = SectionElements;
					Name = Text or "Keybind";
					BackgroundColor3 = Color3.fromRGB(36, 36, 44);
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(0.97, 0, 0, 30);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					Text = "";
					TextSize = 14;
					TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.4);
					TextXAlignment = Enum.TextXAlignment.Left;
					ZIndex = 3;
				})
				CreateModule.Instance("UICorner", { Parent = Keybind; CornerRadius = UDim.new(0, 5) })
				local Label = CreateModule.Instance("TextLabel", {
					Parent = Keybind;
					Name = "Label";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 10, 0, 0);
					Size = UDim2.new(1, -70, 1, 0);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.4);
					Text = Text;
					TextSize = 14;
					TextXAlignment = Enum.TextXAlignment.Left;
				})

				local function GetKeyDisplayName(keyCode)
					local keyString = tostring(keyCode):gsub("Enum.KeyCode.", "")
					local keyMap = {
						["LeftControl"] = "LCtrl", ["RightControl"] = "RCtrl",
						["LeftShift"] = "LShift", ["RightShift"] = "RShift",
						["LeftAlt"] = "LAlt", ["RightAlt"] = "RAlt",
						["Space"] = "Space", ["Return"] = "Enter", ["Escape"] = "Esc",
						["Tab"] = "Tab", ["CapsLock"] = "Caps", ["Backspace"] = "Back",
						["Delete"] = "Del", ["Insert"] = "Ins", ["Home"] = "Home",
						["End"] = "End", ["PageUp"] = "PgUp", ["PageDown"] = "PgDn",
						["ArrowUp"] = "↑", ["ArrowDown"] = "↓", ["ArrowLeft"] = "←", ["ArrowRight"] = "→",
						["F1"] = "F1", ["F2"] = "F2", ["F3"] = "F3", ["F4"] = "F4",
						["F5"] = "F5", ["F6"] = "F6", ["F7"] = "F7", ["F8"] = "F8",
						["F9"] = "F9", ["F10"] = "F10", ["F11"] = "F11", ["F12"] = "F12",
						["MouseButton2"] = "RMB", ["MouseButton1"] = "LMB", ["MouseButton3"] = "MMB",
					}
					return keyMap[keyString] or keyString
				end

				local Key = defkey
				local displayKey = "..."
				local kk = nil
				if typeof(defkey) == "EnumItem" then
					kk = defkey
					Key = tostring(defkey):gsub("Enum.KeyCode.", "")
				elseif type(defkey) == "string" then
					kk = getEnumMember(Enum.KeyCode, defkey)
				end
				if kk then displayKey = GetKeyDisplayName(kk)
				elseif Key ~= nil then displayKey = tostring(Key) end

				local Keybinder = CreateModule.Instance("TextButton", {
					Parent = Keybind;
					BackgroundColor3 = AevryxLib["Theme"]["AccentColor"];
					BorderSizePixel = 0;
					AnchorPoint = Vector2.new(1, 0.5);
					Position = UDim2.new(1, -8, 0.5, 0);
					Size = UDim2.new(0, 56, 0, 22);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					Text = displayKey;
					TextSize = 13;
					TextColor3 = AevryxLib["Theme"]["FontColor"];
					TextXAlignment = Enum.TextXAlignment.Center;
					AutoButtonColor = false;
					ZIndex = 4;
				})
				CreateModule.Instance("UICorner", { Parent = Keybinder; CornerRadius = UDim.new(0, 5) })

				local Picked, Picking = false, false
				local Key = defkey or nil
				InputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard and Picking then
						local hideKey = getEnumMember(Enum.KeyCode, AevryxLib["Theme"]["HideKey"])
						if not (hideKey and input.KeyCode == hideKey) then
							Key = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
							Keybinder.Text = GetKeyDisplayName(input.KeyCode)
							Picked = true
						end
					end
				end)
				Keybinder.MouseButton1Click:Connect(function()
					Picking = true
					Keybinder.Text = "..."
					spawn(function()
						repeat wait() until Picked
						local kk = getEnumMember(Enum.KeyCode, Key)
						local kdisp = kk and GetKeyDisplayName(kk) or tostring(Key)
						Keybinder.Text = kdisp
						pcall(func, Key)
						Picking, Picked = false, false
					end)
				end)
				AddToReg(Keybind)
			end

			function InSection.Checkbox(Text, func, defbool)
				local Checkbox = CreateModule.Instance("TextButton", {
					Parent = SectionElements;
					Name = Text;
					BackgroundColor3 = Color3.fromRGB(36, 36, 44);
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(0.97, 0, 0, 30);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					Text = "";
					TextSize = 14;
					TextXAlignment = Enum.TextXAlignment.Left;
					AutoButtonColor = false;
					ZIndex = 3;
				})
				CreateModule.Instance("UICorner", { Parent = Checkbox; CornerRadius = UDim.new(0, 5) })
				local Label = CreateModule.Instance("TextLabel", {
					Parent = Checkbox;
					Name = "Label";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 12, 0, 0);
					Size = UDim2.new(1, -45, 1, 0);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					Text = Text;
					TextSize = 14;
					TextXAlignment = Enum.TextXAlignment.Left;
				})
				local IsActive = CreateModule.Instance("BoolValue", { Parent = Checkbox; Name = "IsActive"; Value = defbool or false })
				Label.TextColor3 = IsActive.Value and AevryxLib["Theme"]["FontColor"] or Darker(AevryxLib["Theme"]["FontColor"], 1.4)

				local Checked = CreateModule.Instance("Frame", {
					Parent = Checkbox;
					Name = "Cube";
					BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"];
					BorderSizePixel = 0;
					AnchorPoint = Vector2.new(1, 0.5);
					Position = UDim2.new(1, -12, 0.5, 0);
					Size = UDim2.new(0, 18, 0, 18);
					BackgroundTransparency = IsActive.Value and 0 or 1;
					ZIndex = 4;
				})
				CreateModule.Instance("UICorner", { Parent = Checked; CornerRadius = UDim.new(0, 4) })
				CreateModule.Instance("UIStroke", { Parent = Checked; Thickness = 1; Color = Color3.fromRGB(50, 50, 60) })

				IsActive.Changed:Connect(function()
					if IsActive.Value then
						Tween(Label, { TextColor3 = AevryxLib["Theme"]["FontColor"] }, 0.25):Play()
						Tween(Checked, { BackgroundTransparency = 0, BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"] }, 0.25):Play()
						pcall(func, IsActive.Value)
					else
						Tween(Checked, { BackgroundTransparency = 1 }, 0.25):Play()
						Tween(Label, { TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.4) }, 0.25):Play()
						pcall(func, IsActive.Value)
					end
				end)
				Checkbox.MouseButton1Click:Connect(function()
					IsActive.Value = not IsActive.Value
				end)
				AddToReg(Checkbox)
				return Checkbox
			end

			function InSection.TextLabel(Text)
				local Label = CreateModule.Instance("TextLabel", {
					Parent = SectionElements;
					Name = Text;
					BackgroundColor3 = Color3.fromRGB(30, 30, 38);
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(0.97, 0, 0, 26);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					Text = Text;
					TextSize = 13;
					TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.3);
					TextXAlignment = Enum.TextXAlignment.Left;
					TextYAlignment = Enum.TextYAlignment.Center;
					ZIndex = 3;
				})
				CreateModule.Instance("UICorner", { Parent = Label; CornerRadius = UDim.new(0, 5) })
				AddToReg(Label)
				return Label
			end

			function InSection.TextBox(Text, func, defvalue)
				local TextBoxFrame = CreateModule.Instance("Frame", {
					Parent = SectionElements;
					Name = Text;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(0.97, 0, 0, 30);
				})
				local TextBox = CreateModule.Instance("TextBox", {
					Parent = TextBoxFrame;
					Name = "TextBox";
					BackgroundColor3 = Color3.fromRGB(30, 30, 38);
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(1, 0, 1, 0);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					Text = defvalue or "";
					TextSize = 13;
					TextColor3 = AevryxLib["Theme"]["FontColor"];
					TextXAlignment = Enum.TextXAlignment.Left;
					PlaceholderText = Text;
					PlaceholderColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.6);
					ClearTextOnFocus = false;
					ClipsDescendants = true;
					ZIndex = 3;
				})
				CreateModule.Instance("UICorner", { Parent = TextBox; CornerRadius = UDim.new(0, 5) })
				local Stroke = CreateModule.Instance("UIStroke", {
					Parent = TextBox;
					Thickness = 1;
					Color = Color3.fromRGB(50, 50, 60);
					Transparency = 0.5;
				})
				TextBox.Focused:Connect(function()
					Tween(Stroke, { Color = AevryxLib["Theme"]["AccentColor2"] }, 0.25):Play()
				end)
				TextBox.FocusLost:Connect(function()
					Tween(Stroke, { Color = Color3.fromRGB(50, 50, 60) }, 0.25):Play()
					pcall(func, TextBox.Text)
				end)
				AddToReg(TextBoxFrame)
				return TextBox
			end

			function InSection.Slider(Text, min, max, func, precise, defvalue)
				local Slider = CreateModule.Instance("TextLabel", {
					Parent = SectionElements;
					Name = Text;
					BackgroundColor3 = Color3.fromRGB(36, 36, 44);
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(0.97, 0, 0, 44);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					TextColor3 = Darker(AevryxLib["Theme"]["FontColor"], 1.4);
					Text = Text;
					TextSize = 14;
					TextXAlignment = Enum.TextXAlignment.Center;
					TextYAlignment = Enum.TextYAlignment.Top;
					ZIndex = 3;
				})
				CreateModule.Instance("UICorner", { Parent = Slider; CornerRadius = UDim.new(0, 5) })
				local Bar = CreateModule.Instance("Frame", {
					Parent = Slider;
					Name = "Bar";
					BackgroundColor3 = Color3.fromRGB(20, 20, 26);
					BorderSizePixel = 0;
					AnchorPoint = Vector2.new(0, 0.5);
					Position = UDim2.new(0.06, 0, 0.72, 0);
					Size = UDim2.new(0.88, 0, 0, 8);
					ClipsDescendants = true;
					Active = true;
					Selectable = true;
					ZIndex = 4;
				})
				CreateModule.Instance("UICorner", { Parent = Bar; CornerRadius = UDim.new(1, 0) })
				local ValueLabel = CreateModule.Instance("TextLabel", {
					Parent = Bar;
					Name = "Label";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(1, 0, 1, 0);
					Font = Enum.Font[AevryxLib["Theme"]["Font"]];
					TextColor3 = AevryxLib["Theme"]["FontColor"];
					Text = tostring(defvalue and defvalue or min);
					TextSize = 13;
					TextXAlignment = Enum.TextXAlignment.Center;
					ZIndex = 5;
				})
				local Progress = CreateModule.Instance("Frame", {
					Parent = Bar;
					Name = "Progress";
					BackgroundColor3 = AevryxLib["Theme"]["AccentColor2"];
					BorderSizePixel = 0;
					AnchorPoint = Vector2.new(0, 0.5);
					Position = UDim2.new(0, 0, 0.5, 0);
					Size = UDim2.new(0, 0, 1, 0);
					ZIndex = 4;
				})
				CreateModule.Instance("UICorner", { Parent = Progress; CornerRadius = UDim.new(1, 0) })

				local current = defvalue or min
				local function setVisual(val)
					current = math.clamp(val, min, max)
					local pct = (current - min) / (max - min)
					Progress.Size = UDim2.new(pct, 0, 1, 0)
					ValueLabel.Text = string.format(precise and "%.2f" or "%d", current)
				end
				setVisual(current)

				local dragging = false
				Bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						local move
						move = InputService.InputChanged:Connect(function(m)
							if dragging and (m.UserInputType == Enum.UserInputType.MouseMovement or m.UserInputType == Enum.UserInputType.Touch) then
								local rel = math.clamp((m.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
								setVisual(min + rel * (max - min))
								pcall(func, current)
							end
						end)
						local up
						up = InputService.InputEnded:Connect(function(e)
							if e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch then
								dragging = false; move:Disconnect(); up:Disconnect()
							end
						end)
					end
				end)
				AddToReg(Slider)
			end

			return InSection
		end

		return InPage
	end

	MainFrame.Visible = true
	AevryxLib.Tab = InMain.Tab
	AevryxLib.Notification = InMain.Notification
	return AevryxLib
end

return AevryxLib
