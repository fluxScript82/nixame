--[[
    Professional UI Library v3.0 - FIXED VERSION
    Compatible with all Roblox executors
    
    Usage:
    local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source.lua"))()
]]

local ProfessionalUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Try to use CoreGui, fallback to PlayerGui if not available
local function getParent()
    local success, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if success then
        return coreGui
    else
        return Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local GuiParent = getParent()

-- Themes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 30),
        Secondary = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(45, 45, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Primary = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(237, 66, 69)
    },
    Light = {
        Background = Color3.fromRGB(250, 250, 250),
        Secondary = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(230, 230, 230),
        Text = Color3.fromRGB(20, 20, 20),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Primary = Color3.fromRGB(0, 122, 255),
        Success = Color3.fromRGB(52, 199, 89),
        Warning = Color3.fromRGB(255, 149, 0),
        Error = Color3.fromRGB(255, 59, 48)
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
    
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end
    
    local function onInputChanged(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end
    
    dragHandle.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
end

-- Key System
function ProfessionalUI:CreateKeySystem(config)
    config = config or {}
    local keySystemConfig = {
        Title = config.Title or "Professional UI v3.0",
        Description = config.Description or "Enter your access key to continue",
        Key = config.Key or "ProfessionalUI_v3",
        KeyLink = config.KeyLink or "https://example.com/getkey",
        Callback = config.Callback or function() end,
        Theme = config.Theme or "Dark"
    }
    
    local theme = Themes[keySystemConfig.Theme] or Themes.Dark
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystem_v3"
    screenGui.Parent = GuiParent
    screenGui.ResetOnSpawn = false
    
    -- Background blur
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backgroundFrame.BackgroundTransparency = 0.5
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = screenGui
    
    -- Main key frame
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 400, 0, 300)
    keyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    keyFrame.BackgroundColor3 = theme.Background
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = screenGui
    
    local keyFrameCorner = Instance.new("UICorner")
    keyFrameCorner.CornerRadius = UDim.new(0, 12)
    keyFrameCorner.Parent = keyFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = theme.Primary
    header.BorderSizePixel = 0
    header.Parent = keyFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0.5, 0)
    headerFix.Position = UDim2.new(0, 0, 0.5, 0)
    headerFix.BackgroundColor3 = theme.Primary
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = keySystemConfig.Title
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.SourceSansBold
    title.Parent = header
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -40, 0, 40)
    description.Position = UDim2.new(0, 20, 0, 80)
    description.BackgroundTransparency = 1
    description.Text = keySystemConfig.Description
    description.TextColor3 = theme.TextSecondary
    description.TextSize = 14
    description.Font = Enum.Font.SourceSans
    description.TextWrapped = true
    description.Parent = keyFrame
    
    -- Key input
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.Position = UDim2.new(0, 20, 0, 140)
    keyInput.BackgroundColor3 = theme.Secondary
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.TextColor3 = theme.Text
    keyInput.PlaceholderColor3 = theme.TextSecondary
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.SourceSans
    keyInput.Parent = keyFrame
    
    local keyInputCorner = Instance.new("UICorner")
    keyInputCorner.CornerRadius = UDim.new(0, 6)
    keyInputCorner.Parent = keyInput
    
    -- Buttons
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.45, 0, 0, 35)
    submitButton.Position = UDim2.new(0.05, 0, 0, 200)
    submitButton.BackgroundColor3 = theme.Success
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Submit Key"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.TextSize = 14
    submitButton.Font = Enum.Font.SourceSansBold
    submitButton.Parent = keyFrame
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 6)
    submitCorner.Parent = submitButton
    
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Size = UDim2.new(0.45, 0, 0, 35)
    getKeyButton.Position = UDim2.new(0.5, 0, 0, 200)
    getKeyButton.BackgroundColor3 = theme.Secondary
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Text = "Get Key"
    getKeyButton.TextColor3 = theme.Text
    getKeyButton.TextSize = 14
    getKeyButton.Font = Enum.Font.SourceSansBold
    getKeyButton.Parent = keyFrame
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 6)
    getKeyCorner.Parent = getKeyButton
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 250)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = theme.Error
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = keyFrame
    
    -- Make draggable
    MakeDraggable(keyFrame, header)
    
    -- Entrance animation
    keyFrame.Position = UDim2.new(0.5, -200, 1.5, 0)
    CreateTween(keyFrame, {Position = UDim2.new(0.5, -200, 0.5, -150)}, 0.5, Enum.EasingStyle.Back):Play()
    
    -- Button events
    submitButton.MouseButton1Click:Connect(function()
        if keyInput.Text == keySystemConfig.Key then
            statusLabel.Text = "✓ Key accepted! Loading..."
            statusLabel.TextColor3 = theme.Success
            
            wait(1)
            CreateTween(keyFrame, {Position = UDim2.new(0.5, -200, -1.5, 0)}, 0.5):Play()
            wait(0.5)
            screenGui:Destroy()
            keySystemConfig.Callback()
        else
            statusLabel.Text = "✗ Invalid key! Please try again."
            statusLabel.TextColor3 = theme.Error
            
            -- Shake animation
            local originalPos = keyFrame.Position
            for i = 1, 3 do
                CreateTween(keyFrame, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 10, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05):Play()
                wait(0.05)
                CreateTween(keyFrame, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 10, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05):Play()
                wait(0.05)
            end
            CreateTween(keyFrame, {Position = originalPos}, 0.1):Play()
        end
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(keySystemConfig.KeyLink)
            statusLabel.Text = "📋 Key link copied to clipboard!"
            statusLabel.TextColor3 = theme.Primary
        else
            statusLabel.Text = "Key link: " .. keySystemConfig.KeyLink
            statusLabel.TextColor3 = theme.Primary
        end
    end)
    
    return {
        Destroy = function()
            screenGui:Destroy()
        end
    }
end

-- Mini UI
function ProfessionalUI:CreateMiniUI(config)
    config = config or {}
    local miniConfig = {
        Title = config.Title or "UI",
        Position = config.Position or UDim2.new(0, 20, 0, 20),
        Theme = config.Theme or "Dark",
        OnToggle = config.OnToggle or function() end
    }
    
    local theme = Themes[miniConfig.Theme] or Themes.Dark
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MiniUI_v3"
    screenGui.Parent = GuiParent
    screenGui.ResetOnSpawn = false
    
    local miniFrame = Instance.new("Frame")
    miniFrame.Size = UDim2.new(0, 100, 0, 35)
    miniFrame.Position = miniConfig.Position
    miniFrame.BackgroundColor3 = theme.Background
    miniFrame.BorderSizePixel = 0
    miniFrame.Parent = screenGui
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 18)
    miniCorner.Parent = miniFrame
    
    local miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(1, 0, 1, 0)
    miniButton.BackgroundTransparency = 1
    miniButton.Text = miniConfig.Title
    miniButton.TextColor3 = theme.Text
    miniButton.TextSize = 12
    miniButton.Font = Enum.Font.SourceSansBold
    miniButton.Parent = miniFrame
    
    -- Make draggable
    MakeDraggable(miniFrame, miniFrame)
    
    -- Hover effects
    miniButton.MouseEnter:Connect(function()
        CreateTween(miniFrame, {
            Size = UDim2.new(0, 110, 0, 40),
            BackgroundColor3 = theme.Primary
        }, 0.2):Play()
    end)
    
    miniButton.MouseLeave:Connect(function()
        CreateTween(miniFrame, {
            Size = UDim2.new(0, 100, 0, 35),
            BackgroundColor3 = theme.Background
        }, 0.2):Play()
    end)
    
    miniButton.MouseButton1Click:Connect(function()
        miniConfig.OnToggle()
    end)
    
    return {
        Frame = miniFrame,
        Destroy = function()
            screenGui:Destroy()
        end,
        SetVisible = function(visible)
            screenGui.Enabled = visible
        end
    }
end

-- Main Window
function ProfessionalUI:CreateWindow(config)
    config = config or {}
    local windowConfig = {
        Title = config.Title or "Professional UI v3.0",
        Size = config.Size or Vector2.new(600, 400),
        Theme = config.Theme or "Dark",
        Draggable = config.Draggable ~= false,
        MinimizeToTray = config.MinimizeToTray ~= false
    }
    
    local currentTheme = Themes[windowConfig.Theme] or Themes.Dark
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ProfessionalUI_v3"
    screenGui.Parent = GuiParent
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, windowConfig.Size.X, 0, windowConfig.Size.Y)
    mainFrame.Position = UDim2.new(0.5, -windowConfig.Size.X/2, 0.5, -windowConfig.Size.Y/2)
    mainFrame.BackgroundColor3 = currentTheme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = currentTheme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
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
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Window controls
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 7.5)
    closeButton.BackgroundColor3 = currentTheme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -60, 0, 7.5)
    minimizeButton.BackgroundColor3 = currentTheme.Warning
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 16
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeButton
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 150, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundColor3 = currentTheme.Accent
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabContainer
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, -165, 1, -10)
    tabContent.Position = UDim2.new(0, 160, 0, 5)
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = contentFrame
    
    -- Make draggable
    if windowConfig.Draggable then
        MakeDraggable(mainFrame, titleBar)
    end
    
    -- Window controls
    local isMinimized = false
    local originalSize = mainFrame.Size
    local miniUI = nil
    
    closeButton.MouseButton1Click:Connect(function()
        CreateTween(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3):Play()
        wait(0.3)
        screenGui:Destroy()
        if miniUI then
            miniUI.Destroy()
        end
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            screenGui.Enabled = true
            CreateTween(mainFrame, {Size = originalSize}, 0.3):Play()
            isMinimized = false
            minimizeButton.Text = "−"
            if miniUI then
                miniUI.SetVisible(false)
            end
        else
            if windowConfig.MinimizeToTray then
                screenGui.Enabled = false
                if not miniUI then
                    miniUI = ProfessionalUI:CreateMiniUI({
                        Title = windowConfig.Title:sub(1, 8),
                        Theme = windowConfig.Theme,
                        OnToggle = function()
                            screenGui.Enabled = true
                            isMinimized = false
                            minimizeButton.Text = "−"
                            miniUI.SetVisible(false)
                        end
                    })
                else
                    miniUI.SetVisible(true)
                end
            else
                CreateTween(mainFrame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}, 0.3):Play()
            end
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
        CurrentTab = nil,
        MiniUI = miniUI
    }
    
    -- Tab creation
    function Window:CreateTab(config)
        config = config or {}
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or nil
        }
        
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 35)
        tabButton.Position = UDim2.new(0, 5, 0, 5 + #self.Tabs * 40)
        tabButton.BackgroundColor3 = self.Theme.Accent
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabConfig.Name
        tabButton.TextColor3 = self.Theme.TextSecondary
        tabButton.TextSize = 12
        tabButton.Font = Enum.Font.SourceSans
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Parent = self.TabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabButton
        
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, -10, 1, -10)
        tabFrame.Position = UDim2.new(0, 5, 0, 5)
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
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 12
            button.Font = Enum.Font.SourceSansBold
            button.Parent = self.Frame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = button
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = Color3.new(
                    Window.Theme.Primary.R * 1.2,
                    Window.Theme.Primary.G * 1.2,
                    Window.Theme.Primary.B * 1.2
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
            toggleLabel.Size = UDim2.new(1, -50, 1, 0)
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = toggleConfig.Text
            toggleLabel.TextColor3 = Window.Theme.Text
            toggleLabel.TextSize = 12
            toggleLabel.Font = Enum.Font.SourceSans
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 35, 0, 18)
            toggleButton.Position = UDim2.new(1, -40, 0.5, -9)
            toggleButton.BackgroundColor3 = toggleConfig.Default and Window.Theme.Success or Window.Theme.Accent
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            local toggleButtonCorner = Instance.new("UICorner")
            toggleButtonCorner.CornerRadius = UDim.new(0, 9)
            toggleButtonCorner.Parent = toggleButton
            
            local toggleIndicator = Instance.new("Frame")
            toggleIndicator.Size = UDim2.new(0, 14, 0, 14)
            toggleIndicator.Position = toggleConfig.Default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleIndicator.BorderSizePixel = 0
            toggleIndicator.Parent = toggleButton
            
            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(0, 7)
            indicatorCorner.Parent = toggleIndicator
            
            local enabled = toggleConfig.Default
            
            toggleButton.MouseButton1Click:Connect(function()
                enabled = not enabled
                
                local indicatorPos = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
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
                    local indicatorPos = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local buttonColor = enabled and Window.Theme.Success or Window.Theme.Accent
                    CreateTween(toggleIndicator, {Position = indicatorPos}, 0.2):Play()
                    CreateTween(toggleButton, {BackgroundColor3 = buttonColor}, 0.2):Play()
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
            label.TextSize = 12
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
        tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.CurrentTab = tab
    end
    
    function Window:Destroy()
        if miniUI then
            miniUI.Destroy()
        end
        screenGui:Destroy()
    end
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    CreateTween(mainFrame, {
        Size = UDim2.new(0, windowConfig.Size.X, 0, windowConfig.Size.Y),
        Position = UDim2.new(0.5, -windowConfig.Size.X/2, 0.5, -windowConfig.Size.Y/2)
    }, 0.5, Enum.EasingStyle.Back):Play()
    
    return Window
end

return ProfessionalUI
