local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Player = Players.LocalPlayer

local KnitRE = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.5.1"].knit.Services

local Config = {
	AutoReconnect = true,
	AntiAfk = true,
	NoGameplayPaused = true
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

local function NoPauseLoop()
	task.spawn(function()
		while Config.NoGameplayPaused do
			task.wait(20)
			pcall(function()
				local Char = Player.Character
				local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
				if HRP then
					HRP.AssemblyLinearVelocity = HRP.AssemblyLinearVelocity + Vector3.new(0, 1.5, 0)
				end
			end)
		end
	end)
end

local function GameplayPausedLoop()
	task.spawn(function()
		while task.wait() do
			pcall(function()
				if Player.GameplayPaused then
					Player.GameplayPaused = false
				end
			end)
		end
	end)
end

AutoReconnectLoop()
AntiAfkLoop()
NoPauseLoop()
GameplayPausedLoop()

-- ============================================
-- WINDOW 1: Main
-- ============================================
local tab1 = library:CreateWindow("AntiGodHub")

-- Auto Farm Wins
local WinGate = "WinGate_16"
local WinPosition = Vector3.new(1801.7867431641, 782.15179443359, -689403.9375)

tab1:AddToggle({
	text = "Auto Farm Wins [IN RACE]",
	flag = "auto_farm_wins",
	callback = function(v)
		getgenv().AutoFarmWins = v
		while getgenv().AutoFarmWins do
			pcall(function()
				KnitRE.FightService.RE.GetWinsEvent:FireServer(WinGate, WinPosition)
			end)
			task.wait(0.000000001)
		end
	end
})

-- Auto Rebirth
tab1:AddToggle({
	text = "Auto Rebirth",
	flag = "auto_rebirth",
	callback = function(v)
		getgenv().AutoRebirth = v
		while getgenv().AutoRebirth do
			pcall(function()
				KnitRE.RebirthService.RF.Rebirth:InvokeServer()
			end)
			task.wait(0.001)
		end
	end
})

-- Auto Upgrade All
tab1:AddToggle({
	text = "Auto Upgrade",
	flag = "auto_upgrade_all",
	callback = function(v)
		getgenv().AutoUpgradeAll = v
		while getgenv().AutoUpgradeAll do
			pcall(function()
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Wins")
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_TopSpeed")
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Strength")
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Acc")
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Diamond_Num")
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Diamond_Chance")
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Luck")
				KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_StartSpeed")
			end)
			task.wait(0.001)
		end
	end
})

-- Auto Craft Pets
tab1:AddToggle({
	text = "Auto Craft Pets",
	flag = "auto_craft_pets",
	callback = function(v)
		getgenv().AutoCraftPets = v
		while getgenv().AutoCraftPets do
			pcall(function()
				KnitRE.PetService.RE.EnlargeAllPets:FireServer()
			end)
			task.wait(0.5)
		end
	end
})

-- Auto Equip Best Pet
tab1:AddToggle({
	text = "Auto Equip Best Pet",
	flag = "auto_equip_best",
	callback = function(v)
		getgenv().AutoEquipBest = v
		while getgenv().AutoEquipBest do
			pcall(function()
				KnitRE.PetService.RE.EquipBestPets:FireServer()
			end)
			task.wait(1)
		end
	end
})

-- Dupe Pets
tab1:AddToggle({
	text = "Dupe Pets [OP]",
	flag = "dupe_pets",
	callback = function(v)
		getgenv().DupePets = v
		while getgenv().DupePets do
			pcall(function()
				KnitRE.ChestService.RF.ClaimDailyChest:InvokeServer()
			end)
			task.wait(0.003)
		end
	end
})

-- Auto Claim Event Egg
tab1:AddToggle({
	text = "Auto Claim Quest Egg",
	flag = "auto_claim_egg",
	callback = function(v)
		getgenv().AutoClaimEgg = v
		while getgenv().AutoClaimEgg do
			pcall(function()
				KnitRE.OnlineRewardService.RF.ClaimOnlineQuestReward:InvokeServer()
			end)
			task.wait(1)
		end
	end
})

tab1:AddLabel({text = "PRIVATE SCRIPT"})

library:Init()