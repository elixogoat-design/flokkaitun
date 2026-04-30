-- main.lua - execução via executor (exploit)
local UI = require(script.Parent.ui)   -- ajuste o caminho conforme necessário
local Remotes = require(script.Parent.remotes)

UI:Build()

-- Simulação de dados do jogador (já que você não tem acesso ao Data do jogo)
local playerStats = {
    Level = 1,
    Gems = 100,
    Money = 500
}

-- Atualiza a UI com os dados atuais
local function updateUI()
    UI:UpdateStats(playerStats.Level, playerStats.Gems, playerStats.Money)
end

-- Opcional: simular mudanças automáticas a cada 5 segundos
-- (comente se não quiser)
local autoChange = true
if autoChange then
    spawn(function()
        while wait(5) do
            playerStats.Level = playerStats.Level + 1
            playerStats.Gems = playerStats.Gems + 50
            playerStats.Money = playerStats.Money + 200
            updateUI()
        end
    end)
end

-- Inicia loading e transição
local progressTween = UI:StartProgressAnimation(2.5)
updateUI()

local function finish()
    UI:FadeToMain()
end

if progressTween then
    progressTween.Completed:Connect(finish)
else
    task.wait(2.5)
    finish()
end

print("Flok Kaitun carregado para executor!")
