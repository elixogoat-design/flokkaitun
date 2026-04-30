-- ui.lua
-- Cria e gerencia toda a interface no CoreGui (funciona em qualquer executor)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local UI = {}

-- Tema de cores moderno
local THEME = {
    CardBg     = Color3.fromRGB(28, 30, 36),
    Accent     = Color3.fromRGB(100, 108, 255),
    Text       = Color3.fromRGB(240, 242, 245),
    TextDim    = Color3.fromRGB(160, 165, 175),
    Progress   = Color3.fromRGB(100, 108, 255),
    ProgressBg = Color3.fromRGB(45, 47, 52),
}

-- Constrói toda a interface (loading + main)
function UI:Build()
    -- Criar ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlokKaitunUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    -- Canvas de loading (fade)
    local loadingCanvas = Instance.new("CanvasGroup")
    loadingCanvas.Name = "LoadingCanvas"
    loadingCanvas.Size = UDim2.new(1, 0, 1, 0)
    loadingCanvas.BackgroundTransparency = 1
    loadingCanvas.GroupTransparency = 0
    loadingCanvas.Parent = gui

    -- Canvas principal (inicialmente invisível)
    local mainCanvas = Instance.new("CanvasGroup")
    mainCanvas.Name = "MainCanvas"
    mainCanvas.Size = UDim2.new(1, 0, 1, 0)
    mainCanvas.BackgroundTransparency = 1
    mainCanvas.GroupTransparency = 1
    mainCanvas.Parent = gui

    -- Construir os elementos visuais
    self:BuildLoadingScreen(loadingCanvas)
    self:BuildMainUI(mainCanvas)

    -- Armazenar referências
    self.gui = gui
    self.loadingCanvas = loadingCanvas
    self.mainCanvas = mainCanvas
end

-- Tela de loading com barra de progresso animada
function UI:BuildLoadingScreen(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 240)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = THEME.CardBg
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    frame.Parent = parent

    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "Flok Kaitun Loading..."
    title.TextColor3 = THEME.Text
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = frame

    -- Fundo da barra
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0.8, 0, 0, 10)
    progressBg.Position = UDim2.new(0.1, 0, 0.65, 0)
    progressBg.BackgroundColor3 = THEME.ProgressBg
    progressBg.BorderSizePixel = 0
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)
    progressBg.Parent = frame

    -- Barra de progresso (será animada)
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = THEME.Progress
    progressFill.BorderSizePixel = 0
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    progressFill.Parent = progressBg

    -- Texto percentual
    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(1, 0, 0, 20)
    percentText.Position = UDim2.new(0, 0, 0.8, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = THEME.TextDim
    percentText.TextSize = 14
    percentText.Font = Enum.Font.Gotham
    percentText.TextXAlignment = Enum.TextXAlignment.Center
    percentText.Parent = frame

    self.progressFill = progressFill
    self.percentText = percentText
    self.loadingFrame = frame
end

-- UI principal com estatísticas
function UI:BuildMainUI(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 340)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = THEME.CardBg
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
    frame.Parent = parent

    -- Sombra
    Instance.new("UIShadow", frame)

    -- Título principal
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Flok Kaitun"
    title.TextColor3 = THEME.Text
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    -- Linha decorativa
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 2)
    line.Position = UDim2.new(0.05, 0, 0, 65)
    line.BackgroundColor3 = THEME.Accent
    line.BorderSizePixel = 0
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
    line.Parent = frame

    -- Container das stats
    local statsContainer = Instance.new("Frame")
    statsContainer.Size = UDim2.new(1, -40, 0, 160)
    statsContainer.Position = UDim2.new(0, 20, 0, 85)
    statsContainer.BackgroundTransparency = 1
    statsContainer.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 20)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = statsContainer

    -- Função para criar uma linha de stat
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
        descLabel.TextSize = 18
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
    footer.Parent = frame

    -- Sistema de arrastar a janela (custom)
    local dragging, dragInput, dragStart, startPos
    local UIScale = Instance.new("UIScale")
    UIScale.Parent = frame

    local function updateScale()
        local vp = workspace.CurrentCamera.ViewportSize
        local scale = math.min(vp.X / 1920, vp.Y / 1080) * 1.2
        UIScale.Scale = math.clamp(scale, 0.6, 1.2)
        if not dragging then
            frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
    end
    updateScale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            local scale = UIScale.Scale
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X / scale,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y / scale
            )
        end
    end)

    self.mainFrame = frame
end

-- Atualiza os valores exibidos
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
    local tween = TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = targetSize})
    tween:Play()

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not fill.Parent then conn:Disconnect() return end
        local elapsed = tick() - startTime
        local p = math.min(1, elapsed / duration) * 100
        percentText.Text = string.format("%.0f%%", p)
        if elapsed >= duration then conn:Disconnect() end
    end)
    return tween
end

-- Transição fade do loading para a UI principal
function UI:FadeToMain()
    local fadeOut = TweenService:Create(self.loadingCanvas, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {GroupTransparency = 1})
    local fadeIn  = TweenService:Create(self.mainCanvas,  TweenInfo.new(0.6, Enum.EasingStyle.Quad), {GroupTransparency = 0})
    fadeOut:Play()
    fadeIn:Play()
    fadeOut.Completed:Connect(function()
        self.loadingCanvas.Visible = false
        self.loadingCanvas:Destroy()
    end)
end

return UI
