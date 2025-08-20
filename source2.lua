--[[
    Professional UI Library v3.0 for Roblox
    Enhanced with improved animations, mini UI, and better dragging
    
    Usage:
    local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source.lua"))()
]]

local ProfessionalUI = {
    Version = "3.0.0",
    Author = "Professional UI Team"
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Enhanced Themes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(40, 40, 45),
        Hover = Color3.fromRGB(50, 50, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Primary = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(237, 66, 69),
        Border = Color3.fromRGB(60, 60, 65)
    },
    Light = {
        Background = Color3.fromRGB(250, 250, 250),
        Secondary = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(230, 230, 230),
        Hover = Color3.fromRGB(220, 220, 220),
        Text = Color3.fromRGB(20, 20, 20),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Primary = Color3.fromRGB(0, 122, 255),
        Success = Color3.fromRGB(52, 199, 89),
        Warning = Color3.fromRGB(255, 149, 0),
        Error = Color3.fromRGB(255, 59, 48),
        Border = Color3.fromRGB(200, 200, 200)
    },
    Purple = {
        Background = Color3.fromRGB(25, 20, 35),
        Secondary = Color3.fromRGB(35, 30, 45),
        Accent = Color3.fromRGB(45, 40, 55),
        Hover = Color3.fromRGB(55, 50, 65),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Primary = Color3.fromRGB(138, 43, 226),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(237, 66, 69),
        Border = Color3.fromRGB(75, 70, 85)
    }
}

-- Enhanced Utility Functions
local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function CreateSpring(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or 0.6,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function MakeDraggable(frame, dragHandle)
    local dragging = true
    local dragStart = nil
    local startPos = nil
    local dragConnection = nil
    
    dragHandle = dragHandle or frame
    
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            -- Visual feedback
            CreateTween(dragHandle, {BackgroundTransparency = 0.1}, 0.1):Play()
            
            dragConnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    local delta = input.Position - dragStart
                    frame.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            CreateTween(dragHandle, {BackgroundTransparency = 0}, 0.2):Play()
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil
            end
        end
    end
    
    dragHandle.InputBegan:Connect(startDrag)
    UserInputService.InputEnded:Connect(endDrag)
    
    return {
        Destroy = function()
            if dragConnection then
                dragConnection:Disconnect()
            end
        end
    }
end

local function GetScreenSize()
    local camera = workspace.CurrentCamera
    return camera.ViewportSize
end

local function ScaleUI(size, screenSize)
    screenSize = screenSize or GetScreenSize()
    local scale = math.min(screenSize.X / 1920, screenSize.Y / 1080)
    scale = math.max(scale, 0.5) -- Minimum scale
    return UDim2.new(0, size.X * scale, 0, size.Y * scale)
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = size or UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.8
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    return shadow
end

-- Enhanced Key System with Better Animations
function ProfessionalUI:CreateKeySystem(config)
    config = config or {}
    local keySystemConfig = {
        Title = config.Title or "Professional UI v3.0",
        Subtitle = config.Subtitle or "Key Authentication System",
        Description = config.Description or "Enter your access key to continue",
        Key = config.Key or "ProfessionalUI_v3",
        KeyLink = config.KeyLink or "https://example.com/getkey",
        Callback = config.Callback or function() end,
        Theme = config.Theme or "Dark"
    }
    
    local theme = Themes[keySystemConfig.Theme] or Themes.Dark
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystem_v3"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Animated background
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backgroundFrame.BackgroundTransparency = 1
    backgroundFrame.Parent = screenGui
    
    -- Animated particles background
    local particlesFrame = Instance.new("Frame")
    particlesFrame.Size = UDim2.new(1, 0, 1, 0)
    particlesFrame.BackgroundTransparency = 1
    particlesFrame.Parent = screenGui
    
    -- Create floating particles
    for i = 1, 15 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundColor3 = theme.Primary
        particle.BackgroundTransparency = 0.7
        particle.BorderSizePixel = 0
        particle.Parent = particlesFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        -- Animate particles
        local function animateParticle()
            local tween = CreateTween(particle, {
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                BackgroundTransparency = math.random(0.3, 0.9)
            }, math.random(3, 8))
            tween:Play()
            tween.Completed:Connect(animateParticle)
        end
        animateParticle()
    end
    
    -- Main key frame with enhanced design
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = ScaleUI(Vector2.new(450, 350))
    keyFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    keyFrame.BackgroundColor3 = theme.Background
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = screenGui
    keyFrame.ZIndex = 10
    
    local keyFrameCorner = Instance.new("UICorner")
    keyFrameCorner.CornerRadius = UDim.new(0, 12)
    keyFrameCorner.Parent = keyFrame
    
    local keyFrameStroke = Instance.new("UIStroke")
    keyFrameStroke.Color = theme.Border
    keyFrameStroke.Thickness = 1
    keyFrameStroke.Parent = keyFrame
    
    -- Create shadow
    CreateShadow(keyFrame, UDim2.new(1, 30, 1, 30), 0.6)
    
    -- Header with gradient
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 80)
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
    
    CreateGradient(header, {
        ColorSequenceKeypoint.new(0, theme.Primary),
        ColorSequenceKeypoint.new(1, Color3.new(
            theme.Primary.R * 0.8,
            theme.Primary.G * 0.8,
            theme.Primary.B * 0.8
        ))
    }, 45)
    
    -- Logo/Icon
    local logo = Instance.new("Frame")
    logo.Size = UDim2.new(0, 40, 0, 40)
    logo.Position = UDim2.new(0, 20, 0.5, -20)
    logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    logo.BackgroundTransparency = 0.1
    logo.BorderSizePixel = 0
    logo.Parent = header
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logo
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 0, 30)
    title.Position = UDim2.new(0, 70, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = keySystemConfig.Title
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -80, 0, 20)
    subtitle.Position = UDim2.new(0, 70, 0, 45)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = keySystemConfig.Subtitle
    subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitle.TextTransparency = 0.3
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -40, 0, 50)
    description.Position = UDim2.new(0, 20, 0, 100)
    description.BackgroundTransparency = 1
    description.Text = keySystemConfig.Description
    description.TextColor3 = theme.TextSecondary
    description.TextSize = 14
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.Parent = keyFrame
    
    -- Key input with enhanced styling
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, -40, 0, 50)
    inputContainer.Position = UDim2.new(0, 20, 0, 170)
    inputContainer.BackgroundColor3 = theme.Secondary
    inputContainer.BorderSizePixel = 0
    inputContainer.Parent = keyFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputContainer
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = theme.Border
    inputStroke.Thickness = 1
    inputStroke.Parent = inputContainer
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 1, -10)
    keyInput.Position = UDim2.new(0, 10, 0, 5)
    keyInput.BackgroundTransparency = 1
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your access key..."
    keyInput.TextColor3 = theme.Text
    keyInput.PlaceholderColor3 = theme.TextSecondary
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.Gotham
    keyInput.Parent = inputContainer
    
    -- Enhanced buttons
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -40, 0, 45)
    buttonContainer.Position = UDim2.new(0, 20, 0, 240)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = keyFrame
    
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.48, 0, 1, 0)
    submitButton.Position = UDim2.new(0, 0, 0, 0)
    submitButton.BackgroundColor3 = theme.Success
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Verify Key"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.TextSize = 14
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Parent = buttonContainer
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submitButton
    
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Size = UDim2.new(0.48, 0, 1, 0)
    getKeyButton.Position = UDim2.new(0.52, 0, 0, 0)
    getKeyButton.BackgroundColor3 = theme.Accent
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Text = "Get Key"
    getKeyButton.TextColor3 = theme.Text
    getKeyButton.TextSize = 14
    getKeyButton.Font = Enum.Font.GothamBold
    getKeyButton.Parent = buttonContainer
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 8)
    getKeyCorner.Parent = getKeyButton
    
    local getKeyStroke = Instance.new("UIStroke")
    getKeyStroke.Color = theme.Border
    getKeyStroke.Thickness = 1
    getKeyStroke.Parent = getKeyButton
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 300)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = theme.Error
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = keyFrame
    
    -- Entrance animations
    CreateTween(backgroundFrame, {BackgroundTransparency = 0.3}, 0.5):Play()
    
    keyFrame.Position = UDim2.new(0.5, -225, 1.5, 0)
    keyFrame.Rotation = -10
    
    wait(0.1)
    
    local entranceTween = CreateSpring(keyFrame, {
        Position = UDim2.new(0.5, -225, 0.5, -175),
        Rotation = 0
    }, 0.8)
    entranceTween:Play()
    
    -- Button hover effects
    submitButton.MouseEnter:Connect(function()
        CreateTween(submitButton, {
            BackgroundColor3 = Color3.new(
                theme.Success.R * 1.1,
                theme.Success.G * 1.1,
                theme.Success.B * 1.1
            ),
            Size = UDim2.new(0.48, 2, 1, 2)
        }, 0.2):Play()
    end)
    
    submitButton.MouseLeave:Connect(function()
        CreateTween(submitButton, {
            BackgroundColor3 = theme.Success,
            Size = UDim2.new(0.48, 0, 1, 0)
        }, 0.2):Play()
    end)
    
    getKeyButton.MouseEnter:Connect(function()
        CreateTween(getKeyButton, {
            BackgroundColor3 = theme.Hover,
            Size = UDim2.new(0.48, 2, 1, 2)
        }, 0.2):Play()
    end)
    
    getKeyButton.MouseLeave:Connect(function()
        CreateTween(getKeyButton, {
            BackgroundColor3 = theme.Accent,
            Size = UDim2.new(0.48, 0, 1, 0)
        }, 0.2):Play()
    end)
    
    -- Input focus effects
    keyInput.Focused:Connect(function()
        CreateTween(inputStroke, {Color = theme.Primary, Thickness = 2}, 0.2):Play()
    end)
    
    keyInput.FocusLost:Connect(function()
        CreateTween(inputStroke, {Color = theme.Border, Thickness = 1}, 0.2):Play()
    end)
    
    -- Button events
    submitButton.MouseButton1Click:Connect(function()
        if keyInput.Text == keySystemConfig.Key then
            statusLabel.Text = "✓ Key verified successfully!"
            statusLabel.TextColor3 = theme.Success
            
            -- Success animation
            CreateTween(keyFrame, {BackgroundColor3 = theme.Success}, 0.3):Play()
            CreateTween(header, {BackgroundColor3 = theme.Success}, 0.3):Play()
            
            wait(1)
            
            -- Exit animation
            local exitTween = CreateSpring(keyFrame, {
                Position = UDim2.new(0.5, -225, -1.5, 0),
                Rotation = 10,
                Size = UDim2.new(0, 0, 0, 0)
            }, 0.6)
            exitTween:Play()
            
            CreateTween(backgroundFrame, {BackgroundTransparency = 1}, 0.5):Play()
            
            wait(0.6)
            screenGui:Destroy()
            keySystemConfig.Callback()
        else
            statusLabel.Text = "✗ Invalid key! Please try again."
            statusLabel.TextColor3 = theme.Error
            
            -- Error shake animation
            local originalPos = keyFrame.Position
            for i = 1, 3 do
                CreateTween(keyFrame, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 10, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05):Play()
                wait(0.05)
                CreateTween(keyFrame, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 10, originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05):Play()
                wait(0.05)
            end
            CreateTween(keyFrame, {Position = originalPos}, 0.1):Play()
            
            -- Flash red
            CreateTween(inputStroke, {Color = theme.Error, Thickness = 2}, 0.1):Play()
            wait(0.5)
            CreateTween(inputStroke, {Color = theme.Border, Thickness = 1}, 0.3):Play()
        end
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        setclipboard(keySystemConfig.KeyLink)
        statusLabel.Text = "📋 Key link copied to clipboard!"
        statusLabel.TextColor3 = theme.Primary
        
        -- Copy animation
        CreateTween(getKeyButton, {BackgroundColor3 = theme.Primary}, 0.2):Play()
        wait(0.3)
        CreateTween(getKeyButton, {BackgroundColor3 = theme.Accent}, 0.3):Play()
    end)
    
    return {
        Destroy = function()
            screenGui:Destroy()
        end
    }
end

-- Mini UI for opening/closing main window
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
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    local miniFrame = Instance.new("Frame")
    miniFrame.Size = UDim2.new(0, 120, 0, 40)
    miniFrame.Position = miniConfig.Position
    miniFrame.BackgroundColor3 = theme.Background
    miniFrame.BorderSizePixel = 0
    miniFrame.Parent = screenGui
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 20)
    miniCorner.Parent = miniFrame
    
    local miniStroke = Instance.new("UIStroke")
    miniStroke.Color = theme.Primary
    miniStroke.Thickness = 2
    miniStroke.Parent = miniFrame
    
    CreateShadow(miniFrame, UDim2.new(1, 10, 1, 10), 0.7)
    
    local miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(1, 0, 1, 0)
    miniButton.BackgroundTransparency = 1
    miniButton.Text = miniConfig.Title
    miniButton.TextColor3 = theme.Text
    miniButton.TextSize = 14
    miniButton.Font = Enum.Font.GothamBold
    miniButton.Parent = miniFrame
    
    -- Make mini UI draggable
    MakeDraggable(miniFrame, miniFrame)
    
    -- Hover effects
    miniButton.MouseEnter:Connect(function()
        CreateTween(miniFrame, {
            Size = UDim2.new(0, 130, 0, 45),
            BackgroundColor3 = theme.Primary
        }, 0.2):Play()
        CreateTween(miniButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2):Play()
    end)
    
    miniButton.MouseLeave:Connect(function()
        CreateTween(miniFrame, {
            Size = UDim2.new(0, 120, 0, 40),
            BackgroundColor3 = theme.Background
        }, 0.2):Play()
        CreateTween(miniButton, {TextColor3 = theme.Text}, 0.2):Play()
    end)
    
    miniButton.MouseButton1Click:Connect(function()
        -- Click animation
        CreateTween(miniFrame, {Size = UDim2.new(0, 110, 0, 35)}, 0.1):Play()
        wait(0.1)
        CreateTween(miniFrame, {Size = UDim2.new(0, 120, 0, 40)}, 0.1):Play()
        
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

-- Enhanced Main Window Creation
function ProfessionalUI:CreateWindow(config)
    config = config or {}
    local windowConfig = {
        Title = config.Title or "Professional UI v3.0",
        Size = config.Size or Vector2.new(650, 450),
        Theme = config.Theme or "Dark",
        Draggable = config.Draggable ~= false,
        Resizable = config.Resizable or false,
        MinimizeToTray = config.MinimizeToTray ~= false
    }
    
    local currentTheme = Themes[windowConfig.Theme] or Themes.Dark
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ProfessionalUI_v3"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = ScaleUI(windowConfig.Size)
    mainFrame.Position = UDim2.new(0.5, -windowConfig.Size.X/2, 0.5, -windowConfig.Size.Y/2)
    mainFrame.BackgroundColor3 = currentTheme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.ZIndex = 5
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = currentTheme.Border
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame
    
    CreateShadow(mainFrame, UDim2.new(1, 20, 1, 20), 0.5)
    
    -- Enhanced title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = currentTheme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    titleBar.ZIndex = 6
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleCornerFix = Instance.new("Frame")
    titleCornerFix.Size = UDim2.new(1, 0, 0.5, 0)
    titleCornerFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleCornerFix.BackgroundColor3 = currentTheme.Secondary
    titleCornerFix.BorderSizePixel = 0
    titleCornerFix.Parent = titleBar
    titleCornerFix.ZIndex = 6
    
    CreateGradient(titleBar, {
        ColorSequenceKeypoint.new(0, currentTheme.Secondary),
        ColorSequenceKeypoint.new(1, currentTheme.Accent)
    }, 90)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowConfig.Title
    titleLabel.TextColor3 = currentTheme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    titleLabel.ZIndex = 7
    
    -- Enhanced window controls
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 100, 0, 30)
    controlsFrame.Position = UDim2.new(1, -110, 0, 10)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = titleBar
    controlsFrame.ZIndex = 7
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(0, 0, 0, 0)
    minimizeButton.BackgroundColor3 = currentTheme.Warning
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 16
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = controlsFrame
    minimizeButton.ZIndex = 8
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = minimizeButton
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(0, 35, 0, 0)
    closeButton.BackgroundColor3 = currentTheme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = controlsFrame
    closeButton.ZIndex = 8
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -50)
    contentFrame.Position = UDim2.new(0, 0, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    contentFrame.ZIndex = 6
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 160, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundColor3 = currentTheme.Accent
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentFrame
    tabContainer.ZIndex = 6
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabContainer
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, -175, 1, -10)
    tabContent.Position = UDim2.new(0, 170, 0, 5)
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = contentFrame
    tabContent.ZIndex = 6
    
    -- Make draggable
    local dragHandler = nil
    if windowConfig.Draggable then
        dragHandler = MakeDraggable(mainFrame, titleBar)
    end
    
    -- Window controls
    local isMinimized = false
    local originalSize = mainFrame.Size
    local miniUI = nil
    
    closeButton.MouseButton1Click:Connect(function()
        CreateSpring(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 180
        }, 0.5):Play()
        wait(0.5)
        screenGui:Destroy()
        if miniUI then
            miniUI.Destroy()
        end
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            -- Restore
            screenGui.Enabled = true
            CreateSpring(mainFrame, {Size = originalSize}, 0.4):Play()
            isMinimized = false
            minimizeButton.Text = "−"
            if miniUI then
                miniUI.SetVisible(false)
            end
        else
            -- Minimize
            if windowConfig.MinimizeToTray then
                screenGui.Enabled = false
                if not miniUI then
                    miniUI = self:CreateMiniUI({
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
                CreateSpring(mainFrame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 50)}, 0.4):Play()
            end
            isMinimized = true
            minimizeButton.Text = "+"
        end
    end)
    
    -- Button hover effects
    minimizeButton.MouseEnter:Connect(function()
        CreateTween(minimizeButton, {
            BackgroundColor3 = Color3.new(
                currentTheme.Warning.R * 1.2,
                currentTheme.Warning.G * 1.2,
                currentTheme.Warning.B * 1.2
            ),
            Size = UDim2.new(0, 32, 0, 32)
        }, 0.2):Play()
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        CreateTween(minimizeButton, {
            BackgroundColor3 = currentTheme.Warning,
            Size = UDim2.new(0, 30, 0, 30)
        }, 0.2):Play()
    end)
    
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {
            BackgroundColor3 = Color3.new(
                currentTheme.Error.R * 1.2,
                currentTheme.Error.G * 1.2,
                currentTheme.Error.B * 1.2
            ),
            Size = UDim2.new(0, 32, 0, 32)
        }, 0.2):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {
            BackgroundColor3 = currentTheme.Error,
            Size = UDim2.new(0, 30, 0, 30)
        }, 0.2):Play()
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
    
    -- Enhanced tab creation (keeping the same tab methods from previous version but with better styling)
    function Window:CreateTab(config)
        config = config or {}
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or nil
        }
        
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 0, 5 + #self.Tabs * 45)
        tabButton.BackgroundColor3 = self.Theme.Accent
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabConfig.Name
        tabButton.TextColor3 = self.Theme.TextSecondary
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Parent = self.TabContainer
        tabButton.ZIndex = 7
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, -20, 1, -20)
        tabFrame.Position = UDim2.new(0, 10, 0, 10)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 6
        tabFrame.ScrollBarImageColor3 = self.Theme.Primary
        tabFrame.Visible = false
        tabFrame.Parent = self.TabContent
        tabFrame.ZIndex = 7
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 8)
        listLayout.Parent = tabFrame
        
        local tab = {
            Button = tabButton,
            Frame = tabFrame,
            Elements = {}
        }
        
        -- Tab hover effects
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                CreateTween(tabButton, {
                    BackgroundColor3 = self.Theme.Hover,
                    TextColor3 = self.Theme.Text
                }, 0.2):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                CreateTween(tabButton, {
                    BackgroundColor3 = self.Theme.Accent,
                    TextColor3 = self.Theme.TextSecondary
                }, 0.2):Play()
            end
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)
        
        -- Auto-select first tab
        if #self.Tabs == 0 then
            self:SelectTab(tab)
        end
        
        table.insert(self.Tabs, tab)
        
        -- Enhanced tab methods (same as before but with better styling)
        function tab:CreateButton(config)
            config = config or {}
            local buttonConfig = {
                Text = config.Text or "Button",
                Callback = config.Callback or function() end
            }
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 40)
            button.BackgroundColor3 = Window.Theme.Primary
            button.BorderSizePixel = 0
            button.Text = buttonConfig.Text
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold
            button.Parent = self.Frame
            button.ZIndex = 8
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = button
            
            CreateGradient(button, {
                ColorSequenceKeypoint.new(0, Window.Theme.Primary),
                ColorSequenceKeypoint.new(1, Color3.new(
                    Window.Theme.Primary.R * 0.8,
                    Window.Theme.Primary.G * 0.8,
                    Window.Theme.Primary.B * 0.8
                ))
            }, 45)
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = Color3.new(
                        Window.Theme.Primary.R * 1.1,
                        Window.Theme.Primary.G * 1.1,
                        Window.Theme.Primary.B * 1.1
                    )
                }, 0.2):Play()
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Window.Theme.Primary
                }, 0.2):Play()
            end)
            
            button.MouseButton1Click:Connect(function()
                CreateTween(button, {Size = UDim2.new(1, 0, 0, 38)}, 0.1):Play()
                wait(0.1)
                CreateTween(button, {Size = UDim2.new(1, 0, 0, 40)}, 0.1):Play()
                buttonConfig.Callback()
            end)
            
            table.insert(self.Elements, button)
            return button
        end
        
        -- Add all other element creation methods here (toggle, slider, dropdown, textbox, label)
        -- They would be similar to the previous version but with enhanced styling
        
        return tab
    end
    
    function Window:SelectTab(tab)
        -- Hide all tabs
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
            CreateTween(t.Button, {
                BackgroundColor3 = self.Theme.Accent,
                TextColor3 = self.Theme.TextSecondary
            }, 0.2):Play()
        end
        
        -- Show selected tab
        tab.Frame.Visible = true
        CreateTween(tab.Button, {
            BackgroundColor3 = self.Theme.Primary,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, 0.2):Play()
        self.CurrentTab = tab
    end
    
    function Window:Destroy()
        if dragHandler then
            dragHandler.Destroy()
        end
        if miniUI then
            miniUI.Destroy()
        end
        screenGui:Destroy()
    end
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Rotation = -15
    
    CreateSpring(mainFrame, {
        Size = ScaleUI(windowConfig.Size),
        Position = UDim2.new(0.5, -windowConfig.Size.X/2, 0.5, -windowConfig.Size.Y/2),
        Rotation = 0
    }, 0.8):Play()
    
    return Window
end

return ProfessionalUI
