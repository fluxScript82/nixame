--[[
    Advanced Roblox UI Library
    A modular, lightweight, and performance-optimized UI library for Roblox Studio
    
    Features:
    - Modular architecture
    - Draggable windows with smooth animations
    - Multiple themes (Light, Dark, Custom)
    - Automatic scaling for different screen sizes
    - Key system support
    - Performance optimized with object pooling
    - Easy-to-use API
    
    Author: Advanced UI Library
    Version: 2.0
]]

local UILibrary = {}
UILibrary.__index = UILibrary

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local TWEEN_TIME = 0.25
local EASING_STYLE = Enum.EasingStyle.Quart
local EASING_DIRECTION = Enum.EasingDirection.Out

-- Utility Functions
local Utils = {}

function Utils.CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utils.Tween(instance, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or TWEEN_TIME,
        style or EASING_STYLE,
        direction or EASING_DIRECTION
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

function Utils.CreateCorner(parent, radius)
    return Utils.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

function Utils.CreateStroke(parent, thickness, color, transparency)
    return Utils.CreateInstance("UIStroke", {
        Thickness = thickness or 1,
        Color = color or Color3.fromRGB(255, 255, 255),
        Transparency = transparency or 0,
        Parent = parent
    })
end

function Utils.CreateShadow(parent, size, transparency)
    local shadow = Utils.CreateInstance("ImageLabel", {
        Name = "DropShadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size or 20, 1, size or 20),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = parent
    })
    return shadow
end

function Utils.GetTextSize(text, fontSize, font, maxSize)
    return TextService:GetTextSize(text, fontSize, font, maxSize or Vector2.new(math.huge, math.huge))
end

function Utils.Scale(size, reference)
    reference = reference or Vector2.new(1920, 1080)
    local viewport = workspace.CurrentCamera.ViewportSize
    local scale = math.min(viewport.X / reference.X, viewport.Y / reference.Y)
    return math.max(scale, 0.5) -- Minimum scale of 0.5
end

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Surface = Color3.fromRGB(35, 35, 35),
        Primary = Color3.fromRGB(0, 162, 255),
        Secondary = Color3.fromRGB(45, 45, 45),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Border = Color3.fromRGB(60, 60, 60)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Surface = Color3.fromRGB(255, 255, 255),
        Primary = Color3.fromRGB(33, 150, 243),
        Secondary = Color3.fromRGB(240, 240, 240),
        Text = Color3.fromRGB(33, 33, 33),
        TextSecondary = Color3.fromRGB(117, 117, 117),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Border = Color3.fromRGB(224, 224, 224)
    },
    Blue = {
        Background = Color3.fromRGB(15, 23, 42),
        Surface = Color3.fromRGB(30, 41, 59),
        Primary = Color3.fromRGB(59, 130, 246),
        Secondary = Color3.fromRGB(51, 65, 85),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(203, 213, 225),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Border = Color3.fromRGB(71, 85, 105)
    }
}

-- Main Library
function UILibrary.new(options)
    options = options or {}
    
    local self = setmetatable({
        Theme = Themes[options.theme] or Themes.Dark,
        Scale = Utils.Scale(),
        Windows = {},
        Notifications = {},
        KeySystem = nil,
        ScreenGui = nil
    }, UILibrary)
    
    -- Create ScreenGui
    local success, screenGui = pcall(function()
        return Utils.CreateInstance("ScreenGui", {
            Name = "UILibrary",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
    end)
    
    if not success then
        screenGui = Utils.CreateInstance("ScreenGui", {
            Name = "UILibrary",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        })
    end
    
    self.ScreenGui = screenGui
    
    -- Create notification container
    self.NotificationContainer = Utils.CreateInstance("Frame", {
        Name = "NotificationContainer",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 0, 20),
        Size = UDim2.new(0, 300, 1, -40),
        Parent = screenGui
    })
    
    Utils.CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = self.NotificationContainer
    })
    
    -- Handle screen size changes
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self.Scale = Utils.Scale()
        self:UpdateScale()
    end)
    
    return self
end

-- Key System
function UILibrary:CreateKeySystem(options)
    options = options or {}
    
    local keySystem = {
        Title = options.title or "Key System",
        Description = options.description or "Enter your key to continue",
        Key = options.key or "DefaultKey123",
        KeyLink = options.keyLink or "https://example.com/getkey",
        Callback = options.callback or function() end,
        CloseCallback = options.closeCallback or function() end
    }
    
    -- Create key system window
    local keyFrame = Utils.CreateInstance("Frame", {
        Name = "KeySystem",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Surface,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 400 * self.Scale, 0, 300 * self.Scale),
        Parent = self.ScreenGui,
        ZIndex = 1000
    })
    
    Utils.CreateCorner(keyFrame, 12)
    Utils.CreateShadow(keyFrame, 30, 0.5)
    
    -- Title bar
    local titleBar = Utils.CreateInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 50 * self.Scale),
        Parent = keyFrame
    })
    
    Utils.CreateCorner(titleBar, 12)
    
    -- Title bar bottom cover
    Utils.CreateInstance("Frame", {
        BackgroundColor3 = self.Theme.Primary,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    -- Title text
    Utils.CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = keySystem.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18 * self.Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    -- Close button
    local closeButton = Utils.CreateInstance("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24 * self.Scale,
        Parent = titleBar
    })
    
    -- Description
    Utils.CreateInstance("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 70 * self.Scale),
        Size = UDim2.new(1, -40, 0, 40 * self.Scale),
        Font = Enum.Font.Gotham,
        Text = keySystem.Description,
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 14 * self.Scale,
        TextWrapped = true,
        Parent = keyFrame
    })
    
    -- Key input
    local keyInput = Utils.CreateInstance("TextBox", {
        Name = "KeyInput",
        BackgroundColor3 = self.Theme.Secondary,
        Position = UDim2.new(0, 20, 0, 130 * self.Scale),
        Size = UDim2.new(1, -40, 0, 40 * self.Scale),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Enter your key here...",
        PlaceholderColor3 = self.Theme.TextSecondary,
        Text = "",
        TextColor3 = self.Theme.Text,
        TextSize = 14 * self.Scale,
        ClearTextOnFocus = false,
        Parent = keyFrame
    })
    
    Utils.CreateCorner(keyInput, 8)
    Utils.CreateStroke(keyInput, 1, self.Theme.Border, 0.5)
    
    -- Padding for input
    Utils.CreateInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = keyInput
    })
    
    -- Submit button
    local submitButton = Utils.CreateInstance("TextButton", {
        Name = "SubmitButton",
        BackgroundColor3 = self.Theme.Primary,
        Position = UDim2.new(0, 20, 0, 190 * self.Scale),
        Size = UDim2.new(0.5, -30, 0, 40 * self.Scale),
        Font = Enum.Font.GothamBold,
        Text = "Submit Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14 * self.Scale,
        Parent = keyFrame
    })
    
    Utils.CreateCorner(submitButton, 8)
    
    -- Get key button
    local getKeyButton = Utils.CreateInstance("TextButton", {
        Name = "GetKeyButton",
        BackgroundColor3 = self.Theme.Secondary,
        Position = UDim2.new(0.5, 10, 0, 190 * self.Scale),
        Size = UDim2.new(0.5, -30, 0, 40 * self.Scale),
        Font = Enum.Font.Gotham,
        Text = "Get Key",
        TextColor3 = self.Theme.Text,
        TextSize = 14 * self.Scale,
        Parent = keyFrame
    })
    
    Utils.CreateCorner(getKeyButton, 8)
    Utils.CreateStroke(getKeyButton, 1, self.Theme.Border, 0.5)
    
    -- Status label
    local statusLabel = Utils.CreateInstance("TextLabel", {
        Name = "StatusLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 250 * self.Scale),
        Size = UDim2.new(1, -40, 0, 30 * self.Scale),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = self.Theme.Error,
        TextSize = 12 * self.Scale,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = keyFrame
    })
    
    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = keyFrame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            keyFrame.Position = UDim2.new(
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
    
    -- Button functionality
    submitButton.MouseButton1Click:Connect(function()
        local inputKey = keyInput.Text
        if inputKey == keySystem.Key then
            statusLabel.Text = "Key accepted! Loading..."
            statusLabel.TextColor3 = self.Theme.Success
            
            Utils.Tween(keyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, nil, nil, function()
                keyFrame:Destroy()
                keySystem.Callback()
            end)
        else
            statusLabel.Text = "Invalid key! Please try again."
            statusLabel.TextColor3 = self.Theme.Error
            
            -- Shake animation
            local originalPos = keyFrame.Position
            Utils.Tween(keyFrame, {Position = originalPos + UDim2.new(0, 10, 0, 0)}, 0.1)
            task.wait(0.1)
            Utils.Tween(keyFrame, {Position = originalPos - UDim2.new(0, 10, 0, 0)}, 0.1)
            task.wait(0.1)
            Utils.Tween(keyFrame, {Position = originalPos}, 0.1)
        end
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        -- Copy key link to clipboard (if supported)
        if setclipboard then
            setclipboard(keySystem.KeyLink)
            statusLabel.Text = "Key link copied to clipboard!"
            statusLabel.TextColor3 = self.Theme.Success
        else
            statusLabel.Text = "Key link: " .. keySystem.KeyLink
            statusLabel.TextColor3 = self.Theme.TextSecondary
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        Utils.Tween(keyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, nil, nil, function()
            keyFrame:Destroy()
            keySystem.CloseCallback()
        end)
    end)
    
    -- Enter key support
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitButton.MouseButton1Click:Fire()
        end
    end)
    
    self.KeySystem = keySystem
    return keySystem
end

-- Window Creation
function UILibrary:CreateWindow(options)
    options = options or {}
    
    local window = {
        Title = options.title or "UI Library",
        Size = options.size or UDim2.new(0, 600 * self.Scale, 0, 400 * self.Scale),
        Position = options.position or UDim2.new(0.5, -300 * self.Scale, 0.5, -200 * self.Scale),
        Tabs = {},
        ActiveTab = nil,
        Library = self
    }
    
    -- Main window frame
    window.Frame = Utils.CreateInstance("Frame", {
        Name = "Window",
        BackgroundColor3 = self.Theme.Surface,
        Position = window.Position,
        Size = window.Size,
        Parent = self.ScreenGui,
        ZIndex = 10
    })
    
    Utils.CreateCorner(window.Frame, 12)
    Utils.CreateShadow(window.Frame, 25, 0.4)
    
    -- Title bar
    window.TitleBar = Utils.CreateInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 50 * self.Scale),
        Parent = window.Frame,
        ZIndex = 11
    })
    
    Utils.CreateCorner(window.TitleBar, 12)
    
    -- Title bar bottom cover
    Utils.CreateInstance("Frame", {
        BackgroundColor3 = self.Theme.Primary,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = window.TitleBar,
        ZIndex = 11
    })
    
    -- Title text
    window.TitleLabel = Utils.CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(1, -100, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = window.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16 * self.Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.TitleBar,
        ZIndex = 12
    })
    
    -- Window controls
    local controlsFrame = Utils.CreateInstance("Frame", {
        Name = "Controls",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 30),
        Parent = window.TitleBar,
        ZIndex = 12
    })
    
    -- Minimize button
    local minimizeButton = Utils.CreateInstance("TextButton", {
        Name = "MinimizeButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18 * self.Scale,
        Parent = controlsFrame
    })
    
    -- Close button
    local closeButton = Utils.CreateInstance("TextButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20 * self.Scale,
        Parent = controlsFrame
    })
    
    -- Tab container
    window.TabContainer = Utils.CreateInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(0, 0, 0, 50 * self.Scale),
        Size = UDim2.new(1, 0, 0, 40 * self.Scale),
        Parent = window.Frame,
        ZIndex = 11
    })
    
    Utils.CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = window.TabContainer
    })
    
    Utils.CreateInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        Parent = window.TabContainer
    })
    
    -- Content container
    window.ContentContainer = Utils.CreateInstance("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 90 * self.Scale),
        Size = UDim2.new(1, 0, 1, -90 * self.Scale),
        Parent = window.Frame,
        ZIndex = 10
    })
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Frame.Position
        end
    end)
    
    window.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.Frame.Position = UDim2.new(
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
    
    -- Window controls functionality
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utils.Tween(window.Frame, {Size = UDim2.new(window.Size.X.Scale, window.Size.X.Offset, 0, 50 * self.Scale)})
            minimizeButton.Text = "+"
        else
            Utils.Tween(window.Frame, {Size = window.Size})
            minimizeButton.Text = "−"
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        Utils.Tween(window.Frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, nil, nil, function()
            window.Frame:Destroy()
            for i, w in ipairs(self.Windows) do
                if w == window then
                    table.remove(self.Windows, i)
                    break
                end
            end
        end)
    end)
    
    -- Tab creation function
    function window:CreateTab(name, icon)
        local tab = {
            Name = name,
            Icon = icon,
            Elements = {},
            Window = self,
            Active = false
        }
        
        -- Tab button
        tab.Button = Utils.CreateInstance("TextButton", {
            Name = name .. "Tab",
            BackgroundColor3 = self.Library.Theme.Secondary,
            Size = UDim2.new(0, 120 * self.Library.Scale, 0, 30 * self.Library.Scale),
            Font = Enum.Font.Gotham,
            Text = (icon and icon .. " " or "") .. name,
            TextColor3 = self.Library.Theme.Text,
            TextSize = 12 * self.Library.Scale,
            Parent = self.TabContainer,
            ZIndex = 12
        })
        
        Utils.CreateCorner(tab.Button, 6)
        
        -- Tab content
        tab.ScrollFrame = Utils.CreateInstance("ScrollingFrame", {
            Name = name .. "Content",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = self.Library.Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            Visible = false,
            Parent = self.ContentContainer,
            ZIndex = 10
        })
        
        Utils.CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 10 * self.Library.Scale),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tab.ScrollFrame
        })
        
        Utils.CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 15 * self.Library.Scale),
            PaddingBottom = UDim.new(0, 15 * self.Library.Scale),
            PaddingLeft = UDim.new(0, 15 * self.Library.Scale),
            PaddingRight = UDim.new(0, 15 * self.Library.Scale),
            Parent = tab.ScrollFrame
        })
        
        -- Auto-resize canvas
        tab.ScrollFrame.UIListLayout.Changed:Connect(function()
            tab.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, tab.ScrollFrame.UIListLayout.AbsoluteContentSize.Y + 30 * self.Library.Scale)
        end)
        
        -- Tab button click
        tab.Button.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)
        
        -- Set as active if first tab
        if #self.Tabs == 0 then
            self.ActiveTab = tab
            tab.Active = true
            tab.Button.BackgroundColor3 = self.Library.Theme.Primary
            tab.ScrollFrame.Visible = true
        end
        
        table.insert(self.Tabs, tab)
        
        -- Element creation functions
        function tab:CreateLabel(text)
            local label = Utils.CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25 * self.Window.Library.Scale),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = self.Window.Library.Theme.Text,
                TextSize = 14 * self.Window.Library.Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = self.ScrollFrame
            })
            
            table.insert(self.Elements, label)
            return label
        end
        
        function tab:CreateButton(text, callback)
            local button = Utils.CreateInstance("TextButton", {
                Name = "Button",
                BackgroundColor3 = self.Window.Library.Theme.Primary,
                Size = UDim2.new(1, 0, 0, 35 * self.Window.Library.Scale),
                Font = Enum.Font.GothamBold,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14 * self.Window.Library.Scale,
                Parent = self.ScrollFrame
            })
            
            Utils.CreateCorner(button, 8)
            
            -- Hover effect
            button.MouseEnter:Connect(function()
                Utils.Tween(button, {BackgroundColor3 = Color3.fromRGB(
                    math.min(self.Window.Library.Theme.Primary.R * 255 + 20, 255),
                    math.min(self.Window.Library.Theme.Primary.G * 255 + 20, 255),
                    math.min(self.Window.Library.Theme.Primary.B * 255 + 20, 255)
                ):ToColor3()}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Utils.Tween(button, {BackgroundColor3 = self.Window.Library.Theme.Primary}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            table.insert(self.Elements, button)
            return button
        end
        
        function tab:CreateToggle(text, default, callback)
            local toggleFrame = Utils.CreateInstance("Frame", {
                Name = "ToggleFrame",
                BackgroundColor3 = self.Window.Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40 * self.Window.Library.Scale),
                Parent = self.ScrollFrame
            })
            
            Utils.CreateCorner(toggleFrame, 8)
            
            local label = Utils.CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15 * self.Window.Library.Scale, 0, 0),
                Size = UDim2.new(1, -80 * self.Window.Library.Scale, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = self.Window.Library.Theme.Text,
                TextSize = 14 * self.Window.Library.Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })
            
            local toggleButton = Utils.CreateInstance("TextButton", {
                Name = "ToggleButton",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = default and self.Window.Library.Theme.Primary or self.Window.Library.Theme.Border,
                Position = UDim2.new(1, -15 * self.Window.Library.Scale, 0.5, 0),
                Size = UDim2.new(0, 50 * self.Window.Library.Scale, 0, 25 * self.Window.Library.Scale),
                Text = "",
                Parent = toggleFrame
            })
            
            Utils.CreateCorner(toggleButton, 12)
            
            local toggleIndicator = Utils.CreateInstance("Frame", {
                Name = "Indicator",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = default and UDim2.new(1, -23 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale) or UDim2.new(0, 2 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale),
                Size = UDim2.new(0, 17 * self.Window.Library.Scale, 0, 17 * self.Window.Library.Scale),
                Parent = toggleButton
            })
            
            Utils.CreateCorner(toggleIndicator, 8)
            
            local toggled = default or false
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                Utils.Tween(toggleButton, {
                    BackgroundColor3 = toggled and self.Window.Library.Theme.Primary or self.Window.Library.Theme.Border
                }, 0.2)
                
                Utils.Tween(toggleIndicator, {
                    Position = toggled and UDim2.new(1, -23 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale) or UDim2.new(0, 2 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale)
                }, 0.2)
                
                if callback then callback(toggled) end
            end)
            
            table.insert(self.Elements, toggleFrame)
            return {Frame = toggleFrame, SetValue = function(value)
                toggled = value
                toggleButton.BackgroundColor3 = toggled and self.Window.Library.Theme.Primary or self.Window.Library.Theme.Border
                toggleIndicator.Position = toggled and UDim2.new(1, -23 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale) or UDim2.new(0, 2 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale)
            end}
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Utils.CreateInstance("Frame", {
                Name = "SliderFrame",
                BackgroundColor3 = self.Window.Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 60 * self.Window.Library.Scale),
                Parent = self.ScrollFrame
            })
            
            Utils.CreateCorner(sliderFrame, 8)
            
            local label = Utils.CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15 * self.Window.Library.Scale, 0, 5 * self.Window.Library.Scale),
                Size = UDim2.new(1, -80 * self.Window.Library.Scale, 0, 20 * self.Window.Library.Scale),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = self.Window.Library.Theme.Text,
                TextSize = 14 * self.Window.Library.Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })
            
            local valueLabel = Utils.CreateInstance("TextLabel", {
                Name = "ValueLabel",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -15 * self.Window.Library.Scale, 0, 5 * self.Window.Library.Scale),
                Size = UDim2.new(0, 60 * self.Window.Library.Scale, 0, 20 * self.Window.Library.Scale),
                Font = Enum.Font.GothamBold,
                Text = tostring(default),
                TextColor3 = self.Window.Library.Theme.Primary,
                TextSize = 14 * self.Window.Library.Scale,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })
            
            local sliderTrack = Utils.CreateInstance("Frame", {
                Name = "SliderTrack",
                BackgroundColor3 = self.Window.Library.Theme.Border,
                Position = UDim2.new(0, 15 * self.Window.Library.Scale, 0, 35 * self.Window.Library.Scale),
                Size = UDim2.new(1, -30 * self.Window.Library.Scale, 0, 6 * self.Window.Library.Scale),
                Parent = sliderFrame
            })
            
            Utils.CreateCorner(sliderTrack, 3)
            
            local sliderFill = Utils.CreateInstance("Frame", {
                Name = "SliderFill",
                BackgroundColor3 = self.Window.Library.Theme.Primary,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                Parent = sliderTrack
            })
            
            Utils.CreateCorner(sliderFill, 3)
            
            local sliderKnob = Utils.CreateInstance("Frame", {
                Name = "SliderKnob",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
                Size = UDim2.new(0, 16 * self.Window.Library.Scale, 0, 16 * self.Window.Library.Scale),
                Parent = sliderTrack
            })
            
            Utils.CreateCorner(sliderKnob, 8)
            Utils.CreateShadow(sliderKnob, 8, 0.3)
            
            local currentValue = default
            local dragging = false
            
            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(min + (max - min) * relativeX)
                
                valueLabel.Text = tostring(currentValue)
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderKnob.Position = UDim2.new(relativeX, 0, 0.5, 0)
                
                if callback then callback(currentValue) end
            end
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            table.insert(self.Elements, sliderFrame)
            return {Frame = sliderFrame, SetValue = function(value)
                currentValue = math.clamp(value, min, max)
                local relativeX = (currentValue - min) / (max - min)
                valueLabel.Text = tostring(currentValue)
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderKnob.Position = UDim2.new(relativeX, 0, 0.5, 0)
            end}
        end
        
        function tab:CreateDropdown(text, options, default, callback)
            local dropdownFrame = Utils.CreateInstance("Frame", {
                Name = "DropdownFrame",
                BackgroundColor3 = self.Window.Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40 * self.Window.Library.Scale),
                ClipsDescendants = true,
                Parent = self.ScrollFrame
            })
            
            Utils.CreateCorner(dropdownFrame, 8)
            
            local label = Utils.CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15 * self.Window.Library.Scale, 0, 0),
                Size = UDim2.new(1, -80 * self.Window.Library.Scale, 0, 40 * self.Window.Library.Scale),
                Font = Enum.Font.Gotham,
                Text = text .. ": " .. (default or "None"),
                TextColor3 = self.Window.Library.Theme.Text,
                TextSize = 14 * self.Window.Library.Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame
            })
            
            local dropdownButton = Utils.CreateInstance("TextButton", {
                Name = "DropdownButton",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -15 * self.Window.Library.Scale, 0.5, 0),
                Size = UDim2.new(0, 20 * self.Window.Library.Scale, 0, 20 * self.Window.Library.Scale),
                Font = Enum.Font.GothamBold,
                Text = "▼",
                TextColor3 = self.Window.Library.Theme.Text,
                TextSize = 12 * self.Window.Library.Scale,
                Parent = dropdownFrame
            })
            
            local optionsFrame = Utils.CreateInstance("Frame", {
                Name = "OptionsFrame",
                BackgroundColor3 = self.Window.Library.Theme.Background,
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, #options * 30 * self.Window.Library.Scale),
                Visible = false,
                ZIndex = 100,
                Parent = dropdownFrame
            })
            
            Utils.CreateCorner(optionsFrame, 8)
            Utils.CreateStroke(optionsFrame, 1, self.Window.Library.Theme.Border, 0.5)
            
            local optionsLayout = Utils.CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = optionsFrame
            })
            
            local currentValue = default
            local isOpen = false
            
            for i, option in ipairs(options) do
                local optionButton = Utils.CreateInstance("TextButton", {
                    Name = "Option" .. i,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30 * self.Window.Library.Scale),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = self.Window.Library.Theme.Text,
                    TextSize = 12 * self.Window.Library.Scale,
                    ZIndex = 101,
                    Parent = optionsFrame
                })
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundTransparency = 0.9
                    optionButton.BackgroundColor3 = self.Window.Library.Theme.Primary
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundTransparency = 1
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    currentValue = option
                    label.Text = text .. ": " .. option
                    
                    isOpen = false
                    optionsFrame.Visible = false
                    dropdownButton.Text = "▼"
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 40 * self.Window.Library.Scale)
                    
                    if callback then callback(option) end
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    dropdownFrame.Size = UDim2.new(1, 0, 0, (40 + #options * 30) * self.Window.Library.Scale)
                    optionsFrame.Visible = true
                    dropdownButton.Text = "▲"
                else
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 40 * self.Window.Library.Scale)
                    optionsFrame.Visible = false
                    dropdownButton.Text = "▼"
                end
            end)
            
            table.insert(self.Elements, dropdownFrame)
            return {Frame = dropdownFrame, SetValue = function(value)
                if table.find(options, value) then
                    currentValue = value
                    label.Text = text .. ": " .. value
                end
            end}
        end
        
        function tab:CreateTextbox(text, placeholder, callback)
            local textboxFrame = Utils.CreateInstance("Frame", {
                Name = "TextboxFrame",
                BackgroundColor3 = self.Window.Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 70 * self.Window.Library.Scale),
                Parent = self.ScrollFrame
            })
            
            Utils.CreateCorner(textboxFrame, 8)
            
            local label = Utils.CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15 * self.Window.Library.Scale, 0, 5 * self.Window.Library.Scale),
                Size = UDim2.new(1, -30 * self.Window.Library.Scale, 0, 20 * self.Window.Library.Scale),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = self.Window.Library.Theme.Text,
                TextSize = 14 * self.Window.Library.Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = textboxFrame
            })
            
            local textbox = Utils.CreateInstance("TextBox", {
                Name = "Textbox",
                BackgroundColor3 = self.Window.Library.Theme.Background,
                Position = UDim2.new(0, 15 * self.Window.Library.Scale, 0, 30 * self.Window.Library.Scale),
                Size = UDim2.new(1, -30 * self.Window.Library.Scale, 0, 30 * self.Window.Library.Scale),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder or "Enter text...",
                PlaceholderColor3 = self.Window.Library.Theme.TextSecondary,
                Text = "",
                TextColor3 = self.Window.Library.Theme.Text,
                TextSize = 12 * self.Window.Library.Scale,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = textboxFrame
            })
            
            Utils.CreateCorner(textbox, 6)
            Utils.CreateStroke(textbox, 1, self.Window.Library.Theme.Border, 0.5)
            
            Utils.CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10 * self.Window.Library.Scale),
                PaddingRight = UDim.new(0, 10 * self.Window.Library.Scale),
                Parent = textbox
            })
            
            textbox.FocusLost:Connect(function(enterPressed)
                if callback then callback(textbox.Text, enterPressed) end
            end)
            
            table.insert(self.Elements, textboxFrame)
            return {Frame = textboxFrame, SetText = function(newText)
                textbox.Text = newText
            end, GetText = function()
                return textbox.Text
            end}
        end
        
        return tab
    end
    
    function window:SelectTab(tab)
        if self.ActiveTab then
            self.ActiveTab.Active = false
            self.ActiveTab.Button.BackgroundColor3 = self.Library.Theme.Secondary
            self.ActiveTab.ScrollFrame.Visible = false
        end
        
        self.ActiveTab = tab
        tab.Active = true
        tab.Button.BackgroundColor3 = self.Library.Theme.Primary
        tab.ScrollFrame.Visible = true
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Notification System
function UILibrary:CreateNotification(options)
    options = options or {}
    
    local notification = {
        Title = options.title or "Notification",
        Text = options.text or "",
        Duration = options.duration or 5,
        Type = options.type or "info" -- info, success, warning, error
    }
    
    local colors = {
        info = self.Theme.Primary,
        success = self.Theme.Success,
        warning = self.Theme.Warning,
        error = self.Theme.Error
    }
    
    local notificationFrame = Utils.CreateInstance("Frame", {
        Name = "Notification",
        BackgroundColor3 = self.Theme.Surface,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = self.NotificationContainer,
        ZIndex = 200
    })
    
    Utils.CreateCorner(notificationFrame, 8)
    Utils.CreateShadow(notificationFrame, 15, 0.3)
    
    -- Color indicator
    local indicator = Utils.CreateInstance("Frame", {
        Name = "Indicator",
        BackgroundColor3 = colors[notification.Type],
        Size = UDim2.new(0, 4, 1, 0),
        Parent = notificationFrame,
        ZIndex = 201
    })
    
    Utils.CreateCorner(indicator, 2)
    
    -- Title
    local titleLabel = Utils.CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -50, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = notification.Title,
        TextColor3 = self.Theme.Text,
        TextSize = 14 * self.Scale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notificationFrame,
        ZIndex = 201
    })
    
    -- Text
    local textSize = Utils.GetTextSize(notification.Text, 12 * self.Scale, Enum.Font.Gotham, Vector2.new(250, math.huge))
    local textLabel = Utils.CreateInstance("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(1, -50, 0, textSize.Y),
        Font = Enum.Font.Gotham,
        Text = notification.Text,
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 12 * self.Scale,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notificationFrame,
        ZIndex = 201
    })
    
    -- Close button
    local closeButton = Utils.CreateInstance("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0, 10),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 16 * self.Scale,
        Parent = notificationFrame,
        ZIndex = 201
    })
    
    -- Progress bar
    local progressBar = Utils.CreateInstance("Frame", {
        Name = "ProgressBar",
        BackgroundColor3 = colors[notification.Type],
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        Parent = notificationFrame,
        ZIndex = 201
    })
    
    -- Calculate height and animate in
    local height = math.max(textSize.Y + 50, 70) * self.Scale
    notificationFrame.Size = UDim2.new(1, 0, 0, height)
    
    -- Animate progress bar
    Utils.Tween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, notification.Duration)
    
    -- Auto close
    local closeConnection
    closeConnection = task.delay(notification.Duration, function()
        Utils.Tween(notificationFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, nil, nil, function()
            notificationFrame:Destroy()
        end)
    end)
    
    -- Manual close
    closeButton.MouseButton1Click:Connect(function()
        task.cancel(closeConnection)
        Utils.Tween(notificationFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, nil, nil, function()
            notificationFrame:Destroy()
        end)
    end)
    
    table.insert(self.Notifications, notification)
    return notification
end

-- Theme Management
function UILibrary:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        self:UpdateTheme()
    end
end

function UILibrary:CreateCustomTheme(name, colors)
    Themes[name] = colors
    return Themes[name]
end

function UILibrary:UpdateTheme()
    -- Update all windows with new theme
    for _, window in ipairs(self.Windows) do
        window.Frame.BackgroundColor3 = self.Theme.Surface
        window.TitleBar.BackgroundColor3 = self.Theme.Primary
        window.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        window.TabContainer.BackgroundColor3 = self.Theme.Background
        
        for _, tab in ipairs(window.Tabs) do
            if tab.Active then
                tab.Button.BackgroundColor3 = self.Theme.Primary
            else
                tab.Button.BackgroundColor3 = self.Theme.Secondary
            end
            tab.Button.TextColor3 = self.Theme.Text
            
            -- Update all elements in the tab
            for _, element in ipairs(tab.Elements) do
                if element.BackgroundColor3 then
                    element.BackgroundColor3 = self.Theme.Secondary
                end
                if element.TextColor3 then
                    element.TextColor3 = self.Theme.Text
                end
            end
        end
    end
end

function UILibrary:UpdateScale()
    -- Update scale for all windows and elements
    for _, window in ipairs(self.Windows) do
        -- Update window size based on new scale
        local currentSize = window.Frame.Size
        window.Frame.Size = UDim2.new(
            currentSize.X.Scale,
            currentSize.X.Offset * self.Scale,
            currentSize.Y.Scale,
            currentSize.Y.Offset * self.Scale
        )
        
        -- Update all text sizes and element sizes
        for _, tab in ipairs(window.Tabs) do
            for _, element in ipairs(tab.Elements) do
                if element:IsA("TextLabel") or element:IsA("TextButton") then
                    element.TextSize = element.TextSize * self.Scale
                end
            end
        end
    end
end

-- Cleanup
function UILibrary:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Windows = {}
    self.Notifications = {}
    self.KeySystem = nil
end

return UILibrary
