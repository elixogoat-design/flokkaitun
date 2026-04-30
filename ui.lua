-- ui.lua
-- Cria e gerencia toda a interface visual (loading + UI principal)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local UI = {}

-- Tema moderno
local THEME = {
    Background = Color3.fromRGB(18, 20, 24),
    Card       = Color3.fromRGB(28, 30, 36),
    Accent     = Color3.fromRGB(100, 108, 255),
    Text       = Color3.fromRGB(240, 242, 245),
    TextDim    = Color3.fromRGB(160, 165, 175),
    Progress   = Color3.fromRGB(100, 108, 255),
}

-- Constrói toda a interface (deve ser chamada APÓS o PlayerGui existir)
function UI:Build()
    local player = Players.LocalPlayer
    if not player then
        error("UI:Build() chamado sem LocalPlayer disponível")
    end

    -- Aguarda o PlayerGui (garantia contra nil)
    local playerGui = player:WaitForChild("PlayerGui")
    if not playerGui then
        error("PlayerGui não encontrado mesmo após aguardar")
    end

    -- ScreenGui principal
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlokKaitunUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = playerGui  -- Parent seguro

    -- Container do loading (CanvasGroup para fade)
    local loadingCanvas = Instance.new("CanvasGroup")
    loadingCanvas.Name = "LoadingCanvas"
    loadingCanvas.GroupTransparency = 0
    loadingCanvas.Size = UDim2.new(1, 0, 1, 0)
    loadingCanvas.BackgroundTransparency = 1
    loadingCanvas.Parent = gui

    -- Container da UI principal
    local mainCanvas = Instance.new("CanvasGroup")
    mainCanvas.Name = "MainCanvas"
    mainCanvas.GroupTransparency = 1
    mainCanvas.Size = UDim2.new(1, 0, 1, 0)
    mainCanvas.BackgroundTransparency = 1
    mainCanvas.Parent = gui

    -- Constroi os elementos internos
    self:BuildLoadingScreen(loadingCanvas)
    self:BuildMainUI(mainCanvas)

    -- Armazena referências
    self.loadingCanvas = loadingCanvas
    self.mainCanvas = mainCanvas
    self.gui = gui
end

-- Tela de loading com barra de progresso
function UI:BuildLoadingScreen(parent)
    if not parent then return end

    local centerFrame = Instance.new("Frame")
    centerFrame.Name = "CenterFrame"
    centerFrame.Size = UDim2.new(0, 420, 0, 220)
    centerFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
    centerFrame.BackgroundColor3 = THEME.Card
    centerFrame.BackgroundTransparency = 0
    centerFrame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = centerFrame

    -- Sombra (opcional, apenas se disponível)
    local shadow = Instance.new("UIShadow")
    shadow.Parent = centerFrame

    centerFrame.Parent = parent

    -- Título
    local title = Instance.new("TextLabel")
    title.Text = "Flok Kaitun Loading..."
    title.TextColor3 = THEME.Text
    title.TextSize = 26
    title.Font = Enum.Font.GothamBold
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = centerFrame

    -- Fundo da barra
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0.8, 0, 0, 10)
    progressBg.Position = UDim2.new(0.1, 0, 0.7, 0)
    progressBg.BackgroundColor3 = Color3.fromRGB(45, 47, 52)
    progressBg.BorderSizePixel = 0

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = progressBg
    progressBg.Parent = centerFrame

    -- Barra de progresso (animada)
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = THEME.Progress
    progressFill.BorderSizePixel = 0

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = progressFill
    progressFill.Parent = progressBg

    -- Texto percentual
    local percentText = Instance.new("TextLabel")
    percentText.Name = "PercentText"
    percentText.Text = "0%"
    percentText.TextColor3 = THEME.TextDim
    percentText.TextSize = 14
    percentText.Font = Enum.Font.Gotham
    percentText.Size = UDim2.new(1, 0, 0, 20)
    percentText.Position = UDim2.new(0, 0, 0.85, 0)
    percentText.BackgroundTransparency = 1
    percentText.TextXAlignment = Enum.TextXAlignment.Center
    percentText.Parent = centerFrame

    self.progressFill = progressFill
    self.percentText = percentText
end

-- UI principal (stats do jogador)
function UI:BuildMainUI(parent)
    if not parent then return end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 400, 0, 320)
    card.Position = UDim2.new(0.5, -200, 0.5, -160)
    card.BackgroundColor3 = THEME.Card
    card.BackgroundTransparency = 0
    card.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = card

    local shadow = Instance.new("UIShadow")
    shadow.Parent = card

    card.Parent = parent

    -- Título
    local title = Instance.new("TextLabel")
    title.Text = "Flok Kaitun"
    title.TextColor3 = THEME.Text
    title.TextSize = 32
    title.Font = Enum.Font.GothamBold
    title.Size = UDim2.new(1, 0, 0, 70)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Parent = card

    -- Linha decorativa
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 2)
    line.Position = UDim2.new(0.05, 0, 0, 70)
    line.BackgroundColor3 = THEME.Accent
    line.BorderSizePixel = 0
    local lineCorner = Instance.new("UICorner")
    lineCorner.CornerRadius = UDim.new(1, 0)
    lineCorner.Parent = line
    line.Parent = card

    -- Container dos stats
    local statsContainer = Instance.new("Frame")
    statsContainer.Size = UDim2.new(1, -40, 0, 160)
    statsContainer.Position = UDim2.new(0, 20, 0, 90)
    statsContainer.BackgroundTransparency = 1
    statsContainer.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 20)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = statsContainer

    -- Função interna para criar uma linha de stat
    local function createStatRow(icon, labelText, initialValue)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 50)
        row.BackgroundTransparency = 1
        row.Parent = statsContainer

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Text = icon
        iconLabel.TextColor3 = THEME.Accent
        iconLabel.TextSize = 32
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Size = UDim2.new(0, 50, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.TextXAlignment = Enum.TextXAlignment.Left
        iconLabel.Parent = row

        local descLabel = Instance.new("TextLabel")
        descLabel.Text = labelText .. ":"
        descLabel.TextColor3 = THEME.TextDim
        descLabel.TextSize = 20
        descLabel.Font = Enum.Font.Gotham
        descLabel.Size = UDim2.new(0, 100, 1, 0)
        descLabel.Position = UDim2.new(0, 55, 0, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = row

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Text = tostring(initialValue)
        valueLabel.TextColor3 = THEME.Text
        valueLabel.TextSize = 24
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Size = UDim2.new(1, -170, 1, 0)
        valueLabel.Position = UDim2.new(0, 160, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = row

        return valueLabel
    end

    self.levelLabel = createStatRow("📊", "Level", 0)
    self.gemsLabel  = createStatRow("💎", "Gems", 0)
    self.moneyLabel = createStatRow("💰", "Money", 0)

    -- Rodapé
    local footer = Instance.new("TextLabel")
    footer.Text = "© Flok Kaitun System"
    footer.TextColor3 = THEME.TextDim
    footer.TextSize = 12
    footer.Font = Enum.Font.Gotham
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.BackgroundTransparency = 1
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.Parent = card
end

-- Atualiza os valores exibidos na UI
function UI:UpdateStats(level, gems, money)
    if self.levelLabel then self.levelLabel.Text = tostring(level) end
    if self.gemsLabel  then self.gemsLabel.Text  = tostring(gems)  end
    if self.moneyLabel then self.moneyLabel.Text = tostring(money) end
end

-- Anima a barra de progresso (retorna o tween)
function UI:StartProgressAnimation(duration)
    if not self.progressFill then return nil end
    local startTime = tick()
    local fill = self.progressFill
    local percentText = self.percentText

    local targetSize = UDim2.new(1, 0, 1, 0)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(fill, tweenInfo, {Size = targetSize})
    tween:Play()

    -- Atualiza o texto percentual a cada frame
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not fill or not fill.Parent then
            if connection then connection:Disconnect() end
            return
        end
        local elapsed = tick() - startTime
        local percent = math.min(1, elapsed / duration) * 100
        if percentText then
            percentText.Text = string.format("%.0f%%", percent)
        end
        if elapsed >= duration and connection then
            connection:Disconnect()
        end
    end)

    return tween
end

-- Transição suave do loading para a UI principal
function UI:FadeToMain()
    if not self.loadingCanvas or not self.mainCanvas then return end
    local fadeOut = TweenService:Create(self.loadingCanvas, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
    local fadeIn  = TweenService:Create(self.mainCanvas,  TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})

    fadeOut:Play()
    fadeIn:Play()

    fadeOut.Completed:Connect(function()
        if self.loadingCanvas then
            self.loadingCanvas.Visible = false
            self.loadingCanvas:Destroy()
        end
    end)
end

return UI
