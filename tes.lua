local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaUScrip/OMG/refs/heads/main/LOL.lua", true))()
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer

local KnitRE = game:GetService("ReplicatedStorage").Packages[".pesde"]["sleitnick_knit@1.7.0"].knit.Services
local PanningCollect = KnitRE.PanningService.RF.Collect
local PanningClaim = KnitRE.PanningService.RF.ClaimItem
local SellAll = KnitRE.SellService.RF.SellAll
local UpgradeBuy = KnitRE.UpgradeService.RF.Purchase

local SellPrompt = workspace.Game.ScriptingProperties._nodes._shops.Sell.ProximityPrompt

local ActiveLoops = {}
local function RunLoop(name, check, interval, fn)
	if ActiveLoops[name] then return end
	ActiveLoops[name] = true
	task.spawn(function()
		while check() do
			task.wait(interval)
			pcall(fn)
		end
		ActiveLoops[name] = nil
	end)
end

task.spawn(function()
	while true do
		task.wait(1)
		pcall(function()
			local r = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
			local d = r and r:FindFirstChild("DisconnectedFrame")
			if d and d.Visible then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
			end
		end)
	end
end)

task.spawn(function()
	while true do
		task.wait(600)
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end
end)

local tab = library:CreateWindow("TESTING")

tab:AddToggle({
	text = "Auto Farm Items",
	flag = "afi",
	callback = function(v)
		getgenv().afi = v
		RunLoop("afi", function() return getgenv().afi end, 0.5, function()
			PanningCollect:InvokeServer(999)
			PanningClaim:InvokeServer()
		end)
	end
})

tab:AddToggle({
	text = "Auto Sell",
	flag = "as",
	callback = function(v)
		getgenv().as = v
		RunLoop("as", function() return getgenv().as end, 1, function()
			SellAll:InvokeServer(SellPrompt)
		end)
	end
})

tab:AddToggle({
	text = "Auto Upgrade All",
	flag = "au",
	callback = function(v)
		getgenv().au = v
		RunLoop("au", function() return getgenv().au end, 0.01, function()
			UpgradeBuy:InvokeServer("LuckMultiplier")
			UpgradeBuy:InvokeServer("ValueMultiplier")
		end)
	end
})

library:Init()