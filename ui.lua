-- ui.lua
-- Cria a interface fullscreen com loading e UI principal, usando apenas elementos básicos e ícones emoji.

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local UI = {}

-- Configurações visuais
local THEME = {
    OverlayBg = Color3.fromRGB(0, 0, 0),
    CardBg    = Color3.fromRGB(28, 30, 36),
    Accent    = Color3.fromRGB(100, 108, 255),
    Text      = Color3.fromRGB(240, 242, 245),
    TextDim   = Color3.fromRGB(160, 165, 175),
    Progress  = Color3.fromRGB(100, 108, 255),
    ProgressBg = Color3.fromRGB(45, 47, 52),
}

-- Ícones (emoji, sem assets externos)
local ICONS = {
    Level = "📊",
    Gems  = "💎",
    Money = "💰",
}

function UI:Build()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlokKaitunUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    -- Overlay escuro (fullscreen)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = THEME.OverlayBg
    overlay.BackgroundTransparency = 0.7
    overlay.BorderSizePixel = 0
    overlay.Parent = gui

    -- Container do loading (visível inicialmente)
    local loadingContainer = Instance.new("Frame")
    loadingContainer.Name = "LoadingContainer"
    loadingContainer.Size = UDim2.new(1, 0, 1, 0)
    loadingContainer.BackgroundTransparency = 1
    loadingContainer.Parent = gui

    -- Container principal (invisível inicialmente)
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, 0, 1, 0)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Visible = false
    mainContainer.Parent = gui

    self:BuildLoadingScreen(loadingContainer)
    self:BuildMainUI(mainContainer)

    self.gui = gui
    self.loadingContainer = loadingContainer
    self.mainContainer = mainContainer
    self.overlay = overlay
end

function UI:BuildLoadingScreen(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 240)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = THEME.CardBg
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    frame.Parent = parent

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

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0.8, 0, 0, 10)
    progressBg.Position = UDim2.new(0.1, 0, 0.65, 0)
    progressBg.BackgroundColor3 = THEME.ProgressBg
    progressBg.BorderSizePixel = 0
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = progressBg
    progressBg.Parent = frame

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = THEME.Progress
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
    percentText.TextColor3 = THEME.TextDim
    percentText.TextSize = 14
    percentText.Font = Enum.Font.Gotham
    percentText.TextXAlignment = Enum.TextXAlignment.Center
    percentText.Parent = frame

    self.progressFill = progressFill
    self.percentText = percentText
end

function UI:BuildMainUI(parent)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 420, 0, 340)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.BackgroundColor3 = THEME.CardBg
    card.BorderSizePixel = 0
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 20)
    cardCorner.Parent = card
    card.Parent = parent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Flok Kaitun"
    title.TextColor3 = THEME.Text
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = card

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 2)
    line.Position = UDim2.new(0.05, 0, 0, 65)
    line.BackgroundColor3 = THEME.Accent
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

    -- Helper para criar linha de estatística
    local function createStatRow(iconChar, labelText)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 52)
        row.BackgroundTransparency = 1
        row.Parent = statsContainer

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Text = iconChar
        iconLabel.TextColor3 = THEME.Accent
        iconLabel.TextSize = 32
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Size = UDim2.new(0, 50, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.TextXAlignment = Enum.TextXAlignment.Left
        iconLabel.Parent = row

        local desc = Instance.new("TextLabel")
        desc.Text = labelText .. ":"
        desc.TextColor3 = THEME.TextDim
        desc.TextSize = 18
        desc.Font = Enum.Font.Gotham
        desc.Size = UDim2.new(0, 110, 1, 0)
        desc.Position = UDim2.new(0, 55, 0, 0)
        desc.BackgroundTransparency = 1
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = row

        local value = Instance.new("TextLabel")
        value.Text = "0"
        value.TextColor3 = THEME.Text
        value.TextSize = 24
        value.Font = Enum.Font.GothamBold
        value.Size = UDim2.new(1, -180, 1, 0)
        value.Position = UDim2.new(0, 170, 0, 0)
        value.BackgroundTransparency = 1
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = row

        return value
    end

    self.levelLabel = createStatRow(ICONS.Level, "Level")
    self.gemsLabel  = createStatRow(ICONS.Gems, "Gems")
    self.moneyLabel = createStatRow(ICONS.Money, "Money")

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

    -- Sistema de arrastar (funciona com UIScale simples)
    local dragging = false
    local dragStart, startPos
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = card

    local function updateScale()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local vp = camera.ViewportSize
        local scale = math.min(vp.X / 1920, vp.Y / 1080) * 1.2
        scale = math.clamp(scale, 0.6, 1.3)
        uiScale.Scale = scale
        if not dragging then
            card.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
    end
    pcall(updateScale) -- proteção contra falta de câmera
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

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
            local scale = uiScale.Scale
            card.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X / scale,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y / scale
            )
        end
    end)

    self.mainCard = card
end

function UI:UpdateStats(level, gems, money)
    if self.levelLabel then self.levelLabel.Text = tostring(level) end
    if self.gemsLabel  then self.gemsLabel.Text  = tostring(gems)  end
    if self.moneyLabel then self.moneyLabel.Text = tostring(money) end
end

function UI:StartProgressAnimation(duration)
    if not self.progressFill then return nil end
    local startTime = tick()
    local fill = self.progressFill
    local percentText = self.percentText

    local targetSize = UDim2.new(1, 0, 1, 0)
    local tween = TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = targetSize})
    tween:Play()

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if not fill.Parent then 
            if conn then conn:Disconnect() end
            return
        end
        local elapsed = tick() - startTime
        local p = math.min(1, elapsed / duration) * 100
        percentText.Text = string.format("%.0f%%", p)
        if elapsed >= duration then
            conn:Disconnect()
        end
    end)
    return tween
end

function UI:FadeToMain()
    -- Troca a visibilidade dos containers (fade instantâneo, mas limpo)
    self.loadingContainer.Visible = false
    self.mainContainer.Visible = true
    -- Opcional: pequena animação de fade poderia ser feita com TweenService na transparência,
    -- mas para manter compatibilidade, apenas tornamos visível.
end

return UI
