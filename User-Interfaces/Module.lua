local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/derek38/Modules/main/Utility.lua"))()

local CoreGui = game:GetService("CoreGui")
local PlayerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--Functions--
for i,v in pairs(CoreGui:GetChildren()) do
    if v.Name == "" then
        v:Destroy()
    end
end

local Module = {}

function Module.new(Title,Properties)
    Title = typeof(Title) == "string" and Title or "Module"
    Properties = typeof(Properties) == "table" and Properties or {}

    Properties.Font = typeof(Properties.Font) == "EnumItem" and Properties.Font or Enum.Font.Gotham
    Properties.Style = typeof(Properties.Style) == "string" and Properties.Style or "In"
    Properties.Information = typeof(Properties.Information) == "string" and Properties.Information or typeof(Properties.Information) == "number" and Properties.Information or ("Welcome, %s"):format(PlayerService.LocalPlayer.Name)
    Properties.TextSize = typeof(Properties.TextSize) == "number" and Properties.TextSize or 15
    Properties.Execute = typeof(Properties.Execute) == "string" and Properties.Execute or "True"

    local Themes = typeof(Properties.Themes) == "table" and Properties.Themes or {}

    setmetatable(Themes,{__index = {TextColor = Color3.fromRGB(255,255,255),DarkColor = Color3.fromRGB(24,24,24),LightColor = Color3.fromRGB(27,27,27)}})

    local ScreenGui = Utility:Create("ScreenGui",{ --Auto Protects | Check the Utility:Create in the source to find out howt--
        Name = "",
        ResetOnSpawn = false
    })

    local Frame = Utility:Create("Frame",{
        Name = "Frame",
        Parent = ScreenGui,
        Size = UDim2.new(0,0,0,385),
        Position = UDim2.new(.3,0,.2,0),
        AnchorPoint = Vector2.new(.5,.5),
        BackgroundColor3 = Themes.DarkColor,
        ClipsDescendants = true
    },{
        Utility:Create("UICorner",{
            CornerRadius = UDim.new(0,4)
        }),
        Utility:Create("UIScale")
    })

    local Container = Utility:Create("Frame",{
        Name = "Container",
        Parent = Frame,
        Size = UDim2.new(0,0,0,385),
        BackgroundColor3 = Themes.LightColor,
        ClipsDescendants = true
    },{
        Utility:Create("UICorner",{
            CornerRadius = UDim.new(0,4)
        })
    })

    local TitleX = Utility:Create("TextLabel",{
        Name = "Title",
        Parent = Container,
        Size = UDim2.new(1,0,0,50),
        Position = UDim2.new(0,0,.036,0),
        Font = Properties.Font,
        Text = "   "..tostring(Title),
        TextSize = Properties.TextSize,
        TextColor3 = Themes.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = math.random(1,1),
        BackgroundTransparency = math.random(1,1),
        ClipsDescendants = true
    })

    local InformationX = Utility:Create("TextLabel",{
        Name = "Information",
        Parent = Frame,
        Size = UDim2.new(0,403,0,39),
        Position = UDim2.new(.305,0,.018,0),
        Font = Properties.Font,
        Text = "   "..tostring(Properties.Information),
        TextSize = math.clamp(Properties.TextSize - 1,10,20),
        TextColor3 = Themes.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = math.random(1,1),
        BackgroundTransparency = math.random(1,1),
        ClipsDescendants = true

    })

    local TabContainer = Utility:Create("ScrollingFrame",{
        Name = "Tabs",
        Parent = Container,
        Size = UDim2.new(1,0,.534,100),
        Position = UDim2.new(0,0,.206,0),
        CanvasSize = UDim2.new(0,0,0,1),
        ScrollBarThickness = math.random(0,0),
        BackgroundTransparency = math.random(1,1) 
    },{
        Utility:Create("UIListLayout",{
            Padding = UDim.new(0,8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
    })

    local PageContainer = Utility:Create("Frame",{
        Name = "PageContainer",
        Parent = Frame,
        Size = UDim2.new(0,403,0,0),
        Position = UDim2.new(.305,0,.138,0),
        BackgroundColor3 = Themes.LightColor,
        ClipsDescendants = true,
    },{
        Utility:Create("UICorner",{
            CornerRadius = UDim.new(0,4)
        }),
        Utility:Create("Folder")
    })

    --Loading Animations--
    Utility:Tween(Frame,{Size = UDim2.new(0,596,0,385)},1,true) 
    Utility:Tween(Container,{Size = UDim2.new(0,174,0,385)},.5,true)
    Utility:Tween(PageContainer,{Size = UDim2.new(0,403,0,322)},.5,true)
    Utility:Tween(TitleX,{TextTransparency = 0},.5)
    Utility:Tween(InformationX,{TextTransparency = 0},.5)

    --Miscellaneous--
    local Toggling = false

    if Properties.Style == "In" then
        TitleX.Text = tostring(Title)
        TitleX.TextXAlignment = Enum.TextXAlignment.Center

        InformationX.Text = tostring(Properties.Information)
        InformationX.TextXAlignment = Enum.TextXAlignment.Center
    end

    Utility:Dragify(Frame,.1)
    
    TabContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0,0,0,TabContainer.UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    local Functions = {}

    function Functions:Toggle()
        if Toggling then
            return
        end

        Toggling = true

        if Frame.Size == UDim2.new(0,0,0,385) then
            Utility:Tween(Frame,{Size = UDim2.new(0,596,0,385)},.5,true)
            Utility:Tween(Container,{Size = UDim2.new(0,174,0,385)},.5)
            Utility:Tween(PageContainer,{Size = UDim2.new(0,403,0,322)},.5)
            Utility:Tween(Container.Title,{TextTransparency = 0},3)
            Utility:Tween(InformationX,{TextTransparency = 0},3)
            TabContainer.Visible = true
        else
            Utility:Tween(InformationX,{TextTransparency = 1},.2)
            Utility:Tween(Container.Title,{TextTransparency = 1},.2)
            TabContainer.Visible = false
            Utility:Tween(Container,{Size = UDim2.new(0,0,0,384)},.5)
            Utility:Tween(PageContainer,{Size = UDim2.new(0,403,0,0)},.5,true)
            Utility:Tween(Frame,{Size = UDim2.new(0,0,0,385)},.5,true)
        end

        Toggling = false
    end

    function Functions:Destroy()
        Frame:ClearAllChildren()
        Utility:Tween(Frame,{Size = UDim2.new(0,55,0,385)},.5,true)
        Utility:Tween(Frame,{Size = UDim2.new(0,55,0,50)},.5,true)
        Utility:Tween(Frame,{Size = UDim2.new(0,0,0,50)},.5,true)
        ScreenGui:Destroy()
    end

    function Functions:ReturnModule()
        return ScreenGui
    end

    function Functions:OnDestroyed(Function)
        Function = typeof(Function) == "function" and Function or function() end

        local Event
        
        Event = ScreenGui.Parent.ChildRemoved:Connect(function(Object)
            if Object == ScreenGui then
                Function()
                Event:Disconnect()
            end
        end)
    end

    function Functions:SelectPage(name)
        for i,v in pairs(PageContainer.Folder:GetChildren()) do
            if v.Name == name then
                v.Visible = true
                Utility:Tween(v,{CanvasPosition = Vector2.new(0,0)},.25)
            else
                v.Visible = false
            end
        end

        for i,v in pairs(TabContainer:GetChildren()) do
            if v:IsA("TextButton") then
                if v.Name == name then
                    Utility:Tween(v,{TextTransparency = 0},.5)
                else
                    Utility:Tween(v,{TextTransparency = .5},.5)
                end
            end
        end

    end

    function Functions:ChangeTitle(TitleE)
        Title = TitleE
        Utility:SmoothTextChange(TitleX,TitleE,0)
    end

    function Functions:ChangeInformation(Text)
        Properties.Information = Text
        Utility:SmoothTextChange(InformationX,Text,0)
    end

    function Functions:Notify(TitleE,Text,Duration)
        TitleE = typeof(TitleE) == "string" and TitleE or Title
        Text = typeof(Text) == "string" and Text or "Hi, nothing was placed for the Text argument" 
        Duration = tonumber(Duration) or 5

        for i,v in pairs(ScreenGui:GetChildren()) do
            if v.Name == "Notification" then
                Utility:Tween(v,{Position = UDim2.new(1,0,.883,0)},.4)
            end
        end

        local Notification = Utility:Create("Frame",{
            Name = "Notification",
            Parent = ScreenGui,
            Size = UDim2.new(.275,0,.091,0),
            Position = UDim2.new(1,0,.883,0),
            BackgroundColor3 = Themes.LightColor,
            ClipsDescendants = true
        },{
            Utility:Create("UICorner",{
                CornerRadius = UDim.new(.05,0)
            }),
            Utility:Create("TextLabel",{
                Name = "Title",
                Size = UDim2.new(1,0,.513,0),
                Font = Properties.Font,
                Text = "",
                TextSize = 14,
                TextColor3 = Themes.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = math.random(1,1),
                BackgroundTransparency = math.random(1,1),
                ClipsDescendants = true
            }),
            Utility:Create("TextLabel",{
                Name = "TextInfo",
                Size = UDim2.new(.968,0,.487,0),
                Position = UDim2.new(.032,0,.513,0),
                Font = Properties.Font,
                Text = "",
                TextSize = 13,
                TextColor3 = Themes.TextColor,
                TextWrapped = true,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = math.random(.5,.5),
                BackgroundTransparency = math.random(1,1),
                ClipsDescendants = true
            })
        })

        --Loading Animations--
        Utility:Tween(Notification,{Position = UDim2.new(.709,0,.883,0)},.2,false,{},function()
            Utility:SmoothTextChange(Notification.Title,"   "..TitleE,0,.08)
            Utility:SmoothTextChange(Notification.TextInfo,Text,.5,.08)
        end)

        --Functions--
        Utility:OnMouseClick(Notification,function()
            Utility:Tween(Notification,{Position = UDim2.new(1,0,.883,0)},.5,true)
            Notification:Destroy()
        end)

        coroutine.wrap(function()
            wait(Duration - .2)

            if Notification == nil then return end

            Utility:Tween(Notification,{Position = UDim2.new(1,0,.883,0)},1,true)
            Notification:Destroy()
        end)()
    end

    function Functions.new(PageName,PageProperties)
        PageName = typeof(PageName) == "string" and PageName or "Home"
        PageProperties = typeof(PageProperties) == "table" and PageProperties or {}

        local Page = Utility:Create("ScrollingFrame",{
            Name = PageName,
            Parent = PageContainer.Folder,
            Size = UDim2.new(1,0,.966,0),
            Position = UDim2.new(0,0,.034,0),
            CanvasSize = UDim2.new(0,0,0,1),
            ScrollBarThickness = tonumber(PageProperties.ScrollBarThickness) or 1,
            ScrollBarImageColor3 = Themes.DarkColor,
            BackgroundTransparency = math.random(1,1),
            Visible = false
        },{
            Utility:Create("UIListLayout",{
                Padding = UDim.new(0,2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            })
        })

        local Tab = Utility:Create("TextButton",{
            Name = PageName,
            Parent = TabContainer,
            Size = UDim2.new(1,0,-.077,50),
            Font = Properties.Font,
            Text = "   "..PageName,
            TextSize = 13,
            TextColor3 = Themes.TextColor,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = math.random(1,1),
            BackgroundTransparency = math.random(1,1)
        })

        --Animations--
        Utility:Tween(Tab,{TextTransparency = 0.5},.5)
        
        --Functions--
        local ElementTransparency = tonumber(PageProperties.Transparency) or Properties.Transparency  or .5
        local CornerSize =  tonumber(PageProperties.Corner) or Properties.Corner or 4

        if typeof(PageProperties.Visible) == "boolean" and PageProperties.Visible == true then
            Functions:SelectPage(Page.Name)
        end

        if Properties.Style == "In" then
            Tab.Text = PageName
            Tab.TextXAlignment = Enum.TextXAlignment.Center
        end

        Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,Page.UIListLayout.AbsoluteContentSize.Y + 10)
        end)

        Tab.MouseButton1Down:Connect(function()
            if typeof(PageProperties.Callback) == "function" then
                PageProperties.Callback()
            end
            
            Functions:SelectPage(Page.Name)
            Utility:Tween(Tab,{TextSize = 10},.09,true)
            Utility:Tween(Tab,{TextSize = 13},.09)
        end)

        local Elements = {}
        
        function Elements:AddButton(TitleE,Callback)
            TitleE = typeof(TitleE) == "string" and TitleE or "This is a Button"
            Callback = typeof(Callback) == "function" and Callback or function() print("Clicked !!") end
            local ButtonFunctions = {}
            
            local Button = Utility:Create("Frame",{
                Name = "Button",
                Parent = Page,
                Size = UDim2.new(0,0,0,35),
                BackgroundColor3 = Themes.DarkColor,
                ClipsDescendants = true
            },{
                Utility:Create("UICorner",{
                    CornerRadius = UDim.new(0,CornerSize)
                }),
                Utility:Create("TextLabel",{
                    Name = "Title",
                    Size = UDim2.new(1,0,1,0),
                    Font = Properties.Font,
                    Text = "   "..TitleE,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                }),
                Utility:Create("ImageLabel",{
                    Name = "Icon",
                    Size = UDim2.new(0,25,.685714304,0),
                    Position = UDim2.new(.915000021,0,.142857149,0),
                    Image = "rbxassetid://3926305904",
                    ImageColor3 = Themes.TextColor,
                    ImageRectOffset = Vector2.new(84,204),
                    ImageRectSize = Vector2.new(36,36),
                    ImageTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                })
            })

            --Loading Animations--
            Utility:Tween(Button,{Size = UDim2.new(0,390,0,35)},1.5)
            Utility:Tween(Button.Title,{TextTransparency = ElementTransparency},3.5)
            Utility:Tween(Button.Icon,{ImageTransparency = ElementTransparency},3.5)

            --Functions--
            Button.MouseEnter:Connect(function()
                Utility:Tween(Button.Title,{TextTransparency = 0},.5)
                Utility:Tween(Button.Icon,{ImageTransparency = 0},.5)
            end)

            Button.MouseLeave:Connect(function()
                Utility:Tween(Button.Title,{TextTransparency = ElementTransparency},.5)
                Utility:Tween(Button.Icon,{ImageTransparency = ElementTransparency},.5)
            end)

            Utility:OnMouseClick(Button,function()
                ButtonFunctions:UpdateButton(TitleE)
                Callback()
            end)

            function ButtonFunctions:UpdateButton(Changed)
                Changed = typeof(Changed) == "string" and Changed or TitleE
                TitleE = Changed
                Utility:SmoothTextChange(Button.Title,"   "..Changed,ElementTransparency)
            end

            function ButtonFunctions:ReturnModule()
                return Button
            end

            return ButtonFunctions
        end

        function Elements:AddToggle(TitleE,Enabled,Callback)
            TitleE = typeof(TitleE) == "string" and TitleE or "This is a Toggle"
            Enabled = typeof(Enabled) == "boolean" and Enabled or false
            Callback = typeof(Callback) == "function" and Callback or function(c) print(c) end
            local ToggleFunctions = {}

            local Toggle = Utility:Create("Frame",{
                Name = "Toggle",
                Parent = Page,
                Size = UDim2.new(0,0,0,35),
                BackgroundColor3 = Themes.DarkColor,
                ClipsDescendants = true
            },{
                Utility:Create("UICorner",{
                    CornerRadius = UDim.new(0,CornerSize)
                }),
                Utility:Create("TextLabel",{
                    Name = "Title",
                    Size = UDim2.new(1,0,1,0),
                    Font = Properties.Font,
                    Text = "   "..TitleE,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                }),
                Utility:Create("Frame",{
                    Name = "Base",
                    AnchorPoint = Vector2.new(.5,.5),
                    Size = UDim2.new(0,42,0,18),
                    Position = UDim2.new(.93,0,.5,0),
                    BackgroundColor3 = Themes.LightColor
                },{
                    Utility:Create("UICorner",{
                        CornerRadius = UDim.new(0,CornerSize)
                    }),
                    Utility:Create("Frame",{
                        Name = "Square",
                        Size = UDim2.new(0,18,0,13),
                        Position = UDim2.new(.3,0,.5,0),
                        AnchorPoint = Vector2.new(.5,.5),
                        BackgroundColor3 = Themes.TextColor,
                        BackgroundTransparency = math.random(1,1)
                    },{
                        Utility:Create("UICorner",{
                            CornerRadius = UDim.new(0,CornerSize)
                        })
                    })
                })
            })

            --Loading Animations--
            Utility:Tween(Toggle,{Size = UDim2.new(0,390,0,35)},1.5)
            Utility:Tween(Toggle.Title,{TextTransparency = ElementTransparency},3.5)
            Utility:Tween(Toggle.Base.Square,{BackgroundTransparency = ElementTransparency},3.5)

            if Enabled == true then
                Utility:Tween(Toggle.Base.Square,{Position = UDim2.new(.7,0,.5,0)},.1)
            end

            --Functions--
            Toggle.MouseEnter:Connect(function()
                Utility:Tween(Toggle.Title,{TextTransparency = 0},.5)
                Utility:Tween(Toggle.Base.Square,{BackgroundTransparency = 0},.5)
            end)

            Toggle.MouseLeave:Connect(function()
                Utility:Tween(Toggle.Title,{TextTransparency = ElementTransparency},.5)
                Utility:Tween(Toggle.Base.Square,{BackgroundTransparency = ElementTransparency},.5)
            end)

            Utility:OnMouseClick(Toggle,function()
                ToggleFunctions:UpdateToggle(TitleE,not Enabled)
            end)

            if Properties.Execute == "True" then
                Callback(Enabled)
            end

            function ToggleFunctions:UpdateToggle(Changed,Default)
                if typeof(Changed) == "string" then
                    TitleE = Changed
                    Utility:SmoothTextChange(Toggle.Title,"   "..Changed,ElementTransparency)
                end

                if Default ~= nil then
                    Utility:Tween(Toggle.Base.Square,{Size = UDim2.new(0,18,0,5)},.15)
                end

                if Default == true then
                    Enabled = true
                    Utility:Tween(Toggle.Base.Square,{Position = UDim2.new(.7,0,.5,0)},.15,false,{},function()
                        Utility:Tween(Toggle.Base.Square,{Size = UDim2.new(0,18,0,13)},.15)
                    end)                    
                    Callback(Enabled)
                elseif Default == false then
                    Enabled = false
                    Utility:Tween(Toggle.Base.Square,{Position = UDim2.new(.3,0,.5,0)},.15,false,{},function()
                        Utility:Tween(Toggle.Base.Square,{Size = UDim2.new(0,18,0,13)},.15)
                    end) 
                    Callback(Enabled)
                end
            end

            function ToggleFunctions:ReturnModule()
                return Toggle
            end
            
            return ToggleFunctions
        end

        function Elements:AddSlider(TitleE,Default,Minvalue,Maxvalue,Callback)
            TitleE = typeof(TitleE) == "string" and TitleE or "This is a Slider"
            Minvalue = typeof(Minvalue) == "number" and Minvalue or 0
            Maxvalue = typeof(Maxvalue) == "number" and Maxvalue or 38
            Default = typeof(Default) == "number" and Default or Minvalue
            Callback = typeof(Callback) == "function" and Callback or function(c) print(c) end
            local SliderFunctions = {}

            local Slider = Utility:Create("Frame",{
                Name = "Slider",
                Parent = Page,
                Size = UDim2.new(0,0,0,55),
                BackgroundColor3 = Themes.DarkColor,
                ClipsDescendants = true
            },{
                Utility:Create("UICorner",{
                    CornerRadius = UDim.new(0,CornerSize)
                }),
                Utility:Create("TextLabel",{
                    Name = "Title",
                    Size = UDim2.new(1,0,0,35),
                    Font = Properties.Font,
                    Text = "   "..TitleE,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                }),
                Utility:Create("TextBox",{
                    Name = "Number",
                    Size = UDim2.new(.101000004,0,0,35),
                    Position = UDim2.new(.869230747,0,0,0),
                    Font = Properties.Font,
                    Text = Default,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                }),
                Utility:Create("TextButton",{
                    Name = "Base",
                    Size = UDim2.new(0,0,0,5),
                    Position = UDim2.new(.0254360102,0,.699999988,0),
                    Text = "Alpaca was here",
                    TextTransparency = math.random(1,1),
                    AutoButtonColor = false,
                    BackgroundColor3 = Themes.LightColor,
                    ClipsDescendants = true
                },{
                    Utility:Create("UICorner",{
                        CornerRadius = UDim.new(0,CornerSize)
                    }),
                    Utility:Create("Frame",{
                        Name = "Trail",
                        Size = UDim2.new(0,0,1,0),
                        BackgroundColor3 = Themes.TextColor,
                        BackgroundTransparency = math.random(1,1)
                    },{
                        Utility:Create("UICorner",{
                            CornerRadius = UDim.new(0,CornerSize)
                        })
                    })
                })
            })

            --Loading Animations--
            Utility:Tween(Slider,{Size = UDim2.new(0,390,0,55)},1.5)
            Utility:Tween(Slider.Title,{TextTransparency = ElementTransparency},3.5)
            Utility:Tween(Slider.Number,{TextTransparency = ElementTransparency},3.5)
            Utility:Tween(Slider.Base,{Size = UDim2.new(0,371,0,5)},1.5)
            Utility:Tween(Slider.Base.Trail,{Size = UDim2.new(math.clamp((Default - Minvalue) / (Maxvalue - Minvalue),0,1),0,1,0),BackgroundTransparency = ElementTransparency},1)

            --Functions--
            local dragging = false

            if Properties.Execute == "True" then
                Callback(Default)
            end

            Slider.MouseEnter:Connect(function()
                Utility:Tween(Slider.Title,{TextTransparency = 0},.5)
                Utility:Tween(Slider.Number,{TextTransparency = 0},.5)
                Utility:Tween(Slider.Base.Trail,{BackgroundTransparency = 0},.5)
            end)

            Slider.MouseLeave:Connect(function()
                Utility:Tween(Slider.Title,{TextTransparency = ElementTransparency},.5)
                Utility:Tween(Slider.Number,{TextTransparency = ElementTransparency},.5)
                Utility:Tween(Slider.Base.Trail,{BackgroundTransparency = ElementTransparency},.5)
            end)

            local function slide(input)
                local pos = UDim2.new(math.clamp((input.Position.X - Slider.Base.AbsolutePosition.X) / Slider.Base.AbsoluteSize.X ,0,1),0,1,0)
                Utility:Tween(Slider.Base.Trail,{BackgroundTransparency = 0},.5)
                Slider.Base.Trail:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                local s = math.floor(((pos.X.Scale * Maxvalue) / Maxvalue) * (Maxvalue - Minvalue) + Minvalue)
                Slider.Number.Text = tostring(s)
                Callback(s)
            end

            Slider.Base.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    slide(input)
                    dragging = true
                end
            end)

            Slider.Base.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Utility:Tween(Slider.Base.Trail,{BackgroundTransparency = ElementTransparency},.5)
                    dragging = false
                end 
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    slide(input)
                end
            end)

            Slider.Number:GetPropertyChangedSignal("Text"):Connect(function()
                if not Slider.Number:IsFocused() then
                    return
                end

                pcall(function()
                    if tonumber(Slider.Number.Text) > Maxvalue then
                        SliderFunctions:UpdateSlider(TitleE,Maxvalue,Minvalue,Maxvalue)
                    end

                    if tonumber(Slider.Number.Text) < Minvalue then
                        SliderFunctions:UpdateSlider(TitleE,Minvalue,Minvalue,Maxvalue)
                    end
                end)

                if not tonumber(Slider.Number.Text) then
                    Slider.Number.Text = Slider.Number.Text:sub(1,#Slider.Number.Text - 1)
                else
                    SliderFunctions:UpdateSlider(TitleE,tonumber(Slider.Number.Text),Minvalue,Maxvalue)
                end
            end)

            Slider.Number.FocusLost:Connect(function()
                if Slider.Number.Text == "" then
                    SliderFunctions:UpdateSlider(TitleE,Default,Minvalue,Maxvalue)
                end
            end)

            function SliderFunctions:UpdateSlider(Changed,Value,Min,Max)
                if typeof(Changed) == "string" then
                    TitleE = Changed
                    Utility:SmoothTextChange(Slider.Title,"   "..Changed,ElementTransparency)
                end

                if typeof(Value) == "number" then
                    Default = Value
                    Slider.Number.Text = Value
                    Callback(Value)   
                end

                if typeof(Min) == "number" then
                    Minvalue = Min
                end

                if typeof(Max) == "number" then
                    Maxvalue = Max
                end

                Utility:Tween(Slider.Base.Trail,{Size = UDim2.new(math.clamp((Value - Min) / (Max - Min),0,1),0,1,0)},.25)
            end

            function SliderFunctions:ReturnModule()
                return Slider
            end

            return SliderFunctions

        end

        function Elements:AddDropdown(TitleE,List,Callback,PropertiesE)
            TitleE = typeof(TitleE) == "string" and TitleE or "This is a Dropdown"
            List = typeof(List) == "table" and List or {1,2,3,4,5,6,7,8,9,10}
            Callback = typeof(Callback) == "function" and Callback or function(c) print("Clicked on "..c) end
            PropertiesE = typeof(PropertiesE) == "table" and PropertiesE or {}
            local DropdownFunctions = {}

            local Dropdown = Utility:Create("Frame",{
                Name = "Dropdown",
                Parent = Page,
                Size = UDim2.new(0,0,0,35),
                BackgroundColor3 = Themes.DarkColor,
                ClipsDescendants = true
            },{
                Utility:Create("UICorner",{
                    CornerRadius = UDim.new(0,CornerSize)
                }),
                Utility:Create("TextLabel",{
                    Name = "Title",
                    Size = UDim2.new(1,0,0,35),
                    Font = Properties.Font,
                    Text = "   "..TitleE,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                },{
                    Utility:Create("ImageLabel",{
                        Name = "Icon",
                        Size = UDim2.new(0,25,.685714304,0),
                        Position = UDim2.new(.915000021,0,.142857149,0),
                        Image = "rbxassetid://3926305904",
                        ImageColor3 = Themes.TextColor,
                        ImageRectOffset = Vector2.new(404, 284),
                        ImageRectSize = Vector2.new(36, 36),
                        ImageTransparency = math.random(1,1),
                        BackgroundTransparency = math.random(1,1)
                    })
                }),
                Utility:Create("ScrollingFrame",{
                    Name = "Container",
                    Size = UDim2.new(0,371,0,120),
                    Position = UDim2.new(.0254360102,0,.230769232,0),
                    CanvasSize = UDim2.new(0,0,0,1),
                    ScrollBarThickness = PropertiesE.Thickness or 2,
                    ScrollBarImageColor3 = Themes.LightColor,
                    BackgroundTransparency = math.random(1,1),
                    ClipsDescendants = true,
                    Visible = false,
                },{
                    Utility:Create("UIListLayout",{
                        Padding = UDim.new(0,2),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    })
                })
            })

            --Loading Animations--
            Utility:Tween(Dropdown,{Size = UDim2.new(0,390,0,35)},1.5)
            Utility:Tween(Dropdown.Title,{TextTransparency = ElementTransparency},3.5)
            Utility:Tween(Dropdown.Title.Icon,{ImageTransparency = ElementTransparency},3.5)

            --Functions--
            local Debounce = false
            local Default = PropertiesE.Default or "Select"
            local Refresh = PropertiesE.Refresh or false
            local Enabled = PropertiesE.Enabled or false
            local CloseOnClick = PropertiesE.CloseOnClick or true

            Utility:OnMouseClick(Dropdown.Title,function()
                if Debounce then
                    return
                end

                if Refresh == true then
                    DropdownFunctions:UpdateDropdown(nil,List)
                end

                Debounce = true

                DropdownFunctions:Init(not Enabled)

                Debounce = false
            end)

            Dropdown.Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Dropdown.Container.CanvasSize = UDim2.new(0,0,0,Dropdown.Container.UIListLayout.AbsoluteContentSize.Y + 5)
            end)

            spawn(function()
                DropdownFunctions:UpdateDropdown(nil,List)

                if Enabled == true then
                    DropdownFunctions:Init("Open")
                end

                if Properties.Execute == "True" then
                    DropdownFunctions:Select(Default,"True")
                end
            end)

            function DropdownFunctions:Clear()
                for i,v in pairs(Dropdown.Container:GetChildren()) do
                    if v:IsA("TextButton") then
                        v:Destroy()
                    end
                end

                List = {}
            end

            function DropdownFunctions:Add(OptionNmae)
                local Option = Utility:Create("TextButton",{
                    Name = OptionNmae,
                    Parent = Dropdown.Container,
                    Size = UDim2.new(1,0,0,25),
                    Font = Properties.Font,
                    Text = "   "..OptionNmae,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = ElementTransparency,
                    BackgroundColor3 = Themes.DarkColor,
                    AutoButtonColor = false,
                    ClipsDescendants = true
                },{
                    Utility:Create("UICorner",{
                        CornerRadius = UDim.new(0,CornerSize)
                    })
                })

                if Option.Name == Default then
                    Option.TextTransparency = 0
                end

                Option.MouseEnter:Connect(function()
                    Utility:Tween(Option,{BackgroundColor3 = Themes.LightColor},.2)
                end)

                Option.MouseLeave:Connect(function()
                    Utility:Tween(Option,{BackgroundColor3 = Themes.DarkColor},.2)
                end)

                Option.MouseButton1Down:Connect(function()
                    DropdownFunctions:Select(Option.Name,"True")

                    if CloseOnClick == true then
                        DropdownFunctions:Init("Close")
                    end
                end)

            end

            function DropdownFunctions:Init(Changed)
                if Changed == "Open" or Changed == true then
                    Enabled = true
                    Dropdown.Title.Text = "   "..Default
                    Utility:Tween(Dropdown.Title.Icon,{Rotation = 180},.25)
                    Utility:Tween(Dropdown,{Size = UDim2.new(0,390,0,165)},.25,true)
                    Dropdown.Container.Visible = true
                elseif Changed == "Close" or Changed == false then
                    Enabled = false
                    Dropdown.Title.Text = "   "..TitleE.." : "..Default
                    Dropdown.Container.Visible = false
                    Utility:Tween(Dropdown.Title.Icon,{Rotation = 0},.25)
                    Utility:Tween(Dropdown,{Size = UDim2.new(0,390,0,35)},.25,true)
                end
            end

            function DropdownFunctions:Remove(OptionName)
                for i,v in pairs(Dropdown.Container:GetChildren()) do
                    if v.Name == OptionName then
                        v:Destroy()
                        return table.remove(List,Utility:Find(List,OptionName))
                    end
                end
            end

            function DropdownFunctions:Select(OptionName,ExecuteCallback)
                for i,v in pairs(Dropdown.Container:GetChildren()) do
                    if v:IsA("TextButton") then
                        Utility:Tween(v,{TextTransparency = ElementTransparency},.2)
                    end

                    if v:IsA("TextButton") and v.Name == OptionName then
                        Default = OptionName
                        Utility:Tween(v,{TextTransparency = 0},.2)
                        
                        if Enabled == false then
                            Dropdown.Title.Text = "   "..TitleE.." : "..OptionName
                        else
                            Dropdown.Title.Text = "   "..OptionName
                        end

                        if ExecuteCallback == "True" then
                            Callback(OptionName)
                        end
                    end
                end
            end

            function DropdownFunctions:ReturnModule()
                return Dropdown
            end

            function DropdownFunctions:UpdateDropdown(Changed,Options)
                if typeof(Changed) == "string" then
                    TitleE = Changed
                    Utility:SmoothTextChange(Dropdown.Title,"   "..Changed,ElementTransparency)
                end

                DropdownFunctions:Clear()

                List = Options

                for i,v in pairs(Options) do
                    DropdownFunctions:Add(v)
                end
            end

            return DropdownFunctions
        end

        function Elements:AddTextBox(TitleE,PlaceHolder,Callback)
            TitleE = typeof(TitleE) == "string" and TitleE or "This is a TextBox"
            PlaceHolder = typeof(PlaceHolder) == "string" and PlaceHolder or "Text Here"
            Callback = typeof(Callback) == "function" and Callback or function(c) print("Wrote : "..c) end
            local TextBoxFunctions = {}

            local TextBox = Utility:Create("Frame",{
                Name = "TextBox",
                Parent = Page,
                Size = UDim2.new(0,0,0,35),
                BackgroundColor3 = Themes.DarkColor,
                ClipsDescendants = true
            },{
                Utility:Create("UICorner",{
                    CornerRadius = UDim.new(0,CornerSize)
                }),
                Utility:Create("TextLabel",{
                    Name = "Title",
                    Size = UDim2.new(1,0,1,0),
                    Font = Properties.Font,
                    Text = "   "..TitleE,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                }),
                Utility:Create("TextBox",{
                    Size = UDim2.new(0,0,0,18),
                    Position = UDim2.new(.625871718,0,.22857143,0),
                    Font = Properties.Font,
                    Text = PlaceHolder,
                    TextSize = 11,
                    TextColor3 = Themes.TextColor,
                    TextTransparency = math.random(1,1),
                    BackgroundColor3 = Themes.LightColor,
                    ClipsDescendants = true
                },{
                    Utility:Create("UICorner",{
                        CornerRadius = UDim.new(0,CornerSize)
                    })
                })
            })

            --Loading Animations--
            Utility:Tween(TextBox,{Size = UDim2.new(0,390,0,35)},1.5)
            Utility:Tween(TextBox.TextBox,{Size = UDim2.new(0, 137, 0, 18)},1.5)
            Utility:Tween(TextBox.Title,{TextTransparency = ElementTransparency},3.5)
            Utility:Tween(TextBox.TextBox,{TextTransparency = ElementTransparency},3.5)

            --Functions--
            TextBox.MouseEnter:Connect(function()
                if TextBox.TextBox:IsFocused() then
                    return
                end

                Utility:Tween(TextBox.Title,{TextTransparency = 0},.5)
                Utility:Tween(TextBox.TextBox,{TextTransparency = 0},.5)
            end)

            TextBox.MouseLeave:Connect(function()
                if TextBox.TextBox:IsFocused() then
                    return
                end

                Utility:Tween(TextBox.Title,{TextTransparency = ElementTransparency},.5)
                Utility:Tween(TextBox.TextBox,{TextTransparency = ElementTransparency},.5)
            end)

            TextBox.TextBox.Focused:Connect(function()
                Utility:Tween(TextBox.TextBox,{
                    Size = UDim2.new(0,250,0,18),
                    Position = UDim2.new(.335871718,0,.22857143,0)
                },.5)

                Utility:Tween(TextBox.Title,{TextTransparency = 1},.5)
                Utility:Tween(TextBox.TextBox,{TextTransparency = 0},.5)
            end)

            TextBox.TextBox.FocusLost:Connect(function()
                if TextBox.TextBox.Text == "" then
                    TextBoxFunctions:UpdateTextBox(TitleE,PlaceHolder)
                else
                    PlaceHolder = TextBox.TextBox.Text
                end

                Utility:Tween(TextBox.TextBox,{
                    Size = UDim2.new(0,137,0,18),
                    Position = UDim2.new(.625871718,0,.22857143,0)
                },.5)

                Utility:Tween(TextBox.Title,{TextTransparency = ElementTransparency},.5)
                Utility:Tween(TextBox.TextBox,{TextTransparency = ElementTransparency},.5)
                Callback(PlaceHolder)
            end)

            function TextBoxFunctions:UpdateTextBox(Changed,Changed2)
                if typeof(Changed) == "string" then
                    TitleE = Changed
                    Utility:SmoothTextChange(TextBox.Title,"   "..Changed,ElementTransparency)    
                end

                if typeof(Changed2) == "string" then
                    PlaceHolder = Changed2
                    Utility:SmoothTextChange(TextBox.TextBox,Changed2,ElementTransparency)
                end

            end

            function TextBoxFunctions:ReturnModule()
                return TextBox
            end

            return TextBoxFunctions
        end

        function Elements:AddKeybind(TitleE,Preset,Callback)
            TitleE = typeof(TitleE) == "string" and TitleE or "This is a Keybind" 
            Preset = typeof(Preset) == "EnumItem" and Preset or Enum.KeyCode.RightShift
            Callback = typeof(Callback) == "function" and Callback or function(c) print("Pressed "..c) end
            local KeybindFunctions = {}

            local Keybind = Utility:Create("Frame",{
                Name = "Keybind",
                Parent = Page,
                Size = UDim2.new(0,0,0,35),
                BackgroundColor3 = Themes.DarkColor,
                ClipsDescendants = true
            },{
                Utility:Create("UICorner",{
                    CornerRadius = UDim.new(0,CornerSize)
                }),
                Utility:Create("TextLabel",{
                    Name = "Title",
                    Size = UDim2.new(1,0,1,0),
                    Font = Properties.Font,
                    Text = "   "..TitleE,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                }),
                Utility:Create("TextLabel",{
                    Name = "Bind",
                    Size = UDim2.new(0,94,0,21),
                    Position = UDim2.new(.733,0,.2,0),
                    Font = Properties.Font,
                    Text = "[ "..Preset.Name:gsub(" ","").." ]",
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                })
            })

            --Loading Animations--
            Utility:Tween(Keybind,{Size = UDim2.new(0,390,0,35)},1.5)
            Utility:Tween(Keybind.Title,{TextTransparency = ElementTransparency},3.5)
            Utility:Tween(Keybind.Bind,{TextTransparency = ElementTransparency},3.5)

            --Functions--
            local Keyconnection
            local CurrentKey = Preset.Name

            Keybind.MouseEnter:Connect(function()
                Utility:Tween(Keybind.Title,{TextTransparency = 0},.5)
                Utility:Tween(Keybind.Bind,{TextTransparency = 0},.5)
            end)

            Keybind.MouseLeave:Connect(function()
                Utility:Tween(Keybind.Title,{TextTransparency = ElementTransparency},.5)
                Utility:Tween(Keybind.Bind,{TextTransparency = ElementTransparency},.5)
            end)

            Utility:OnMouseClick(Keybind,function()
                CurrentKey = ""
                Keybind.Bind.Text = "[ ... ]"

                local Key = UserInputService.InputBegan:Wait()
                
                while Key.UserInputType ~= Enum.UserInputType.Keyboard  do
                    Key = UserInputService.InputBegan:Wait()
                end

                KeybindFunctions:UpdateKeybind(TitleE,Key.KeyCode)
            end)

            Keyconnection = UserInputService.InputBegan:Connect(function(input)
                if UserInputService:GetFocusedTextBox() then return end

                if input.KeyCode.Name == CurrentKey then
                    Utility:Tween(Keybind.Bind,{TextSize = 15},.07,false,{},function()
                        Utility:Tween(Keybind.Bind,{TextSize = 12},.07)
                    end)
                    Callback(CurrentKey,input.KeyCode)
                end
            end)

            Functions:OnDestroyed(function()
                Keyconnection:Disconnect()
            end)

            function KeybindFunctions:UpdateKeybind(Changed,Changed2)
                if typeof(Changed) == "string" then
                    TitleE = Changed
                    Utility:SmoothTextChange(Keybind.Title,"   "..Changed,ElementTransparency)
                end

                if typeof(Changed2) == "EnumItem" then
                    wait(.05)
                    CurrentKey = Changed2.Name
                    Utility:SmoothTextChange(Keybind.Bind,"[ "..Changed2.Name:gsub(" ","").." ]",ElementTransparency)
                end
            end

            function KeybindFunctions:ReturnModule()
                return Keybind
            end

            return KeybindFunctions
        end

        function Elements:AddLabel(TitleE)
            TitleE = typeof(TitleE) == "string" and TitleE or "This is a Label"
            local LabelFunctions = {}

            local Label = Utility:Create("Frame",{
                Name = "Label",
                Parent = Page,
                Size = UDim2.new(0,0,0,35),
                BackgroundColor3 = Themes.DarkColor,
                ClipsDescendants = true
            },{
                Utility:Create("UICorner",{
                    CornerRadius = UDim.new(0,CornerSize)
                }),
                Utility:Create("TextLabel",{
                    Name = "Title",
                    Size = UDim2.new(1,0,1,0),
                    Font = Properties.Font,
                    Text = TitleE,
                    TextSize = 12,
                    TextColor3 = Themes.TextColor,
                    TextWrapped = true,
                    TextTransparency = math.random(1,1),
                    BackgroundTransparency = math.random(1,1)
                })
            })

            --Loading Animations--
            Utility:Tween(Label,{Size = UDim2.new(0,390,0,35)},1.5)
            Utility:Tween(Label.Title,{TextTransparency = ElementTransparency},3.5)

            --Functions--
            function LabelFunctions:UpdateLabel(Changed)
                if typeof(Changed) == "string" then
                    TitleE = Changed
                    Utility:SmoothTextChange(Label.Title,Changed,ElementTransparency)
                end
            end

            function LabelFunctions:ReturnModule()
                return Label
            end

            return LabelFunctions
        end
        
        function Elements:AddEmpty(Size)
            Size = typeof(Size) == "number" and Size or 15

            local Empty = Utility:Create("Frame",{
                Name = "Empty",
                Parent = Page,
                Size = UDim2.new(0,0,0,Size),
                BackgroundTransparency = 1,
                ClipsDescendants = true
            })

            return Empty --No Functions Just The Instance Cause Yes--
        end

        function Elements:AddSettings(Preset)
            local InstanceToReturn = Functions:ReturnModule().Frame.UIScale

            self:AddLabel("UI Settings :")

            self:AddKeybind("UI Toggle Key | Open/Close",Preset,function()
                Functions:Toggle()
            end)

            self:AddButton("Destroy UI",function()
                Functions:Destroy()
            end)

            self:AddEmpty()

            self:AddLabel("UI Sizing :")

            self:AddButton("Increase UI Size",function()
                Utility:Tween(InstanceToReturn,{Scale = InstanceToReturn.Scale + .01},.1)
            end)

            self:AddButton("Decrease UI Size",function()
                Utility:Tween(InstanceToReturn,{Scale = InstanceToReturn.Scale - .01},.1)
            end)

            self:AddKeybind("Reset UI Size",Enum.KeyCode.Equals,function()
                Utility:Tween(InstanceToReturn,{Scale = 1},.1)
            end)
        end

        function Elements:Scroll(Y)
            Utility:Tween(Page,{CanvasPosition = Vector2.new(0,Y)},.25)
        end

        return Elements
    end

    return Functions
end
return Module
