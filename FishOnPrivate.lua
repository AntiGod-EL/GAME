local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Player = Players.LocalPlayer

local FishingEvent = game:GetService("ReplicatedStorage").RemoteEvents.Fishing
local SellFishEvent = game:GetService("ReplicatedStorage").RemoteEvents.SellFish
local BuyPotionEvent = game:GetService("ReplicatedStorage").RemoteEvents.BuyPotionEvent

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

local tab1 = library:CreateWindow("Fish On Private")

local function ThrowLineSecret()
	local Character = Player.Character
	if not Character then return end
	local Rod = Character:FindFirstChild("Rod")
	if not Rod then return end
	local Beam = Rod:FindFirstChild("Beam")
	local Rope = Rod:FindFirstChild("Rope")
	if not Beam or not Rope then return end

	FishingEvent:FireServer(
		"Throw",
		{
			character = Character,
			beam = Beam,
			rope = Rope,
			currentLuck = math.huge,
			bobberName = "Red Bait",
			isWater = true
		}
	)
end

local function ThrowLineNormal()
	local Character = Player.Character
	if not Character then return end
	local Rod = Character:FindFirstChild("Rod")
	if not Rod then return end
	local Beam = Rod:FindFirstChild("Beam")
	local Rope = Rod:FindFirstChild("Rope")
	if not Beam or not Rope then return end

	FishingEvent:FireServer(
		"Throw",
		{
			character = Character,
			beam = Beam,
			rope = Rope,
			currentLuck = 1,
			bobberName = "Red Bait",
			isWater = true
		}
	)
end

local function CatchFish()
	FishingEvent:FireServer(
		"Catch",
		{
			getFish = true,
			character = Player.Character
		}
	)
end

local PotionList = {
	"Potion Fisherman Luck",
	"Potion Ocean's Gift",
	"Potion Fortune Sight",
	"Potion Sweet Affection",
	"Potion Toxic Hazard",
	"Potion Volcanic Fury",
	"Potion Perfectionist",
	"Potion Cybernetic Pulse",
	"Potion Royal Gold",
	"Potion Cosmic Eclipse",
	"Potion Overwhelming Luck",
	"Potion Divine Spirit"
}

tab1:AddToggle({
	text = "Auto Fish [SECRET]",
	flag = "auto_fish_secret",
	callback = function(v)
		getgenv().AutoFishSecret = v
		while getgenv().AutoFishSecret do
			pcall(function()
				ThrowLineSecret()
				task.wait(0.3)
				CatchFish()
			end)
			task.wait(1)
		end
	end
})

tab1:AddToggle({
	text = "Auto Fish [NORMAL]",
	flag = "auto_fish_normal",
	callback = function(v)
		getgenv().AutoFishNormal = v
		while getgenv().AutoFishNormal do
			pcall(function()
				ThrowLineNormal()
				task.wait(0.3)
				CatchFish()
			end)
			task.wait(1)
		end
	end
})

tab1:AddToggle({
	text = "Auto Sell",
	flag = "auto_sell",
	callback = function(v)
		getgenv().AutoSell = v
		while getgenv().AutoSell do
			pcall(function()
				SellFishEvent:FireServer("all")
			end)
			task.wait(2)
		end
	end
})

tab1:AddToggle({
	text = "Buy All Potion",
	flag = "buy_all_potion",
	callback = function(v)
		getgenv().BuyAllPotion = v
		while getgenv().BuyAllPotion do
			pcall(function()
				for _, potion in ipairs(PotionList) do
					if not getgenv().BuyAllPotion then break end
					pcall(function()
						BuyPotionEvent:FireServer(potion)
					end)
					task.wait(0.3)
				end
			end)
			task.wait(1)
		end
	end
})

tab1:AddLabel({text = "PRIVATE REQUESTS"})

library:Init()
