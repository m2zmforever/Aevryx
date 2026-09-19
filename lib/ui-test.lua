local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local AevryxLib = {
	["Theme"] = {
		["Font"] = "RobotoMono",
		["AccentColor"] = Color3.fromRGB(66, 134, 255),
		["FontColor"] = Color3.fromRGB(255,255,255),
		["HideKey"] = "LeftControl"
	},
}

local function Darker(col, coe)
	local h, s, v = Color3.toHSV(col)
	return Color3.fromHSV(h, s, v / (coe or 1.5))
end

local function Lighter(col, coe)
	local h, s, v = Color3.toHSV(col)
	return Color3.fromHSV(h, s, v * (coe or 1.5))
end

local gui = Instance.new("ScreenGui")
gui.Name = "AevryxLib"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 800, 0, 400)
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
topbar.BorderSizePixel = 0
topbar.Size = UDim2.new(1, 0, 0, 32)
topbar.Parent = mainFrame

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(0, 8)
topbarCorner.Parent = topbar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Font = Enum.Font[AevryxLib.Theme.Font]
titleLabel.Text = "Aevryx"
titleLabel.TextColor3 = AevryxLib.Theme.FontColor
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topbar

local hideKeybind = Instance.new("TextButton")
hideKeybind.Name = "Hide"
hideKeybind.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
hideKeybind.BorderSizePixel = 0
hideKeybind.Position = UDim2.new(1, -40, 0.5, -10)
hideKeybind.Size = UDim2.new(0, 30, 0, 20)
hideKeybind.Font = Enum.Font[AevryxLib.Theme.Font]
hideKeybind.Text = "X"
hideKeybind.TextColor3 = AevryxLib.Theme.FontColor
hideKeybind.TextSize = 12
hideKeybind.AutoButtonColor = false
hideKeybind.Parent = topbar

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 4)
hideCorner.Parent = hideKeybind

local tabHolder = Instance.new("Frame")
tabHolder.Name = "TabHolder"
tabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tabHolder.BorderSizePixel = 0
tabHolder.Position = UDim2.new(0, 0, 0, 32)
tabHolder.Size = UDim2.new(0, 150, 1, -32)
tabHolder.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)
tabLayout.Parent = tabHolder

local contentHolder = Instance.new("Frame")
contentHolder.Name = "ContentHolder"
contentHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
contentHolder.BorderSizePixel = 0
contentHolder.Position = UDim2.new(0, 150, 0, 32)
contentHolder.Size = UDim2.new(1, -150, 1, -32)
contentHolder.Parent = mainFrame

local tabsContainer = Instance.new("Folder")
tabsContainer.Name = "Tabs"
tabsContainer.Parent = contentHolder

local activeNotifications = {}
local notifOffset = 0.13
local notifBaseY = 0.76

local function makeDraggable(topbarObj, obj)
	local dragging = nil
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	local function update(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
		obj.Position = newPos
	end

	topbarObj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	topbarObj.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	InputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

makeDraggable(topbar, mainFrame)

local uiVisible = true
hideKeybind.MouseButton1Click:Connect(function()
	uiVisible = not uiVisible
	if uiVisible then
		mainFrame.Visible = true
		gui.Enabled = true
	else
		gui.Enabled = false
	end
end)

InputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode[AevryxLib.Theme.HideKey or "LeftControl"] then
		uiVisible = not uiVisible
		mainFrame.Visible = uiVisible
		gui.Enabled = uiVisible
	end
end)

function AevryxLib:Notification(title, text)
	local offset = notifBaseY - (notifOffset * #activeNotifications)

	local bar = Instance.new("Frame")
	bar.Name = "Notification_" .. title
	bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	bar.BorderSizePixel = 0
	bar.AnchorPoint = Vector2.new(0, 1)
	bar.Position = UDim2.new(1, 20, offset, 0)
	bar.Size = UDim2.new(0, 300, 0, 80)
	bar.ClipsDescendants = true
	bar.BackgroundTransparency = 1
	bar.Parent = gui

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 6)
	barCorner.Parent = bar

	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.BackgroundTransparency = 1
	header.Position = UDim2.new(0, 10, 0, 8)
	header.Size = UDim2.new(0, 280, 0, 24)
	header.Font = Enum.Font[AevryxLib.Theme.Font]
	header.Text = title
	header.TextColor3 = AevryxLib.Theme.FontColor
	header.TextSize = 14
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = bar

	local body = Instance.new("TextLabel")
	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.Position = UDim2.new(0, 10, 0, 32)
	body.Size = UDim2.new(0, 280, 0, 40)
	body.Font = Enum.Font[AevryxLib.Theme.Font]
	body.Text = text
	body.TextColor3 = Darker(AevryxLib.Theme.FontColor, 1.5)
	body.TextSize = 12
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextWrapped = true
	body.Parent = bar

	table.insert(activeNotifications, bar)

	TweenService:Create(bar, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, -320, offset, 0),
		BackgroundTransparency = 0,
	}):Play()

	task.delay(4, function()
		TweenService:Create(bar, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 20, offset, 0),
			BackgroundTransparency = 1,
		}):Play()
		task.wait(0.4)
		for i, v in ipairs(activeNotifications) do
			if v == bar then
				table.remove(activeNotifications, i)
				break
			end
		end
		bar:Destroy()
	end)
end

local tabCount = 0
local firstTab = nil

function AevryxLib:Tab(name)
	tabCount = tabCount + 1
	local isFirst = (tabCount == 1)

	local tabButton = Instance.new("TextButton")
	tabButton.Name = "Tab_" .. name
	tabButton.BackgroundColor3 = isFirst and AevryxLib.Theme.AccentColor or Color3.fromRGB(45, 45, 50)
	tabButton.BorderSizePixel = 0
	tabButton.Size = UDim2.new(1, 0, 0, 36)
	tabButton.Font = Enum.Font[AevryxLib.Theme.Font]
	tabButton.Text = "  " .. name
	tabButton.TextColor3 = isFirst and Color3.fromRGB(255,255,255) or Darker(AevryxLib.Theme.FontColor, 2)
	tabButton.TextSize = 13
	tabButton.TextXAlignment = Enum.TextXAlignment.Left
	tabButton.AutoButtonColor = false
	tabButton.Parent = tabHolder

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 4)
	tabCorner.Parent = tabButton

	local page = Instance.new("ScrollingFrame")
	page.Name = "Page_" .. name
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Size = UDim2.new(1, 0, 1, 0)
	page.ScrollBarThickness = 4
	page.ScrollBarImageColor3 = Darker(AevryxLib.Theme.AccentColor, 2)
	page.Visible = isFirst
	page.Parent = tabsContainer

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 8)
	pageLayout.Parent = page

	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingTop = UDim.new(0, 8)
	pagePadding.PaddingLeft = UDim.new(0, 8)
	pagePadding.PaddingRight = UDim.new(0, 8)
	pagePadding.PaddingBottom = UDim.new(0, 8)
	pagePadding.Parent = page

	if isFirst then
		firstTab = page
	end

	tabButton.MouseButton1Click:Connect(function()
		for _, child in pairs(tabsContainer:GetChildren()) do
			child.Visible = false
		end
		page.Visible = true
		for _, child in pairs(tabHolder:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
				child.TextColor3 = Darker(AevryxLib.Theme.FontColor, 2)
			end
		end
		tabButton.BackgroundColor3 = AevryxLib.Theme.AccentColor
		tabButton.TextColor3 = Color3.fromRGB(255,255,255)
	end)

	local tabObj = {}
	sectionCount = 0

	function tabObj:Section(name)
		sectionCount = sectionCount + 1

		local section = Instance.new("Frame")
		section.Name = "Section_" .. name
		section.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
		section.BorderSizePixel = 0
		section.Size = UDim2.new(1, 0, 0, 30)
		section.AutomaticSize = Enum.AutomaticSize.Y
		section.Parent = page

		local sectionCorner = Instance.new("UICorner")
		sectionCorner.CornerRadius = UDim.new(0, 5)
		sectionCorner.Parent = section

		local sectionTitle = Instance.new("TextLabel")
		sectionTitle.Name = "Title"
		sectionTitle.BackgroundTransparency = 1
		sectionTitle.Position = UDim2.new(0, 8, 0, 4)
		sectionTitle.Size = UDim2.new(1, -16, 0, 22)
		sectionTitle.Font = Enum.Font[AevryxLib.Theme.Font]
		sectionTitle.Text = name
		sectionTitle.TextColor3 = AevryxLib.Theme.FontColor
		sectionTitle.TextSize = 13
		sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
		sectionTitle.Parent = section

		local elements = Instance.new("Frame")
		elements.Name = "Elements"
		elements.BackgroundTransparency = 1
		elements.Position = UDim2.new(0, 0, 0, 28)
		elements.Size = UDim2.new(1, 0, 1, -28)
		elements.Parent = section

		local elementsLayout = Instance.new("UIListLayout")
		elementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
		elementsLayout.Padding = UDim.new(0, 6)
		elementsLayout.Parent = elements

		local sectionObj = {}
		local elemCount = 0

		function sectionObj:Checkbox(name, callback, default)
			elemCount = elemCount + 1
			local checked = default or false

			local container = Instance.new("TextButton")
			container.Name = "Checkbox_" .. name
			container.BackgroundTransparency = 1
			container.Size = UDim2.new(1, 0, 0, 24)
			container.Font = Enum.Font[AevryxLib.Theme.Font]
			container.Text = ""
			container.TextColor3 = Color3.fromRGB(0, 0, 0)
			container.AutoButtonColor = false
			container.Parent = elements

			local box = Instance.new("Frame")
			box.Name = "Box"
			box.BackgroundColor3 = checked and AevryxLib.Theme.AccentColor or Color3.fromRGB(70, 70, 75)
			box.BorderSizePixel = 0
			box.Position = UDim2.new(0, 4, 0.5, -6)
			box.Size = UDim2.new(0, 12, 0, 12)
			box.Parent = container

			local boxCorner = Instance.new("UICorner")
			boxCorner.CornerRadius = UDim.new(0, 3)
			boxCorner.Parent = box

			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.BackgroundTransparency = 1
			label.Position = UDim2.new(0, 24, 0, 0)
			label.Size = UDim2.new(1, -28, 1, 0)
			label.Font = Enum.Font[AevryxLib.Theme.Font]
			label.Text = name
			label.TextColor3 = checked and AevryxLib.Theme.FontColor or Darker(AevryxLib.Theme.FontColor, 2)
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			container.MouseButton1Click:Connect(function()
				checked = not checked
				box.BackgroundColor3 = checked and AevryxLib.Theme.AccentColor or Color3.fromRGB(70, 70, 75)
				label.TextColor3 = checked and AevryxLib.Theme.FontColor or Darker(AevryxLib.Theme.FontColor, 2)
				if callback then callback(checked) end
			end)

			if callback then callback(checked) end
			return container
		end

		function sectionObj:Toggle(name, desc, default, callback)
			return self:Checkbox(name, callback, default)
		end

		function sectionObj:Slider(name, min, max, callback, precise, default)
			elemCount = elemCount + 1
			local startVal = default or min

			local container = Instance.new("Frame")
			container.Name = "Slider_" .. name
			container.BackgroundTransparency = 1
			container.Size = UDim2.new(1, 0, 0, 44)
			container.Parent = elements

			local title = Instance.new("TextLabel")
			title.Name = "Title"
			title.BackgroundTransparency = 1
			title.Size = UDim2.new(1, 0, 0, 18)
			title.Font = Enum.Font[AevryxLib.Theme.Font]
			title.Text = name
			title.TextColor3 = AevryxLib.Theme.FontColor
			title.TextSize = 12
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = container

			local bar = Instance.new("Frame")
			bar.Name = "Bar"
			bar.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
			bar.BorderSizePixel = 0
			bar.Position = UDim2.new(0, 4, 1, -14)
			bar.Size = UDim2.new(1, -8, 0, 4)
			bar.Parent = container

			local barCorner = Instance.new("UICorner")
			barCorner.CornerRadius = UDim.new(2, 0)
			barCorner.Parent = bar

			local fill = Instance.new("Frame")
			fill.Name = "Fill"
			fill.BackgroundColor3 = AevryxLib.Theme.AccentColor
			fill.BorderSizePixel = 0
			fill.Size = UDim2.new((startVal - min) / (max - min), 0, 1, 0)
			fill.Parent = bar

			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(2, 0)
			fillCorner.Parent = fill

			local valueLabel = Instance.new("TextLabel")
			valueLabel.Name = "Value"
			valueLabel.BackgroundTransparency = 1
			valueLabel.Position = UDim2.new(0, 4, 0, 22)
			valueLabel.Size = UDim2.new(0, 60, 0, 16)
			valueLabel.Font = Enum.Font[AevryxLib.Theme.Font]
			valueLabel.Text = tostring(startVal)
			valueLabel.TextColor3 = AevryxLib.Theme.FontColor
			valueLabel.TextSize = 11
			valueLabel.TextXAlignment = Enum.TextXAlignment.Left
			valueLabel.Parent = container

			local dragging = false
			local function updateSlider(input)
				if not dragging then return end
				local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				local val = min + relX * (max - min)
				val = precise and tonumber(string.format("%.1f", val)) or math.floor(val)
				fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
				valueLabel.Text = tostring(val)
				if callback then callback(val) end
			end

			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					local val = min + relX * (max - min)
					val = precise and tonumber(string.format("%.1f", val)) or math.floor(val)
					fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
					valueLabel.Text = tostring(val)
					if callback then callback(val) end
				end
			end)

			bar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			InputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					updateSlider(input)
				end
			end)

			local sliderApi = {}
			function sliderApi:Change(val)
				val = math.clamp(val, min, max)
				local display = precise and tonumber(string.format("%.1f", val)) or math.floor(val)
				fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
				valueLabel.Text = tostring(display)
				if callback then callback(display) end
			end
			return sliderApi
		end

		function sectionObj:Button(name, callback)
			elemCount = elemCount + 1

			local btn = Instance.new("TextButton")
			btn.Name = "Button_" .. name
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
			btn.BorderSizePixel = 0
			btn.Size = UDim2.new(1, -8, 0, 30)
			btn.Font = Enum.Font[AevryxLib.Theme.Font]
			btn.Text = name
			btn.TextColor3 = AevryxLib.Theme.FontColor
			btn.TextSize = 12
			btn.AutoButtonColor = false
			btn.Parent = elements

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 4)
			btnCorner.Parent = btn

			btn.MouseEnter:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(75, 75, 80)}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)

			return btn
		end

		function sectionObj:TextLabel(text)
			elemCount = elemCount + 1

			local label = Instance.new("TextLabel")
			label.Name = "TextLabel"
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, 0, 0, 18)
			label.Font = Enum.Font[AevryxLib.Theme.Font]
			label.Text = text
			label.TextColor3 = Darker(AevryxLib.Theme.FontColor, 2)
			label.TextSize = 11
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = elements

			return label
		end

		function sectionObj:TextBox(name, callback, default, placeholder)
			elemCount = elemCount + 1

			local container = Instance.new("Frame")
			container.Name = "TextBox_" .. name
			container.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
			container.BorderSizePixel = 0
			container.Size = UDim2.new(1, -8, 0, 26)
			container.Parent = elements

			local containerCorner = Instance.new("UICorner")
			containerCorner.CornerRadius = UDim.new(0, 4)
			containerCorner.Parent = container

			local box = Instance.new("TextBox")
			box.Name = "Input"
			box.BackgroundTransparency = 1
			box.Size = UDim2.new(1, -16, 1, 0)
			box.Position = UDim2.new(0, 8, 0, 0)
			box.Font = Enum.Font[AevryxLib.Theme.Font]
			box.Text = default or ""
			box.TextColor3 = AevryxLib.Theme.FontColor
			box.TextSize = 12
			box.TextXAlignment = Enum.TextXAlignment.Left
			box.PlaceholderText = placeholder or ""
			box.PlaceholderColor3 = Darker(AevryxLib.Theme.FontColor, 2)
			box.ClearTextOnFocus = false
			box.Parent = container

			box.FocusLost:Connect(function(enterPressed)
				if not enterPressed then return end
				pcall(callback, box.Text)
			end)

			return box
		end

		function sectionObj:KeyBind(name, callback, defaultKey)
			elemCount = elemCount + 1
			local currentKey = defaultKey or "K"

			local container = Instance.new("Frame")
			container.Name = "KeyBind_" .. name
			container.BackgroundTransparency = 1
			container.Size = UDim2.new(1, 0, 0, 26)
			container.Parent = elements

			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(0.7, 0, 1, 0)
			label.Font = Enum.Font[AevryxLib.Theme.Font]
			label.Text = name
			label.TextColor3 = Darker(AevryxLib.Theme.FontColor, 2)
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			local keyBtn = Instance.new("TextButton")
			keyBtn.Name = "KeyButton"
			keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
			keyBtn.BorderSizePixel = 0
			keyBtn.Size = UDim2.new(0, 60, 1, 0)
			keyBtn.Position = UDim2.new(1, -64, 0, 0)
			keyBtn.Font = Enum.Font[AevryxLib.Theme.Font]
			keyBtn.Text = currentKey
			keyBtn.TextColor3 = AevryxLib.Theme.FontColor
			keyBtn.TextSize = 11
			keyBtn.AutoButtonColor = false
			keyBtn.Parent = container

			local keyBtnCorner = Instance.new("UICorner")
			keyBtnCorner.CornerRadius = UDim.new(0, 4)
			keyBtnCorner.Parent = keyBtn

			keyBtn.MouseButton1Click:Connect(function()
				keyBtn.Text = "..."
				InputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode.Name
						keyBtn.Text = currentKey
						if callback then callback(currentKey) end
						return true
					end
				end)
			end)

			return container
		end

		function sectionObj:WelcomeSection(imageId, text)
			elemCount = elemCount + 1

			local container = Instance.new("Frame")
			container.Name = "WelcomeSection"
			container.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			container.BorderSizePixel = 0
			container.Size = UDim2.new(1, -8, 0, 80)
			container.Parent = elements

			local containerCorner = Instance.new("UICorner")
			containerCorner.CornerRadius = UDim.new(0, 5)
			containerCorner.Parent = container

			local avatar = Instance.new("ImageLabel")
			avatar.Name = "Avatar"
			avatar.BackgroundTransparency = 1
			avatar.Position = UDim2.new(0, 8, 0.5, -28)
			avatar.Size = UDim2.new(0, 56, 0, 56)
			avatar.Image = imageId or ""
			avatar.ScaleType = Enum.ScaleType.Crop
			avatar.Parent = container

			local avatarCorner = Instance.new("UICorner")
			avatarCorner.CornerRadius = UDim.new(0, 4)
			avatarCorner.Parent = avatar

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Name = "NameLabel"
			nameLabel.BackgroundTransparency = 1
			nameLabel.Position = UDim2.new(0, 72, 0, 16)
			nameLabel.Size = UDim2.new(1, -80, 0, 24)
			nameLabel.Font = Enum.Font[AevryxLib.Theme.Font]
			nameLabel.Text = text or ""
			nameLabel.TextColor3 = AevryxLib.Theme.FontColor
			nameLabel.TextSize = 18
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.Parent = container

			local subtitle = Instance.new("TextLabel")
			subtitle.Name = "Subtitle"
			subtitle.BackgroundTransparency = 1
			subtitle.Position = UDim2.new(0, 72, 0, 42)
			subtitle.Size = UDim2.new(1, -80, 0, 18)
			subtitle.Font = Enum.Font[AevryxLib.Theme.Font]
			subtitle.Text = "Welcome"
			subtitle.TextColor3 = Darker(AevryxLib.Theme.FontColor, 2)
			subtitle.TextSize = 11
			subtitle.TextXAlignment = Enum.TextXAlignment.Left
			subtitle.Parent = container

			local welcomeApi = {}
			function welcomeApi:SetAvatar(img)
				avatar.Image = img or ""
			end
			function welcomeApi:SetName(txt)
				nameLabel.Text = tostring(txt)
			end
			function welcomeApi:SetSubtitle(txt)
				subtitle.Text = tostring(txt)
			end
			return welcomeApi
		end

		function sectionObj:Dropdown(name, items, index, callback)
			elemCount = elemCount + 1
			local isOpen = false
			local selected = nil

			local container = Instance.new("TextButton")
			container.Name = "Dropdown_" .. name
			container.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
			container.BorderSizePixel = 0
			container.Size = UDim2.new(1, -8, 0, 30)
			container.Font = Enum.Font[AevryxLib.Theme.Font]
			container.Text = "  " .. name
			container.TextColor3 = AevryxLib.Theme.FontColor
			container.TextSize = 12
			container.TextXAlignment = Enum.TextXAlignment.Left
			container.AutoButtonColor = false
			container.Parent = elements

			local containerCorner = Instance.new("UICorner")
			containerCorner.CornerRadius = UDim.new(0, 4)
			containerCorner.Parent = container

			local list = Instance.new("ScrollingFrame")
			list.Name = "List"
			list.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			list.BorderSizePixel = 0
			list.Position = UDim2.new(0, 0, 1, 4)
			list.Size = UDim2.new(1, -8, 0, 0)
			list.Visible = false
			list.ScrollBarThickness = 3
			list.ClipsDescendants = true
			list.Parent = container

			local listLayout = Instance.new("UIListLayout")
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Padding = UDim.new(0, 2)
			listLayout.Parent = list

			local listCorner = Instance.new("UICorner")
			listCorner.CornerRadius = UDim.new(0, 4)
			listCorner.Parent = list

			local toggleDropdown = nil
			toggleDropdown = function()
				isOpen = not isOpen
				if isOpen then
					list.Size = UDim2.new(1, -8, 0, math.min(120, 26 * (#items or 0)))
					list.Visible = true
				else
					list.Visible = false
					list.Size = UDim2.new(1, -8, 0, 0)
				end
			end

			container.MouseButton1Click:Connect(toggleDropdown)

			for display, value in pairs(items or {}) do
				local item = Instance.new("TextButton")
				item.Name = "Item_" .. tostring(display)
				item.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
				item.BorderSizePixel = 0
				item.Size = UDim2.new(1, -4, 0, 26)
				item.Font = Enum.Font[AevryxLib.Theme.Font]
				item.Text = "    " .. tostring(display)
				item.TextColor3 = AevryxLib.Theme.FontColor
				item.TextSize = 11
				item.TextXAlignment = Enum.TextXAlignment.Left
				item.AutoButtonColor = false
				item.Parent = list

				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 3)
				itemCorner.Parent = item

				item.MouseEnter:Connect(function()
					item.BackgroundColor3 = Color3.fromRGB(75, 75, 80)
				end)
				item.MouseLeave:Connect(function()
					item.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
				end)
				item.MouseButton1Click:Connect(function()
					selected = display
					container.Text = "  " .. display
					pcall(callback, value, display)
					toggleDropdown()
				end)
			end

			local dropApi = {}
			function dropApi:Refresh(newItems)
				items = newItems or items
				for _, child in pairs(list:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end
				for display, value in pairs(items) do
					local item = Instance.new("TextButton")
					item.Name = "Item_" .. tostring(display)
					item.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
					item.BorderSizePixel = 0
					item.Size = UDim2.new(1, -4, 0, 26)
					item.Font = Enum.Font[AevryxLib.Theme.Font]
					item.Text = "    " .. tostring(display)
					item.TextColor3 = AevryxLib.Theme.FontColor
					item.TextSize = 11
					item.TextXAlignment = Enum.TextXAlignment.Left
					item.AutoButtonColor = false
					item.Parent = list

					local itemCorner = Instance.new("UICorner")
					itemCorner.CornerRadius = UDim.new(0, 3)
					itemCorner.Parent = item

					item.MouseButton1Click:Connect(function()
						selected = display
						container.Text = "  " .. display
						pcall(callback, value, display)
						toggleDropdown()
					end)
				end
			end
			function dropApi:Set(val)
				container.Text = "  " .. tostring(val)
			end
			return dropApi
		end

		function sectionObj:MultiDropdown(name, items, index, callback)
			elemCount = elemCount + 1
			local selected = {}

			local container = Instance.new("TextButton")
			container.Name = "MultiDropdown_" .. name
			container.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
			container.BorderSizePixel = 0
			container.Size = UDim2.new(1, -8, 0, 30)
			container.Font = Enum.Font[AevryxLib.Theme.Font]
			container.Text = "  " .. name
			container.TextColor3 = AevryxLib.Theme.FontColor
			container.TextSize = 12
			container.TextXAlignment = Enum.TextXAlignment.Left
			container.AutoButtonColor = false
			container.Parent = elements

			local containerCorner = Instance.new("UICorner")
			containerCorner.CornerRadius = UDim.new(0, 4)
			containerCorner.Parent = container

			local list = Instance.new("ScrollingFrame")
			list.Name = "List"
			list.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			list.BorderSizePixel = 0
			list.Position = UDim2.new(0, 0, 1, 4)
			list.Size = UDim2.new(1, -8, 0, 0)
			list.Visible = false
			list.ScrollBarThickness = 3
			list.ClipsDescendants = true
			list.Parent = container

			local listLayout = Instance.new("UIListLayout")
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Padding = UDim.new(0, 2)
			listLayout.Parent = list

			local listCorner = Instance.new("UICorner")
			listCorner.CornerRadius = UDim.new(0, 4)
			listCorner.Parent = list

			local isOpen = false
			local toggleDropdown = nil
			toggleDropdown = function()
				isOpen = not isOpen
				if isOpen then
					list.Size = UDim2.new(1, -8, 0, math.min(120, 26 * (#items or 0)))
					list.Visible = true
				else
					list.Visible = false
					list.Size = UDim2.new(1, -8, 0, 0)
				end
			end

			container.MouseButton1Click:Connect(toggleDropdown)

			for display, value in pairs(items or {}) do
				local item = Instance.new("TextButton")
				item.Name = "Item_" .. tostring(display)
				item.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
				item.BorderSizePixel = 0
				item.Size = UDim2.new(1, -4, 0, 24)
				item.Font = Enum.Font[AevryxLib.Theme.Font]
				item.Text = "    " .. tostring(display)
				item.TextColor3 = AevryxLib.Theme.FontColor
				item.TextSize = 11
				item.TextXAlignment = Enum.TextXAlignment.Left
				item.AutoButtonColor = false
				item.Parent = list

				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 3)
				itemCorner.Parent = item

				local mark = Instance.new("TextLabel")
				mark.Name = "Mark"
				mark.BackgroundTransparency = 1
				mark.AnchorPoint = Vector2.new(1, 0.5)
				mark.Position = UDim2.new(1, -8, 0.5, 0)
				mark.Size = UDim2.new(0, 12, 0, 12)
				mark.Font = Enum.Font[AevryxLib.Theme.Font]
				mark.Text = ""
				mark.TextColor3 = AevryxLib.Theme.AccentColor
				mark.TextSize = 12
				mark.TextXAlignment = Enum.TextXAlignment.Right
				mark.Parent = item

				item.MouseButton1Click:Connect(function()
					selected[display] = not selected[display]
					mark.Text = selected[display] and "X" or ""
					pcall(callback, value, display)
				end)
			end

			local dropApi = {}
			function dropApi:Refresh(newItems)
				items = newItems or items
				for _, child in pairs(list:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end
				for display, value in pairs(items) do
					local item = Instance.new("TextButton")
					item.Name = "Item_" .. tostring(display)
					item.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
					item.BorderSizePixel = 0
					item.Size = UDim2.new(1, -4, 0, 24)
					item.Font = Enum.Font[AevryxLib.Theme.Font]
					item.Text = "    " .. tostring(display)
					item.TextColor3 = AevryxLib.Theme.FontColor
					item.TextSize = 11
					item.TextXAlignment = Enum.TextXAlignment.Left
					item.AutoButtonColor = false
					item.Parent = list

					local itemCorner = Instance.new("UICorner")
					itemCorner.CornerRadius = UDim.new(0, 3)
					itemCorner.Parent = item

					item.MouseButton1Click:Connect(function()
						selected[display] = not selected[display]
						pcall(callback, value, display)
					end)
				end
			end
			return dropApi
		end

		return sectionObj
	end

	return tabObj
end

function AevryxLib:Window(name, x, y)
	tabCount = 0
	x = x or 800
	y = y or 400

	local oldGui = game.CoreGui:FindFirstChild("AevryxLib")
	if oldGui then oldGui:Destroy() end

	mainFrame.Size = UDim2.new(0, x, 0, y)
	mainFrame.Visible = true
	gui.Enabled = true

	local tabApi = {}
	function tabApi:Tab(name)
		return AevryxLib:Tab(name)
	end

	return tabApi
end

return AevryxLib
