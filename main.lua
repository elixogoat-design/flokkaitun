--[[
    Arquivo: main.lua
    Responsabilidade: Orquestrar o fluxo de inicialização,
    buscar os dados do jogador, manter as estatísticas atualizadas
    em tempo real e executar a transição da tela de loading.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Carrega os módulos
local UI = require(script.Parent.Modules.ui)
local Remotes = require(script.Parent.Modules.remotes) -- reservado

local player = Players.LocalPlayer
if not player then
    player = Players:WaitForChild("LocalPlayer")
end

-- Constrói toda a interface (já fica invisível até o final)
UI:Build()

-- Aguarda a pasta de dados do jogador
local dataFolder = player:WaitForChild("Data")
local levelValue = dataFolder:WaitForChild("Level")
local gemsValue  = dataFolder:WaitForChild("Gems")
local moneyValue = dataFolder:WaitForChild("Money")

-- Atualiza todos os valores na UI
local function updateAllStats()
    UI:UpdateStats(levelValue.Value, gemsValue.Value, moneyValue.Value)
end

-- Conecta eventos para atualização automática (live)
local levelConn = levelValue.Changed:Connect(updateAllStats)
local gemsConn  = gemsValue.Changed:Connect(updateAllStats)
local moneyConn = moneyValue.Changed:Connect(updateAllStats)

-- Exibe os valores iniciais
updateAllStats()

-- ==============================
-- SEQUÊNCIA DE LOADING
-- ==============================
local LOADING_DURATION = 2.5  -- segundos

-- Inicia a animação da barra de progresso
local progressTween = UI:StartProgressAnimation(LOADING_DURATION)

-- Pequeno delay adicional por segurança (caso os dados demorem)
-- mas como já temos os dados, apenas aguarda o fim da barra.
local function finishLoading()
    UI:FadeToMain()
    
    -- Pequena limpeza (opcional)
    task.delay(1, function()
        -- Desconecta o tween se ainda existir (garantia)
        if progressTween and progressTween.Completed then
            progressTween:Cancel()
        end
    end)
end

-- Quando a barra terminar, faz a transição
progressTween.Completed:Connect(finishLoading)

-- Fallback de segurança: se por algum motivo a barra travar, força após X segundos
task.delay(LOADING_DURATION + 0.5, function()
    if UI.loadingCanvas and UI.loadingCanvas.Visible ~= false then
        warn("Forçando transição por segurança.")
        finishLoading()
    end
end)

-- Limpeza das conexões caso o jogador saia
player.AncestryChanged:Connect(function()
    if not player.Parent then
        levelConn:Disconnect()
        gemsConn:Disconnect()
        moneyConn:Disconnect()
        if progressTween then progressTween:Cancel() end
    end
end)

print("Flok Kaitun UI inicializado com sucesso!")
