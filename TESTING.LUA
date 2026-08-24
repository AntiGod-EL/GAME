local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Player = Players.LocalPlayer

-- Events
local ClickStartEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_ClickStart
local ClickStopEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_ClickStop
local X2ClaimEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_X2Claim
local RebirthEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_RebirthRequest
local SellAllEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_SellAll
local BuyUpgradeEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_BuyUpgrade

local Config = {
	AutoReconnect = true,
	AntiAfk = true
}

ProximityPromptService.PromptButtonHoldBegan:Connect(function(promptheld)
	fireproximityprompt(promptheld)
end)

local function AutoReconnectLoop()
	task.spawn(function()
		while Config.AutoReconnect do
			task.wait(0.5)
			pcall(function()
				local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
				local DFrame = RobloxGui and RobloxGui:FindFirstChild("DisconnectedFrame")
				if DFrame and DFrame.Visible then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
				end
			end)
		end
	end)
end

local function AntiAfkLoop()
	task.spawn(function()
		while Config.AntiAfk do
			task.wait(600)
			pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end
	end)
end

AutoReconnectLoop()
AntiAfkLoop()

-- =============================================

local tab1 = library:CreateWindow("PRIVATE")

tab1:AddToggle({
	text = "Farm Level [FAST]",
	flag = "auto_farm",
	callback = function(v)
		getgenv().AutoFarm = v
		while getgenv().AutoFarm do
			pcall(function()
				ClickStartEvent:FireServer()
			end)
			task.wait(0.00001)
			pcall(function()
				ClickStopEvent:FireServer()
			end)
			task.wait(0.00001)
			pcall(function()
				X2ClaimEvent:FireServer()
			end)
			task.wait(0.1)
		end
	end
})

tab1:AddToggle({
	text = "Auto Rebirth",
	flag = "auto_rebirth",
	callback = function(v)
		getgenv().AutoRebirth = v
		while getgenv().AutoRebirth do
			pcall(function()
				RebirthEvent:FireServer()
			end)
			task.wait(0.1)
		end
	end
})

tab1:AddToggle({
	text = "Sell All",
	flag = "auto_sell",
	callback = function(v)
		getgenv().AutoSell = v
		while getgenv().AutoSell do
			pcall(function()
				SellAllEvent:FireServer()
			end)
			task.wait(0.1)
		end
	end
})

tab1:AddToggle({
	text = "Auto Buy Upgrade",
	flag = "auto_buy_upgrade",
	callback = function(v)
		getgenv().AutoBuyUpgrade = v
		while getgenv().AutoBuyUpgrade do
			pcall(function()
				BuyUpgradeEvent:FireServer("ExpPerClick", 5)
			end)
			task.wait(0.00001)
		end
	end
})

library:Init()