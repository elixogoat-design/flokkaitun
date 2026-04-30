-- main.lua
-- Ponto de entrada, carrega dados e orquestra a UI

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local UI = require(script.Parent.ui)
local Remotes = require(script.Parent.remotes) -- reservado

-- Dados do jogador (simulados inicialmente)
local playerStats = {
    Level = 1,
    Gems = 100,
    Money = 500
}

-- Tenta carregar dados reais da pasta "Data"
local function loadRealData()
    if not player then return false end
    local dataFolder = player:FindFirstChild("Data")
    if not dataFolder then return false end

    local levelVal = dataFolder:FindFirstChild("Level")
    local gemsVal  = dataFolder:FindFirstChild("Gems")
    local moneyVal = dataFolder:FindFirstChild("Money")

    if levelVal and typeof(levelVal.Value) == "number" then playerStats.Level = levelVal.Value end
    if gemsVal  and typeof(gemsVal.Value)  == "number" then playerStats.Gems  = gemsVal.Value end
    if moneyVal and typeof(moneyVal.Value) == "number" then playerStats.Money = moneyVal.Value end

    -- Conexões para atualização em tempo real
    local function update()
        UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)
    end
    if levelVal then levelVal.Changed:Connect(function(v) playerStats.Level = v; update() end) end
    if gemsVal  then gemsVal.Changed:Connect(function(v) playerStats.Gems  = v; update() end) end
    if moneyVal then moneyVal.Changed:Connect(function(v) playerStats.Money = v; update() end) end
    update()
    return true
end

local hasRealData = loadRealData()

-- Constrói a UI (fullscreen)
UI:Build()
UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)

-- Se não houver dados reais, simula aumento automático a cada 5 segundos
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

-- Anima a barra de progresso e depois mostra a UI principal
local progressTween = UI:StartProgressAnimation(2.5)
if progressTween then
    progressTween.Completed:Connect(function()
        UI:FadeToMain()
    end)
else
    -- Fallback: espera 2.5 segundos e troca
    task.wait(2.5)
    UI:FadeToMain()
end

print("Flok Kaitun UI modular carregada com sucesso!")
