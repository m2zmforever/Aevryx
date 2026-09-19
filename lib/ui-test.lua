local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local AevryxLib = {
	["Theme"] = {
		["Font"] = "RobotoMono",
		["AccentColor"] = Color3.fromRGB(60, 60, 60),
		["FontColor"] = Color3.fromRGB(255, 255, 255),
		["HideKey"] = "LeftControl"
	}
}

local function Darker(col, coeff)
	local h, s, v = col:HSV()
	return Color3.fromHSV(h, s, v / (coeff or 1.5))
end

local function Brighter(col, coeff)
	local h, s, v = col:HSV()
	return Color3.fromHSV(h, s, math.min(v * (coeff or 1.5), 1))
end

local function getEnumMember(enumType, memberName)
	local ok, res = pcall(function() return enumType[memberName] end)
	return ok and res or nil
end

local function AddToReg(reg, inst)
	table.insert(reg, inst)
end

function AevryxLib:Window(title, width, height)
	for _, v in next, game.CoreGui:GetChildren() do
		if v.Name == "AevryxLib" then
			v:Destroy()
		end
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AevryxLib"
	screenGui.Parent = game.CoreGui
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false

	local loadingScreen = Instance.new("Frame")
	loadingScreen.Name = "LoadingScreen"
	loadingScreen.Parent = screenGui
	loadingScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	loadingScreen.BorderSizePixel = 0
	loadingScreen.Position = UDim2.new(0.5, 0, 0.5, 0)
	loadingScreen.Size = UDim2.new(0, 250, 0, 100)
	loadingScreen.AnchorPoint = Vector2.new(0.5, 0.5)
	loadingScreen.ZIndex = 100

	local loadingCorner = Instance.new("UICorner")
	loadingCorner.Parent = loadingScreen
	loadingCorner.CornerRadius = UDim.new(0, 8)

	local loadingStroke = Instance.new("UIStroke")
	loadingStroke.Parent = loadingScreen
	loadingStroke.Thickness = 2
	loadingStroke.Color = self.Theme.AccentColor

	local loadingTitle = Instance.new("ImageLabel")
	loadingTitle.Parent = loadingScreen
	loadingTitle.Name = "Title"
	loadingTitle.BackgroundTransparency = 1
	loadingTitle.Image = "rbxassetid://88607367141872"
	loadingTitle.ScaleType = Enum.ScaleType.Fit
	loadingTitle.AnchorPoint = Vector2.new(0.5, 0)
	loadingTitle.Position = UDim2.new(0.5, 0, 0.08, 0)
	loadingTitle.Size = UDim2.new(0, 64, 0, 64)
	loadingTitle.ZIndex = 101

	local loadingStatus = Instance.new("TextLabel")
	loadingStatus.Parent = loadingScreen
	loadingStatus.Name = "Status"
	loadingStatus.BackgroundTransparency = 1
	loadingStatus.Font = Enum.Font[self.Theme.Font]
	loadingStatus.Text = "Loading..."
	loadingStatus.TextSize = 12
	loadingStatus.TextColor3 = Darker(self.Theme.FontColor, 1.5)
	loadingStatus.Position = UDim2.new(0, 0, 0.75, 0)
	loadingStatus.Size = UDim2.new(1, 0, 0.2, 0)
	loadingStatus.ZIndex = 101

	task.wait(0.2)
	loadingStatus.Text = "Loading Modules..."
	task.wait(0.3)
	loadingStatus.Text = "Loading UI..."
	task.wait(0.3)
	loadingStatus.Text = "Loading Config..."
	task.wait(0.5)
	loadingStatus.Text = "Welcome To Aevryx..."
	task.wait(0.3)

	TweenService:Create(loadingScreen, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadingStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
	TweenService:Create(loadingTitle, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
	TweenService:Create(loadingStatus, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	task.wait(0.35)
	loadingScreen:Destroy()

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Parent = screenGui
	mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	mainFrame.BorderSizePixel = 0
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.Size = UDim2.new(0, width, 0, height)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.ClipsDescendants = true

	local mainCorner = Instance.new("UICorner")
	mainCorner.Parent = mainFrame
	mainCorner.CornerRadius = UDim.new(0, 5)

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Parent = mainFrame
	mainStroke.Thickness = 1
	mainStroke.Color = self.Theme.AccentColor
	mainStroke.Transparency = 0.5

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Parent = mainFrame
	sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	sidebar.BorderSizePixel = 0
	sidebar.Size = UDim2.new(0, 130, 1, 0)

	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.Parent = sidebar
	sidebarCorner.CornerRadius = UDim.new(0, 5)

	local sidebarStroke = Instance.new("UIStroke")
	sidebarStroke.Parent = sidebar
	sidebarStroke.Thickness = 1
	sidebarStroke.Color = Color3.fromRGB(20, 20, 20)
	sidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Parent = sidebar
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font[self.Theme.Font]
	titleLabel.Text = title
	titleLabel.TextColor3 = self.Theme.FontColor
	titleLabel.TextSize = 18
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.Size = UDim2.new(1, -20, 0, 24)

	local tabScroll = Instance.new("ScrollingFrame")
	tabScroll.Name = "TabScroll"
	tabScroll.Parent = sidebar
	tabScroll.BackgroundTransparency = 1
	tabScroll.BorderSizePixel = 0
	tabScroll.Position = UDim2.new(0, 0, 0, 35)
	tabScroll.Size = UDim2.new(1, 0, 1, -35)
	tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabScroll.ScrollBarThickness = 0

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Parent = tabScroll
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 3)

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Parent = mainFrame
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.Position = UDim2.new(0, 130, 0, 0)
	contentFrame.Size = UDim2.new(1, -130, 1, 0)

	local pageLayout = Instance.new("UIPageLayout")
	pageLayout.Parent = contentFrame
	pageLayout.FillDirection = Enum.FillDirection.Vertical
	pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	pageLayout.TweenTime = 0.2
	pageLayout.EasingDirection = Enum.EasingDirection.Out
	pageLayout.EasingStyle = Enum.EasingStyle.Sine
	pageLayout.Padding = UDim.new(0, 10)
	pageLayout.ScrollWheelInputEnabled = false

	local isGuiVisible = true
	UserInputService.InputBegan:Connect(function(input, isTyping)
		if isTyping then return end
		local keyName = self.Theme.HideKey
		local keyEnum = getEnumMember(Enum.KeyCode, keyName)
		local uitEnum = getEnumMember(Enum.UserInputType, keyName)
		if (keyEnum and input.KeyCode == keyEnum) or (uitEnum and input.UserInputType == uitEnum) then
			isGuiVisible = not isGuiVisible
			mainFrame.Visible = isGuiVisible
		end
	end)

	local tabButtons = {}
	local pages = {}
	local activeTab = nil

	local main = {}

	local function switchPage(page)
		for _, p in next, contentFrame:GetChildren() do
			if p:IsA("Frame") and p.Name == "Page" then
				if p ~= page then
					p.Visible = false
				end
			end
		end
		page.Visible = true
		pageLayout:JumpTo(page)
	end

	function main:Tab(tabName)
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tabName
		tabBtn.Parent = tabScroll
		tabBtn.BackgroundColor3 = self.Theme.AccentColor
		tabBtn.BackgroundTransparency = 1
		tabBtn.BorderSizePixel = 0
		tabBtn.Size = UDim2.new(1, -8, 0, 28)
		tabBtn.Position = UDim2.new(0, 4, 0, 0)
		tabBtn.Font = Enum.Font[self.Theme.Font]
		tabBtn.Text = "  " .. tabName
		tabBtn.TextColor3 = Darker(self.Theme.FontColor, 2)
		tabBtn.TextSize = 13
		tabBtn.TextXAlignment = Enum.TextXAlignment.Left
		tabBtn.AutoButtonColor = false

		local tabCorner = Instance.new("UICorner")
		tabCorner.Parent = tabBtn
		tabCorner.CornerRadius = UDim.new(0, 4)

		local isActive = Instance.new("BoolValue")
		isActive.Name = "IsActive"
		isActive.Parent = tabBtn
		isActive.Value = false

		local page = Instance.new("Frame")
		page.Name = "Page"
		page.Parent = contentFrame
		page.BackgroundTransparency = 1
		page.Size = UDim2.new(0.95, 0, 1, 0)
		page.Visible = false

		local leftCol = Instance.new("Frame")
		leftCol.Name = "LeftCol"
		leftCol.Parent = page
		leftCol.BackgroundTransparency = 1
		leftCol.BorderSizePixel = 0
		leftCol.Position = UDim2.new(0, 0, 0, 0)
		leftCol.Size = UDim2.new(0.485, 0, 1, 0)

		local rightCol = Instance.new("Frame")
		rightCol.Name = "RightCol"
		rightCol.Parent = page
		rightCol.BackgroundTransparency = 1
		rightCol.BorderSizePixel = 0
		rightCol.Position = UDim2.new(0.515, 0, 0, 0)
		rightCol.Size = UDim2.new(0.485, 0, 1, 0)

		local leftList = Instance.new("UIListLayout")
		leftList.Parent = leftCol
		leftList.Padding = UDim.new(0, 8)
		leftList.SortOrder = Enum.SortOrder.LayoutOrder

		local rightList = Instance.new("UIListLayout")
		rightList.Parent = rightCol
		rightList.Padding = UDim.new(0, 8)
		rightList.SortOrder = Enum.SortOrder.LayoutOrder

		local leftPadding = Instance.new("UIPadding")
		leftPadding.Parent = leftCol
		leftPadding.PaddingTop = UDim.new(0, 5)
		leftPadding.PaddingLeft = UDim.new(0, 5)

		local rightPadding = Instance.new("UIPadding")
		rightPadding.Parent = rightCol
		rightPadding.PaddingTop = UDim.new(0, 5)
		rightPadding.PaddingRight = UDim.new(0, 5)

		table.insert(tabButtons, {btn = tabBtn, page = page})
		table.insert(pages, page)

		tabBtn.MouseButton1Click:Connect(function()
			for _, tb in ipairs(tabButtons) do
				tb.btn.IsActive.Value = false
				TweenService:Create(tb.btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				TweenService:Create(tb.btn, TweenInfo.new(0.2), {TextColor3 = Darker(self.Theme.FontColor, 2)}):Play()
			end
			tabBtn.IsActive.Value = true
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {TextColor3 = self.Theme.FontColor}):Play()
			switchPage(page)
			activeTab = page
		end)

		if #tabButtons == 1 then
			tabBtn.IsActive.Value = true
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {TextColor3 = self.Theme.FontColor}):Play()
			page.Visible = true
			activeTab = page
		end

		local pageObj = {}
		local sections = {}
		local welcomeHeight = 0

		local function getTargetColumn()
			if leftList.AbsoluteContentSize.Y <= rightList.AbsoluteContentSize.Y then
				return leftCol
			else
				return rightCol
			end
		end

		function pageObj.WelcomeSection(imageId, text)
			local section = Instance.new("Frame")
			section.Name = "Welcome"
			section.Parent = page
			section.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			section.BorderSizePixel = 0
			section.Position = UDim2.new(0.015, 0, 0, 5)
			section.Size = UDim2.new(0.97, 0, 0, 80)

			local corner = Instance.new("UICorner")
			corner.Parent = section
			corner.CornerRadius = UDim.new(0, 5)

			local stroke = Instance.new("UIStroke")
			stroke.Parent = section
			stroke.Thickness = 1
			stroke.Color = Color3.fromRGB(20, 20, 20)
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			local avatar = Instance.new("ImageLabel")
			avatar.Name = "Avatar"
			avatar.Parent = section
			avatar.BackgroundTransparency = 1
			avatar.Position = UDim2.new(0, 8, 0, 8)
			avatar.Size = UDim2.new(0, 64, 0, 64)
			avatar.Image = imageId or ""
			avatar.ScaleType = Enum.ScaleType.Fit

			local avatarCorner = Instance.new("UICorner")
			avatarCorner.Parent = avatar
			avatarCorner.CornerRadius = UDim.new(0, 5)

			local welcomeText = Instance.new("TextLabel")
			welcomeText.Name = "WelcomeText"
			welcomeText.Parent = section
			welcomeText.BackgroundTransparency = 1
			welcomeText.Position = UDim2.new(0, 82, 0, 0)
			welcomeText.Size = UDim2.new(1, -90, 1, 0)
			welcomeText.Font = Enum.Font[self.Theme.Font]
			welcomeText.Text = text or ""
			welcomeText.TextSize = 18
			welcomeText.TextColor3 = self.Theme.FontColor
			welcomeText.TextXAlignment = Enum.TextXAlignment.Left
			welcomeText.TextYAlignment = Enum.TextYAlignment.Center

			welcomeHeight = 85

			leftCol.Position = UDim2.new(0, 0, 0, welcomeHeight)
			rightCol.Position = UDim2.new(0.515, 0, 0, welcomeHeight)

			local secObj = {}
			function secObj.SetText(newText)
				welcomeText.Text = newText
			end
			function secObj.SetAvatar(newId)
				avatar.Image = newId or ""
			end
			return secObj
		end

		function pageObj.Section(sectionName)
			local targetCol = getTargetColumn()

			local section = Instance.new("Frame")
			section.Name = sectionName
			section.Parent = targetCol
			section.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			section.BorderSizePixel = 0
			section.Size = UDim2.new(1, 0, 0, 25)
			section.AutomaticSize = Enum.AutomaticSize.Y

			local corner = Instance.new("UICorner")
			corner.Parent = section
			corner.CornerRadius = UDim.new(0, 5)

			local stroke = Instance.new("UIStroke")
			stroke.Parent = section
			stroke.Thickness = 1
			stroke.Color = Color3.fromRGB(20, 20, 20)
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			local sectionTitle = Instance.new("TextLabel")
			sectionTitle.Name = "Title"
			sectionTitle.Parent = section
			sectionTitle.BackgroundTransparency = 1
			sectionTitle.Font = Enum.Font[self.Theme.Font]
			sectionTitle.Text = sectionName
			sectionTitle.TextSize = 14
			sectionTitle.TextColor3 = self.Theme.FontColor
			sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			sectionTitle.Position = UDim2.new(0, 8, 0, 3)
			sectionTitle.Size = UDim2.new(1, -16, 0, 18)

			local elementHolder = Instance.new("Frame")
			elementHolder.Name = "Elements"
			elementHolder.Parent = section
			elementHolder.BackgroundTransparency = 1
			elementHolder.Position = UDim2.new(0, 0, 0, 22)
			elementHolder.Size = UDim2.new(1, 0, 0, 0)
			elementHolder.AutomaticSize = Enum.AutomaticSize.Y

			local elementList = Instance.new("UIListLayout")
			elementList.Parent = elementHolder
			elementList.Padding = UDim.new(0, 4)
			elementList.SortOrder = Enum.SortOrder.LayoutOrder

			local secObj = {}
			table.insert(sections, secObj)

			function secObj.Button(btnText, callback)
				local btn = Instance.new("TextButton")
				btn.Name = btnText
				btn.Parent = elementHolder
				btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				btn.BorderSizePixel = 1
				btn.BorderColor3 = Color3.fromRGB(20, 20, 20)
				btn.Size = UDim2.new(0.95, 0, 0, 22)
				btn.Position = UDim2.new(0.025, 0, 0, 0)
				btn.Font = Enum.Font[self.Theme.Font]
				btn.Text = btnText
				btn.TextSize = 13
				btn.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				btn.TextXAlignment = Enum.TextXAlignment.Center
				btn.AutoButtonColor = false

				local btnCorner = Instance.new("UICorner")
				btnCorner.Parent = btn
				btnCorner.CornerRadius = UDim.new(0, 4)

				local btnStroke = Instance.new("UIStroke")
				btnStroke.Parent = btn
				btnStroke.Thickness = 1
				btnStroke.Color = Color3.fromRGB(20, 20, 20)
				btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				btn.MouseEnter:Connect(function()
					TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = self.Theme.FontColor}):Play()
				end)
				btn.MouseLeave:Connect(function()
					TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Darker(self.Theme.FontColor, 1.5)}):Play()
				end)
				btn.MouseButton1Click:Connect(function()
					pcall(callback)
				end)
				return btn
			end

			function secObj.Checkbox(cbText, callback, default)
				local cbFrame = Instance.new("TextButton")
				cbFrame.Name = cbText
				cbFrame.Parent = elementHolder
				cbFrame.BackgroundTransparency = 1
				cbFrame.BorderSizePixel = 0
				cbFrame.Size = UDim2.new(0.95, 0, 0, 20)
				cbFrame.Position = UDim2.new(0.025, 0, 0, 0)
				cbFrame.Font = Enum.Font[self.Theme.Font]
				cbFrame.Text = ""
				cbFrame.AutoButtonColor = false

				local cbCorner = Instance.new("UICorner")
				cbCorner.Parent = cbFrame
				cbCorner.CornerRadius = UDim.new(0, 4)

				local checkIndicator = Instance.new("Frame")
				checkIndicator.Name = "Indicator"
				checkIndicator.Parent = cbFrame
				checkIndicator.BackgroundColor3 = self.Theme.AccentColor
				checkIndicator.BorderSizePixel = 0
				checkIndicator.AnchorPoint = Vector2.new(0, 0.5)
				checkIndicator.Position = UDim2.new(0, 4, 0.5, 0)
				checkIndicator.Size = UDim2.new(0, 12, 0, 12)

				local indCorner = Instance.new("UICorner")
				indCorner.Parent = checkIndicator
				indCorner.CornerRadius = UDim.new(0, 3)

				local cbLabel = Instance.new("TextLabel")
				cbLabel.Name = "Label"
				cbLabel.Parent = cbFrame
				cbLabel.BackgroundTransparency = 1
				cbLabel.Position = UDim2.new(0, 22, 0, 0)
				cbLabel.Size = UDim2.new(1, -22, 1, 0)
				cbLabel.Font = Enum.Font[self.Theme.Font]
				cbLabel.Text = cbText
				cbLabel.TextSize = 13
				cbLabel.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				cbLabel.TextXAlignment = Enum.TextXAlignment.Left

				local isActive = Instance.new("BoolValue")
				isActive.Name = "IsActive"
				isActive.Parent = cbFrame
				isActive.Value = default or false

				checkIndicator.BackgroundTransparency = default and 0 or 1

				isActive.Changed:Connect(function()
					if isActive.Value then
						TweenService:Create(checkIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
						TweenService:Create(cbLabel, TweenInfo.new(0.2), {TextColor3 = self.Theme.FontColor}):Play()
						pcall(callback, true)
					else
						TweenService:Create(checkIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
						TweenService:Create(cbLabel, TweenInfo.new(0.2), {TextColor3 = Darker(self.Theme.FontColor, 1.5)}):Play()
						pcall(callback, false)
					end
				end)

				cbFrame.MouseButton1Click:Connect(function()
					isActive.Value = not isActive.Value
				end)

				return cbFrame
			end

			function secObj.Slider(sliderText, min, max, callback, precise, default)
				min = min or 0
				max = max or 100
				default = default or min

				local sliderFrame = Instance.new("Frame")
				sliderFrame.Name = sliderText
				sliderFrame.Parent = elementHolder
				sliderFrame.BackgroundTransparency = 1
				sliderFrame.BorderSizePixel = 0
				sliderFrame.Size = UDim2.new(0.95, 0, 0, 35)
				sliderFrame.Position = UDim2.new(0.025, 0, 0, 0)

				local sliderTitle = Instance.new("TextLabel")
				sliderTitle.Name = "Title"
				sliderTitle.Parent = sliderFrame
				sliderTitle.BackgroundTransparency = 1
				sliderTitle.Font = Enum.Font[self.Theme.Font]
				sliderTitle.Text = sliderText
				sliderTitle.TextSize = 12
				sliderTitle.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				sliderTitle.Position = UDim2.new(0, 0, 0, 0)
				sliderTitle.Size = UDim2.new(1, 0, 0, 14)

				local barFrame = Instance.new("Frame")
				barFrame.Name = "Bar"
				barFrame.Parent = sliderFrame
				barFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				barFrame.BorderSizePixel = 0
				barFrame.Position = UDim2.new(0, 0, 0, 18)
				barFrame.Size = UDim2.new(1, 0, 0, 12)
				barFrame.ClipsDescendants = true

				local barCorner = Instance.new("UICorner")
				barCorner.Parent = barFrame
				barCorner.CornerRadius = UDim.new(0, 4)

				local barStroke = Instance.new("UIStroke")
				barStroke.Parent = barFrame
				barStroke.Thickness = 1
				barStroke.Color = Color3.fromRGB(20, 20, 20)

				local progressFrame = Instance.new("Frame")
				progressFrame.Name = "Progress"
				progressFrame.Parent = barFrame
				progressFrame.BackgroundColor3 = self.Theme.AccentColor
				progressFrame.BorderSizePixel = 0
				progressFrame.Size = UDim2.new(0, 0, 1, 0)

				local progCorner = Instance.new("UICorner")
				progCorner.Parent = progressFrame
				progCorner.CornerRadius = UDim.new(0, 4)

				local valueLabel = Instance.new("TextLabel")
				valueLabel.Name = "Value"
				valueLabel.Parent = barFrame
				valueLabel.BackgroundTransparency = 1
				valueLabel.Font = Enum.Font[self.Theme.Font]
				valueLabel.Text = tostring(default) .. "/" .. tostring(max)
				valueLabel.TextSize = 10
				valueLabel.TextColor3 = self.Theme.FontColor
				valueLabel.TextXAlignment = Enum.TextXAlignment.Center
				valueLabel.Size = UDim2.new(1, 0, 1, 0)
				valueLabel.ZIndex = 2

				local dragging = false
				local currentValue = default

				local function updateSlider(val)
					local scale = math.clamp((val - min) / (max - min), 0, 1)
					progressFrame.Size = UDim2.new(scale, 0, 1, 0)
					local displayVal = precise and tonumber(string.format("%.1f", val)) or math.floor(val)
					valueLabel.Text = tostring(displayVal) .. "/" .. tostring(max)
				end

				updateSlider(default)

				barFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						local barAbsPos = barFrame.AbsolutePosition.X
						local barAbsSize = barFrame.AbsoluteSize.X
						if barAbsSize > 0 then
							local scale = math.clamp((input.Position.X - barAbsPos) / barAbsSize, 0, 1)
							currentValue = min + scale * (max - min)
							updateSlider(currentValue)
							local displayVal = precise and tonumber(string.format("%.1f", currentValue)) or math.floor(currentValue)
							pcall(callback, displayVal)
						end
						TweenService:Create(progressFrame, TweenInfo.new(0.2), {BackgroundColor3 = Darker(self.Theme.AccentColor, 1.2)}):Play()
					end
				end)

				barFrame.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
						TweenService:Create(progressFrame, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.AccentColor}):Play()
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						local barAbsPos = barFrame.AbsolutePosition.X
						local barAbsSize = barFrame.AbsoluteSize.X
						if barAbsSize > 0 then
							local scale = math.clamp((input.Position.X - barAbsPos) / barAbsSize, 0, 1)
							currentValue = min + scale * (max - min)
							updateSlider(currentValue)
							local displayVal = precise and tonumber(string.format("%.1f", currentValue)) or math.floor(currentValue)
							pcall(callback, displayVal)
						end
					end
				end)

				return sliderFrame
			end

			function secObj.Dropdown(ddText, items, index, callback)
				local ddFrame = Instance.new("Frame")
				ddFrame.Name = ddText
				ddFrame.Parent = elementHolder
				ddFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				ddFrame.BorderSizePixel = 0
				ddFrame.Size = UDim2.new(0.95, 0, 0, 22)
				ddFrame.Position = UDim2.new(0.025, 0, 0, 0)
				ddFrame.ClipsDescendants = true

				local ddCorner = Instance.new("UICorner")
				ddCorner.Parent = ddFrame
				ddCorner.CornerRadius = UDim.new(0, 4)

				local ddStroke = Instance.new("UIStroke")
				ddStroke.Parent = ddFrame
				ddStroke.Thickness = 1
				ddStroke.Color = Color3.fromRGB(20, 20, 20)
				ddStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				local ddBtn = Instance.new("TextButton")
				ddBtn.Name = "Button"
				ddBtn.Parent = ddFrame
				ddBtn.BackgroundTransparency = 1
				ddBtn.Font = Enum.Font[self.Theme.Font]
				ddBtn.Text = "  " .. ddText
				ddBtn.TextSize = 13
				ddBtn.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				ddBtn.TextXAlignment = Enum.TextXAlignment.Left
				ddBtn.Size = UDim2.new(1, 0, 0, 22)
				ddBtn.AutoButtonColor = false

				local ddArrow = Instance.new("ImageLabel")
				ddArrow.Parent = ddBtn
				ddArrow.AnchorPoint = Vector2.new(0, 0.5)
				ddArrow.BackgroundTransparency = 1
				ddArrow.Position = UDim2.new(0.9, 0, 0.5, 0)
				ddArrow.Size = UDim2.new(0, 16, 0, 16)
				ddArrow.Image = "rbxassetid://3926305904"
				ddArrow.ImageColor3 = Color3.fromRGB(136, 136, 136)
				ddArrow.ImageRectOffset = Vector2.new(44, 404)
				ddArrow.ImageRectSize = Vector2.new(36, 36)

				local ddList = Instance.new("ScrollingFrame")
				ddList.Name = "List"
				ddList.Parent = ddFrame
				ddList.BackgroundTransparency = 1
				ddList.BorderSizePixel = 0
				ddList.Position = UDim2.new(0, 0, 0, 22)
				ddList.Size = UDim2.new(1, 0, 0, 0)
				ddList.AutomaticCanvasSize = Enum.AutomaticSize.Y
				ddList.ScrollBarThickness = 3

				local ddListLayout = Instance.new("UIListLayout")
				ddListLayout.Parent = ddList
				ddListLayout.Padding = UDim.new(0, 2)
				ddListLayout.SortOrder = Enum.SortOrder.LayoutOrder

				local isOpen = false
				local selectedValue = nil
				local valueToDisplay = {}

				local function toggleDD()
					isOpen = not isOpen
					if isOpen then
						ddFrame:TweenSize(UDim2.new(0.95, 0, 0, 100), "Out", "Quart", 0.2, true)
						ddList:TweenSize(UDim2.new(1, 0, 0, 78), "Out", "Quart", 0.2, true)
						TweenService:Create(ddArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
					else
						ddFrame:TweenSize(UDim2.new(0.95, 0, 0, 22), "Out", "Quart", 0.2, true)
						ddList:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quart", 0.2, true)
						TweenService:Create(ddArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
					end
				end

				ddBtn.MouseButton1Click:Connect(toggleDD)

				local function addItem(name, value)
					local itemBtn = Instance.new("TextButton")
					itemBtn.Name = name
					itemBtn.Parent = ddList
					itemBtn.BackgroundTransparency = 1
					itemBtn.Font = Enum.Font[self.Theme.Font]
					itemBtn.Text = "  " .. name
					itemBtn.TextSize = 12
					itemBtn.TextColor3 = Darker(self.Theme.FontColor, 1.5)
					itemBtn.TextXAlignment = Enum.TextXAlignment.Left
					itemBtn.Size = UDim2.new(1, 0, 0, 18)
					itemBtn.AutoButtonColor = false

					local itemCorner = Instance.new("UICorner")
					itemCorner.Parent = itemBtn
					itemCorner.CornerRadius = UDim.new(0, 3)

					itemBtn.MouseEnter:Connect(function()
						TweenService:Create(itemBtn, TweenInfo.new(0.2), {TextColor3 = self.Theme.FontColor}):Play()
					end)
					itemBtn.MouseLeave:Connect(function()
						TweenService:Create(itemBtn, TweenInfo.new(0.2), {TextColor3 = Darker(self.Theme.FontColor, 1.5)}):Play()
					end)
					itemBtn.MouseButton1Click:Connect(function()
						selectedValue = value
						ddBtn.Text = "  " .. name
						toggleDD()
						pcall(callback, name, value)
					end)
				end

				for name, value in next, items do
					if index == 1 then
						addItem(tostring(name), tostring(value))
						valueToDisplay[tostring(value)] = tostring(name)
					elseif index == 2 then
						addItem(tostring(value), tostring(name))
						valueToDisplay[tostring(name)] = tostring(value)
					end
				end

				local ddObj = {}

				function ddObj.Refresh(newItems)
					for _, v in next, ddList:GetChildren() do
						if v:IsA("TextButton") then v:Destroy() end
					end
					task.wait()
					valueToDisplay = {}
					selectedValue = nil
					for name, value in next, newItems do
						if index == 1 then
							addItem(tostring(name), tostring(value))
							valueToDisplay[tostring(value)] = tostring(name)
						elseif index == 2 then
							addItem(tostring(value), tostring(name))
							valueToDisplay[tostring(name)] = tostring(value)
						end
					end
					ddBtn.Text = "  " .. ddText
				end

				function ddObj.Set(selection)
					if typeof(selection) ~= "string" then return end
					local display = valueToDisplay[selection]
					if display then
						ddBtn.Text = "  " .. display
					else
						ddBtn.Text = "  " .. selection
					end
					selectedValue = selection
				end

				function ddObj.SetByIndex(idx)
					local i = 0
					for k, v in next, items do
						i = i + 1
						if i == tonumber(idx) then
							ddBtn.Text = "  " .. tostring(v)
							return
						end
					end
				end

				return ddObj
			end

			function secObj.MultiDropdown(mdText, items, index, callback)
				local mdFrame = Instance.new("Frame")
				mdFrame.Name = mdText
				mdFrame.Parent = elementHolder
				mdFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				mdFrame.BorderSizePixel = 0
				mdFrame.Size = UDim2.new(0.95, 0, 0, 22)
				mdFrame.Position = UDim2.new(0.025, 0, 0, 0)
				mdFrame.ClipsDescendants = true

				local mdCorner = Instance.new("UICorner")
				mdCorner.Parent = mdFrame
				mdCorner.CornerRadius = UDim.new(0, 4)

				local mdStroke = Instance.new("UIStroke")
				mdStroke.Parent = mdFrame
				mdStroke.Thickness = 1
				mdStroke.Color = Color3.fromRGB(20, 20, 20)
				mdStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				local mdBtn = Instance.new("TextButton")
				mdBtn.Name = "Button"
				mdBtn.Parent = mdFrame
				mdBtn.BackgroundTransparency = 1
				mdBtn.Font = Enum.Font[self.Theme.Font]
				mdBtn.Text = "  " .. mdText
				mdBtn.TextSize = 13
				mdBtn.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				mdBtn.TextXAlignment = Enum.TextXAlignment.Left
				mdBtn.Size = UDim2.new(1, 0, 0, 22)
				mdBtn.AutoButtonColor = false

				local mdArrow = Instance.new("ImageLabel")
				mdArrow.Parent = mdBtn
				mdArrow.AnchorPoint = Vector2.new(0, 0.5)
				mdArrow.BackgroundTransparency = 1
				mdArrow.Position = UDim2.new(0.9, 0, 0.5, 0)
				mdArrow.Size = UDim2.new(0, 16, 0, 16)
				mdArrow.Image = "rbxassetid://3926305904"
				mdArrow.ImageColor3 = Color3.fromRGB(136, 136, 136)
				mdArrow.ImageRectOffset = Vector2.new(44, 404)
				mdArrow.ImageRectSize = Vector2.new(36, 36)

				local mdList = Instance.new("ScrollingFrame")
				mdList.Name = "List"
				mdList.Parent = mdFrame
				mdList.BackgroundTransparency = 1
				mdList.BorderSizePixel = 0
				mdList.Position = UDim2.new(0, 0, 0, 22)
				mdList.Size = UDim2.new(1, 0, 0, 0)
				mdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
				mdList.ScrollBarThickness = 3

				local mdListLayout = Instance.new("UIListLayout")
				mdListLayout.Parent = mdList
				mdListLayout.Padding = UDim.new(0, 2)
				mdListLayout.SortOrder = Enum.SortOrder.LayoutOrder

				local isOpen = false
				local selected = {}

				local function toggleMD()
					isOpen = not isOpen
					if isOpen then
						mdFrame:TweenSize(UDim2.new(0.95, 0, 0, 100), "Out", "Quart", 0.2, true)
						mdList:TweenSize(UDim2.new(1, 0, 0, 78), "Out", "Quart", 0.2, true)
						TweenService:Create(mdArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
					else
						mdFrame:TweenSize(UDim2.new(0.95, 0, 0, 22), "Out", "Quart", 0.2, true)
						mdList:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quart", 0.2, true)
						TweenService:Create(mdArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
					end
				end

				mdBtn.MouseButton1Click:Connect(toggleMD)

				local function addItem(name, value)
					local itemBtn = Instance.new("TextButton")
					itemBtn.Name = name
					itemBtn.Parent = mdList
					itemBtn.BackgroundTransparency = 1
					itemBtn.Font = Enum.Font[self.Theme.Font]
					itemBtn.Text = "  " .. name
					itemBtn.TextSize = 12
					itemBtn.TextColor3 = Darker(self.Theme.FontColor, 1.5)
					itemBtn.TextXAlignment = Enum.TextXAlignment.Left
					itemBtn.Size = UDim2.new(1, -20, 0, 18)
					itemBtn.AutoButtonColor = false

					local checkMark = Instance.new("TextLabel")
					checkMark.Name = "Check"
					checkMark.Parent = itemBtn
					checkMark.BackgroundTransparency = 1
					checkMark.Position = UDim2.new(0.88, 0, 0, 0)
					checkMark.Size = UDim2.new(0.1, 0, 1, 0)
					checkMark.Font = Enum.Font[self.Theme.Font]
					checkMark.Text = ""
					checkMark.TextSize = 12
					checkMark.TextColor3 = self.Theme.FontColor
					checkMark.TextXAlignment = Enum.TextXAlignment.Center

					local itemCorner = Instance.new("UICorner")
					itemCorner.Parent = itemBtn
					itemCorner.CornerRadius = UDim.new(0, 3)

					itemBtn.MouseEnter:Connect(function()
						TweenService:Create(itemBtn, TweenInfo.new(0.2), {TextColor3 = self.Theme.FontColor}):Play()
					end)
					itemBtn.MouseLeave:Connect(function()
						TweenService:Create(itemBtn, TweenInfo.new(0.2), {TextColor3 = Darker(self.Theme.FontColor, 1.5)}):Play()
					end)
					itemBtn.MouseButton1Click:Connect(function()
						selected[name] = not selected[name]
						checkMark.Text = selected[name] and "●" or ""
						pcall(callback, name, value)
					end)
				end

				for name, value in next, items do
					if index == 1 then
						addItem(tostring(name), tostring(value))
					elseif index == 2 then
						addItem(tostring(value), tostring(name))
					end
				end

				local mdObj = {}

				function mdObj.Refresh(newItems)
					for _, v in next, mdList:GetChildren() do
						if v:IsA("TextButton") then v:Destroy() end
					end
					task.wait()
					selected = {}
					for name, value in next, newItems do
						if index == 1 then
							addItem(tostring(name), tostring(value))
						elseif index == 2 then
							addItem(tostring(value), tostring(name))
						end
					end
				end

				return mdObj
			end

			function secObj.TextBox(tbText, callback, default, placeholder)
				local tbFrame = Instance.new("Frame")
				tbFrame.Name = tbText
				tbFrame.Parent = elementHolder
				tbFrame.BackgroundTransparency = 1
				tbFrame.Size = UDim2.new(0.95, 0, 0, 24)
				tbFrame.Position = UDim2.new(0.025, 0, 0, 0)

				local textBox = Instance.new("TextBox")
				textBox.Name = "TextBox"
				textBox.Parent = tbFrame
				textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				textBox.BorderSizePixel = 0
				textBox.Size = UDim2.new(1, 0, 1, 0)
				textBox.Font = Enum.Font[self.Theme.Font]
				textBox.Text = default or ""
				textBox.PlaceholderText = placeholder or tbText
				textBox.PlaceholderColor3 = Darker(self.Theme.FontColor, 1.5)
				textBox.TextSize = 12
				textBox.TextColor3 = self.Theme.FontColor
				textBox.TextXAlignment = Enum.TextXAlignment.Left
				textBox.ClearTextOnFocus = false

				local tbCorner = Instance.new("UICorner")
				tbCorner.Parent = textBox
				tbCorner.CornerRadius = UDim.new(0, 4)

				local tbStroke = Instance.new("UIStroke")
				tbStroke.Parent = textBox
				tbStroke.Thickness = 1
				tbStroke.Color = Color3.fromRGB(20, 20, 20)
				tbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				textBox.Focused:Connect(function()
					TweenService:Create(tbStroke, TweenInfo.new(0.2), {Color = self.Theme.AccentColor}):Play()
				end)
				textBox.FocusLost:Connect(function()
					TweenService:Create(tbStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(20, 20, 20)}):Play()
					pcall(callback, textBox.Text)
				end)

				return textBox
			end

			function secObj.TextLabel(labelText)
				local label = Instance.new("TextLabel")
				label.Name = "Label"
				label.Parent = elementHolder
				label.BackgroundTransparency = 1
				label.BorderSizePixel = 0
				label.Size = UDim2.new(0.95, 0, 0, 16)
				label.Position = UDim2.new(0.025, 0, 0, 0)
				label.Font = Enum.Font[self.Theme.Font]
				label.Text = labelText
				label.TextSize = 11
				label.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				label.TextXAlignment = Enum.TextXAlignment.Left

				return label
			end

			function secObj.KeyBind(kbText, callback, defaultKey)
				local kbFrame = Instance.new("Frame")
				kbFrame.Name = kbText
				kbFrame.Parent = elementHolder
				kbFrame.BackgroundTransparency = 1
				kbFrame.Size = UDim2.new(0.95, 0, 0, 22)
				kbFrame.Position = UDim2.new(0.025, 0, 0, 0)

				local kbLabel = Instance.new("TextLabel")
				kbLabel.Name = "Label"
				kbLabel.Parent = kbFrame
				kbLabel.BackgroundTransparency = 1
				kbLabel.Position = UDim2.new(0, 0, 0, 0)
				kbLabel.Size = UDim2.new(1, -60, 1, 0)
				kbLabel.Font = Enum.Font[self.Theme.Font]
				kbLabel.Text = kbText
				kbLabel.TextSize = 12
				kbLabel.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				kbLabel.TextXAlignment = Enum.TextXAlignment.Left

				local keyDisplay = Instance.new("TextButton")
				keyDisplay.Name = "KeyBind"
				keyDisplay.Parent = kbFrame
				keyDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				keyDisplay.BorderSizePixel = 0
				keyDisplay.AnchorPoint = Vector2.new(1, 0.5)
				keyDisplay.Position = UDim2.new(1, 0, 0.5, 0)
				keyDisplay.Size = UDim2.new(0, 50, 0, 18)
				keyDisplay.Font = Enum.Font[self.Theme.Font]
				keyDisplay.TextSize = 11
				keyDisplay.TextColor3 = Darker(self.Theme.FontColor, 1.5)
				keyDisplay.AutoButtonColor = false

				local kdCorner = Instance.new("UICorner")
				kdCorner.Parent = keyDisplay
				kdCorner.CornerRadius = UDim.new(0, 4)

				local kdStroke = Instance.new("UIStroke")
				kdStroke.Parent = keyDisplay
				kdStroke.Thickness = 1
				kdStroke.Color = Color3.fromRGB(20, 20, 20)
				kdStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				local keyName = defaultKey or "..."
				local picking = false

				local function getKeyDisplay(k)
					local s = tostring(k):gsub("Enum.KeyCode.", "")
					local map = {
						["LeftControl"] = "LCtrl", ["RightControl"] = "RCtrl",
						["LeftShift"] = "LShift", ["RightShift"] = "RShift",
						["LeftAlt"] = "LAlt", ["RightAlt"] = "RAlt",
						["Space"] = "Space", ["Return"] = "Enter",
						["Escape"] = "Esc", ["Tab"] = "Tab",
						["Backspace"] = "Back", ["Delete"] = "Del",
						["Insert"] = "Ins", ["Home"] = "Home",
						["End"] = "End", ["PageUp"] = "PgUp",
						["PageDown"] = "PgDn"
					}
					return map[s] or s
				end

				if typeof(defaultKey) == "EnumItem" then
					keyName = tostring(defaultKey):gsub("Enum.KeyCode.", "")
					keyDisplay.Text = getKeyDisplay(defaultKey)
				elseif type(defaultKey) == "string" then
					keyName = defaultKey
					local ke = getEnumMember(Enum.KeyCode, defaultKey)
					keyDisplay.Text = ke and getKeyDisplay(ke) or defaultKey
				else
					keyDisplay.Text = "..."
				end

				UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard and picking then
						local hideKey = getEnumMember(Enum.KeyCode, self.Theme.HideKey)
						if not (hideKey and input.KeyCode == hideKey) then
							keyName = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
							keyDisplay.Text = getKeyDisplay(input.KeyCode)
							picking = false
							pcall(callback, keyName)
						end
					end
				end)

				keyDisplay.MouseButton1Click:Connect(function()
					picking = true
					keyDisplay.Text = "..."
				end)

				return kbFrame
			end

			return pageObj
		end

		local notifications = {}
		local notifOffset = 0.135
		local notifBaseY = 0.76

		local function updateNotifPositions()
			for i, notif in ipairs(notifications) do
				local newY = notifBaseY - (notifOffset * (i - 1))
				TweenService:Create(notif, TweenInfo.new(0.2), {Position = UDim2.new(0.78, 0, newY, 0)}):Play()
			end
		end

		function main:Notification(header, text)
			local yOff = notifBaseY - (notifOffset * #notifications)

			local bar = Instance.new("Frame")
			bar.Name = header
			bar.Parent = screenGui
			bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			bar.BorderSizePixel = 0
			bar.Position = UDim2.new(1, 20, yOff, 0)
			bar.Size = UDim2.new(0.2, 0, 0.12, 0)
			bar.ClipsDescendants = true
			bar.BackgroundTransparency = 1
			bar.ZIndex = 50 + #notifications

			local barCorner = Instance.new("UICorner")
			barCorner.Parent = bar
			barCorner.CornerRadius = UDim.new(0, 8)

			local barStroke = Instance.new("UIStroke")
			barStroke.Parent = bar
			barStroke.Thickness = 1
			barStroke.Color = self.Theme.AccentColor
			barStroke.Transparency = 0.5

			local headerLabel = Instance.new("TextLabel")
			headerLabel.Parent = bar
			headerLabel.Font = Enum.Font[self.Theme.Font]
			headerLabel.Text = header
			headerLabel.TextSize = 14
			headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			headerLabel.TextXAlignment = Enum.TextXAlignment.Left
			headerLabel.BackgroundTransparency = 1
			headerLabel.BorderSizePixel = 0
			headerLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
			headerLabel.Size = UDim2.new(0.9, 0, 0.25, 0)
			headerLabel.ZIndex = 51 + #notifications

			local infoLabel = Instance.new("TextLabel")
			infoLabel.Parent = bar
			infoLabel.Font = Enum.Font[self.Theme.Font]
			infoLabel.Text = text
			infoLabel.TextSize = 11
			infoLabel.TextColor3 = self.Theme.FontColor
			infoLabel.TextXAlignment = Enum.TextXAlignment.Left
			infoLabel.TextYAlignment = Enum.TextYAlignment.Top
			infoLabel.BackgroundTransparency = 1
			infoLabel.BorderSizePixel = 0
			infoLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
			infoLabel.Size = UDim2.new(0.9, 0, 0.6, 0)
			infoLabel.TextWrapped = true
			infoLabel.ZIndex = 51 + #notifications

			table.insert(notifications, bar)

			task.spawn(function()
				TweenService:Create(bar, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.78, 0, yOff, 0),
					BackgroundTransparency = 0
				}):Play()
				TweenService:Create(barStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()

				task.wait(4)

				TweenService:Create(bar, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					Position = UDim2.new(1, 20, yOff, 0),
					BackgroundTransparency = 1
				}):Play()
				TweenService:Create(barStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()

				task.wait(0.4)
				for i, n in ipairs(notifications) do
					if n == bar then
						table.remove(notifications, i)
						break
					end
				end
				updateNotifPositions()
				bar:Destroy()
			end)
		end

		return main
	end

	return AevryxLib
end
