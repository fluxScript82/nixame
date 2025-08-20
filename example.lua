--[[
    Professional UI Library - Universal Example
    Works perfectly on Mobile, Tablet, and Desktop
    
    Features:
    - Universal dragging (touch and mouse)
    - Compact toggle UI
    - Mobile-optimized interactions
    - Touch-friendly buttons
]]

-- Load the library via loadstring (replace with your actual URL)
local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source.lua"))(

-- Create the UI instance
local UI = ProfessionalUI.new({
    theme = "Dark" -- Available: "Dark", "Light", "Purple", "Red", "Green", "Cyberpunk"
})

-- Optional: Create a key system
local function createKeySystem()
    UI:CreateKeySystem({
        title = "Universal Script Hub",
        description = "Enter your key to access all features (works on all devices)",
        key = "UniversalKey2024", -- Your actual key
        keyLink = "https://linkvertise.com/your-key-link", -- Your key link
        saveKey = true, -- Allow users to save their key
        callback = function()
            print("✅ Access granted! Loading universal interface...")
            createMainInterface()
        end,
        closeCallback = function()
            print("❌ Key system closed")
        end
    })
end

-- Create the main interface
local function createMainInterface()
    -- Create main window (universally draggable!)
    local mainWindow = UI:CreateWindow("Universal Script Hub", UDim2.new(0, 650, 0, 450))
    
    -- Create tabs
    local homeTab = mainWindow:CreateTab("Home", "🏠")
    local scriptsTab = mainWindow:CreateTab("Scripts", "📜")
    local settingsTab = mainWindow:CreateTab("Settings", "⚙️")
    local mobileTab = mainWindow:CreateTab("Mobile", "📱")
    
    -- Home Tab
    homeTab:CreateLabel("Welcome to Universal Script Hub!")
    homeTab:CreateLabel("🖱️ Desktop: Click and drag title bar to move windows")
    homeTab:CreateLabel("📱 Mobile: Touch and drag title bar to move windows")
    homeTab:CreateLabel("⚡ Use the compact toggle button to show/hide interface")
    homeTab:CreateLabel("🎯 Windows automatically center when opened")

    homeTab:CreateButton("Test Window Dragging", function()
        UI:CreateNotification({
            title = "Drag Test",
            text = "Try dragging this window by its blue title bar!",
            type = "info",
            duration = 5
        })
        
        -- Highlight the title bar briefly
        local titleBar = mainWindow.TitleBar
        local originalColor = titleBar.BackgroundColor3
        Utils.Tween(titleBar, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.3)
        task.wait(0.5)
        Utils.Tween(titleBar, {BackgroundColor3 = originalColor}, 0.3)
    end)

    homeTab:CreateButton("Center All Windows", function()
        for _, window in ipairs(UI.Windows) do
            if window.Frame then
                local windowWidth = window.Size.X.Offset
                local windowHeight = window.Size.Y.Offset
                Utils.Tween(window.Frame, {
                    Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
                }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            end
        end
        
        UI:CreateNotification({
            title = "Windows Centered",
            text = "All windows have been moved to center!",
            type = "success",
            duration = 3
        })
    end)

    homeTab:CreateButton("Test Multiple Windows", function()
        -- Create a second draggable window to test
        local testWindow = UI:CreateWindow("Draggable Test Window", UDim2.new(0, 400, 0, 300))
        local testTab = testWindow:CreateTab("Test", "🧪")
        
        testTab:CreateLabel("This window is also draggable!")
        testTab:CreateLabel("Try dragging both windows around.")
        
        testTab:CreateButton("Close This Window", function()
            testWindow.Frame:Destroy()
            -- Remove from windows list
            for i, w in ipairs(UI.Windows) do
                if w == testWindow then
                    table.remove(UI.Windows, i)
                    break
                end
            end
        end)
        
        -- Position the test window slightly offset
        testWindow.Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
        
        UI:CreateNotification({
            title = "Test Window Created",
            text = "Try dragging both windows by their title bars!",
            type = "success",
            duration = 4
        })
    end)
    
    homeTab:CreateButton("Toggle Interface", function()
        UI:ToggleVisibility()
        task.wait(2)
        UI:ToggleVisibility()
        UI:CreateNotification({
            title = "Toggle Test",
            text = "Interface toggled successfully!",
            type = "success",
            duration = 3
        })
    end)
    
    homeTab:CreateButton("Device Detection", function()
        local device = "Unknown"
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            device = "Mobile"
        elseif UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
            device = "Tablet"
        else
            device = "Desktop"
        end
        
        UI:CreateNotification({
            title = "Device Detected",
            text = "You are using: " .. device,
            type = "info",
            duration = 3
        })
    end)
    
    -- Scripts Tab
    scriptsTab:CreateLabel("Universal Scripts (All Devices)")
    
    scriptsTab:CreateButton("Universal ESP", function()
        UI:CreateNotification({
            title = "ESP Loaded",
            text = "Universal ESP works on all devices!",
            type = "success",
            duration = 3
        })
        print("Loading Universal ESP...")
    end)
    
    scriptsTab:CreateButton("Speed Hack", function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local currentSpeed = player.Character.Humanoid.WalkSpeed
            if currentSpeed == 16 then
                player.Character.Humanoid.WalkSpeed = 50
                UI:CreateNotification({
                    title = "Speed Hack",
                    text = "Speed increased to 50!",
                    type = "success",
                    duration = 2
                })
            else
                player.Character.Humanoid.WalkSpeed = 16
                UI:CreateNotification({
                    title = "Speed Hack",
                    text = "Speed reset to normal",
                    type = "info",
                    duration = 2
                })
            end
        end
    end)
    
    scriptsTab:CreateButton("Jump Power", function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 100
            UI:CreateNotification({
                title = "Jump Power",
                text = "Jump power increased to 100!",
                type = "success",
                duration = 2
            })
        end
    end)
    
    local autoFarmToggle = scriptsTab:CreateToggle("Auto Farm", false, function(value)
        if value then
            UI:CreateNotification({
                title = "Auto Farm",
                text = "Auto farm enabled (works on all devices)!",
                type = "success",
                duration = 2
            })
            print("Auto farm enabled")
        else
            UI:CreateNotification({
                title = "Auto Farm",
                text = "Auto farm disabled",
                type = "info",
                duration = 2
            })
            print("Auto farm disabled")
        end
    end)
    
    -- Settings Tab
    settingsTab:CreateLabel("Universal Theme Settings")
    settingsTab:CreateLabel("Choose your preferred theme (all devices):")
    
    local themes = {"Dark", "Light", "Purple", "Red", "Green", "Cyberpunk"}
    for _, themeName in ipairs(themes) do
        settingsTab:CreateButton(themeName .. " Theme", function()
            UI:SetTheme(themeName)
            UI:CreateNotification({
                title = "Theme Changed",
                text = "Switched to " .. themeName .. " theme",
                type = "info",
                duration = 2
            })
        end)
    end
    
    settingsTab:CreateButton("Custom Rainbow Theme", function()
        UI:CreateCustomTheme("Rainbow", {
            Background = Color3.fromRGB(20, 20, 30),
            Surface = Color3.fromRGB(30, 30, 40),
            Primary = Color3.fromRGB(255, 100, 200),
            Secondary = Color3.fromRGB(40, 40, 50),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(200, 200, 200),
            Success = Color3.fromRGB(100, 255, 150),
            Warning = Color3.fromRGB(255, 200, 100),
            Error = Color3.fromRGB(255, 100, 100),
            Border = Color3.fromRGB(100, 50, 150)
        })
        UI:SetTheme("Rainbow")
        UI:CreateNotification({
            title = "Custom Theme",
            text = "Rainbow theme created and applied!",
            type = "success",
            duration = 3
        })
    end)
    
    settingsTab:CreateLabel("Interface Settings")
    
    local notificationsToggle = settingsTab:CreateToggle("Enable Notifications", true, function(value)
        print("Notifications:", value and "enabled" or "disabled")
    end)
    
    local autoExecuteToggle = settingsTab:CreateToggle("Auto Execute on Join", false, function(value)
        print("Auto execute:", value and "enabled" or "disabled")
    end)
    
    -- Mobile Tab (Mobile-specific features)
    mobileTab:CreateLabel("Mobile-Optimized Features")
    mobileTab:CreateLabel("These features are optimized for touch devices:")
    
    mobileTab:CreateButton("Mobile-Friendly ESP", function()
        UI:CreateNotification({
            title = "Mobile ESP",
            text = "ESP optimized for mobile devices activated!",
            type = "success",
            duration = 3
        })
    end)
    
    mobileTab:CreateButton("Touch Controls", function()
        UI:CreateNotification({
            title = "Touch Controls",
            text = "Enhanced touch controls enabled!",
            type = "success",
            duration = 3
        })
    end)
    
    mobileTab:CreateButton("Screen Size Info", function()
        local viewport = workspace.CurrentCamera.ViewportSize
        UI:CreateNotification({
            title = "Screen Info",
            text = string.format("Resolution: %dx%d", viewport.X, viewport.Y),
            type = "info",
            duration = 4
        })
    end)
    
    local mobileOptimizedToggle = mobileTab:CreateToggle("Mobile Optimization", true, function(value)
        if value then
            UI:CreateNotification({
                title = "Mobile Mode",
                text = "Mobile optimizations enabled!",
                type = "success",
                duration = 2
            })
        else
            UI:CreateNotification({
                title = "Mobile Mode",
                text = "Mobile optimizations disabled",
                type = "info",
                duration = 2
            })
        end
    end)
    
    mobileTab:CreateButton("Create Mobile Window", function()
        -- Create a smaller window optimized for mobile
        local mobileWindow = UI:CreateWindow("Mobile Window", UDim2.new(0, 350, 0, 250))
        local mobileTab = mobileWindow:CreateTab("Mobile", "📱")
        
        mobileTab:CreateLabel("This window is mobile-optimized!")
        mobileTab:CreateLabel("Smaller size, touch-friendly controls.")
        
        mobileTab:CreateButton("Close Mobile Window", function()
            mobileWindow.Frame:Destroy()
        end)
        
        UI:CreateNotification({
            title = "Mobile Window",
            text = "Created mobile-optimized window!",
            type = "success",
            duration = 3
        })
    end)
    
    -- Show welcome notification
    UI:CreateNotification({
        title = "Universal Script Hub Loaded",
        text = "Fully compatible with Mobile, Tablet, and Desktop!",
        type = "success",
        duration = 5
    })
    
    -- Device-specific welcome message
    task.wait(2)
    local deviceMessage = ""
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        deviceMessage = "Mobile device detected! Use touch gestures to interact."
    elseif UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
        deviceMessage = "Tablet detected! Touch and keyboard controls available."
    else
        deviceMessage = "Desktop detected! Mouse and keyboard controls available."
    end
    
    UI:CreateNotification({
        title = "Device Optimized",
        text = deviceMessage,
        type = "info",
        duration = 4
    })
    
    -- Show toggle UI instructions
    task.wait(3)
    UI:CreateNotification({
        title = "Toggle UI Guide",
        text = "⚡ Drag the toggle button to move it. Tap to show/hide interface!",
        type = "info",
        duration = 5
    })
end

-- Start the application
-- Uncomment the next line to use the key system
-- createKeySystem()

-- Or start directly with the main interface
createMainInterface()

-- Print success message with device info
local deviceType = "Unknown"
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    deviceType = "Mobile"
elseif UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
    deviceType = "Tablet"
else
    deviceType = "Desktop"
end

print("🚀 Universal Script Hub loaded successfully!")
print("📖 Version: " .. ProfessionalUI.Version)
print("👨‍💻 Created by: " .. ProfessionalUI.Author)
print("📱 Device: " .. deviceType)
print("🎮 Features: Universal dragging, Compact toggle UI, Touch support")
print("✨ Optimized for all devices and screen sizes!")
