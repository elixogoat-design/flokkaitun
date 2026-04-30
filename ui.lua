-- ui.lua
-- Cria a interface completa (loading + main UI) de forma segura.
-- Evita qualquer erro de "nil parent" através de verificações rigorosas.

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local UI = {}

-- Cores e ícones (emoji, sem assets)
local COLORS = {
    Overlay  = Color3.fromRGB(0, 0, 0),
    CardBg   = Color3.fromRGB(28, 30, 36),
    Accent   = Color3.fromRGB(100, 108, 255),
    Text     = Color3.fromRGB(240, 242, 245),
    TextDim  = Color3.fromRGB(160, 165, 175),
    Progress = Color3.fromRGB(100, 108, 255),
    ProgBg   = Color3.fromRGB(45, 47, 52),
}

local ICONS = { Level = "📊", Gems = "💎", Money = "💰" }

-- Constrói toda a GUI
function UI:Build()
    -- Aguarda o CoreGui existir (segurança)
    while not CoreGui do
        CoreGui = game:GetService("CoreGui")
        task.wait()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlokKaitunUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    -- Parent seguro: CoreGui existe
    screenGui.Parent = CoreGui

    -- Overlay escuro (fullscreen)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = COLORS.Overlay
    overlay.BackgroundTransparency = 0.7
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui  -- seguro

    -- Container do loading
    local loadingContainer = Instance.new("Frame")
    loadingContainer.Name = "LoadingContainer"
    loadingContainer.Size = UDim2.new(1, 0, 1, 0)
    loadingContainer.BackgroundTransparency = 1
    loadingContainer.Parent = screenGui

    -- Container principal (inicialmente invisível)
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, 0, 1, 0)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Visible = false
    mainContainer.Parent = screenGui

    -- Cria os elementos internos (loading e main)
    self:BuildLoading(loadingContainer)
    self:BuildMain(mainContainer)

    self.screenGui = screenGui
    self.loadingContainer = loadingContainer
    self.mainContainer = mainContainer
    self.overlay = overlay
end

-- Tela de loading (barra de progresso)
function UI:BuildLoading(parent)
    if not parent then return end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 240)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = COLORS.CardBg
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
    title.TextColor3 = COLORS.Text
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = frame

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.8, 0, 0, 10)
    bg.Position = UDim2.new(0.1, 0, 0.65, 0)
    bg.BackgroundColor3 = COLORS.ProgBg
    bg.BorderSizePixel = 0
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = bg
    bg.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Progress
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    fill.Parent = bg

    local percent = Instance.new("TextLabel")
    percent.Size = UDim2.new(1, 0, 0, 20)
    percent.Position = UDim2.new(0, 0, 0.8, 0)
    percent.BackgroundTransparency = 1
    percent.Text = "0%"
    percent.TextColor3 = COLORS.TextDim
    percent.TextSize = 14
    percent.Font = Enum.Font.Gotham
    percent.TextXAlignment = Enum.TextXAlignment.Center
    percent.Parent = frame

    self.progressFill = fill
    self.percentText = percent
end

-- UI principal (estatísticas)
function UI:BuildMain(parent)
    if not parent then return end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 420, 0, 340)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.BackgroundColor3 = COLORS.CardBg
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
    title.TextColor3 = COLORS.Text
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = card

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 2)
    line.Position = UDim2.new(0.05, 0, 0, 65)
    line.BackgroundColor3 = COLORS.Accent
    line.BorderSizePixel = 0
    local lineCorner = Instance.new("UICorner")
    lineCorner.CornerRadius = UDim.new(1, 0)
    lineCorner.Parent = line
    line.Parent = card

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 180)
    container.Position = UDim2.new(0, 20, 0, 85)
    container.BackgroundTransparency = 1
    container.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 24)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = container

    local function createRow(icon, label)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 52)
        row.BackgroundTransparency = 1
        row.Parent = container

        local iconLbl = Instance.new("TextLabel")
        iconLbl.Text = icon
        iconLbl.TextColor3 = COLORS.Accent
        iconLbl.TextSize = 32
        iconLbl.Font = Enum.Font.GothamBold
        iconLbl.Size = UDim2.new(0, 50, 1, 0)
        iconLbl.BackgroundTransparency = 1
        iconLbl.TextXAlignment = Enum.TextXAlignment.Left
        iconLbl.Parent = row

        local desc = Instance.new("TextLabel")
        desc.Text = label .. ":"
        desc.TextColor3 = COLORS.TextDim
        desc.TextSize = 18
        desc.Font = Enum.Font.Gotham
        desc.Size = UDim2.new(0, 110, 1, 0)
        desc.Position = UDim2.new(0, 55, 0, 0)
        desc.BackgroundTransparency = 1
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = row

        local val = Instance.new("TextLabel")
        val.Text = "0"
        val.TextColor3 = COLORS.Text
        val.TextSize = 24
        val.Font = Enum.Font.GothamBold
        val.Size = UDim2.new(1, -180, 1, 0)
        val.Position = UDim2.new(0, 170, 0, 0)
        val.BackgroundTransparency = 1
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.Parent = row

        return val
    end

    self.levelLabel = createRow(ICONS.Level, "Level")
    self.gemsLabel  = createRow(ICONS.Gems,  "Gems")
    self.moneyLabel = createRow(ICONS.Money, "Money")

    local footer = Instance.new("TextLabel")
    footer.Text = "© Flok Kaitun System"
    footer.TextColor3 = COLORS.TextDim
    footer.TextSize = 12
    footer.Font = Enum.Font.Gotham
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.BackgroundTransparency = 1
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.Parent = card

    -- Arrastar a janela (com UIScale simples)
    local dragging = false
    local dragStart, startPos
    local scaleUI = Instance.new("UIScale")
    scaleUI.Parent = card

    local function updateScale()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        local s = math.min(vp.X / 1920, vp.Y / 1080) * 1.2
        scaleUI.Scale = math.clamp(s, 0.6, 1.3)
        if not dragging then
            card.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
    end
    pcall(updateScale)
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
            local scale = scaleUI.Scale
            card.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X / scale,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y / scale
            )
        end
    end)
end

function UI:UpdateStats(level, gems, money)
    if self.levelLabel then self.levelLabel.Text = tostring(level) end
    if self.gemsLabel  then self.gemsLabel.Text  = tostring(gems) end
    if self.moneyLabel then self.moneyLabel.Text = tostring(money) end
end

function UI:StartProgressAnimation(duration)
    if not self.progressFill then return nil end
    local start = tick()
    local fill = self.progressFill
    local pText = self.percentText

    local tween = TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if not fill.Parent then
            if conn then conn:Disconnect() end
            return
        end
        local elapsed = tick() - start
        local perc = math.min(1, elapsed / duration) * 100
        pText.Text = string.format("%.0f%%", perc)
        if elapsed >= duration then
            conn:Disconnect()
        end
    end)
    return tween
end

function UI:FadeToMain()
    if not self.loadingContainer or not self.mainContainer then return end
    self.loadingContainer.Visible = false
    self.mainContainer.Visible = true
end

return UI
