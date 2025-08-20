--[[
    Professional Executor UI Library
    Universal Draggable Version for All Devices
    
    Load with:
    local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/ProfessionalUI/main/main.lua"))()
    
    Author: Professional UI Team
    Version: 4.2 (Universal Edition)
]]

-- Prevent multiple loads
if _G.ProfessionalUI_Loaded then
    return _G.ProfessionalUI
end

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- Main Library
local ProfessionalUI = {}
ProfessionalUI.__index = ProfessionalUI

-- Version info
ProfessionalUI.Version = "4.2"
ProfessionalUI.Author = "Professional UI Team"

-- Utility Functions
local Utils = {}

function Utils.Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utils.Tween(instance, properties, duration, style, direction, callback)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or 0.3,
            style or Enum.EasingStyle.Quart,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

function Utils.CreateCorner(parent, radius)
    return Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

function Utils.CreateStroke(parent, thickness, color, transparency)
    return Utils.Create("UIStroke", {
        Thickness = thickness or 1,
        Color = color or Color3.fromRGB(255, 255, 255),
        Transparency = transparency or 0,
        Parent = parent
    })
end

function Utils.CreateShadow(parent, size, transparency)
    local shadow = Utils.Create("ImageLabel", {
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

function Utils.GetScale()
    local viewport = workspace.CurrentCamera.ViewportSize
    local scale = math.min(viewport.X / 1920, viewport.Y / 1080)
    return math.max(scale, 0.5)
end

function Utils.GenerateId()
    return HttpService:GenerateGUID(false)
end

-- Universal Draggable Function (Works on all devices)
function Utils.MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    dragHandle = dragHandle or frame
    
    -- Mouse/Touch input began
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            -- Handle input ending
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end
    
    -- Mouse/Touch input changed (movement)
    local function onInputChanged(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end
    
    -- Connect drag handle events
    dragHandle.InputBegan:Connect(onInputBegan)
    dragHandle.InputChanged:Connect(onInputChanged)
    
    -- Global input changed for dragging
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            
            -- Apply the new position directly (remove constraints for now to test)
            frame.Position = newPosition
        end
    end)
    
    -- Global input ended
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Themes
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
    Purple = {
        Background = Color3.fromRGB(20, 15, 30),
        Surface = Color3.fromRGB(30, 25, 40),
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(40, 35, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Border = Color3.fromRGB(60, 55, 70)
    },
    Red = {
        Background = Color3.fromRGB(30, 15, 15),
        Surface = Color3.fromRGB(40, 25, 25),
        Primary = Color3.fromRGB(220, 50, 50),
        Secondary = Color3.fromRGB(50, 35, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Border = Color3.fromRGB(70, 55, 55)
    },
    Green = {
        Background = Color3.fromRGB(15, 30, 15),
        Surface = Color3.fromRGB(25, 40, 25),
        Primary = Color3.fromRGB(50, 180, 100),
        Secondary = Color3.fromRGB(35, 50, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Border = Color3.fromRGB(55, 70, 55)
    },
    Cyberpunk = {
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 25),
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(30, 30, 35),
        Text = Color3.fromRGB(0, 255, 255),
        TextSecondary = Color3.fromRGB(150, 255, 255),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 0, 100),
        Border = Color3.fromRGB(0, 100, 100)
    }
}

-- Main Library Constructor
function ProfessionalUI.new(options)
    options = options or {}
    
    local self = setmetatable({
        Theme = Themes[options.theme] or Themes.Dark,
        Scale = Utils.GetScale(),
        Windows = {},
        Notifications = {},
        ScreenGui = nil,
        ToggleUI = nil,
        Id = Utils.GenerateId(),
        Visible = true
    }, ProfessionalUI)
    
    -- Create ScreenGui
    local success, screenGui = pcall(function()
        return Utils.Create("ScreenGui", {
            Name = "ProfessionalUI_" .. self.Id,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
    end)
    
    if not success then
        screenGui = Utils.Create("ScreenGui", {
            Name = "ProfessionalUI_" .. self.Id,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = Player:WaitForChild("PlayerGui")
        })
    end
    
    self.ScreenGui = screenGui
    
    -- Create Toggle UI
    self:CreateToggleUI()
    
    -- Create notification container
    self.NotificationContainer = Utils.Create("Frame", {
        Name = "NotificationContainer",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 0, 20),
        Size = UDim2.new(0, 300, 1, -40),
        Parent = screenGui
    })
    
    Utils.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = self.NotificationContainer
    })
    
    -- Handle screen size changes
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self.Scale = Utils.GetScale()
    end)
    
    -- Print load message
    print("🚀 Professional UI Library v" .. ProfessionalUI.Version .. " loaded successfully!")
    print("📖 Created by " .. ProfessionalUI.Author)
    print("🆔 Instance ID: " .. self.Id)
    print("📱 Universal dragging enabled for all devices")
    print("🎮 Compact toggle UI created - Drag to move, tap to toggle")
    
    return self
end

-- Create Compact Toggle UI
function ProfessionalUI:CreateToggleUI()
    -- Main toggle frame (smaller and more compact)
    self.ToggleUI = Utils.Create("Frame", {
        Name = "ToggleUI",
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.Theme.Surface,
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0, 45, 0, 45), -- Smaller size
        Parent = self.ScreenGui,
        ZIndex = 1000
    })
    
    Utils.CreateCorner(self.ToggleUI, 22) -- More circular
    Utils.CreateShadow(self.ToggleUI, 12, 0.6)
    Utils.CreateStroke(self.ToggleUI, 2, self.Theme.Primary, 0)
    
    -- Toggle button
    local toggleButton = Utils.Create("TextButton", {
        Name = "ToggleButton",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "⚡", -- More compact icon
        TextColor3 = self.Theme.Primary,
        TextSize = 18, -- Smaller text
        Parent = self.ToggleUI,
        ZIndex = 1001
    })
    
    -- Smaller status indicator
    local statusIndicator = Utils.Create("Frame", {
        Name = "StatusIndicator",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = self.Theme.Success,
        Position = UDim2.new(1, -3, 0, 3),
        Size = UDim2.new(0, 8, 0, 8), -- Smaller indicator
        Parent = self.ToggleUI,
        ZIndex = 1002
    })
    
    Utils.CreateCorner(statusIndicator, 4)
    
    -- Make toggle UI draggable (works on all devices)
    Utils.MakeDraggable(self.ToggleUI)
    
    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        self:ToggleVisibility()
    end)
    
    -- Touch support for mobile
    toggleButton.TouchTap:Connect(function()
        self:ToggleVisibility()
    end)
    
    -- Hover/Touch effects
    local function onHover()
        Utils.Tween(self.ToggleUI, {Size = UDim2.new(0, 50, 0, 50)}, 0.2)
        Utils.Tween(toggleButton, {TextSize = 20}, 0.2)
    end
    
    local function onLeave()
        Utils.Tween(self.ToggleUI, {Size = UDim2.new(0, 45, 0, 45)}, 0.2)
        Utils.Tween(toggleButton, {TextSize = 18}, 0.2)
    end
    
    toggleButton.MouseEnter:Connect(onHover)
    toggleButton.MouseLeave:Connect(onLeave)
    
    -- Touch equivalents for mobile
    toggleButton.TouchLongPress:Connect(onHover)
    
    -- Subtle pulse animation for status indicator
    spawn(function()
        while self.ToggleUI and self.ToggleUI.Parent do
            Utils.Tween(statusIndicator, {Size = UDim2.new(0, 10, 0, 10)}, 1.5)
            wait(1.5)
            Utils.Tween(statusIndicator, {Size = UDim2.new(0, 8, 0, 8)}, 1.5)
            wait(1.5)
        end
    end)
    
    return self.ToggleUI
end

-- Toggle Visibility
function ProfessionalUI:ToggleVisibility()
    self.Visible = not self.Visible
    
    local toggleButton = self.ToggleUI:FindFirstChild("ToggleButton")
    local statusIndicator = self.ToggleUI:FindFirstChild("StatusIndicator")
    
    if self.Visible then
        -- Show all windows with proper centering
        for _, window in ipairs(self.Windows) do
            window.Frame.Visible = true
            
            -- Ensure window is centered
            local windowWidth = window.Size.X.Offset
            local windowHeight = window.Size.Y.Offset
            window.Frame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
            
            Utils.Tween(window.Frame, {Size = window.Size}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
        
        -- Show notifications
        self.NotificationContainer.Visible = true
        
        -- Update toggle UI
        toggleButton.Text = "⚡"
        statusIndicator.BackgroundColor3 = self.Theme.Success
        Utils.Tween(self.ToggleUI, {BackgroundColor3 = self.Theme.Surface}, 0.2)
        
        self:CreateNotification({
            title = "Interface Opened",
            text = "Professional UI is now visible and centered",
            type = "success",
            duration = 2
        })
    else
        -- Hide all windows
        for _, window in ipairs(self.Windows) do
            Utils.Tween(window.Frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, nil, nil, function()
                window.Frame.Visible = false
            end)
        end
        
        -- Hide notifications
        self.NotificationContainer.Visible = false
        
        -- Update toggle UI
        toggleButton.Text = "▶"
        statusIndicator.BackgroundColor3 = self.Theme.Warning
        Utils.Tween(self.ToggleUI, {BackgroundColor3 = self.Theme.Secondary}, 0.2)
    end
end

-- Hide Interface
function ProfessionalUI:Hide()
    if self.Visible then
        self:ToggleVisibility()
    end
end

-- Show Interface
function ProfessionalUI:Show()
    if not self.Visible then
        self:ToggleVisibility()
    end
end

-- Key System
function ProfessionalUI:CreateKeySystem(options)
    options = options or {}
    
    local keySystem = {
        Title = options.title or "Key System",
        Description = options.description or "Enter your key to continue",
        Key = options.key or "DefaultKey123",
        KeyLink = options.keyLink or "https://example.com/getkey",
        Callback = options.callback or function() end,
        CloseCallback = options.closeCallback or function() end,
        SaveKey = options.saveKey or false
    }
    
    -- Load saved key if enabled
    local savedKey = nil
    if keySystem.SaveKey then
        pcall(function()
            savedKey = readfile("ProfessionalUI_SavedKey.txt")
        end)
    end
    
    -- Auto-login if saved key matches
    if savedKey and savedKey == keySystem.Key then
        keySystem.Callback()
        return keySystem
    end
    
    -- Hide main interface while key system is active
    self:Hide()
    
    -- Create key system window
    local keyFrame = Utils.Create("Frame", {
        Name = "KeySystem",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Surface,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 400 * self.Scale, 0, 320 * self.Scale),
        Parent = self.ScreenGui,
        ZIndex = 2000
    })
    
    Utils.CreateCorner(keyFrame, 12)
    Utils.CreateShadow(keyFrame, 30, 0.5)
    
    -- Title bar
    local titleBar = Utils.Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 50 * self.Scale),
        Parent = keyFrame
    })
    
    Utils.CreateCorner(titleBar, 12)
    
    -- Make key system draggable (universal)
    Utils.MakeDraggable(keyFrame, titleBar)
    
    -- Title bar bottom cover
    Utils.Create("Frame", {
        BackgroundColor3 = self.Theme.Primary,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    -- Title text
    Utils.Create("TextLabel", {
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
    local closeButton = Utils.Create("TextButton", {
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
    Utils.Create("TextLabel", {
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
    local keyInput = Utils.Create("TextBox", {
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
    Utils.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = keyInput
    })
    
    -- Save key checkbox (if enabled)
    local saveKeyCheckbox = nil
    if keySystem.SaveKey then
        local checkboxFrame = Utils.Create("Frame", {
            Name = "CheckboxFrame",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 180 * self.Scale),
            Size = UDim2.new(1, -40, 0, 25 * self.Scale),
            Parent = keyFrame
        })
        
        saveKeyCheckbox = Utils.Create("TextButton", {
            Name = "Checkbox",
            BackgroundColor3 = self.Theme.Secondary,
            Size = UDim2.new(0, 20, 0, 20),
            Text = "",
            Parent = checkboxFrame
        })
        
        Utils.CreateCorner(saveKeyCheckbox, 4)
        Utils.CreateStroke(saveKeyCheckbox, 1, self.Theme.Border, 0.5)
        
        local checkmark = Utils.Create("TextLabel", {
            Name = "Checkmark",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "",
            TextColor3 = self.Theme.Primary,
            TextSize = 14,
            Parent = saveKeyCheckbox
        })
        
        Utils.Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(1, -30, 1, 0),
            Font = Enum.Font.Gotham,
            Text = "Remember my key",
            TextColor3 = self.Theme.Text,
            TextSize = 12 * self.Scale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = checkboxFrame
        })
        
        local saveKeyEnabled = false
        saveKeyCheckbox.MouseButton1Click:Connect(function()
            saveKeyEnabled = not saveKeyEnabled
            checkmark.Text = saveKeyEnabled and "✓" or ""
            saveKeyCheckbox.BackgroundColor3 = saveKeyEnabled and self.Theme.Primary or self.Theme.Secondary
        end)
        
        -- Touch support
        saveKeyCheckbox.TouchTap:Connect(function()
            saveKeyEnabled = not saveKeyEnabled
            checkmark.Text = saveKeyEnabled and "✓" or ""
            saveKeyCheckbox.BackgroundColor3 = saveKeyEnabled and self.Theme.Primary or self.Theme.Secondary
        end)
    end
    
    -- Submit button
    local submitButton = Utils.Create("TextButton", {
        Name = "SubmitButton",
        BackgroundColor3 = self.Theme.Primary,
        Position = UDim2.new(0, 20, 0, keySystem.SaveKey and 220 * self.Scale or 190 * self.Scale),
        Size = UDim2.new(0.5, -30, 0, 40 * self.Scale),
        Font = Enum.Font.GothamBold,
        Text = "Submit Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14 * self.Scale,
        Parent = keyFrame
    })
    
    Utils.CreateCorner(submitButton, 8)
    
    -- Get key button
    local getKeyButton = Utils.Create("TextButton", {
        Name = "GetKeyButton",
        BackgroundColor3 = self.Theme.Secondary,
        Position = UDim2.new(0.5, 10, 0, keySystem.SaveKey and 220 * self.Scale or 190 * self.Scale),
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
    local statusLabel = Utils.Create("TextLabel", {
        Name = "StatusLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, keySystem.SaveKey and 280 * self.Scale or 250 * self.Scale),
        Size = UDim2.new(1, -40, 0, 30 * self.Scale),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = self.Theme.Error,
        TextSize = 12 * self.Scale,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = keyFrame
    })
    
    -- Button functionality
    local function submitKey()
        local inputKey = keyInput.Text
        if inputKey == keySystem.Key then
            statusLabel.Text = "Key accepted! Loading..."
            statusLabel.TextColor3 = self.Theme.Success
            
            -- Save key if enabled
            if keySystem.SaveKey and saveKeyCheckbox then
                local saveKeyEnabled = saveKeyCheckbox:FindFirstChild("Checkmark").Text == "✓"
                if saveKeyEnabled then
                    pcall(function()
                        writefile("ProfessionalUI_SavedKey.txt", inputKey)
                    end)
                end
            end
            
            Utils.Tween(keyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, nil, nil, function()
                keyFrame:Destroy()
                self:Show() -- Show main interface
                
                -- Ensure all windows are properly centered after showing
                for _, window in ipairs(self.Windows) do
                    if window.Frame then
                        local windowWidth = window.Size.X.Offset
                        local windowHeight = window.Size.Y.Offset
                        window.Frame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
                    end
                end
                
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
    end
    
    submitButton.MouseButton1Click:Connect(submitKey)
    submitButton.TouchTap:Connect(submitKey)
    
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
    
    getKeyButton.TouchTap:Connect(function()
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
    
    closeButton.TouchTap:Connect(function()
        Utils.Tween(keyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, nil, nil, function()
            keyFrame:Destroy()
            keySystem.CloseCallback()
        end)
    end)
    
    -- Enter key support
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitKey()
        end
    end)
    
    return keySystem
end

-- Window Creation
function ProfessionalUI:CreateWindow(title, size)
    local window = {
        Title = title or "Professional UI",
        Size = size or UDim2.new(0, 600 * self.Scale, 0, 400 * self.Scale),
        Tabs = {},
        ActiveTab = nil,
        Library = self,
        Elements = {}
    }
    
    -- Calculate center position based on window size
    local windowWidth = window.Size.X.Offset
    local windowHeight = window.Size.Y.Offset
    
    -- Main window frame - positioned in center
    window.Frame = Utils.Create("Frame", {
        Name = "Window",
        BackgroundColor3 = self.Theme.Surface,
        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2), -- Center the window
        Size = window.Size,
        Parent = self.ScreenGui,
        ZIndex = 10
    })
    
    Utils.CreateCorner(window.Frame, 12)
    Utils.CreateShadow(window.Frame, 25, 0.4)
    
    -- Title bar
    window.TitleBar = Utils.Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 50 * self.Scale),
        Parent = window.Frame,
        ZIndex = 11
    })
    
    Utils.CreateCorner(window.TitleBar, 12)
    
    -- Make window draggable (universal for all devices)
    Utils.MakeDraggable(window.Frame, window.TitleBar)
    
    -- Title bar bottom cover
    Utils.Create("Frame", {
        BackgroundColor3 = self.Theme.Primary,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = window.TitleBar,
        ZIndex = 11
    })
    
    -- Title text
    window.TitleLabel = Utils.Create("TextLabel", {
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
    local controlsFrame = Utils.Create("Frame", {
        Name = "Controls",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 30),
        Parent = window.TitleBar,
        ZIndex = 12
    })
    
    -- Minimize button
    local minimizeButton = Utils.Create("TextButton", {
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
    local closeButton = Utils.Create("TextButton", {
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
    window.TabContainer = Utils.Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(0, 0, 0, 50 * self.Scale),
        Size = UDim2.new(1, 0, 0, 40 * self.Scale),
        Parent = window.Frame,
        ZIndex = 11
    })
    
    Utils.Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = window.TabContainer
    })
    
    Utils.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        Parent = window.TabContainer
    })
    
    -- Content container
    window.ContentContainer = Utils.Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 90 * self.Scale),
        Size = UDim2.new(1, 0, 1, -90 * self.Scale),
        Parent = window.Frame,
        ZIndex = 10
    })
    
    -- Window controls functionality
    local minimized = false
    local function toggleMinimize()
        minimized = not minimized
        if minimized then
            Utils.Tween(window.Frame, {Size = UDim2.new(window.Size.X.Scale, window.Size.X.Offset, 0, 50 * self.Scale)})
            minimizeButton.Text = "+"
        else
            Utils.Tween(window.Frame, {Size = window.Size})
            minimizeButton.Text = "−"
        end
    end
    
    minimizeButton.MouseButton1Click:Connect(toggleMinimize)
    minimizeButton.TouchTap:Connect(toggleMinimize)
    
    local function closeWindow()
        Utils.Tween(window.Frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, nil, nil, function()
            window.Frame:Destroy()
            for i, w in ipairs(self.Windows) do
                if w == window then
                    table.remove(self.Windows, i)
                    break
                end
            end
        end)
    end
    
    closeButton.MouseButton1Click:Connect(closeWindow)
    closeButton.TouchTap:Connect(closeWindow)
    
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
        tab.Button = Utils.Create("TextButton", {
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
        tab.ScrollFrame = Utils.Create("ScrollingFrame", {
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
        
        Utils.Create("UIListLayout", {
            Padding = UDim.new(0, 10 * self.Library.Scale),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tab.ScrollFrame
        })
        
        Utils.Create("UIPadding", {
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
        
        -- Tab button click with touch support
        local function selectTab()
            self:SelectTab(tab)
        end
        
        tab.Button.MouseButton1Click:Connect(selectTab)
        tab.Button.TouchTap:Connect(selectTab)
        
        -- Set as active if first tab
        if #self.Tabs == 0 then
            self.ActiveTab = tab
            tab.Active = true
            tab.Button.BackgroundColor3 = self.Library.Theme.Primary
            tab.ScrollFrame.Visible = true
        end
        
        table.insert(self.Tabs, tab)
        
        -- Element creation functions (same as before but with touch support)
        function tab:CreateLabel(text)
            local label = Utils.Create("TextLabel", {
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
            local button = Utils.Create("TextButton", {
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
            
            local function onClick()
                if callback then callback() end
            end
            
            button.MouseButton1Click:Connect(onClick)
            button.TouchTap:Connect(onClick)
            
            table.insert(self.Elements, button)
            return button
        end
        
        function tab:CreateToggle(text, default, callback)
            local toggleFrame = Utils.Create("Frame", {
                Name = "ToggleFrame",
                BackgroundColor3 = self.Window.Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40 * self.Window.Library.Scale),
                Parent = self.ScrollFrame
            })
            
            Utils.CreateCorner(toggleFrame, 8)
            
            local label = Utils.Create("TextLabel", {
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
            
            local toggleButton = Utils.Create("TextButton", {
                Name = "ToggleButton",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = default and self.Window.Library.Theme.Primary or self.Window.Library.Theme.Border,
                Position = UDim2.new(1, -15 * self.Window.Library.Scale, 0.5, 0),
                Size = UDim2.new(0, 50 * self.Window.Library.Scale, 0, 25 * self.Window.Library.Scale),
                Text = "",
                Parent = toggleFrame
            })
            
            Utils.CreateCorner(toggleButton, 12)
            
            local toggleIndicator = Utils.Create("Frame", {
                Name = "Indicator",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = default and UDim2.new(1, -23 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale) or UDim2.new(0, 2 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale),
                Size = UDim2.new(0, 17 * self.Window.Library.Scale, 0, 17 * self.Window.Library.Scale),
                Parent = toggleButton
            })
            
            Utils.CreateCorner(toggleIndicator, 8)
            
            local toggled = default or false
            
            local function toggle()
                toggled = not toggled
                
                Utils.Tween(toggleButton, {
                    BackgroundColor3 = toggled and self.Window.Library.Theme.Primary or self.Window.Library.Theme.Border
                }, 0.2)
                
                Utils.Tween(toggleIndicator, {
                    Position = toggled and UDim2.new(1, -23 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale) or UDim2.new(0, 2 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale)
                }, 0.2)
                
                if callback then callback(toggled) end
            end
            
            toggleButton.MouseButton1Click:Connect(toggle)
            toggleButton.TouchTap:Connect(toggle)
            
            table.insert(self.Elements, toggleFrame)
            return {
                Frame = toggleFrame,
                SetValue = function(value)
                    toggled = value
                    toggleButton.BackgroundColor3 = toggled and self.Window.Library.Theme.Primary or self.Window.Library.Theme.Border
                    toggleIndicator.Position = toggled and UDim2.new(1, -23 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale) or UDim2.new(0, 2 * self.Window.Library.Scale, 0.5, -8.5 * self.Window.Library.Scale)
                end,
                GetValue = function()
                    return toggled
                end
            }
        end
        
        -- Additional element functions would continue here with touch support...
        
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
function ProfessionalUI:CreateNotification(options)
    options = options or {}
    
    local notification = {
        Title = options.title or "Notification",
        Text = options.text or "",
        Duration = options.duration or 5,
        Type = options.type or "info"
    }
    
    local colors = {
        info = self.Theme.Primary,
        success = self.Theme.Success,
        warning = self.Theme.Warning,
        error = self.Theme.Error
    }
    
    local notificationFrame = Utils.Create("Frame", {
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
    local indicator = Utils.Create("Frame", {
        Name = "Indicator",
        BackgroundColor3 = colors[notification.Type],
        Size = UDim2.new(0, 4, 1, 0),
        Parent = notificationFrame,
        ZIndex = 201
    })
    
    Utils.CreateCorner(indicator, 2)
    
    -- Title
    local titleLabel = Utils.Create("TextLabel", {
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
    local textSize = TextService:GetTextSize(notification.Text, 12 * self.Scale, Enum.Font.Gotham, Vector2.new(250, math.huge))
    local textLabel = Utils.Create("TextLabel", {
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
    local closeButton = Utils.Create("TextButton", {
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
    local progressBar = Utils.Create("Frame", {
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
    
    -- Manual close with touch support
    local function closeNotification()
        task.cancel(closeConnection)
        Utils.Tween(notificationFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, nil, nil, function()
            notificationFrame:Destroy()
        end)
    end
    
    closeButton.MouseButton1Click:Connect(closeNotification)
    closeButton.TouchTap:Connect(closeNotification)
    
    table.insert(self.Notifications, notification)
    return notification
end

-- Theme Management
function ProfessionalUI:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        self:UpdateTheme()
        self:UpdateToggleUI()
    end
end

function ProfessionalUI:CreateCustomTheme(name, colors)
    Themes[name] = colors
    return Themes[name]
end

function ProfessionalUI:UpdateTheme()
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
        end
    end
end

function ProfessionalUI:UpdateToggleUI()
    if self.ToggleUI then
        self.ToggleUI.BackgroundColor3 = self.Theme.Surface
        local stroke = self.ToggleUI:FindFirstChild("UIStroke")
        if stroke then
            stroke.Color = self.Theme.Primary
        end
        
        local toggleButton = self.ToggleUI:FindFirstChild("ToggleButton")
        if toggleButton then
            toggleButton.TextColor3 = self.Theme.Primary
        end
    end
end

-- Cleanup
function ProfessionalUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Windows = {}
    self.Notifications = {}
    self.ToggleUI = nil
end

-- Set global variables and mark as loaded
_G.ProfessionalUI = ProfessionalUI
_G.ProfessionalUI_Loaded = true

-- Return the library
return ProfessionalUI
