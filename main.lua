--[[
	Flok Kaitun - Main Controller
	Handles logic, data updates, and transitions
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Require our modules
local UI = require(script.Parent.ui)
local Remotes = require(script.Parent.remotes)

local FlokKaitun = {}

-- Data tracking
local currentData = {
	Level = nil,
	Gems = nil,
	Money = nil
}

-- Update interval (prevents excessive updates)
local UPDATE_THROTTLE = 0.1
local lastUpdate = 0

--[[
	Fetches current player data safely
]]
local function getPlayerData()
	local success, data = pcall(function()
		return LocalPlayer:WaitForChild("Data", 5)
	end)
	
	if success and data then
		return {
			Level = data:FindFirstChild("Level") and data.Level.Value or 0,
			Gems = data:FindFirstChild("Gems") and data.Gems.Value or 0,
			Money = data:FindFirstChild("Money") and data.Money.Value or 0
		}
	end
	
	return nil
end

--[[
	Updates UI with current data
]]
local function updateUI()
	local data = getPlayerData()
	if not data then return end
	
	-- Check if values actually changed to avoid unnecessary updates
	if data.Level ~= currentData.Level then
		UI.updateStat("Level", data.Level)
		currentData.Level = data.Level
	end
	
	if data.Gems ~= currentData.Gems then
		UI.updateStat("Gems", data.Gems)
		currentData.Gems = data.Gems
	end
	
	if data.Money ~= currentData.Money then
		UI.updateStat("Money", data.Money)
		currentData.Money = data.Money
	end
end

--[[
	Heartbeat loop for real-time updates (optimized)
]]
local function startDataLoop()
	RunService.Heartbeat:Connect(function(deltaTime)
		lastUpdate += deltaTime
		if lastUpdate >= UPDATE_THROTTLE then
			lastUpdate = 0
			updateUI()
		end
	end)
end

--[[
	Main initialization sequence
]]
function FlokKaitun.init()
	-- Create UI elements
	UI.createLoadingScreen()
	
	-- Simulate loading with smooth transition
	task.wait(1) -- Brief initial delay
	
	-- Start loading animation
	UI.startLoading()
	
	-- Simulate asset loading time
	task.wait(3) -- Adjust based on your needs
	
	-- Transition from loading to main UI
	UI.fadeOutLoading(function()
		-- Create main UI after loading fades
		UI.createMainUI()
		
		-- Fade in main UI
		UI.fadeInMain(function()
			-- Initial data update
			updateUI()
			
			-- Start real-time updates
			startDataLoop()
		end)
	end)
end

return FlokKaitun
