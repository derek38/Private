local Aimbot = {
    Enabled = false,
    AimPart = "Head",
    TeamCheck = false,
    WallCheck = false,
    FOVCheck = false,
    Sens = 5,
    Circle = false,
    Color = Color3.fromRGB(255,75,75),
    Radius = 50,
    Thickness = 1,
    Key = "MouseButton2"
}

local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Utility.lua"))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Holded = false

local Connection
local EndConnection
local BeganConnection

local PartList = Aimbot.PartList or {"Head","Torso","LeftArm","RightArm"}

local Circle = Utility:Draw("Circle",{
    Radius = Aimbot.Radius,
    Thickness = Aimbot.Thickness,
    Transparency = 1,
    Color = Aimbot.Color  
})

function Aimbot:IsVisible(Position,Part)
    local Params = RaycastParams.new()
    Params.FilterDescendantsInstances = {plr.Character,Part.Parent}
    Params.FilterType = Enum.RaycastFilterType.Blacklist

    local Result = Workspace:Raycast(plr.Character.HumanoidRootPart.Position,(Position - plr.Character.HumanoidRootPart.Position).Unit * (Position - plr.Character.HumanoidRootPart.Position).Magnitude,Params)

    if self.WallCheck == false then
        return true
    end

    if Result ~= nil then
        return false
    end

    return true
end

function Aimbot:Target()
    local Target
    local Distance = math.huge

    local Part = self.AimPart
    local Cursor = UserInputService:GetMouseLocation()

    if Part == "Random" then
        Part = PartList[math.random(#PartList)]
    end

    local Circle_Radius = Circle.Radius
    local Circle_Position = Circle.Position

    for i,v in pairs(Players:GetPlayers()) do
        if v == plr or not v.Character or not v.Character.Humanoid or v.Character.Humanoid.Health == 0 or (self.TeamCheck and v.Team == plr.Team) then continue end

        local part 

        for i,v in pairs(v.Character:GetChildren()) do
            if not v:IsA("BasePart") then continue end

            if string.match(v.Name,Part) then
                part = v
            end
        end

        if not part or self:IsVisible(v.Character[part.Name].Position,v.Character[part.Name]) == false then continue end

        local Vector,Visible = Camera:WorldToViewportPoint(part.Position)
        if not Visible then continue end

        local NewVector = Vector2.new(Vector.x,Vector.y)
        local MouseDistance = (Cursor - NewVector).Magnitude

        if self.FOVCheck then
            local Top = (Circle_Position.Y - Circle_Radius)
            local Bottom = (Circle_Position.Y + Circle_Radius)
            local Left = (Circle_Position.X - Circle_Radius)
            local Right = (Circle_Position.X + Circle_Radius)

            if not ((NewVector.X <= Right and NewVector.X >= Left) and (NewVector.Y <= Bottom and NewVector.Y >= Top)) then
                continue
            end
        end

        if MouseDistance < Distance then
            Distance = MouseDistance
            Target = part
        end
    end

    return Target
end

function Aimbot:Disconnect()
    Circle:Remove()
    Connection:Disconnect()
    EndConnection:Disconnect()
    BeganConnection:Disconnect()
end

BeganConnection = UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode.Name == Aimbot.Key or input.UserInputType.Name == Aimbot.Key then
        Holded = true
    end
end)

EndConnection = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode.Name == Aimbot.Key or input.UserInputType.Name == Aimbot.Key then
        Holded = false
    end
end)

Connection = RunService.RenderStepped:Connect(function()
    Camera = Workspace.CurrentCamera
    
    Circle.Radius = Aimbot.Radius
    Circle.Position = UserInputService:GetMouseLocation()
    Circle.Thickness = Aimbot.Thickness
    Circle.Visible = Aimbot.Circle
    Circle.Color = Aimbot.Color

    if not Aimbot.Enabled or not Holded then
        return
    end

    local A,B = pcall(function()
        local Target = Aimbot:Target()

        local Cursor = UserInputService:GetMouseLocation()
        local Vector,Visible = Camera:WorldToViewportPoint(Target.Position)

        if not Visible then return end
        local TPosition = Vector2.new(Vector.X,Vector.Y)
        local Mag = (TPosition - Cursor)

        mousemoverel(Mag.X / Aimbot.Sens,Mag.Y / Aimbot.Sens)
    end)
end)

return Aimbot
