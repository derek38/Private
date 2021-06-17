-- Felt like remaking so yeah
-- Not done yet though

--@Utility--
local Utility = {Name = "Utility"}
Utility.__index = Utility

--@Main-Services--
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--@Declarations--
local plr = Players.LocalPlayer
local ReGuest = (syn and syn.request) or http_request or request --Should be enough--

local Output = function(Text)
    warn(("[%s] : %s"):format(Utility.Name,Text))
end

--@Tweening--
function Utility:TweenToObject(Object,Duration,WaitUntilCompleted)
    if typeof(Object) ~= "CFrame"  then
        return Output(("First argument has to be a CFrame, not %s | TweenToObject"):format(typeof(Object)))
    end

    local Information = TweenInfo.new((plr.Character:FindFirstChild("HumanoidRootPart").Position - Object.Position).Magnitude/Duration,Enum.EasingStyle.Sine)
    local Tween = TweenService:Create(plr.Character:FindFirstChild("HumanoidRootPart"),Information,{CFrame = Object})
    Tween:Play()

    if WaitUntilCompleted == true then
       Tween.Completed:Wait()
    end

    return Tween
end

function Utility:Tween(Object,Properties,Duration,WaitUntilCompleted)
    local Tween = TweenService:Create(Object,TweenInfo.new(Duration),Properties)
    Tween:Play()

    if WaitUntilCompleted == true then
        Tween.Completed:Wait()
    end

    return Tween
end

--@Instancing--
function Utility:Create(Class,Properties,Children)
    local Object = Instance.new(Class)
    pcall(function() Object.BorderSizePixel = 0 end)

    for i,v in pairs(Properties or {}) do
        local A,B = pcall(function() Object[i] = v end)
        Utility:CallResult(A,B)
    end

    for i,v in pairs(Children or {}) do
        v.Parent = Object
    end

    return Object
end

--@Debugging--
function Utility:CallResult(Success,Result)
    if not Success then
        Output(Result)
    end
end

return Utility
