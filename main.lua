-- main.lua
-- Orquestra carregamento, dados e live update.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local UI = require(script.Parent.ui)
local Remotes = require(script.Parent.remotes) -- reservado

-- Dados do jogador (simulados ou reais)
local playerStats = {
    Level = 1,
    Gems = 100,
    Money = 500
}

-- Tenta obter dados reais da pasta "Data"
local function tryGetRealData()
    if not player then return false end
    local dataFolder = player:FindFirstChild("Data")
    if not dataFolder then return false end

    local levelVal = dataFolder:FindFirstChild("Level")
    local gemsVal  = dataFolder:FindFirstChild("Gems")
    local moneyVal = dataFolder:FindFirstChild("Money")

    if levelVal and typeof(levelVal.Value) == "number" then playerStats.Level = levelVal.Value end
    if gemsVal  and typeof(gemsVal.Value)  == "number" then playerStats.Gems  = gemsVal.Value end
    if moneyVal and typeof(moneyVal.Value) == "number" then playerStats.Money = moneyVal.Value end

    local function updateFromGame()
        UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)
    end
    if levelVal then levelVal.Changed:Connect(function(v) playerStats.Level = v; updateFromGame() end) end
    if gemsVal  then gemsVal.Changed:Connect(function(v) playerStats.Gems  = v; updateFromGame() end) end
    if moneyVal then moneyVal.Changed:Connect(function(v) playerStats.Money = v; updateFromGame() end) end
    updateFromGame()
    return true
end

local hasRealData = tryGetRealData()

-- Constrói a UI (fullscreen)
UI:Build()
UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)

-- Se não houver dados reais, simula aumento automático a cada 5s
if not hasRealData then
    spawn(function()
        while true do
            task.wait(5)
            playerStats.Level = playerStats.Level + 1
            playerStats.Gems  = playerStats.Gems + 50
            playerStats.Money = playerStats.Money + 200
            UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)
        end
    end)
end

-- Inicia animação da barra de progresso
local progressTween = UI:StartProgressAnimation(2.5)
if progressTween then
    progressTween.Completed:Connect(function()
        UI:FadeToMain()
    end)
else
    task.wait(2.5)
    UI:FadeToMain()
end

print("Flok Kaitun UI fullscreen carregada com ícones personalizados!")
