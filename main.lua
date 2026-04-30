-- main.lua
-- Script principal que orquestra o carregamento e atualiza os stats

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Carregar módulos (assumindo que estão na mesma pasta)
local UI = require(script.Parent.ui)
local Remotes = require(script.Parent.remotes) -- não usado, mas disponível

-- ========== DADOS DO JOGADOR (simulados ou reais) ==========
local playerStats = {
    Level = 1,
    Gems = 100,
    Money = 500
}

-- Tenta obter dados reais do jogo (se existir a pasta "Data")
local function tryGetRealData()
    if player then
        local dataFolder = player:FindFirstChild("Data")
        if dataFolder then
            local levelVal = dataFolder:FindFirstChild("Level")
            local gemsVal  = dataFolder:FindFirstChild("Gems")
            local moneyVal = dataFolder:FindFirstChild("Money")
            if levelVal and typeof(levelVal.Value) == "number" then playerStats.Level = levelVal.Value end
            if gemsVal  and typeof(gemsVal.Value)  == "number" then playerStats.Gems  = gemsVal.Value end
            if moneyVal and typeof(moneyVal.Value) == "number" then playerStats.Money = moneyVal.Value end
            
            -- Conectar para atualizações em tempo real
            local function updateFromGame()
                UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)
            end
            if levelVal then levelVal.Changed:Connect(function(v) playerStats.Level = v; updateFromGame() end) end
            if gemsVal  then gemsVal.Changed:Connect(function(v) playerStats.Gems  = v; updateFromGame() end) end
            if moneyVal then moneyVal.Changed:Connect(function(v) playerStats.Money = v; updateFromGame() end) end
            updateFromGame()
            return true
        end
    end
    return false
end

local hasRealData = tryGetRealData()

-- Se não há dados reais, usamos simulação com incremento automático
local autoIncConnection = nil
if not hasRealData then
    -- Atualiza a UI com os valores simulados
    local function updateUI()
        UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)
    end
    updateUI()
    
    -- Incrementa automaticamente a cada 5 segundos (exemplo)
    autoIncConnection = game:GetService("RunService").Stepped:Connect(function()
        -- a cada 5 segundos (aproximado)
        if tick() % 5 < 0.1 then
            playerStats.Level = playerStats.Level + 1
            playerStats.Gems = playerStats.Gems + 50
            playerStats.Money = playerStats.Money + 200
            updateUI()
        end
    end)
end

-- ========== CONSTRUIR E INICIAR A UI ==========
UI:Build()

-- Animar barra de progresso
local progressTween = UI:StartProgressAnimation(2.5) -- 2.5 segundos

-- Ao terminar a animação, fazer o fade para a UI principal
if progressTween then
    progressTween.Completed:Connect(function()
        UI:FadeToMain()
    end)
else
    -- Fallback
    task.wait(2.5)
    UI:FadeToMain()
end

-- Limpeza quando o script for interrompido (opcional)
game:GetService("Players").LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if not player.Parent then
        if autoIncConnection then autoIncConnection:Disconnect() end
    end
end)

print("Flok Kaitun UI carregada com sucesso!")
