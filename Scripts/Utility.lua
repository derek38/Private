--Your going to see alot of "typeof","and","or" statements. Please don't judge me :c
--Im trying to find a better way of commenting and making my code look better
--Anyways everything is sorted into categorys so find what you need

local Utility = {
    Name = "Utility", --Name Showed when there is a error | Example : "[Utility] : First Argument is nil"
    Debugging = true, --Don't want errors to be printed in the dev console? Turn this to false
    Connections = {}
}

--Vars : Services--
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketPlaceService = game:GetService("MarketplaceService")

--Vars : Miscellaneous--
local plr = Players.LocalPlayer
local RequestFunction = http_request or request or Request or syn.request --Only request functions i know but should be enough--

getgenv().PathBreak = false

if getconnections then
    for i,v in pairs(getconnections(UserInputService.WindowFocusReleased)) do
        v:Disable()
    end
end

--Name : Tweening--
function Utility:Tween(Object,Properties,Duration,Complete,Data,CmpF)
    if Object == nil and self.Debugging then
        return warn(("[%s] : An error occurred !! First Argument is nil"):format(self.Name))
    end

   Properties = typeof(Properties) == "table" and Properties or {}
   Duration = typeof(Duration) == "number" and Duration or 1
   Complete = typeof(Complete) == "boolean" and Complete or false 
   Data = typeof(Data) == "table" and Data or {}
   CmpF = typeof(CmpF) == "function" and CmpF or function() end

   local Tween = TweenService:Create(Object,TweenInfo.new(Duration,unpack(Data)),Properties)
   Tween:Play()

   if Complete == true then
       Tween.Completed:Wait()
   end

   Tween.Completed:Connect(CmpF)
end

function Utility:TweenToObject(Object,Speed,Complete,Data)
    if typeof(Object) ~= "CFrame" and self.Debugging then
        return warn(("[%s] : First Argument has to be a CFrame | Example : workspace.Part.CFrame"):format(self.Name))
    end

    Speed = typeof(Speed) == "number" and Speed or 100
    Complete = typeof(Complete) == "boolean" and Complete or false
    Data = typeof(Data) == "table" and Data or {Enum.EasingStyle.Sine}

    local Tween_Info = TweenInfo.new((plr.Character.HumanoidRootPart.Position - Object.Position).Magnitude / Speed,unpack(Data))
    local Tween = TweenService:Create(plr.Character.HumanoidRootPart,Tween_Info,{CFrame = Object})
    Tween:Play()

    if Complete == true then
        Tween.Completed:Wait()
    end
end

--Name : Instancing--
function Utility:Create(Class,Properties,Children)
    local Object = Instance.new(Class)
    Properties = typeof(Properties) == "table" and Properties or {}
    Children = typeof(Children) == "table" and Children or {}

    pcall(function() Object.BorderSizePixel = 0 end) --Saves alot of time | pcalled because not everything has borders like parts--

    for i,v in pairs(Properties) do
        local Success,Result = pcall(function() Object[i] = v end)  --Just incase i misspelled something--
        self:CallResult(Success,Result)
    end

    for i,v in pairs(Children) do
        v.Parent = Object
    end

    if Object:IsA("ScreenGui") then
        self:Protect_GUI(Object)
    end

    return Object
end

function Utility:Draw(Class,Properties)
    if typeof(Drawing.new) ~= "function" and self.Debugging then
        return warn(("[%s] : Your exploit doesn't support the Drawing Library. Get a better one lul"):format(self.Name))
    end

    local Object = Drawing.new(Class)
    Properties = typeof(Properties) == "table" and Properties or {}

    for i,v in pairs(Properties) do
        local Success,Result = pcall(function() Object[i] = v end) --Explained in self:Create--
        self:CallResult(Success,Result)
    end

    return Object
end

--Name : Player(s) Info--
function Utility:UserOwnGamepass(Gamepass,UserID)
    if typeof(Gamepass) ~= "number" and self.Debugging then
        return warn(("[%s] : First Argument has to be a Number !!"):format(self.Name))    
    end

    UserID = typeof(UserID) == "number" and UserID or plr.UserId

    return MarketPlaceService:UserOwnsGamePassAsync(UserID,Gamepass)
end

function Utility:GetPlayerProfile(UserID)
    UserID = typeof(UserID) == "number" and UserID or plr.UserId
    return Players:GetUserThumbnailAsync(UserID,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size420x420)
end

function Utility:GetPlayerWithItem(Item)
    for i,v in pairs(Players:GetPlayers()) do
        if v.Backpack:FindFirstChild(Item) or v.Character:FindFirstChild(Item) then
            return v
        end
    end
end

--Name : Local--
function Utility:SetHumanoid(Type,Value)
    local Humanoid = plr.Character:FindFirstChildWhichIsA('Humanoid')
    
    if Humanoid then
        Humanoid[Type:gsub(" ","")] = Value
    end
end

function Utility:Teleport(Position)
    plr.Character:FindFirstChild("HumanoidRootPart").CFrame = Position
end

function Utility:TeleportToPlayer(Name)
    local Child = Players:FindFirstChild(Name)
    
    if Child and Child:FindFirstChild("HumanoidRootPart") then
        self:Teleport(Child.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,1))
    elseif self.Debugging then
        warn(("[%s] Couldn't find %s or %s was dead"):format(self.Name,Name,Name))
        self:Teleport(plr.Character.HumanoidRootPart.CFrame)
    end
end

--Name : Enviroment--
function Utility:Load(Url)
    return loadstring(game:HttpGet(Url))()
end

function Utility:SendEmbed(Webhook,Data)
    RequestFunction({
        Url = Webhook,
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(Data),
        Method = "POST"
    })
end

function Utility:ServerHop(GameId)
    GameId = typeof(GameId) == "number" and GameId or game.PlaceId

    for i,v in pairs(HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))).data) do
        if v.playing ~= v.maxPlayers and v.ping < 500 and v.id ~= tostring(game.JobId) then
            TeleportService:TeleportToPlaceInstance(GameId,v.id,plr)
            return
        end
    end

    if self.Debugging then warn(("[%s] : Failed to server hop"):format(self.Name)) end
end

function Utility:Connect(Signal,Function,Name)
    local Connection = Signal:Connect(Function)
    
    if Name then
        self.Connections[Name] = Connection
        return
    end

    table.insert(self.Connections,Connection)

    return Connection
end

function Utility:Disconnect(Name)
    if Name then
        self.Connections[Name]:Disconnect()
        return
    end

    for i,v in pairs(self.Connections) do
        v:Disconnect()
    end
end

--Name : Scripting--
function Utility:FireRemote(Name,Arguments,Parent)
    Name = typeof(Name) == "string" and Name or ""
    Arguments = typeof(Arguments) == "table" and Arguments or {}
    Parent = typeof(Parent) == "Instance" and Parent or ReplicatedStorage
    
    local Remote = Parent:FindFirstChild(Name)

    if Remote:IsA("RemoteEvent") then
        Parent[Name]:FireServer(unpack(Arguments))
    elseif Remote:IsA("RemoteFunction") then
        Parent[Name]:InvokeServer(unpack(Arguments))
    end
end

function Utility:FindParentOfObject(Parent,Object)
    Parent = typeof(Parent) == "Instance" and Parent or Workspace

    for i,v in pairs(Parent:GetChildren()) do
        if v:FindFirstChild(Object) then
            return v
        end
    end

    return Parent
end

--Name : Path Finding--
function Utility:GetPathWaypoints(Object)
    local Path = game:GetService("PathfindingService"):CreatePath()
    Path:ComputeAsync(plr.Character.HumanoidRootPart.Position,Object.Position)
    return Path:GetWaypoints()
end

function Utility:WalkToObject(Object)
    if typeof(Object) ~= "CFrame" then
        return warn(("[%s] First Argument has to be a CFrame | Example : workspace.Part.CFrame"):format(self.Name))
    end

    local Lop = Utility:GetPathWaypoints(Object)
    local Distance
    
    for i,v in pairs(Lop) do
        plr.Character:FindFirstChildWhichIsA("Humanoid"):MoveTo(v.Position)

        if v.Action == Enum.PathWaypointAction.Jump then
            plr.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end

        repeat
            if not plr.Character or plr.Character.Humanoid.Health == 0 or PathBreak == true then break end
            plr.Character:FindFirstChildWhichIsA("Humanoid"):MoveTo(v.Position)
            Distance = (v.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            wait()
        until Distance <= 5 or not plr.Character or not plr.Character.Humanoid or PathBreak == true
    end
end

--Name : Interface--
function Utility:OnMouseClick(Object,Callback)
    Object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Callback()
        end
    end)
end

function Utility:SmoothTextChange(Object,Text,Transparency,Speed)
    Speed = Speed or .2

    Utility:Tween(Object,{TextTransparency = 1},Speed,false,{},function()
        Utility:Tween(Object,{TextTransparency = Transparency},Speed)
        Object.Text = Text
    end)
end

function Utility:Protect_GUI(ScreenGui)
    if not ScreenGui:IsA("ScreenGui") then
        return warn(("[%s] : First Argument has to be a ScreenGui !!"):format(self.Name))
    end

    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    elseif getexecutorname and gethui  then
        ScreenGui.Parent = gethui()
    elseif get_hidden_gui then
        ScreenGui.Parent = get_hidden_gui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
        if self.Debugging then warn(("[%s] Couldn't Protect %s | Your Exploit doesn't support a protect gui function"):format(self.Name,ScreenGui.Name)) end
    end
end

function Utility:Dragify(Frame,speed)
    local dragToggle = nil
    local dragSpeed = speed or 1
    local dragInput = nil
    local dragStart = nil
    local dragPos = nil
    
    local function updateInput(input)
        local Delta = input.Position - dragStart
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        TweenService:Create(Frame, TweenInfo.new(dragSpeed), {Position = Position}):Play()
    end
    
    Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if (input.UserInputState == Enum.UserInputState.End) then
                    dragToggle = false
                end
            end)
            
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if (input == dragInput and dragToggle) then
            updateInput(input)
        end
    end)
end

--Name : Tables--
function Utility:Find(Table,Value)
    for i,v in pairs(Table) do
        if v == Value then
            return i
        end
    end
end

function Utility:Insert(Parent,Table,Value)
    if typeof(Parent) ~= "Instance" and self.Debugging then
        return warn(("[%s] : First argument has to be a instance !!"):format(self.Name))
    end

    Table = typeof(Table) == "table" and Table or {}
    Value = typeof(Value) == "string" and Value or "Name"
    
    for i,v in pairs(Parent:GetChildren()) do
        if table.find(Table,v.Name) then continue end

        if Value == "Name" then
            table.insert(Table,v.Name)    
        elseif Value == "Object" then
            table.insert(Table,v)
        end
    end

    table.sort(Table)

    return Table
end

--Name : Notifications--
function Utility:Kick(Msg,User)
    Msg = Msg or "Lop Lul"
    User = User or plr

    User:Kick("\n "..Msg)
end

function Utility:Notify(Type,Properties)
    Type = typeof(Type) == "string" and Type or "SendNotification"
    Properties = typeof(Properties) == "table" and Properties or {Title = self.Name}

    game:GetService("StarterGui"):SetCore(Type,Properties)
end

--Name : Debugging--
function Utility:CallResult(Success,Result)
    if Success == false then
        warn(("[%s] : %s"):format(self.Name,Result))
    end
end

-- () --

return Utility
