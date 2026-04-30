-- ============================================
-- FLOK KAITUN UI - FULLSCREEN + ICONES
-- Versão ultra compatível (funciona em todo executor)
-- ============================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ========== CONFIGURAÇÕES ==========
local LOADING_DURATION = 2.5
local ICONS = {
    Level = "rbxassetid://121308741910400",
    Gems  = "rbxassetid://119885288633197",
    Money = "rbxassetid://102739438416112",
}

-- ========== DADOS DO JOGADOR ==========
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

-- ========== CRIAÇÃO DA GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlokKaitunUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- OVERLAY escuro (fullscreen)
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.7
overlay.BorderSizePixel = 0
overlay.Parent = screenGui

-- Container do LOADING (visível inicialmente)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 420, 0, 240)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
loadingFrame.BackgroundTransparency = 0
loadingFrame.BorderSizePixel = 0
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = loadingFrame
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
local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(1, 0)
bgCorner.Parent = progressBg
progressBg.Parent = loadingFrame

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(100, 108, 255)
progressFill.BorderSizePixel = 0
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = progressFill
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

-- ========== UI PRINCIPAL ==========
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = false  -- começa invisível
mainContainer.Parent = screenGui

local card = Instance.new("Frame")
card.Size = UDim2.new(0, 420, 0, 340)
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.5, 0)
card.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
card.BorderSizePixel = 0
local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 20)
cardCorner.Parent = card
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
local lineCorner = Instance.new("UICorner")
lineCorner.CornerRadius = UDim.new(1, 0)
lineCorner.Parent = line
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

-- Função para criar linha de stat com ícone
local levelLabel, gemsLabel, moneyLabel
local function createStatRow(iconAsset, labelText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundTransparency = 1
    row.Parent = statsContainer

    local iconImg = Instance.new("ImageLabel")
    iconImg.Image = iconAsset
    iconImg.Size = UDim2.new(0, 36, 0, 36)
    iconImg.Position = UDim2.new(0, 0, 0.5, -18)
    iconImg.BackgroundTransparency = 1
    iconImg.Parent = row

    local desc = Instance.new("TextLabel")
    desc.Text = labelText .. ":"
    desc.TextColor3 = Color3.fromRGB(160, 165, 175)
    desc.TextSize = 18
    desc.Font = Enum.Font.Gotham
    desc.Size = UDim2.new(0, 110, 1, 0)
    desc.Position = UDim2.new(0, 50, 0, 0)
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

levelLabel = createStatRow(ICONS.Level, "Level")
gemsLabel  = createStatRow(ICONS.Gems, "Gems")
moneyLabel = createStatRow(ICONS.Money, "Money")

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

-- Atualizar stats
local function updateStats()
    levelLabel.Text = tostring(playerStats.Level)
    gemsLabel.Text  = tostring(playerStats.Gems)
    moneyLabel.Text = tostring(playerStats.Money)
end
updateStats()

-- Conexão com dados reais (se existir)
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

-- Simulação se não houver dados reais
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

-- ========== ANIMAÇÃO DE LOADING E TRANSIÇÃO ==========
local startTime = tick()
local tween = TweenService:Create(progressFill, TweenInfo.new(LOADING_DURATION, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

local conn
conn = game:GetService("RunService").RenderStepped:Connect(function()
    local elapsed = tick() - startTime
    local percent = math.min(1, elapsed / LOADING_DURATION) * 100
    percentText.Text = string.format("%.0f%%", percent)
    if elapsed >= LOADING_DURATION then
        conn:Disconnect()
    end
end)

tween.Completed:Connect(function()
    -- Esconde loading e mostra UI principal
    loadingFrame.Visible = false
    loadingFrame:Destroy()
    mainContainer.Visible = true
    -- Efeito fade simples (opcional, mas seguro)
    mainContainer.BackgroundTransparency = 0
    for _, child in ipairs(mainContainer:GetDescendants()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("ImageLabel") then
            child.BackgroundTransparency = child.BackgroundTransparency or 0
        end
    end
end)

-- Ajuste de escala (opcional, sem dependência de CurrentCamera)
local function adjustScale()
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local scale = math.min(viewport.X / 1920, viewport.Y / 1080) * 1.2
    scale = math.clamp(scale, 0.6, 1.3)
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = scale
    uiScale.Parent = card
end
pcall(adjustScale) -- se falhar, não quebra

-- Arrastar a janela
local dragging = false
local dragStart, startPos
local currentScale = 1
card.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = card.Position
    end
end)
card.InputEnded:Connect(function()
    dragging = false
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        local scale = card:FindFirstChildWhichIsA("UIScale") and card:FindFirstChildWhichIsA("UIScale").Scale or 1
        card.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X / scale,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y / scale
        )
    end
end)

print("Flok Kaitun UI carregada com sucesso!")
