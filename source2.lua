--[[
    Professional UI Library for Roblox
    Version: 1.0.0
    Author: Professional UI Team
    
    Usage:
    local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source.lua"))()
]]

local ProfessionalUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Themes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(45, 45, 45),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Primary = Color3.fromRGB(0, 162, 255),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 0, 0)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Secondary = Color3.fromRGB(235, 235, 235),
        Accent = Color3.fromRGB(225, 225, 225),
        Text = Color3.fromRGB(0, 0, 0),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Primary = Color3.fromRGB(0, 122, 255),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 140, 0),
        Error = Color3.fromRGB(255, 0, 0)
    }
}

-- Utility Functions
local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function GetScreenSize()
    local camera = workspace.CurrentCamera
    return camera.ViewportSize
end

local function ScaleUI(size, screenSize)
    screenSize = screenSize or GetScreenSize()
    local scale = math.min(screenSize.X / 1920, screenSize.Y / 1080)
    return UDim2.new(0, size.X * scale, 0, size.Y * scale)
end

-- Key System
function ProfessionalUI:CreateKeySystem(config)
    config = config or {}
    local keySystemConfig = {
        Title = config.Title or "Key System",
        Description = config.Description or "Enter your key to continue",
        Key = config.Key or "DefaultKey123",
        KeyLink = config.KeyLink or "https://example.com/getkey",
        Callback = config.Callback or function() end
    }
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystem"
    screenGui.Parent = CoreGui
    
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.5
    blur.Parent = screenGui
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = ScaleUI(Vector2.new(400, 300))
    keyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    keyFrame.BackgroundColor3 = Themes.Dark.Background
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = keyFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = keySystemConfig.Title
    title.TextColor3 = Themes.Dark.Text
    title.TextSize = 20
    title.Font = Enum.Font.SourceSansBold
    title.Parent = keyFrame
    
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -40, 0, 40)
    description.Position = UDim2.new(0, 20, 0, 60)
    description.BackgroundTransparency = 1
    description.Text = keySystemConfig.Description
    description.TextColor3 = Themes.Dark.TextSecondary
    description.TextSize = 14
    description.Font = Enum.Font.SourceSans
    description.TextWrapped = true
    description.Parent = keyFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.Position = UDim2.new(0, 20, 0, 120)
    keyInput.BackgroundColor3 = Themes.Dark.Secondary
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter key here..."
    keyInput.TextColor3 = Themes.Dark.Text
    keyInput.PlaceholderColor3 = Themes.Dark.TextSecondary
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.SourceSans
    keyInput.Parent = keyFrame
    
    local keyInputCorner = Instance.new("UICorner")
    keyInputCorner.CornerRadius = UDim.new(0, 4)
    keyInputCorner.Parent = keyInput
    
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.45, 0, 0, 35)
    submitButton.Position = UDim2.new(0.05, 0, 0, 180)
    submitButton.BackgroundColor3 = Themes.Dark.Primary
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Submit"
    submitButton.TextColor3 = Themes.Dark.Text
    submitButton.TextSize = 14
    submitButton.Font = Enum.Font.SourceSansBold
    submitButton.Parent = keyFrame
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 4)
    submitCorner.Parent = submitButton
    
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Size = UDim2.new(0.45, 0, 0, 35)
    getKeyButton.Position = UDim2.new(0.5, 0, 0, 180)
    getKeyButton.BackgroundColor3 = Themes.Dark.Secondary
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Text = "Get Key"
    getKeyButton.TextColor3 = Themes.Dark.Text
    getKeyButton.TextSize = 14
    getKeyButton.Font = Enum.Font.SourceSansBold
    getKeyButton.Parent = keyFrame
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 4)
    getKeyCorner.Parent = getKeyButton
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0, 230)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Themes.Dark.Error
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = keyFrame
    
    -- Animations
    keyFrame.Position = UDim2.new(0.5, -200, 1, 0)
    CreateTween(keyFrame, {Position = UDim2.new(0.5, -200, 0.5, -150)}, 0.5):Play()
    
    -- Button Events
    submitButton.MouseButton1Click:Connect(function()
        if keyInput.Text == keySystemConfig.Key then
            statusLabel.Text = "Key accepted! Loading..."
            statusLabel.TextColor3 = Themes.Dark.Success
            wait(1)
            CreateTween(keyFrame, {Position = UDim2.new(0.5, -200, -1, 0)}, 0.5):Play()
            wait(0.5)
            screenGui:Destroy()
            keySystemConfig.Callback()
        else
            statusLabel.Text = "Invalid key! Please try again."
            statusLabel.TextColor3 = Themes.Dark.Error
            CreateTween(keyFrame, {Position = UDim2.new(0.5, -210, 0.5, -150)}, 0.1):Play()
            wait(0.1)
            CreateTween(keyFrame, {Position = UDim2.new(0.5, -190, 0.5, -150)}, 0.1):Play()
            wait(0.1)
            CreateTween(keyFrame, {Position = UDim2.new(0.5, -200, 0.5, -150)}, 0.1):Play()
        end
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        setclipboard(keySystemConfig.KeyLink)
        statusLabel.Text = "Key link copied to clipboard!"
        statusLabel.TextColor3 = Themes.Dark.Success
    end)
    
    return {
        Destroy = function()
            screenGui:Destroy()
        end
    }
end

-- Main Window Creation
function ProfessionalUI:CreateWindow(config)
    config = config or {}
    local windowConfig = {
        Title = config.Title or "Professional UI",
        Size = config.Size or Vector2.new(600, 400),
        Theme = config.Theme or "Dark",
        Draggable = config.Draggable ~= false,
        Resizable = config.Resizable or false
    }
    
    local currentTheme = Themes[windowConfig.Theme] or Themes.Dark
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ProfessionalUI"
    screenGui.Parent = CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = ScaleUI(windowConfig.Size)
    mainFrame.Position = UDim2.new(0.5, -windowConfig.Size.X/2, 0.5, -windowConfig.Size.Y/2)
    mainFrame.BackgroundColor3 = currentTheme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = currentTheme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleCornerFix = Instance.new("Frame")
    titleCornerFix.Size = UDim2.new(1, 0, 0.5, 0)
    titleCornerFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleCornerFix.BackgroundColor3 = currentTheme.Secondary
    titleCornerFix.BorderSizePixel = 0
    titleCornerFix.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowConfig.Title
    titleLabel.TextColor3 = currentTheme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = currentTheme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = currentTheme.Text
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = currentTheme.Warning
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = currentTheme.Text
    minimizeButton.TextSize = 18
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeButton
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 150, 1, 0)
    tabContainer.BackgroundColor3 = currentTheme.Accent
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentFrame
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, -150, 1, 0)
    tabContent.Position = UDim2.new(0, 150, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = contentFrame
    
    -- Make draggable
    if windowConfig.Draggable then
        MakeDraggable(mainFrame, titleBar)
    end
    
    -- Window controls
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    closeButton.MouseButton1Click:Connect(function()
        CreateTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3):Play()
        wait(0.3)
        screenGui:Destroy()
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            CreateTween(mainFrame, {Size = originalSize}, 0.3):Play()
            isMinimized = false
            minimizeButton.Text = "−"
        else
            CreateTween(mainFrame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}, 0.3):Play()
            isMinimized = true
            minimizeButton.Text = "+"
        end
    end)
    
    -- Window object
    local Window = {
        Frame = mainFrame,
        TabContainer = tabContainer,
        TabContent = tabContent,
        Theme = currentTheme,
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Tab creation
    function Window:CreateTab(config)
        config = config or {}
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or nil
        }
        
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.Position = UDim2.new(0, 0, 0, #self.Tabs * 35)
        tabButton.BackgroundColor3 = self.Theme.Accent
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabConfig.Name
        tabButton.TextColor3 = self.Theme.TextSecondary
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.SourceSans
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Parent = self.TabContainer
        
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, -20, 1, -20)
        tabFrame.Position = UDim2.new(0, 10, 0, 10)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollBarImageColor3 = self.Theme.Primary
        tabFrame.Visible = false
        tabFrame.Parent = self.TabContent
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 5)
        listLayout.Parent = tabFrame
        
        local tab = {
            Button = tabButton,
            Frame = tabFrame,
            Elements = {}
        }
        
        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)
        
        -- Auto-select first tab
        if #self.Tabs == 0 then
            self:SelectTab(tab)
        end
        
        table.insert(self.Tabs, tab)
        
        -- Tab methods
        function tab:CreateButton(config)
            config = config or {}
            local buttonConfig = {
                Text = config.Text or "Button",
                Callback = config.Callback or function() end
            }
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 35)
            button.BackgroundColor3 = Window.Theme.Primary
            button.BorderSizePixel = 0
            button.Text = buttonConfig.Text
            button.TextColor3 = Window.Theme.Text
            button.TextSize = 14
            button.Font = Enum.Font.SourceSansBold
            button.Parent = self.Frame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = button
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = Color3.new(
                    Window.Theme.Primary.R + 0.1,
                    Window.Theme.Primary.G + 0.1,
                    Window.Theme.Primary.B + 0.1
                )}, 0.2):Play()
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = Window.Theme.Primary}, 0.2):Play()
            end)
            
            button.MouseButton1Click:Connect(buttonConfig.Callback)
            
            table.insert(self.Elements, button)
            return button
        end
        
        function tab:CreateToggle(config)
            config = config or {}
            local toggleConfig = {
                Text = config.Text or "Toggle",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.BackgroundColor3 = Window.Theme.Secondary
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = self.Frame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 4)
            toggleCorner.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Position = UDim2.new(0, 15, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = toggleConfig.Text
            toggleLabel.TextColor3 = Window.Theme.Text
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.SourceSans
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            toggleButton.BackgroundColor3 = toggleConfig.Default and Window.Theme.Success or Window.Theme.Accent
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            local toggleButtonCorner = Instance.new("UICorner")
            toggleButtonCorner.CornerRadius = UDim.new(0, 10)
            toggleButtonCorner.Parent = toggleButton
            
            local toggleIndicator = Instance.new("Frame")
            toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            toggleIndicator.Position = toggleConfig.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            toggleIndicator.BackgroundColor3 = Window.Theme.Text
            toggleIndicator.BorderSizePixel = 0
            toggleIndicator.Parent = toggleButton
            
            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(0, 8)
            indicatorCorner.Parent = toggleIndicator
            
            local enabled = toggleConfig.Default
            
            toggleButton.MouseButton1Click:Connect(function()
                enabled = not enabled
                
                local indicatorPos = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local buttonColor = enabled and Window.Theme.Success or Window.Theme.Accent
                
                CreateTween(toggleIndicator, {Position = indicatorPos}, 0.2):Play()
                CreateTween(toggleButton, {BackgroundColor3 = buttonColor}, 0.2):Play()
                
                toggleConfig.Callback(enabled)
            end)
            
            table.insert(self.Elements, toggleFrame)
            return {
                Frame = toggleFrame,
                SetValue = function(value)
                    enabled = value
                    local indicatorPos = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local buttonColor = enabled and Window.Theme.Success or Window.Theme.Accent
                    CreateTween(toggleIndicator, {Position = indicatorPos}, 0.2):Play()
                    CreateTween(toggleButton, {BackgroundColor3 = buttonColor}, 0.2):Play()
                end
            }
        end
        
        function tab:CreateSlider(config)
            config = config or {}
            local sliderConfig = {
                Text = config.Text or "Slider",
                Min = config.Min or 0,
                Max = config.Max or 100,
                Default = config.Default or 50,
                Callback = config.Callback or function() end
            }
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.BackgroundColor3 = Window.Theme.Secondary
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = self.Frame
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 4)
            sliderCorner.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(1, -20, 0, 20)
            sliderLabel.Position = UDim2.new(0, 10, 0, 5)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = sliderConfig.Text
            sliderLabel.TextColor3 = Window.Theme.Text
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.SourceSans
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -60, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(sliderConfig.Default)
            valueLabel.TextColor3 = Window.Theme.Primary
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.SourceSansBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Size = UDim2.new(1, -20, 0, 4)
            sliderTrack.Position = UDim2.new(0, 10, 0, 30)
            sliderTrack.BackgroundColor3 = Window.Theme.Accent
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = sliderFrame
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(0, 2)
            trackCorner.Parent = sliderTrack
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Window.Theme.Primary
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 2)
            fillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Size = UDim2.new(0, 16, 0, 16)
            sliderButton.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), -8, 0.5, -8)
            sliderButton.BackgroundColor3 = Window.Theme.Text
            sliderButton.BorderSizePixel = 0
            sliderButton.Text = ""
            sliderButton.Parent = sliderTrack
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = sliderButton
            
            local currentValue = sliderConfig.Default
            local dragging = false
            
            sliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relativePos = math.clamp((Mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    currentValue = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * relativePos)
                    
                    valueLabel.Text = tostring(currentValue)
                    sliderButton.Position = UDim2.new(relativePos, -8, 0.5, -8)
                    sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                    
                    sliderConfig.Callback(currentValue)
                end
            end)
            
            table.insert(self.Elements, sliderFrame)
            return {
                Frame = sliderFrame,
                SetValue = function(value)
                    currentValue = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                    local relativePos = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                    valueLabel.Text = tostring(currentValue)
                    sliderButton.Position = UDim2.new(relativePos, -8, 0.5, -8)
                    sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                end
            }
        end
        
        function tab:CreateDropdown(config)
            config = config or {}
            local dropdownConfig = {
                Text = config.Text or "Dropdown",
                Options = config.Options or {"Option 1", "Option 2", "Option 3"},
                Default = config.Default or config.Options[1],
                Callback = config.Callback or function() end
            }
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            dropdownFrame.BackgroundColor3 = Window.Theme.Secondary
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Parent = self.Frame
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 4)
            dropdownCorner.Parent = dropdownFrame
            
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(0.5, -10, 1, 0)
            dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = dropdownConfig.Text
            dropdownLabel.TextColor3 = Window.Theme.Text
            dropdownLabel.TextSize = 14
            dropdownLabel.Font = Enum.Font.SourceSans
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0.5, -15, 0, 25)
            dropdownButton.Position = UDim2.new(0.5, 0, 0.5, -12.5)
            dropdownButton.BackgroundColor3 = Window.Theme.Accent
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Text = dropdownConfig.Default .. " ▼"
            dropdownButton.TextColor3 = Window.Theme.Text
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.SourceSans
            dropdownButton.Parent = dropdownFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = dropdownButton
            
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(0.5, -15, 0, #dropdownConfig.Options * 25)
            optionsFrame.Position = UDim2.new(0.5, 0, 1, 5)
            optionsFrame.BackgroundColor3 = Window.Theme.Accent
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.ZIndex = 10
            optionsFrame.Parent = dropdownFrame
            
            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 4)
            optionsCorner.Parent = optionsFrame
            
            local optionsLayout = Instance.new("UIListLayout")
            optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optionsLayout.Parent = optionsFrame
            
            for i, option in ipairs(dropdownConfig.Options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 25)
                optionButton.BackgroundColor3 = Window.Theme.Accent
                optionButton.BorderSizePixel = 0
                optionButton.Text = option
                optionButton.TextColor3 = Window.Theme.Text
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.SourceSans
                optionButton.ZIndex = 11
                optionButton.Parent = optionsFrame
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundColor3 = Window.Theme.Primary
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundColor3 = Window.Theme.Accent
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option .. " ▼"
                    optionsFrame.Visible = false
                    dropdownConfig.Callback(option)
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                optionsFrame.Visible = not optionsFrame.Visible
            end)
            
            table.insert(self.Elements, dropdownFrame)
            return {
                Frame = dropdownFrame,
                SetValue = function(value)
                    dropdownButton.Text = value .. " ▼"
                end
            }
        end
        
        function tab:CreateTextbox(config)
            config = config or {}
            local textboxConfig = {
                Text = config.Text or "Textbox",
                PlaceholderText = config.PlaceholderText or "Enter text...",
                Default = config.Default or "",
                Callback = config.Callback or function() end
            }
            
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Size = UDim2.new(1, 0, 0, 35)
            textboxFrame.BackgroundColor3 = Window.Theme.Secondary
            textboxFrame.BorderSizePixel = 0
            textboxFrame.Parent = self.Frame
            
            local textboxCorner = Instance.new("UICorner")
            textboxCorner.CornerRadius = UDim.new(0, 4)
            textboxCorner.Parent = textboxFrame
            
            local textboxLabel = Instance.new("TextLabel")
            textboxLabel.Size = UDim2.new(0.3, -10, 1, 0)
            textboxLabel.Position = UDim2.new(0, 15, 0, 0)
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Text = textboxConfig.Text
            textboxLabel.TextColor3 = Window.Theme.Text
            textboxLabel.TextSize = 14
            textboxLabel.Font = Enum.Font.SourceSans
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            textboxLabel.Parent = textboxFrame
            
            local textbox = Instance.new("TextBox")
            textbox.Size = UDim2.new(0.7, -15, 0, 25)
            textbox.Position = UDim2.new(0.3, 0, 0.5, -12.5)
            textbox.BackgroundColor3 = Window.Theme.Accent
            textbox.BorderSizePixel = 0
            textbox.Text = textboxConfig.Default
            textbox.PlaceholderText = textboxConfig.PlaceholderText
            textbox.TextColor3 = Window.Theme.Text
            textbox.PlaceholderColor3 = Window.Theme.TextSecondary
            textbox.TextSize = 12
            textbox.Font = Enum.Font.SourceSans
            textbox.Parent = textboxFrame
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 4)
            inputCorner.Parent = textbox
            
            textbox.FocusLost:Connect(function()
                textboxConfig.Callback(textbox.Text)
            end)
            
            table.insert(self.Elements, textboxFrame)
            return {
                Frame = textboxFrame,
                SetValue = function(value)
                    textbox.Text = value
                end,
                GetValue = function()
                    return textbox.Text
                end
            }
        end
        
        function tab:CreateLabel(config)
            config = config or {}
            local labelConfig = {
                Text = config.Text or "Label"
            }
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 25)
            label.BackgroundTransparency = 1
            label.Text = labelConfig.Text
            label.TextColor3 = Window.Theme.Text
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = self.Frame
            
            table.insert(self.Elements, label)
            return {
                Label = label,
                SetText = function(text)
                    label.Text = text
                end
            }
        end
        
        return tab
    end
    
    function Window:SelectTab(tab)
        -- Hide all tabs
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
            t.Button.BackgroundColor3 = self.Theme.Accent
            t.Button.TextColor3 = self.Theme.TextSecondary
        end
        
        -- Show selected tab
        tab.Frame.Visible = true
        tab.Button.BackgroundColor3 = self.Theme.Primary
        tab.Button.TextColor3 = self.Theme.Text
        self.CurrentTab = tab
    end
    
    function Window:Destroy()
        screenGui:Destroy()
    end
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    CreateTween(mainFrame, {
        Size = ScaleUI(windowConfig.Size),
        Position = UDim2.new(0.5, -windowConfig.Size.X/2, 0.5, -windowConfig.Size.Y/2)
    }, 0.5, Enum.EasingStyle.Back):Play()
    
    return Window
end

return ProfessionalUI
