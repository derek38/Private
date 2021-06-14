--@Utility--
local Utility = {Name = "Utility",Debugging = true,Connections = {}}
Utility.__index = Utility

--@Main-Services--
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--@Declarations--
local plr = Players.LocalPlayer
local http_request = (syn and syn.request) or request or http_request

--@Functions--
for i,v in pairs(getconnections(UserInputService.WindowFocusReleased)) do
    v:Disable()
end

for i,v in pairs(getconnections(UserInputService.WindowFocused)) do
    v:Fire()
end

function GetService(Name)
    return game:GetService(Name)
end

function Output(Text,Function)
    warn(("[%s] : %s | Function : %s"):format(Utility.Name,Text,Function))
end

--@Tweening--
function Utility:TweenToObject(Object,Speed,Wait)
    if typeof(Object) ~= "CFrame" and self.Debugging then
        return Output("First Argument has to be a CFrame","TweenToObject")
    end

    local Information = TweenInfo.new((plr.Character.HumanoidRootPart.Position - Object.Position).Magnitude / Speed,Enum.EasingStyle.Sine)
    local Tween = TweenService:Create(plr.Character.HumanoidRootPart,Information,{CFrame = Object})
    Tween:Play()

    if (Wait == true) then
        Tween.Completed:Wait()
    end
end

--@Signals--
function Utility:Connect(Signal,Function)
    local Connection = Signal:Connect(Function)
    table.insert(self.Connections,Connection)
    return Connection
end
