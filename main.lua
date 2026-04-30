-- main.lua
-- Ponto de entrada: carrega e coordena a UI, gerencia os dados do jogador.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Carrega os módulos (mesmo diretório)
local UI = require(script.Parent.ui)
local Remotes = require(script.Parent.remotes)  -- opcional, pode remover se não existir

-- Dados iniciais (simulação)
local stats = { Level = 1, Gems = 100, Money = 500 }

-- Tenta obter dados reais da pasta "Data" do jogador
local function loadRealData()
    if not player then return false end
    local data = player:FindFirstChild("Data")
    if not data then return false end

    local lvl = data:FindFirstChild("Level")
    local gem = data:FindFirstChild("Gems")
    local mon = data:FindFirstChild("Money")

    if lvl and typeof(lvl.Value) == "number" then stats.Level = lvl.Value end
    if gem and typeof(gem.Value) == "number" then stats.Gems  = gem.Value end
    if mon and typeof(mon.Value) == "number" then stats.Money = mon.Value end

    local function updateAll()
        UI:UpdateStats(stats.Level, stats.Gems, stats.Money)
    end

    if lvl then lvl.Changed:Connect(function(v) stats.Level = v; updateAll() end) end
    if gem then gem.Changed:Connect(function(v) stats.Gems  = v; updateAll() end) end
    if mon then mon.Changed:Connect(function(v) stats.Money = v; updateAll() end) end
    updateAll()
    return true
end

local realDataExists = loadRealData()

-- Constrói a GUI
UI:Build()
UI:UpdateStats(stats.Level, stats.Gems, stats.Money)

-- Se não há dados reais, simula incremento a cada 5 segundos
if not realDataExists then
    spawn(function()
        while true do
            task.wait(5)
            stats.Level = stats.Level + 1
            stats.Gems  = stats.Gems + 50
            stats.Money = stats.Money + 200
            UI:UpdateStats(stats.Level, stats.Gems, stats.Money)
        end
    end)
end

-- Animação de loading e transição
local progress = UI:StartProgressAnimation(2.5)
if progress then
    progress.Completed:Connect(function()
        UI:FadeToMain()
    end)
else
    task.wait(2.5)
    UI:FadeToMain()
end

print("Flok Kaitun UI carregada com sucesso!")
