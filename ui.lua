
--[[
	Flok Kaitun - UI Generator
	Handles all UI creation, styling, and animations
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local UI = {}
local uiObjects = {}

-- Constants for styling
local COLORS = {
	Background = Color3.fromRGB(25, 25, 35),
	Accent = Color3.fromRGB(100, 150, 255),
	AccentDark = Color3.fromRGB(70, 120, 220),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 200),
	Card = Color3.fromRGB(35, 35, 50),
	LoadingBar = Color3.fromRGB(100, 150, 255)
}

local FONTS = {
	Title = Enum.Font.GothamBold,
	Body = Enum.Font.GothamSemibold,
	Mono = Enum.Font.Gotham
}

-- Helper function to create rounded corners
local function applyRoundedCorners(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

-- Helper function to create strokes
local function applyStroke(instance, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Transparency = 0.7
	stroke.Parent = instance
	return stroke
end

--[[
	Creates the loading screen
]]
function UI.createLoadingScreen()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlokKaitun_Loading"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = PlayerGui
	
	-- Main container
	local container = Instance.new("Frame")
	container.Name = "LoadingContainer"
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundColor3 = COLORS.Background
	container.BackgroundTransparency = 0
	container.BorderSizePixel = 0
	container.Parent = screenGui
	
	-- Center content
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(0, 400, 0, 200)
	content.Position = UDim2.new(0.5, -200, 0.5, -100)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Parent = container
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "FLOK KAITUN"
	title.TextColor3 = COLORS.Text
	title.TextSize = 32
	title.Font = FONTS.Title
	title.TextTransparency = 0
	title.Parent = content
	
	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.Size = UDim2.new(1, 0, 0, 25)
	subtitle.Position = UDim2.new(0, 0, 0, 45)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Loading..."
	subtitle.TextColor3 = COLORS.TextSecondary
	subtitle.TextSize = 18
	subtitle.Font = FONTS.Body
	subtitle.TextTransparency = 0
	subtitle.Parent = content
	
	-- Progress bar background
	local barBg = Instance.new("Frame")
	barBg.Name = "ProgressBg"
	barBg.Size = UDim2.new(1, -20, 0, 6)
	barBg.Position = UDim2.new(0, 10, 0, 90)
	barBg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	barBg.BorderSizePixel = 0
	barBg.Parent = content
	applyRoundedCorners(barBg, 3)
	
	-- Progress bar fill
	local barFill = Instance.new("Frame")
	barFill.Name = "ProgressFill"
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = COLORS.LoadingBar
	barFill.BorderSizePixel = 0
	barFill.Parent = barBg
	applyRoundedCorners(barFill, 3)
	
	-- Gradient on progress bar for style
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, COLORS.Accent),
		ColorSequenceKeypoint.new(1, COLORS.AccentDark)
	})
	gradient.Parent = barFill
	
	-- Store objects for later use
	uiObjects.LoadingGui = screenGui
	uiObjects.LoadingContainer = container
	uiObjects.ProgressFill = barFill
	uiObjects.LoadingText = subtitle
end

--[[
	Starts loading animation
]]
function UI.startLoading()
	local barFill = uiObjects.ProgressFill
	if not barFill then return end
	
	-- Animate progress bar
	local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(barFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
	tween:Play()
	
	-- Update loading text with dots animation
	local dots = 0
	local textLabel = uiObjects.LoadingText
	
	task.spawn(function()
		while textLabel and textLabel.Parent do
			dots = (dots % 3) + 1
			textLabel.Text = "Loading" .. string.rep(".", dots)
			task.wait(0.5)
		end
	end)
end

--[[
	Fades out loading screen
]]
function UI.fadeOutLoading(callback)
	local container = uiObjects.LoadingContainer
	if not container then
		if callback then callback() end
		return
	end
	
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(container, tweenInfo, {BackgroundTransparency = 1})
	
	-- Fade all children
	for _, child in ipairs(container:GetDescendants()) do
		if child:IsA("TextLabel") or child:IsA("ImageLabel") then
			local textTween = TweenService:Create(child, tweenInfo, {TextTransparency = 1})
			textTween:Play()
		elseif child:IsA("Frame") and child.Name ~= "ProgressBg" then
			local frameTween = TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1})
			frameTween:Play()
		end
	end
	
	tween:Play()
	tween.Completed:Connect(function()
		if uiObjects.LoadingGui then
			uiObjects.LoadingGui:Destroy()
			uiObjects.LoadingGui = nil
		end
		if callback then callback() end
	end)
end

--[[
	Creates the main UI
]]
function UI.createMainUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlokKaitun_Main"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = PlayerGui
	
	-- Main container (initially transparent for fade in)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 350, 0, 250)
	mainFrame.Position = UDim2.new(0, 20, 0.5, -125)
	mainFrame.BackgroundColor3 = COLORS.Background
	mainFrame.BackgroundTransparency = 1 -- Start transparent
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	applyRoundedCorners(mainFrame, 12)
	applyStroke(mainFrame, COLORS.Accent, 1.5)
	
	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 50)
	titleBar.BackgroundColor3 = COLORS.AccentDark
	titleBar.BackgroundTransparency = 1
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame
	applyRoundedCorners(titleBar, 12)
	
	local titleText = Instance.new("TextLabel")
	titleText.Name = "Title"
	titleText.Size = UDim2.new(1, -20, 1, 0)
	titleText.Position = UDim2.new(0, 10, 0, 0)
	titleText.BackgroundTransparency = 1
	titleText.Text = "FLOK KAITUN"
	titleText.TextColor3 = COLORS.Text
	titleText.TextSize = 22
	titleText.Font = FONTS.Title
	titleText.TextTransparency = 1
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.Parent = titleBar
	
	-- Stats container
	local statsContainer = Instance.new("Frame")
	statsContainer.Name = "StatsContainer"
	statsContainer.Size = UDim2.new(1, -30, 0, 170)
	statsContainer.Position = UDim2.new(0, 15, 0, 65)
	statsContainer.BackgroundTransparency = 1
	statsContainer.Parent = mainFrame
	
	-- Create stat cards
	local stats = {
		{Name = "Level", Icon = "⭐", Color = Color3.fromRGB(255, 200, 50)},
		{Name = "Gems", Icon = "💎", Color = Color3.fromRGB(100, 200, 255)},
		{Name = "Money", Icon = "💰", Color = Color3.fromRGB(100, 255, 100)}
	}
	
	local statCards = {}
	
	for i, stat in ipairs(stats) do
		local yPos = (i - 1) * 58
		
		-- Card background
		local card = Instance.new("Frame")
		card.Name = stat.Name .. "Card"
		card.Size = UDim2.new(1, 0, 0, 50)
		card.Position = UDim2.new(0, 0, 0, yPos)
		card.BackgroundColor3 = COLORS.Card
		card.BackgroundTransparency = 1
		card.BorderSizePixel = 0
		card.Parent = statsContainer
		applyRoundedCorners(card, 8)
		
		-- Icon
		local icon = Instance.new("TextLabel")
		icon.Name = "Icon"
		icon.Size = UDim2.new(0, 40, 0, 40)
		icon.Position = UDim2.new(0, 10, 0.5, -20)
		icon.BackgroundTransparency = 1
		icon.Text = stat.Icon
		icon.TextSize = 24
		icon.TextTransparency = 1
		icon.Parent = card
		
		-- Stat name
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "Name"
		nameLabel.Size = UDim2.new(0, 100, 0, 25)
		nameLabel.Position = UDim2.new(0, 60, 0, 5)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = stat.Name
		nameLabel.TextColor3 = COLORS.TextSecondary
		nameLabel.TextSize = 14
		nameLabel.Font = FONTS.Mono
		nameLabel.TextTransparency = 1
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = card
		
		-- Stat value
		local valueLabel = Instance.new("TextLabel")
		valueLabel.Name = "Value"
		valueLabel.Size = UDim2.new(1, -70, 0, 30)
		valueLabel.Position = UDim2.new(0, 60, 0, 20)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = "0"
		valueLabel.TextColor3 = stat.Color
		valueLabel.TextSize = 20
		valueLabel.Font = FONTS.Title
		valueLabel.TextTransparency = 1
		valueLabel.TextXAlignment = Enum.TextXAlignment.Left
		valueLabel.Parent = card
		
		statCards[stat.Name] = {
			Card = card,
			Icon = icon,
			Name = nameLabel,
			Value = valueLabel
		}
	end
	
	-- Store references
	uiObjects.MainGui = screenGui
	uiObjects.MainFrame = mainFrame
	uiObjects.TitleBar = titleBar
	uiObjects.TitleText = titleText
	uiObjects.StatCards = statCards
end

--[[
	Fades in main UI
]]
function UI.fadeInMain(callback)
	local mainFrame = uiObjects.MainFrame
	if not mainFrame then return end
	
	-- Fade in main frame
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local frameTween = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0})
	frameTween:Play()
	
	-- Fade in title bar
	local titleBarTween = TweenService:Create(uiObjects.TitleBar, tweenInfo, {BackgroundTransparency = 0})
	titleBarTween:Play()
	
	-- Fade in all text elements with stagger
	local delay = 0
	for _, cardData in pairs(uiObjects.StatCards) do
		delay += 0.1
		
		task.delay(delay, function()
			if cardData.Card and cardData.Card.Parent then
				local cardTween = TweenService:Create(cardData.Card, tweenInfo, {BackgroundTransparency = 0})
				cardTween:Play()
				
				for _, element in ipairs({cardData.Icon, cardData.Name, cardData.Value}) do
					if element and element.Parent then
						local textTween = TweenService:Create(element, tweenInfo, {TextTransparency = 0})
						textTween:Play()
					end
				end
			end
		end)
	end
	
	-- Fade in title text
	task.delay(delay + 0.1, function()
		local titleTween = TweenService:Create(uiObjects.TitleText, tweenInfo, {TextTransparency = 0})
		titleTween:Play()
		
		if callback then
			task.delay(0.6, callback)
		end
	end)
end

--[[
	Updates a specific stat value with animation
]]
function UI.updateStat(statName, value)
	local cardData = uiObjects.StatCards and uiObjects.StatCards[statName]
	if not cardData then return end
	
	local valueLabel = cardData.Value
	if not valueLabel or not valueLabel.Parent then return end
	
	-- Format value based on type
	local formattedValue = tostring(value)
	if statName == "Money" or statName == "Gems" then
		-- Format large numbers with commas
		formattedValue = tostring(math.floor(value)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	end
	
	-- Scale animation for feedback
	local scaleTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local scaleUp = TweenService:Create(valueLabel, scaleTweenInfo, {TextSize = 24})
	local scaleDown = TweenService:Create(valueLabel, scaleTweenInfo, {TextSize = 20})
	
	scaleUp:Play()
	scaleUp.Completed:Connect(function()
		valueLabel.Text = formattedValue
		scaleDown:Play()
	end)
	
	-- If value hasn't changed, just update text
	if valueLabel.Text == formattedValue then
		scaleUp:Cancel()
		scaleDown:Cancel()
		valueLabel.Text = formattedValue
	end
end

return UI
