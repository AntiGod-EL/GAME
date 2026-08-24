local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaUScrip/OMG/refs/heads/main/LOL.lua", true))()
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

local ActiveLoops = {}

local function RunLoop(name, flagCheck, interval, fn)
    if ActiveLoops[name] then return end
    ActiveLoops[name] = true
    task.spawn(function()
        while flagCheck() do
            task.wait(interval)
            pcall(fn)
        end
        ActiveLoops[name] = nil
    end)
end

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

task.spawn(function()
    while Config.AntiAfk do
        task.wait(600)
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

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

task.spawn(function()
    while task.wait() do
        pcall(function()
            if Player.GameplayPaused then
                Player.GameplayPaused = false
            end
        end)
    end
end)

-- ============================================
-- WINDOW 1: Auto Farm
-- ============================================
local tab1 = library:CreateWindow("Horse Race")

local WinGate = "WinGate_16"
local WinPosition = Vector3.new(1801.7867431641, 782.15179443359, -689403.9375)

tab1:AddToggle({
    text = "Auto Farm Wins",
    flag = "auto_farm_wins",
    callback = function(v)
        getgenv().AutoFarmWins = v
        RunLoop("AutoFarmWins", function() return getgenv().AutoFarmWins end, 0.0000001, function()
            KnitRE.FightService.RE.GetWinsEvent:FireServer(WinGate, WinPosition)
        end)
    end
})

tab1:AddToggle({
    text = "Inf Wins",
    flag = "inf_wins",
    callback = function(v)
        getgenv().InfWins = v
        RunLoop("InfWins", function() return getgenv().InfWins end, 0.00001, function()
            KnitRE.RandomPotionService.RE.BuyPotionEvent:FireServer(-7e+71, {}, true, "yippie!")
        end)
    end
})

tab1:AddToggle({
    text = "Auto Rebirth",
    flag = "auto_rebirth",
    callback = function(v)
        getgenv().AutoRebirth = v
        RunLoop("AutoRebirth", function() return getgenv().AutoRebirth end, 0.00001, function()
            KnitRE.RebirthService.RF.Rebirth:InvokeServer()
        end)
    end
})

tab1:AddToggle({
    text = "Auto Super Rebirth",
    flag = "auto_super_rebirth",
    callback = function(v)
        getgenv().AutoSuperRebirth = v
        RunLoop("AutoSuperRebirth", function() return getgenv().AutoSuperRebirth end, 0.00001, function()
            KnitRE.RebirthService.RF.SuperRebirth:InvokeServer()
        end)
    end
})

tab1:AddToggle({
    text = "Auto Upgrade",
    flag = "auto_upgrade_all",
    callback = function(v)
        getgenv().AutoUpgradeAll = v
        RunLoop("AutoUpgradeAll", function() return getgenv().AutoUpgradeAll end, 0.00001, function()
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Wins")
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_TopSpeed")
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Strength")
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Acc")
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Diamond_Num")
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Diamond_Chance")
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_Luck")
            KnitRE.UpgradeService.RE.Upgrade:FireServer("Upgrade_StartSpeed")
        end)
    end
})

tab1:AddToggle({
    text = "Auto Craft Pets",
    flag = "auto_craft_pets",
    callback = function(v)
        getgenv().AutoCraftPets = v
        RunLoop("AutoCraftPets", function() return getgenv().AutoCraftPets end, 0.00001, function()
            KnitRE.PetService.RE.EnlargeAllPets:FireServer()
        end)
    end
})

tab1:AddToggle({
    text = "Auto Equip Best Pet",
    flag = "auto_equip_best",
    callback = function(v)
        getgenv().AutoEquipBest = v
        RunLoop("AutoEquipBest", function() return getgenv().AutoEquipBest end, 0.00001, function()
            KnitRE.PetService.RE.EquipBestPets:FireServer()
        end)
    end
})

tab1:AddToggle({
    text = "Inf Potions & King Slime",
    flag = "dupe_pets",
    callback = function(v)
        getgenv().DupePets = v
        RunLoop("DupePets", function() return getgenv().DupePets end, 0.00001, function()
            KnitRE.ChestService.RF.ClaimDailyChest:InvokeServer()
        end)
    end
})

tab1:AddToggle({
    text = "Auto Claim Event Egg",
    flag = "auto_claim_egg",
    callback = function(v)
        getgenv().AutoClaimEgg = v
        RunLoop("AutoClaimEgg", function() return getgenv().AutoClaimEgg end, 0.00001, function()
            KnitRE.OnlineRewardService.RF.ClaimOnlineQuestReward:InvokeServer()
        end)
    end
})

-- ============================================
-- WINDOW 2: Egg Hatch + Teleport
-- ============================================
local tab2 = library:CreateWindow("Misc")

-- EGG HATCH FOLDER
local eggFolder = tab2:AddFolder("Egg")

eggFolder:AddToggle({
    text = "Hatch Normal Egg",
    flag = "hatch_normal_egg",
    callback = function(v)
        getgenv().HatchNormalEgg = v
        RunLoop("HatchNormalEgg", function() return getgenv().HatchNormalEgg end, 0.00001, function()
            KnitRE.EggHatchService.RE.Hatch:FireServer("Egg_4_3", 10)
        end)
    end
})

eggFolder:AddToggle({
    text = "Hatch Christmas Egg",
    flag = "hatch_christmas_egg",
    callback = function(v)
        getgenv().HatchChristmasEgg = v
        RunLoop("HatchChristmasEgg", function() return getgenv().HatchChristmasEgg end, 0.00001, function()
            KnitRE.EggHatchService.RE.Hatch:FireServer("Egg_Christmas", 10)
        end)
    end
})

-- TELEPORT FOLDER
local tpFolder = tab2:AddFolder("Teleport")

local AreaEvent = KnitRE.AreaService.RE.UpdatePlayerCurrentArea

local function TeleportAndRejoin(area)
    pcall(function()
        AreaEvent:FireServer(area)
    end)
    task.wait(0.5)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end)
end

tpFolder:AddButton({
    text = "Area 1",
    flag = "tp_area_1",
    callback = function()
        TeleportAndRejoin("Area_1")
    end
})

tpFolder:AddButton({
    text = "Area 2",
    flag = "tp_area_2",
    callback = function()
        TeleportAndRejoin("Area_2")
    end
})

tpFolder:AddButton({
    text = "Area 3",
    flag = "tp_area_3",
    callback = function()
        TeleportAndRejoin("Area_3")
    end
})

tpFolder:AddButton({
    text = "Area 4",
    flag = "tp_area_4",
    callback = function()
        TeleportAndRejoin("Area_4")
    end
})

tpFolder:AddButton({
    text = "Area Fruit",
    flag = "tp_area_fruit",
    callback = function()
        TeleportAndRejoin("Area_Fruit")
    end
})

library:Init()