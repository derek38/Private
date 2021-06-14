--Librarys--
local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Utility.lua"))()
local Visuals = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Visuals.lua"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Aimbot.lua"))()
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Releases/main/UI-%231/Source.lua"))()

--Services--
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

--Variables--
local plr = Players.LocalPlayer

--Starting--
local UI = Module.new("Link Hub | Universal",{
    Style = "Out",
    Information = "Welcome to Link Hub | "..plr.Name
})

UI:OnDestroyed(function()
    Aimbot.Enabled = false
    Aimbot:Disconnect()

    for i,v in pairs(Visuals.Objects) do
        if not v.Remove then continue end
        v:Remove()
    end
end)

local Copy = function(Text)
    if not setclipboard then UI:Notify(nil,("Failed to copy %s | Your exploit doesn't support the setclipboard function"):format(Text)) return end
    setclipboard(Text)
    UI:Notify(nil,("Copied %s to Clipboard"):format(Text))
end

--Config--
local Config = {
    ESP = false,
    Boxes = true,
    Tracers = false,
    NameTags = false,
    NameTagFont = "UI",
    NameTagOffset = 25,
    NameTagTextSize = 18,
    TracerFoundation = "Bottom",
    TracerAndBoxThickness = 1,
    TeamColor = true,
    TeamMates = true,
    FaceCamera = false,
    Information = true,
    Aimbot = false,
    TeamCheck = false,
    WallCheck = false,
    FOVCheck = false,
    ShowCircle = false,
    Radius = 200,
    CircleThickness = 1,
    AimPart = "Head",
    Sensitivity = 5,
    Message = "OK",
    Delay = 0,
    Spam = false,
}

pcall(function()
    Config = HttpService:JSONDecode(readfile("dchUniversal.json"))
end)

local Save = function(Index,Value)
    Config[Index] = Value
    writefile("dchUniversal.json",HttpService:JSONEncode(Config))
end

--Home--
local Home = UI.new("Home",{Visible = true})
Home:AddButton("Developer Discord | derek38#0038",function() Copy("derek38#0038") end)
Home:AddButton("Developer V3rmillion | @derek chan",function() Copy("derek chan") end)
Home:AddButton("Developer Github | github.com/derek38",function() Copy("github.com/derek38") end)

--Aimbot--
local Tab_Aimbot = UI.new("Aimbot")

Tab_Aimbot:AddToggle("Enable Aimbot | Right-Click",Config.Aimbot,function(value)
    Aimbot.Enabled = value
    Save("Aimbot",value)
end)

Tab_Aimbot:AddEmpty()

Tab_Aimbot:AddToggle("Team Check",Config.TeamCheck,function(value)
    Aimbot.TeamCheck = value
    Save("TeamCheck",value)
end)

Tab_Aimbot:AddToggle("Wall/Visiblity Check",Config.WallCheck,function(value)
    Aimbot.WallCheck = value
    Save("WallCheck",value)
end)

Tab_Aimbot:AddToggle("FOV/Circle Check",Config.FOVCheck,function(value)
    Aimbot.FOVCheck = value
    Save("FOVCheck",value)
end)

Tab_Aimbot:AddEmpty()

Tab_Aimbot:AddToggle("Show Circle",Config.ShowCircle,function(value)
    Aimbot.Circle = value
    Save("ShowCircle",value)
end)

Tab_Aimbot:AddSlider("Radius",Config.Radius,0,500,function(value)
    Aimbot.Radius = value
    Save("Radius",value)
end)

Tab_Aimbot:AddSlider("Thickness",Config.CircleThickness,1,15,function(value)
    Aimbot.Thickness = value
    Save("CircleThickness",value)
end)

Tab_Aimbot:AddEmpty()

Tab_Aimbot:AddDropdown("Aim Part",{"Head","Torso","LeftArm","RightArm","Random"},function(value)
    Aimbot.AimPart = value
    Save("AimPart",value)
end,{
    Default = Config.AimPart,
    Execute = true
})

Tab_Aimbot:AddSlider("Sensitivity",Config.Sensitivity,1,10,function(value)
    Aimbot.Sens = value
    Save("Sensitivity",value)
end)

--Visuals--
local Tab_Visuals = UI.new("Visuals")

Tab_Visuals:AddToggle("Enable ESP",Config.ESP,function(value)
    Visuals:Toggle(value)
    Save("ESP",value)
end)

Tab_Visuals:AddEmpty()

Tab_Visuals:AddToggle("Boxes",Config.Boxes,function(value)
    Visuals.Boxes = value
    Save("Boxes",value)
end)

Tab_Visuals:AddToggle("Tracers",Config.Tracers,function(value)
    Visuals.Tracers = value
    Save("Tracers",value)
end)

Tab_Visuals:AddToggle("Name Tags",Config.NameTags,function(value)
    Visuals.Names = value
    Save("NameTags",value)
end)

Tab_Visuals:AddEmpty()

Tab_Visuals:AddDropdown("Name Tag Font",{"UI","Plex","System","Monospace"},function(value)
    Visuals.Font = Drawing.Fonts[value]
    Save("NameTagFont",value)
end,{
    Default = Config.NameTagFont,
    Execute = true
})

Tab_Visuals:AddDropdown("Tracer Foundation",{"Top","Center","Bottom"},function(value)
    if value == "Top" then
        Visuals.AttachShift = 100
    elseif value == "Center" then
        Visuals.AttachShift = 2
    else
        Visuals.AttachShift = 1
    end

    Save("TracerFoundation",value)
end,{
    Default = Config.TracerFoundation,
    Execute = true
}) 

Tab_Visuals:AddEmpty()

Tab_Visuals:AddSlider("Name Tag Text SIze",Config.NameTagTextSize,0,50,function(value)
    Visuals.TextSize = value
    Save("NameTagTextSize",value)
end)

Tab_Visuals:AddSlider("Name Tag Text Offset",Config.NameTagOffset,-50,50,function(value)
    Visuals.Pos = value
    Save("NameTagOffset",value)
end)

Tab_Visuals:AddSlider("Box and Tracer Thickness",Config.TracerAndBoxThickness,1,5,function(value)
    Visuals.Thickness = value
    Save("TracerAndBoxThickness",value)
end)

Tab_Visuals:AddEmpty()

Tab_Visuals:AddToggle("Use Team Color",Config.TeamColor,function(value)
    Visuals.TeamColor = value
    Save("TeamColor",value)
end)

Tab_Visuals:AddToggle("Show Team Mates",Config.TeamMates,function(value)
    Visuals.TeamMates = value
    Save("TeamMates",value)
end)

Tab_Visuals:AddToggle("Boxes Face Your Camera",Config.FaceCamera,function(value)
    Visuals.FaceCamera = value
    Save("FaceCamera",value)
end)

Tab_Visuals:AddToggle("Information | Distance/Health",Config.Information,function(value)
    Visuals.Information = value
    Visuals.Health = value
    Save("Information",value)
end)

--Miscellaneous--
local Tab_Misc = UI.new("Miscellaneous")

Tab_Misc:AddButton("Rejoin Server",function()
    UI:Notify(nil,"Rejoining Server...") wait(.5)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,tostring(game.JobId),plr)
end)

Tab_Misc:AddButton("Join ANOTHER Server / Server-Hop",function()
    UI:Notify(nil,"Server Hoping..",.8)
    wait(1.5)
    UI:Notify(nil,"Finding Server...",1.5)
    wait(1.5)
    Utility:ServerHop()
    wait(1.5)
    UI:Notify(nil,"Failed to ServerHop | Reasons : No Avaible,Full or High Ping Servers")
end)

Tab_Misc:AddEmpty()

Tab_Misc:AddTextBox("Message To Spam",Config.Message,function(value)
    Config.Message = value
    Save("Message",value)
end)

Tab_Misc:AddSlider("Message Spam Delay",Config.Delay,0,5,function(value)
    Config.Delay = value
    Save("Delay",value)
end)

Tab_Misc:AddToggle("Spam Message",Config.Spam,function(value)
    Config.Spam = value
    Save("Spam",value)
end)

--Settings--
UI.new("UI Config"):AddSettings()

UI:Notify(nil,"Successfuly Loaded | Have fun i guess.")

coroutine.wrap(function()
    while wait(3.5) do
        local Messages = {"Welcome to Link Hub | "..plr.Name,"Note : Your Settings Save (ESP Enabled,Aimbot,Boxes .Etc)","Find the source here | github.com/derek38/Releases","My Favorite Food Combination is Rice,Chicken and Egg"}
        local ReturnedModule = UI:ReturnModule()
        if not ReturnedModule then break end

        local msg = Messages[math.random(#Messages)]

        if not string.match(ReturnedModule.Frame.Information.Text,msg) then
            UI:ChangeInformation(msg)
        end
    end
end)()

coroutine.wrap(function()
    while wait(Config.Delay) do
        if Config.Spam then
            Utility:FireRemote("SayMessageRequest",{Config.Message,"All"},game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents)
        end
    end
end)()
