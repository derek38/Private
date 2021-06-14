--// Ignore \\--
repeat
    wait()
until game:IsLoaded()

getgenv().ErrorMessage = "Kanda Hub"

--// Declarations \\--
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Releases/main/UI-Librarys/Kanda.lua"))()
local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Releases/main/Tools/Utility.lua"))()
local EspLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Releases/main/Tools/Esp.lua"))()
local AimbotLibrary = {}

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local HTTPService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

getgenv().Self = PlayerService.LocalPlayer

local Mouse = PlayerService.LocalPlayer:GetMouse()

if typeof(getgenv().UI_Themes) ~= "table" then
    return Utilities:Kick("[Kanda Hub] \n \n Theme Table Is Missing. Execute a Theme before Executing the Script. \n \n discord.gg/zXyPavzACn")
end

--// Detection \\--
local ExploitUsed = "Unknown"
local CurrentGame = "Universal"

if syn and syn.protect_gui and Drawing then
    ExploitUsed = "Synapse-X"
elseif KRNL_LOADED and Drawing then
    ExploitUsed = "Krnl"
elseif is_fluxus_closure and Drawing then
    ExploitUsed = "Fluxus"
elseif getexecutorname and Drawing then
    ExploitUsed = "Script-ware"
else
    Utilities:Kick("[Kanda Hub] Read Everything Below :\n Your Exploit/Executor Is Not Supported. \n \n Check In The Discord Server To See The Supported Exploits/Executors \n \n discord.gg/zXyPavzACn")
end

if typeof(Drawing.new) ~= "function" then
    Utilities:Kick("[Kanda Hub] Read Everything Below :\n Your Exploit/Executor Is Not Supported.\n \n Check In The Discord Server To See The Supported Exploits/Executors \n \n discord.gg/zXyPavzACn")
end

local SupportedGames = {
    ["Bubble Gum"] = 2512643572,
    ["MM2"] = 142823291
}

local function Current()
    for i,v in pairs(SupportedGames) do
        if game.PlaceId == v then
            CurrentGame = i
            return
        else
            CurrentGame = "Universal"
        end
    end
end

Current()

local UI = Library:Init("Kanda Hub\n",{
    Themes = getgenv().UI_Themes
})

local Home = UI:AddPage("Home",{
    Visible = true
})

Home:AddCredits()

if CurrentGame == "Universal" then
    --// Declarations \\--
    local Visuals = UI:AddPage("Visuals")

    --// Functions \\--
    UI:OnDestroyed(function()
        EspLibrary:Toggle(false)
    end)

    --// Visuals \\--
    Visuals:AddToggle("Enable ESP",false,function(value)
        EspLibrary:Toggle(value)
    end)

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Name Tags",false,function(value)
        EspLibrary.Names = value
    end)

    Visuals:AddToggle("Show Distance Info",false,function(value)
        EspLibrary.Distance = value
    end)

    Visuals:AddDropdown("Name Tag Font",{"UI","System","Plex","Monospace"},function(value)
        EspLibrary.Font = Drawing.Fonts[value]
    end,{
        Default = "UI",
        Execute = true
    })

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Boxes",true,function(value)
        EspLibrary.Boxes = value
    end)

    Visuals:AddToggle("Show Tracers",false,function(value)
        EspLibrary.Tracers = value
    end)

    Visuals:AddSlider("Box and Tracer Thickness",1,1,5,function(value)
        EspLibrary.Thickness = value
    end)

    Visuals:AddDropdown("Tracers Foundation",{"Top","Middle","Bottom"},function(value)
        if value == "Top" then
            EspLibrary.AttachShift = 100
        elseif value == "Middle" then
            EspLibrary.AttachShift = 2
        else
            EspLibrary.AttachShift = 1
        end
    end,{
        Default = "Bottom",
        Execute = true
    })

    Visuals:AddEmpty()

    Visuals:AddToggle("Use Team Color",true,function(value)
        EspLibrary.TeamColor = value
    end)

    Visuals:AddToggle("Boxes Face Camera",false,function(value)
        EspLibrary.FaceCamera = value
    end)

    Visuals:AddToggle("Show Team Mates",false,function(value)
        EspLibrary.TeamMates = value
    end)

    Visuals:AddEmpty()

    Visuals:AddColorPicker("ESP Color",Color3.fromRGB(255,65,65),function(value)
        EspLibrary.Color = value
    end)

end

if CurrentGame == "Bubble Gum" then
    --// Declarations \\--
    local Local = UI:AddPage("Local")
    local Visuals = UI:AddPage("Visuals")
    local AutoFarm = UI:AddPage("Auto-Farm")
    local AutoEgg = UI:AddPage("Auto-Egg")
    local Miscellaneous = UI:AddPage("Miscellaneous")

    local EggTable = {}
    local EggService = ReplicatedStorage.Assets.Modules.EggService
    local Module = require(EggService)
    local OldModule = Module.HatchEgg
    local ChatModule = PlayerService.LocalPlayer.PlayerGui.Chat.Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller

    BubbleConfig = typeof(getgenv().BubbleConfig) == "table" and getgenv().BubbleConfig or {
        AutoBlowBubbles = false,
        AutoSellBubbles = false,
        AutoClaimDailyRewards = false,
        AutoClaimGroupRewards = false,
        AutoSpinWheel = false,
        AutoCollectChestRewards = false,
        AutoClaimShardRewards = false,
        AutoStartShardQuest = false,
        ShardQuestType = "Easy",
        AutoCollectDrops = false,
        AutoCollectDropSpeed = 50,
        AutoCollectDropsMethod = "Tweening",
        EggValue = "Common Egg",
        AutoOpenEgg = false,
        Auto2xHatchSpeed = false,
        AutoMultiOpenEgg = false,
        Enable2xLuck = false,
        Enable2xShiny = false,
        Enable2xMythic = false,
        PetNotifierWebhook = "",
        EnablePetNotifer = false
    }

    local LocalMods = {
        WalkSpeed = 16,
        JumpPower = 50,
        FieldOfView = 70,
        Enabled = false
    }

    --// Functions \\--
    Utilities:InsertObjects(Workspace.Eggs,EggTable,true)

    local Connection = RunService.Heartbeat:Connect(function()
        if not PlayerService.LocalPlayer.Character:FindFirstChild("Humanoid") then
            return
        end

        if LocalMods.Enabled == true then
            PlayerService.LocalPlayer.Character.Humanoid.WalkSpeed = LocalMods.WalkSpeed
            PlayerService.LocalPlayer.Character.Humanoid.JumpPower = LocalMods.JumpPower
            Workspace.Camera.FieldOfView = LocalMods.FieldOfView
        end

        if LocalMods.Enabled == false then
            PlayerService.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            PlayerService.LocalPlayer.Character.Humanoid.JumpPower = 50
            Workspace.Camera.FieldOfView = 70
        end
    end)

    UI:OnDestroyed(function()
        Connection:Disconnect()
        EspLibrary:Toggle(false)
    end)

    --// Local \\--
    Local:AddSlider("Walkspeed",tonumber(PlayerService.LocalPlayer.Character.Humanoid.WalkSpeed),0,100,function(value)
        LocalMods.WalkSpeed = value
    end)

    Local:AddSlider("JumpPower",tonumber(PlayerService.LocalPlayer.Character.Humanoid.JumpPower),0,100,function(value)
        LocalMods.JumpPower = value
    end)

    Local:AddSlider("Field Of View",70,0,120,function(value)
        LocalMods.FieldOfView = value
    end)

    Local:AddToggle("Enable Modifications",false,function(value)
        LocalMods.Enabled = value
    end)

    Local:AddEmpty()

    Local:AddButton("Rejoin Server",function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId,tostring(game.JobId),PlayerService.LocalPlayer)
    end)

    Local:AddButton("Respawn",function()
        Utilities:SetHumanoid("Health",0)
    end)

    --// Visuals \\--
    Visuals:AddToggle("Enable ESP",false,function(value)
        EspLibrary:Toggle(value)
    end)

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Name Tags",false,function(value)
        EspLibrary.Names = value
    end)

    Visuals:AddToggle("Show Distance Info",false,function(value)
        EspLibrary.Distance = value
    end)

    Visuals:AddDropdown("Name Tag Font",{"UI","Monospace","System","Plex"},function(value)
        EspLibrary.Font = Drawing.Fonts[value]
    end,{
        Default = "UI",
        Execute = true
    })

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Boxes",true,function(value)
        EspLibrary.Boxes = value
    end)

    Visuals:AddToggle("Show Tracers",false,function(value)
        EspLibrary.Tracers = value
    end)

    Visuals:AddSlider("Box and Tracer Thickness",1,1,5,function(value)
        EspLibrary.Thickness = value
    end)

    Visuals:AddDropdown("Tracers Foundation",{"Top","Middle","Bottom"},function(value)
        if value == "Top" then
            EspLibrary.AttachShift = 100
        elseif value == "Middle" then
            EspLibrary.AttachShift = 2
        else
            EspLibrary.AttachShift = 1
        end
    end,{
        Default = "Bottom",
        Execute = true
    })

    Visuals:AddEmpty()

    Visuals:AddToggle("Use Team Color",true,function(value)
        EspLibrary.TeamColor = value
    end)

    Visuals:AddToggle("Boxes Face Camera",false,function(value)
        EspLibrary.FaceCamera = value
    end)

    Visuals:AddToggle("Show Team Mates",true,function(value)
        EspLibrary.TeamMates = value
    end)

    Visuals:AddEmpty()

    Visuals:AddColorPicker("ESP Color",Color3.fromRGB(255,65,65),function(value)
        EspLibrary.Color = value
    end)

    --// Auto Farm \\--
    AutoFarm:AddToggle("Auto Blow Bubbles",BubbleConfig.AutoBlowBubbles,function(value)
        BubbleConfig.AutoBlowBubbles = value
    end)

    AutoFarm:AddToggle("Auto Sell Bubbles",BubbleConfig.AutoSellBubbles,function(value)
        BubbleConfig.AutoSellBubbles = value
    end)

    AutoFarm:AddToggle("Auto Claim Daily Rewards",BubbleConfig.AutoClaimDailyRewards,function(value)
        BubbleConfig.AutoClaimDailyRewards = value
    end)

    AutoFarm:AddToggle("Auto Claim Group Rewards",BubbleConfig.AutoClaimGroupRewards,function(value)
        BubbleConfig.AutoClaimGroupRewards = value
    end)

    AutoFarm:AddToggle("Auto Spin Wheel",BubbleConfig.AutoSpinWheel,function(value)
        BubbleConfig.AutoSpinWheel = value
    end)

    AutoFarm:AddToggle("Auto Collect Chest Rewards",BubbleConfig.AutoCollectChestRewards,function(value)
        BubbleConfig.AutoCollectChestRewards = value
    end)

    AutoFarm:AddEmpty()

    AutoFarm:AddLabel("Shard Farm :")

    AutoFarm:AddToggle("Auto Claim Shard Rewards",BubbleConfig.AutoClaimShardRewards,function(value)
        BubbleConfig.AutoClaimShardRewards = value
    end)

    AutoFarm:AddToggle("Auto Start Shard Quest",BubbleConfig.AutoStartShardQuest,function(value)
        BubbleConfig.AutoStartShardQuest = value
    end)    

    AutoFarm:AddDropdown("Shard Quest Type",{"Easy","Medium","Hard"},function(value)
        BubbleConfig.ShardQuestType = value
    end,{
        Default = BubbleConfig.ShardQuestType,
        Execute = true
    })

    AutoFarm:AddEmpty()

    AutoFarm:AddLabel("Drop Farm :")

    AutoFarm:AddToggle("Auto Collect Drops",BubbleConfig.AutoCollectDrops,function(value)
        BubbleConfig.AutoCollectDrops = value
        getgenv().Activate_Path = value
    end)

    AutoFarm:AddSlider("Drop Farm Speed",BubbleConfig.AutoCollectDropSpeed,0,250,function(value)
        BubbleConfig.AutoCollectDropSpeed = value
    end)

    AutoFarm:AddDropdown("Drop Farm Method",{"Tweening","Instant Teleport","Walking"},function(value)
        BubbleConfig.AutoCollectDropsMethod = value
    end,{
        Default = BubbleConfig.AutoCollectDropsMethod,
        Execute = true
    })

    --// Auto Egg \\--
    AutoEgg:AddToggle("Auto Open Egg",BubbleConfig.AutoOpenEgg,function(value)
        BubbleConfig.AutoOpenEgg = value    
    end)

    if Utilities:UserOwnsGamepass(5502695) == true then
        AutoEgg:AddToggle("Auto Multi Open Egg",BubbleConfig.AutoMultiOpenEgg,function(value)
            BubbleConfig.AutoMultiOpenEgg = value    
        end)
    end

    AutoEgg:AddToggle("Enable 2x Hatch Speed",BubbleConfig.Auto2xHatchSpeed,function(value)
        BubbleConfig.Auto2xHatchSpeed = value

        if BubbleConfig.Auto2xHatchSpeed == true and Utilities:UserOwnsGamepass(5582507) == true then
            UI:SendNotification("This won't have any effect since you own the Fast Hatch Gamepass")
        end

        if BubbleConfig.Auto2xHatchSpeed == true then
            ReplicatedStorage.Assets.Modules.Is2xSpeedEnabled.Enabled.Value = true
        else
            ReplicatedStorage.Assets.Modules.Is2xSpeedEnabled.Enabled.Value = false
        end
    end)
    
    AutoEgg:AddEmpty()

    AutoEgg:AddDropdown("Pick a Egg",EggTable,function(value)
        BubbleConfig.EggValue = value
    end,{
        Default = BubbleConfig.EggValue,
        Execute = true
    })

    AutoEgg:AddEmpty()

    AutoEgg:AddLabel("Boost (Just Visuals) Give 1-5 seconds to Load")

    AutoEgg:AddToggle("Enable 2x Luck",BubbleConfig.Enable2xLuck,function(value)
        BubbleConfig.Enable2xLuck = value
    end)

    AutoEgg:AddToggle("Enable 2x Shiny",BubbleConfig.Enable2xShiny,function(value)
        BubbleConfig.Enable2xShiny = value
    end)

    AutoEgg:AddToggle("Enable 2x Mythic",BubbleConfig.Enable2xMythic,function(value)
        BubbleConfig.Enable2xMythic = value
    end)

    --// Miscellaneous \\--
    Miscellaneous:AddButton("Unlock All Islands",function()
        for i,v in pairs(Workspace.FloatingIslands:GetDescendants()) do
            if v.Name == "Collision" then
                Utilities:Teleport(v.CFrame)
                wait(.25)
            end
        end  
    end)

    --// Coroutine \\--
    coroutine.wrap(function() --// Basic Auto Farm Stuff \\--
        while wait(.1) do
            local A,B = pcall(function()
            
                if BubbleConfig.AutoBlowBubbles then
                    Utilities:FireRemote("NetworkRemoteEvent",{"BlowBubble"})
                end

                if BubbleConfig.AutoClaimDailyRewards then
                    Utilities:FireRemote("NetworkRemoteEvent",{"ClaimDailyReward"})
                end

                if BubbleConfig.AutoClaimGroupRewards then
                    Utilities:FireRemote("NetworkRemoteFunction",{"CollectGroupReward"},"InvokeServer")
                end

                if BubbleConfig.AutoSpinWheel then
                    Utilities:FireRemote("NetworkRemoteEvent",{"SpinToWin"})
                end

                if BubbleConfig.AutoClaimShardRewards then
                    Utilities:FireRemote("NetworkRemoteEvent",{"ClaimShardQuestRewad"})
                end

                if BubbleConfig.AutoStartShardQuest then
                    Utilities:FireRemote("NetworkRemoteEvent",{"GetShardQuest",BubbleConfig.ShardQuestType})
                end

                if BubbleConfig.AutoOpenEgg then
                    Utilities:FireRemote("NetworkRemoteEvent",{"PurchaseEgg",BubbleConfig.EggValue})
                end

                if Utilities:UserOwnsGamepass(5502695) == true then
                    if BubbleConfig.AutoMultiOpenEgg then
                        Utilities:FireRemote("NetworkRemoteEvent",{"PurchaseEgg",BubbleConfig.EggValue,"Multi"})
                    end    
                end

            end)
            Utilities:CallResult(A,B)     
        end
    end)()

    coroutine.wrap(function() --// Visuals Boosts \\--
        while wait(.1) do
            if BubbleConfig.Enable2xLuck then
                debug.setupvalue(require(ReplicatedStorage.Assets.Modules.Is2xLuckEnabled), 1, true)
            end

            if BubbleConfig.Enable2xShiny then
                debug.setupvalue(require(ReplicatedStorage.Assets.Modules.Is2xShinyEnabled), 1, true)
            end

            if BubbleConfig.Enable2xMythic then
                debug.setupvalue(require(ReplicatedStorage.Assets.Modules.Is2xMythicEnabled), 1, true)
            end
        end
    end)()

    coroutine.wrap(function() --// Drop Farm \\--
        while wait(.1) do
            if BubbleConfig.AutoCollectDrops then
                local A,B = pcall(function()
                    local Object 
                    local Distance = 100

                    for i,v in pairs(Workspace.Pickups:GetChildren()) do
                        if v ~= nil and v:FindFirstChild("TouchInterest") then
                            if (PlayerService.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= Distance and (PlayerService.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 100 then
                                Object = v
                                Distance = (PlayerService.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude
                            end
                        end
                    end
                    
                    if Object ~= nil and BubbleConfig.AutoCollectDropsMethod == "Tweening" then
                        Utilities:TweenToObject(Object.CFrame,BubbleConfig.AutoCollectDropSpeed,true)
                    end

                    if Object ~= nil and BubbleConfig.AutoCollectDropsMethod == "Instant Teleport" then
                        Utilities:Teleport(Object.CFrame)
                    end

                    if Object ~= nil and BubbleConfig.AutoCollectDropsMethod == "Walking" then
                        Utilities:WalkToObject(Object.CFrame)
                    end
                end)
                Utilities:CallResult(A,B)
            end
        end
    end)()

    coroutine.wrap(function() --// Auto Collect Chest \\--
        while wait(.1) do
            if BubbleConfig.AutoCollectChestRewards then
                local A,B = pcall(function()
                    for i,v in pairs(Workspace.FloatingIslands:GetDescendants()) do
                        if v.Name == "Chest" and v.ClassName == "Model" then
                            if v.Regen.Enabled == false and BubbleConfig.AutoCollectChestRewards then
                                Utilities:FireRemote("NetworkRemoteEvent",{"TeleportToCheckpoint",v.Parent.Name})
                                wait(.5)
                                for RemoteCall = 1,5,1 do
                                    Utilities:FireRemote("NetworkRemoteEvent",{"CollectChestReward",v.Parent.Name})
                                    wait()
                                end
                                wait()
                            end
                        end
                    end
                end)
                Utilities:CallResult(A,B)
            end
        end
    end)()
    
    coroutine.wrap(function() --// Auto Sell Bubbles \\--
        while wait(.1) do
            if BubbleConfig.AutoSellBubbles then
                local BubbleAmount = string.split(PlayerService.LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Bubble.Amount.Text,"/")[1]
                local MaxBubbleAmount = string.split(PlayerService.LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Bubble.Amount.Text,"/")[2]

                if BubbleAmount >= MaxBubbleAmount and BubbleConfig.AutoSellBubbles then
                    for i = 1,5,1 do
                        if BubbleConfig.AutoSellBubbles == false then return end
                        Utilities:Teleport(CFrame.new(45.8346748,11384.292,-273.940369))
                        wait(.1)
                    end

                end

            end
        end
    end)()

end

if CurrentGame == "MM2" then
    --// Declarations \\--
    local Local = UI:AddPage("Local")
    local Visuals = UI:AddPage("Visuals")
    local AutoFarm = UI:AddPage("Auto-Farm")
    local Teleports = UI:AddPage("Teleports")
    local Miscellaneous = UI:AddPage("Miscellaneous")
    
    local LocalMods = {
        WalkSpeed = 16,
        JumpPower = 50,
        FieldOfView = 70,
        Enabled = false
    }

    MurderMysteryConfig = typeof(getgenv().MurderMysteryConfig) == "table" and getgenv().MurderMysteryConfig or {
        CoinFarm = false,
        CoinFarmSpeed = 20,
        CoinFarmMethod = "Tweening",
        CoinFarmPickupDelay = 1,
        AutoDieIfMurderer = false,
        AutoDie = false,
        AutoHide = false,
    }

    --// Functions \\--
    local Connection = RunService.Heartbeat:Connect(function()
        if not PlayerService.LocalPlayer.Character:FindFirstChild("Humanoid") then
            return
        end

        if MurderMysteryConfig.CoinFarm == true and MurderMysteryConfig.CoinFarmMethod == "Tweening" and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Visible == true and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Visible == true and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false then
            PlayerService.LocalPlayer.Character.Humanoid:ChangeState(11)
        end

        if LocalMods.Enabled == true then
            PlayerService.LocalPlayer.Character.Humanoid.WalkSpeed = LocalMods.WalkSpeed
            PlayerService.LocalPlayer.Character.Humanoid.JumpPower = LocalMods.JumpPower
            Workspace.Camera.FieldOfView = LocalMods.FieldOfView
        end

        if LocalMods.Enabled == false then
            PlayerService.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            PlayerService.LocalPlayer.Character.Humanoid.JumpPower = 50
            Workspace.Camera.FieldOfView = 70
        end
    end)

    local function Map()
        return Utilities:FindParentOfObject(Workspace,"CoinContainer")
    end

    local function Container()
        return Utilities:FindParentOfObject(Workspace,"CoinContainer").CoinContainer
    end

    UI:OnDestroyed(function()
        Connection:Disconnect()
        EspLibrary:Toggle(false)
    end)

    --// Local \\--
    Local:AddSlider("Walkspeed",tonumber(PlayerService.LocalPlayer.Character.Humanoid.WalkSpeed),0,100,function(value)
        LocalMods.WalkSpeed = value
    end)

    Local:AddSlider("JumpPower",tonumber(PlayerService.LocalPlayer.Character.Humanoid.JumpPower),0,100,function(value)
        LocalMods.JumpPower = value
    end)

    Local:AddSlider("Field Of View",70,0,120,function(value)
        LocalMods.FieldOfView = value
    end)

    Local:AddToggle("Enable Modifications",false,function(value)
        LocalMods.Enabled = value
    end)

    Local:AddEmpty()

    Local:AddButton("Rejoin Server",function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId,tostring(game.JobId),PlayerService.LocalPlayer)
    end)

    Local:AddButton("Respawn",function()
        Utilities:SetHumanoid("Health",0)
    end)

    --// Visuals \\--
    Visuals:AddToggle("Enable ESP",false,function(value)
        EspLibrary:Toggle(value)
    end)

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Name Tags",false,function(value)
        EspLibrary.Names = value
    end)

    Visuals:AddToggle("Show Distance Info",false,function(value)
        EspLibrary.Distance = value
    end)

    Visuals:AddDropdown("Name Tag Font",{"UI","Monospace","System","Plex"},function(value)
        EspLibrary.Font = Drawing.Fonts[value]
    end)

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Boxes",true,function(value)
        EspLibrary.Boxes = value
    end)

    Visuals:AddToggle("Show Tracers",false,function(value)
        EspLibrary.Tracers = value
    end)

    Visuals:AddSlider("Box and Tracer Thickness",1,1,5,function(value)
        EspLibrary.Thickness = value
    end)

    Visuals:AddDropdown("Tracers Foundation",{"Top","Middle","Bottom"},function(value)
        if value == "Top" then
            EspLibrary.AttachShift = 100
        elseif value == "Middle" then
            EspLibrary.AttachShift = 2
        else
            EspLibrary.AttachShift = 1
        end
    end,{
        Default = "Bottom",
        Execute = true
    })

    Visuals:AddEmpty()

    Visuals:AddToggle("Use Team Color",true,function(value)
        EspLibrary.TeamColor = value
    end)

    Visuals:AddToggle("Boxes Face Camera",false,function(value)
        EspLibrary.FaceCamera = value
    end)

    Visuals:AddToggle("Show Team Mates",true,function(value)
        EspLibrary.TeamMates = value
    end)

    Visuals:AddEmpty()

    Visuals:AddColorPicker("ESP Color",Color3.fromRGB(255,65,65),function(value)
        EspLibrary.Color = value
    end)

    --// Auto Farm \\==
    AutoFarm:AddLabel("Coin Farm :")

    AutoFarm:AddToggle("Coin Farm",MurderMysteryConfig.CoinFarm,function(value)
        MurderMysteryConfig.CoinFarm = value
        getgenv().Activate_Path = value
    end)

    AutoFarm:AddSlider("Coin Farm Tweening Speed",MurderMysteryConfig.CoinFarmSpeed,0,50,function(value)
        MurderMysteryConfig.CoinFarmSpeed = value
    end)

    AutoFarm:AddSlider("Coin Farm After Pickup Delay",MurderMysteryConfig.CoinFarmPickupDelay,0,10,function(value)
        MurderMysteryConfig.CoinFarmPickupDelay = value
    end)

    AutoFarm:AddDropdown("Coin Farm Method",{"Tweening","Instant Teleport","Walking"},function(value)
        MurderMysteryConfig.CoinFarmMethod = value

        if value ~= "Tweening" then
            UI:SendNotification(nil,"This method is currently buggy. If you want the best experience use Tweening")
        end
    end,{
        Default = MurderMysteryConfig.CoinFarmMethod,
        Execute = true
    })

    AutoFarm:AddEmpty()

    AutoFarm:AddToggle("Auto Die If Murderer",MurderMysteryConfig.AutoDieIfMurderer,function(value)
        MurderMysteryConfig.AutoDieIfMurderer = value
    end)

    AutoFarm:AddToggle("Auto Die Once Bag Is Full",MurderMysteryConfig.AutoDie,function(value)
        MurderMysteryConfig.AutoDie = value
    end)

    AutoFarm:AddToggle("Auto Hide Once Bag Is Full",MurderMysteryConfig.AutoHide,function(value)
        MurderMysteryConfig.AutoHide = value
    end)

    Teleports:AddButton("Teleport To Map",function()
        local A,B = pcall(function()
            Utilities:Teleport(Map().Spawns:FindFirstChild("Spawn").CFrame)
        end)
        Utilities:CallResult(A,B)
    end)

    Teleports:AddButton("Teleport to Lobby",function()
        local A,B = pcall(function()
            Utilities:Teleport(CFrame.new(-131.402283, 138.337341, -9.27049732))
        end)
        Utilities:CallResult(A,B)
    end)

    Teleports:AddButton("Teleport to Sheriff",function()
        local A,B = pcall(function()
            Utilities:Teleport(Utilities:GetPlayerWithItem("Gun").Character.HumanoidRootPart.CFrame)
        end)
        Utilities:CallResult(A,B)
    end)

    Teleports:AddButton("Teleport to Murderer",function()
        local A,B = pcall(function()
            Utilities:Teleport(Utilities:GetPlayerWithItem("Knife").Character.HumanoidRootPart.CFrame)
        end)
        Utilities:CallResult(A,B)
    end)

    Teleports:AddPlayerDropdown("Teleport to a Player",function(value)
        Utilities:TeleportToPlayer(value)
    end)

    --// Coroutine \\--
    coroutine.wrap(function()
        while wait(.1) do
            if MurderMysteryConfig.CoinFarm and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Visible == true then
                local A,B = pcall(function()
                    --// Checks \\--
                    if PlayerService.LocalPlayer.Name == Utilities:GetPlayerWithItem("Knife").Name then
                        Utilities:SetHumanoid("Health",0)
                        UI:SendNotification(nil,"You were the Murderer")
                    end
                    
                    if PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Full.Visible == true and MurderMysteryConfig.AutoDie then
                        Utilities:SetHumanoid("Health",0)
                    end

                    if PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Full.Visible == true and MurderMysteryConfig.AutoHide and MurderMysteryConfig.AutoDie == false and PlayerService.LocalPlayer.Character.HumanoidRootPart.CFrame ~= CFrame.new(-139.295319, 132.718155, -62.7025604) then
                        Utilities:Teleport(CFrame.new(-139.295319, 132.718155, -62.7025604))
                    end

                    --// Finding Closest Coin \\--
                    local Object = Container().Coin_Server
                    local Distance = (PlayerService.LocalPlayer.Character.HumanoidRootPart.Position - Object.Coin.Position).Magnitude            
                    
                    for i,v in pairs(Container():GetChildren()) do
                        if v ~= nil and v.Name == "Coin_Server" then
                            if (PlayerService.LocalPlayer.Character.HumanoidRootPart.Position - v.Coin.Position).Magnitude <= Distance then
                                Object = v
                                Distance = (PlayerService.LocalPlayer.Character.HumanoidRootPart.Position - v.Coin.Position).Magnitude
                            end
                        end
                    end

                    --// Farming \\--
                    if Object ~= nil and Object:FindFirstChild("TouchInterest") and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Visible == true and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false and MurderMysteryConfig.CoinFarmMethod == "Tweening" then
                        Utilities:TweenToObject(Object.Coin.CFrame,MurderMysteryConfig.CoinFarmSpeed,true)
                        wait(MurderMysteryConfig.CoinFarmPickupDelay)
                    end

                    if Object ~= nil and Object:FindFirstChild("TouchInterest") and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Visible == true and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false and MurderMysteryConfig.CoinFarmMethod == "Instant Teleport" then
                        Utilities:Teleport(Object.Coin.CFrame)
                        wait(MurderMysteryConfig.CoinFarmPickupDelay)
                    end

                    if Object ~= nil and Object:FindFirstChild("TouchInterest") and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Visible == true and PlayerService.LocalPlayer.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false and MurderMysteryConfig.CoinFarmMethod == "Walking" then
                        Utilities:WalkToObject(Object.Coin.CFrame)
                        wait(MurderMysteryConfig.CoinFarmPickupDelay)
                    end

                end)
                Utilities:CallResult(A,B)
            end
        end
    end)()

end

local Settings = UI:AddPage("UI Settings")
Settings:AddConfig()

UI:SendNotification(nil,"Any Errors/Bugs Occur ? Report it in the #bugs-and-errors channel in the dsc server")
