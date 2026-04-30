-- main.lua
-- Inicializa o sistema, aguarda dados e controla a transição

local Players = game:GetService("Players")

-- Carrega os módulos (caminho relativo: mesmo nível da pasta Modules)
local UI = require(script.Parent.Modules.ui)
local Remotes = require(script.Parent.Modules.remotes) -- não usado agora

local player = Players.LocalPlayer
if not player then
    player = Players:WaitForChild("LocalPlayer")
end

-- Constrói a UI (seguro, aguarda PlayerGui internamente)
UI:Build()

-- Aguarda a pasta de dados do jogador
local dataFolder = player:WaitForChild("Data")
local levelValue = dataFolder:WaitForChild("Level")
local gemsValue  = dataFolder:WaitForChild("Gems")
local moneyValue = dataFolder:WaitForChild("Money")

-- Função que atualiza todos os stats na UI
local function updateAllStats()
    UI:UpdateStats(levelValue.Value, gemsValue.Value, moneyValue.Value)
end

-- Conecta eventos para atualização em tempo real (live)
local levelConn = levelValue.Changed:Connect(updateAllStats)
local gemsConn  = gemsValue.Changed:Connect(updateAllStats)
local moneyConn = moneyValue.Changed:Connect(updateAllStats)

-- Exibe os valores iniciais
updateAllStats()

-- ========== SEQUÊNCIA DE LOADING ==========
local LOADING_DURATION = 2.5 -- segundos

local progressTween = UI:StartProgressAnimation(LOADING_DURATION)

local function finishLoading()
    UI:FadeToMain()
    if progressTween then
        progressTween.Completed:Wait() -- pequena sincronia opcional
    end
end

if progressTween then
    progressTween.Completed:Connect(finishLoading)
else
    -- Fallback se a animação falhar
    task.wait(LOADING_DURATION)
    finishLoading()
end

-- Limpeza das conexões quando o player sair
player.AncestryChanged:Connect(function()
    if not player.Parent then
        levelConn:Disconnect()
        gemsConn:Disconnect()
        moneyConn:Disconnect()
        if progressTween then progressTween:Cancel() end
    end
end)

print("Flok Kaitun UI inicializado com sucesso!")
