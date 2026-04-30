-- ============================================
-- FLOK KAITUN UI - FULLSCREEN (SEM ASSETS)
-- Sem rbxassetid, sem erros de carregamento
-- ============================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- CONFIGURAÇÕES
local LOADING_DURATION = 2.5
local ICONS = { Level = "📊", Gems = "💎", Money = "💰" }

-- DADOS DO JOGADOR
local playerStats = { Level = 1, Gems = 100, Money = 500 }

local function loadRealData()
    local dataFolder = player and player:FindFirstChild("Data")
    if not dataFolder then return false end
    local lv = dataFolder:FindFirstChild("Level")
    local gm = dataFolder:FindFirstChild("Gems")
    local mn = dataFolder:FindFirstChild("Money")
    if lv and typeof(lv.Value) == "number" then playerStats.Level = lv.Value end
    if gm and typeof(gm.Value) == "number" then playerStats.Gems = gm.Value end
    if mn and typeof(mn.Value) == "number" then playerStats.Money = mn.Value end
    return true
end
local hasRealData = loadRealData()

-- CRIAÇÃO DA GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlokKaitunUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- Overlay escuro fullscreen
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.7
overlay.BorderSizePixel = 0
overlay.Parent = screenGui

-- TELA DE LOADING
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 420, 0, 240)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
loadingFrame.BorderSizePixel = 0
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 16)
loadingFrame.Parent = screenGui

local titleLoad = Instance.new("TextLabel")
titleLoad.Size = UDim2.new(1, -40, 0, 50)
titleLoad.Position = UDim2.new(0, 20, 0, 20)
titleLoad.BackgroundTransparency = 1
titleLoad.Text = "Flok Kaitun Loading..."
titleLoad.TextColor3 = Color3.fromRGB(240, 242, 245)
titleLoad.TextSize = 24
titleLoad.Font = Enum.Font.GothamBold
titleLoad.TextXAlignment = Enum.TextXAlignment.Center
titleLoad.Parent = loadingFrame

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.8, 0, 0, 10)
progressBg.Position = UDim2.new(0.1, 0, 0.65, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(45, 47, 52)
progressBg.BorderSizePixel = 0
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)
progressBg.Parent = loadingFrame

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(100, 108, 255)
progressFill.BorderSizePixel = 0
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
progressFill.Parent = progressBg

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1, 0, 0, 20)
percentText.Position = UDim2.new(0, 0, 0.8, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(160, 165, 175)
percentText.TextSize = 14
percentText.Font = Enum.Font.Gotham
percentText.TextXAlignment = Enum.TextXAlignment.Center
percentText.Parent = loadingFrame

-- UI PRINCIPAL
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = false
mainContainer.Parent = screenGui

local card = Instance.new("Frame")
card.Size = UDim2.new(0, 420, 0, 340)
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.5, 0)
card.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
card.BorderSizePixel = 0
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 20)
card.Parent = mainContainer

local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, 0, 0, 60)
mainTitle.Position = UDim2.new(0, 0, 0, 0)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "Flok Kaitun"
mainTitle.TextColor3 = Color3.fromRGB(240, 242, 245)
mainTitle.TextSize = 28
mainTitle.Font = Enum.Font.GothamBold
mainTitle.Parent = card

local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 65)
line.BackgroundColor3 = Color3.fromRGB(100, 108, 255)
line.BorderSizePixel = 0
Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
line.Parent = card

local statsContainer = Instance.new("Frame")
statsContainer.Size = UDim2.new(1, -40, 0, 180)
statsContainer.Position = UDim2.new(0, 20, 0, 85)
statsContainer.BackgroundTransparency = 1
statsContainer.Parent = card

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 24)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = statsContainer

local function createStatRow(iconChar, labelText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundTransparency = 1
    row.Parent = statsContainer

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Text = iconChar
    iconLabel.TextColor3 = Color3.fromRGB(100, 108, 255)
    iconLabel.TextSize = 32
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Size = UDim2.new(0, 50, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.TextXAlignment = Enum.TextXAlignment.Left
    iconLabel.Parent = row

    local desc = Instance.new("TextLabel")
    desc.Text = labelText .. ":"
    desc.TextColor3 = Color3.fromRGB(160, 165, 175)
    desc.TextSize = 18
    desc.Font = Enum.Font.Gotham
    desc.Size = UDim2.new(0, 110, 1, 0)
    desc.Position = UDim2.new(0, 55, 0, 0)
    desc.BackgroundTransparency = 1
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = row

    local value = Instance.new("TextLabel")
    value.Text = "0"
    value.TextColor3 = Color3.fromRGB(240, 242, 245)
    value.TextSize = 24
    value.Font = Enum.Font.GothamBold
    value.Size = UDim2.new(1, -180, 1, 0)
    value.Position = UDim2.new(0, 170, 0, 0)
    value.BackgroundTransparency = 1
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Parent = row

    return value
end

local levelLabel = createStatRow(ICONS.Level, "Level")
local gemsLabel  = createStatRow(ICONS.Gems, "Gems")
local moneyLabel = createStatRow(ICONS.Money, "Money")

local footer = Instance.new("TextLabel")
footer.Text = "© Flok Kaitun System"
footer.TextColor3 = Color3.fromRGB(160, 165, 175)
footer.TextSize = 12
footer.Font = Enum.Font.Gotham
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = card

local function updateStats()
    levelLabel.Text = tostring(playerStats.Level)
    gemsLabel.Text  = tostring(playerStats.Gems)
    moneyLabel.Text = tostring(playerStats.Money)
end
updateStats()

if hasRealData and player then
    local dataFolder = player:FindFirstChild("Data")
    if dataFolder then
        local lv = dataFolder:FindFirstChild("Level")
        local gm = dataFolder:FindFirstChild("Gems")
        local mn = dataFolder:FindFirstChild("Money")
        if lv then lv.Changed:Connect(function(v) playerStats.Level = v; updateStats() end) end
        if gm then gm.Changed:Connect(function(v) playerStats.Gems = v; updateStats() end) end
        if mn then mn.Changed:Connect(function(v) playerStats.Money = v; updateStats() end) end
    end
end

if not hasRealData then
    spawn(function()
        while true do
            task.wait(5)
            playerStats.Level = playerStats.Level + 1
            playerStats.Gems = playerStats.Gems + 50
            playerStats.Money = playerStats.Money + 200
            updateStats()
        end
    end)
end

-- ANIMAÇÃO E TRANSIÇÃO
local startTime = tick()
local tween = TweenService:Create(progressFill, TweenInfo.new(LOADING_DURATION, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

local conn = game:GetService("RunService").RenderStepped:Connect(function()
    local elapsed = tick() - startTime
    local percent = math.min(1, elapsed / LOADING_DURATION) * 100
    percentText.Text = string.format("%.0f%%", percent)
    if elapsed >= LOADING_DURATION then conn:Disconnect() end
end)

tween.Completed:Connect(function()
    loadingFrame.Visible = false
    loadingFrame:Destroy()
    mainContainer.Visible = true
end)

print("Flok Kaitun UI carregada com sucesso!")
