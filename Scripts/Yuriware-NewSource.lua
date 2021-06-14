--Ignore--
repeat
    wait()
until game:IsLoaded()

--Librarys--
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Interface.lua"))()
local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Utility.lua"))()
local EspLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Visuals.lua"))()
local AimbotLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Aimbot.lua"))()

getgenv().ErrorMessage = Utility.File.Name

--Services--
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HTTPService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Miscellaneous--
local Self = Players.LocalPlayer

--Support--
local ExploitUsed = "Unknown"
local CurrentGame = "Universal"

if syn and syn.protect_gui and typeof(Drawing.new) == "function" then
    ExploitUsed = "Synapse-X"
elseif getexecutorname and typeof(Drawing.new) == "function" then
    ExploitUsed = "Script-ware"
elseif KRNL_LOADED and typeof(Drawing.new) == "function" then
    ExploitUsed = "Krnl"
elseif is_fluxus_closure and typeof(Drawing.new) == "function" then
    ExploitUsed = "Fluxus"
else
    return Utility:Kick("["..Utility.File.Name.." : Error] \n Your exploit/executor is not supported. Check in the discord server to see the 4 supported exploits/executors")
end

local SupportedGames = {
    ["MurderMystery2"] = 142823291
}

local TryToFindGameID = Utility:Find(SupportedGames,game.PlaceId)

if TryToFindGameID then
    CurrentGame = TryToFindGameID
end

local UI = Module.new(Utility.File.Name,{
    Themes = getgenv().Themes,
    Execute = "True"
})

local Home = UI.new("Home",{
    Visible = true
})

Home:AddCredits()

if CurrentGame == "Universal" then
    --Declarations--
    local Aimbot = UI.new("Aimbot")
    local Visuals = UI.new("Visuals")
    local Miscellaneous = UI.new("Miscellaneous")

    --Functions--
    UI:OnDestroyed(function()
        EspLib:Toggle(false)
        AimbotLib:Disconnect()
    end)

    --Aimbot--
    Aimbot:AddToggle("Enable Aimbot | Hold Right Click",false,function(value)
        AimbotLib:Toggle(value)
    end)

    Aimbot:AddEmpty()

    Aimbot:AddToggle("Team Check",false,function(value)
        AimbotLib.TeamCheck = value
    end)

    Aimbot:AddToggle("Visibility Check",false,function(value)
        AimbotLib.WallCheck = value
    end)

    Aimbot:AddToggle("Check If Player Is In FOV",false,function(value)
        AimbotLib.UseCircleRadius = value
    end)

    Aimbot:AddEmpty()

    Aimbot:AddToggle("Show Circle",false,function(value)
        AimbotLib.Circle = value
    end)

    Aimbot:AddSlider("Circle Radius",150,0,250,function(value)
        AimbotLib.CircleRadius = value
    end)

    Aimbot:AddSlider("Circle Thickness",1,0,5,function(value)
        AimbotLib.CircleThickness = value
    end)

    Aimbot:AddEmpty()

    Aimbot:AddDropdown("Aim Part",{"Head","UpperTorso","LowerTorso","LeftHand","RightHand","Random"},function(value)
        if value ~= "Random" then
            AimbotLib.Random = false
            AimbotLib.AimPart = value
        end

        if value == "Random" then
            AimbotLib.Random = true
        end
    end,{
        Default = "Head",
        Execute = true
    })

    Aimbot:AddSlider("Smoothness (The lower the more legit)",5,0,10,function(value)
        AimbotLib.Smoothness = value / 10
    end)

    --Visuals--
    Visuals:AddToggle("Enable ESP",false,function(value)
        EspLib:Toggle(value)
    end)

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Names",false,function(value)
        EspLib.Names = value    
    end)

    Visuals:AddToggle("Show Distance",false,function(value)
        EspLib.Distance = value
    end)

    Visuals:AddDropdown("Name Font",{"UI","System","Plex","Monospace"},function(value)
        EspLib.Font = Drawing.Fonts[value]
    end,{
        Default = "UI",
        Execute = true
    })

    Visuals:AddEmpty()

    Visuals:AddToggle("Show Boxes",true,function(value)
        EspLib.Boxes = value
    end)

    Visuals:AddToggle("Show Tracers",false,function(value)
        EspLib.Tracers = value
    end)

    Visuals:AddSlider("Box and Tracer Thickness",1,0,5,function(value)
        EspLib.Thickness = value
    end)

    Visuals:AddDropdown("Tracer Foundation",{"Top","Middle","Bottom"},function(value)
        if value == "Top" then
            EspLib.AttachShift = 100
        elseif value == "Middle" then
            EspLib.AttachShift = 2
        else
            EspLib.AttachShift = 1
        end
    end,{
        Default = "Bottom",
        Execute = true
    })

    Visuals:AddEmpty()

    Visuals:AddToggle("Use Team Color",false,function(value)
        EspLib.TeamColor = value
    end)

    Visuals:AddToggle("Make Boxes Face Your Camera",false,function(value)
        EspLib.FaceCamera = value
    end)

    Visuals:AddToggle("Show Team Mates",true,function(value)
        EspLib.TeamMates = value
    end)

    --Miscellaneous--
    Miscellaneous:AddButton("Rejoin Game",function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,tostring(game.JobId),Self)
    end)

    Miscellaneous:AddTextBox("Send Notification","Text",function(value)
        UI:Notify(nil,value,2)
    end)

end

if CurrentGame == "MurderMystery2" then
    --Declarations--
    local Local = UI.new("Local")
    local Visuals = UI.new("Visuals")
    local AutoFarm = UI.new("Auto-Farm")
    local Teleports = UI.new("Teleports")
    local Notifier = UI.new("Notifier/Webhook")

    local TotalAmountOfExp = 0
    local TotalAmountOfCoins = 0

    local Config = {
        WalkSpeed = 16,
        JumpPower = 50,
        FieldOfView = 70,
        CoinFarm = false,
        FarmSpeed = 20,
        FarmDelay = 1,
        FarmMethod = "Tweening",
        FarmAutoDie = false,
        FarmAutoHide = false,
        FarmServerHop = false,
        Webhook = "",
        RequestEnabled = false,
    }

    pcall(function()
        Config = HTTPService:JSONDecode(readfile("chMM2.json"))
    end)    

    --Functions--
    local function Save(Info)
        for i,v in pairs(Info) do
            Config[i] = v
        end

        writefile("chMM2.json",HTTPService:JSONEncode(Config))
    end

    local function SendWebhook()
        Utility:SendEmbed(Config.Webhook,{
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = Utility.File.Name.." | Murder Mystery 2",
                ["description"] = "Reasons This Message Was Sent : \n ```[+] Auto Die Was Enabled \n [+] Auto Hide Was Enabled \n [+] Or The Round Ended\n```",
                ["color"] = tonumber(0xFF4141),
                ["fields"] = {
                    {
                        ["name"] = "Farm Information :",
                        ["value"] = "Total Amount Of **Coins** Earned `"..TotalAmountOfCoins.."` \n Total Amount Of **Exp** Earned `"..TotalAmountOfExp.."`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Miscellaneous",
                        ["value"] = "New/Current Level `"..Self.PlayerGui.Scoreboard.Classic.Container.LevelUp.Level.Level.LevelText.Text.."` \n Current Coins In Inventory `"..Self.PlayerGui.MainGUI.Game.Shop.Title.Coins.Container.Amount.Text.."` ",
                        ["inline"] = true
                    }
                }
    
            }}
        })
    end

    local Connection = RunService.Heartbeat:Connect(function()
        if not Self.Character or not Self.Character.Humanoid then
            return
        end

        Utility:SetHumanoid("WalkSpeed",Config.WalkSpeed)
        Utility:SetHumanoid("JumpPower",Config.JumpPower)
        Workspace.Camera.FieldOfView = Config.FieldOfView
    end)

    local function FindMap()
        return Utility:FindParentOfObject(Workspace,"CoinContainer")
    end

    local function Container()
        return Utility:FindParentOfObject(Workspace,"CoinContainer").CoinContainer
    end

    UI:OnDestroyed(function()
        EspLib:Disconnect()
        AimbotLib:Disconnect()
        Connection:Disconnect()
    end)

    --Visuals--
    Visuals:AddToggle("Enable ESP")

    --Local--
    Local:AddSlider("Walk Speed",16,0,100,function(value)
        Save({WalkSpeed = value})
    end)

    Local:AddSlider("Jump Power",50,0,150,function(value)
        Save({JumpPower = value})
    end)

    Local:AddSlider("Field Of View",70,0,120,function(value)
        Save({FieldOfView = value})
    end)

    Local:AddEmpty()

    Local:AddButton("Rejoin Server",function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId,tostring(game.JobId),Self)
    end)

    Local:AddButton("Respawn",function()
        Utility:SetHumanoid("Health",0)
    end)

    --AutoFarm--
    AutoFarm:AddLabel("Farming :")

    AutoFarm:AddToggle("Coin Farm",Config.CoinFarm,function(value)
        Save({CoinFarm = value})
    end)

    AutoFarm:AddSlider("Coin Farm Speed",Config.FarmSpeed,0,45,function(value)
        Save({FarmSpeed = value})
    end)

    AutoFarm:AddSlider("Coin Farm Pickup Delay",Config.FarmDelay,0,5,function(value)
        Save({FarmDelay = value})
    end)

    AutoFarm:AddDropdown("Coin Farm Method",{"Tweening","Walking","Instant Teleport"},function(value)
        Save({FarmMethod = value})
    end,{
        Default = Config.FarmMethod
    })

    AutoFarm:AddEmpty()

    AutoFarm:AddLabel("Bag Full Functions :")

    AutoFarm:AddToggle("Auto Die",Config.FarmAutoDie,function(value)
        Save({FarmAutoDie = value})
    end)

    AutoFarm:AddToggle("Auto Hide",Config.FarmAutoHide,function(value)
        Save({FarmAutoHide = value})
    end)

    AutoFarm:AddToggle("Server Hop",Config.FarmServerHop,function(value)
        Save({FarmServerHop = value})
    end)

    --Teleports--
    Teleports:AddButton("Teleport To Map",function()
        local A,B = pcall(function()
            Utility:Teleport(FindMap().Spawns:FindFirstChild("Spawn").CFrame)
        end)
        Utility:CallResult(A,B)
    end)

    Teleports:AddButton("Teleport to Lobby",function()
        local A,B = pcall(function()
            Utility:Teleport(CFrame.new(-131.402283, 138.337341, -9.27049732))
        end)
        Utility:CallResult(A,B)
    end)

    Teleports:AddButton("Teleport to Sheriff",function()
        local A,B = pcall(function()
            Utility:Teleport(Utility:GetPlayerWithItem("Gun").Character.HumanoidRootPart.CFrame)
        end)
        Utility:CallResult(A,B)
    end)

    Teleports:AddButton("Teleport to Murderer",function()
        local A,B = pcall(function()
            Utility:Teleport(Utility:GetPlayerWithItem("Knife").Character.HumanoidRootPart.CFrame)
        end)
        Utility:CallResult(A,B)
    end)

    --Notifier/Webhook--
    Notifier:AddTextBox("Webhook Here",Config.Webhook,function(value)
        Save({Webhook = value})    
    end)
    
    Notifier:AddToggle("Enable Notifier",Config.RequestEnabled,function(value)
        Save({RequestEnabled = value})
    end)

    Notifier:AddButton("Send Embed Message",function()
        SendWebhook()
    end)

    Notifier:AddEmpty(10)

    Notifier:AddLabel("This is what the Notifier Does :")
    Notifier:AddLabel("[1] Sends a Embed Message When Collected All The Coins Possible")
    Notifier:AddLabel("[3] Sends a Embed Message When One Of The Bag Full Functions Is On")
    Notifier:AddLabel("[2] Sends a Embed Message When Your ServerHop/Leave The Game With The Total Amount Of Coins You Made")

    --Coroutine--
    coroutine.wrap(function()
        while wait(.1) do
            if Config.CoinFarm == true and Self.PlayerGui.MainGUI.Game.CashBag.Visible == true and Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false then
                local Success,Result = pcall(function()
                    --Checks--
                    if Config.FarmServerHop and Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == true then
                        if ExploitUsed == "Synapse-X" then
                            Utility:ServerHop(142823291,11)
                            return Utility:Error("Server Hopping...")
                        else
                            UI:Notify("Error","Attempted To Use Server Hop Option When Exploit Is Not Synapse-X")
                        end
                    end

                    if Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == true then
                        TotalAmountOfCoins = 0
                    end   

                    if Config.FarmAutoHide and Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == true then
                        Utility:Teleport(CFrame.new(-139.295319, 132.718155, -62.7025604))
                    end    

                    if Config.FarmAutoDie and Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == true then
                        Utility:SetHumanoid("Health",0)
                    end    

                    --Finding Coin--
                    print("Finding Coin...")

                    local Object = Container().Coin_Server
                    local Distance = (Self.Character.HumanoidRootPart.Position - Object.Coin.Position).Magnitude

                    for i,v in pairs(Container():GetChildren()) do
                        if v ~= nil and v.Name == "Coin_Server" and v:FindFirstChild("Coin") then
                            if (Self.Character.HumanoidRootPart.Position - v.Coin.Position).Magnitude <= Distance then
                                Object = v
                                Distance = (Self.Character.HumanoidRootPart.Position - v.Coin.Position).Magnitude
                            end
                        end
                    end
                    
                    print("Collecting Coin...")

                    --Farming--
                    if Object ~= nil and Object:FindFirstChild("TouchInterest") and Config.FarmMethod == "Tweening" and Self.PlayerGui.MainGUI.Game.CashBag.Visible == true and Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false then
                        Utility:TweenToObject(Object.Coin.CFrame,Config.FarmSpeed,true)
                        wait(Config.FarmDelay - .2)
                    end

                    if Object ~= nil and Object:FindFirstChild("TouchInterest") and Config.FarmMethod == "Instant Teleport" and Self.PlayerGui.MainGUI.Game.CashBag.Visible == true and Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false then
                        Utility:Teleport(Object.Coin.CFrame)
                        wait(Config.FarmDelay - .2)
                    end

                    if Object ~= nil and Object:FindFirstChild("TouchInterest") and Config.FarmMethod == "Walking" and Self.PlayerGui.MainGUI.Game.CashBag.Visible == true and Self.PlayerGui.MainGUI.Game.CashBag.Full.Visible == false then
                        Utility:WalkToObject(Object.Coin.CFrame)
                        wait(Config.FarmDelay - .2)
                    end

                    print("Finding Another Coin...")
                end)

                Utility:CallResult(Success,Result)
            end
        end    
    end)()

end

local Settings = UI.new("Settings")

Settings:AddConfig()

print("Made by derek38")

if ExploitUsed == "Synapse-X" then
    syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/derek38/Kuchel/main/File.lua'))()")
end
