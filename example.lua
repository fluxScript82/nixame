--[[
    Professional UI Library - Enhanced Example with Toggle UI
    
    This demonstrates the new draggable functionality and toggle UI
]]

-- Load the library via loadstring (replace with your actual URL)
local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/refs/heads/main/source.lua"))()

-- Create the UI instance
local UI = ProfessionalUI.new({
    theme = "Dark" -- Available: "Dark", "Light", "Purple", "Red", "Green", "Cyberpunk"
})

-- Optional: Create a key system
local function createKeySystem()
    UI:CreateKeySystem({
        title = "Professional Script Hub",
        description = "Please enter your key to access premium features",
        key = "ProfessionalKey2024", -- Your actual key
        keyLink = "https://linkvertise.com/your-key-link", -- Your key link
        saveKey = true, -- Allow users to save their key
        callback = function()
            print("✅ Access granted! Loading main interface...")
            createMainInterface()
        end,
        closeCallback = function()
            print("❌ Key system closed")
        end
    })
end

-- Create the main interface
local function createMainInterface()
    -- Create main window (now draggable!)
    local mainWindow = UI:CreateWindow("Professional Script Hub", UDim2.new(0, 650, 0, 450))
    
    -- Create tabs
    local homeTab = mainWindow:CreateTab("Home", "🏠")
    local scriptsTab = mainWindow:CreateTab("Scripts", "📜")
    local settingsTab = mainWindow:CreateTab("Settings", "⚙️")
    local premiumTab = mainWindow:CreateTab("Premium", "⭐")
    
    -- Home Tab
    homeTab:CreateLabel("Welcome to Professional Script Hub!")
    homeTab:CreateLabel("🎮 Use the toggle UI on the left to show/hide this interface")
    homeTab:CreateLabel("🖱️ Drag windows by their title bars to move them around")
    
    homeTab:CreateButton("Test Toggle UI", function()
        UI:ToggleVisibility()
        task.wait(2)
        UI:ToggleVisibility()
        UI:CreateNotification({
            title = "Toggle Test",
            text = "Toggle UI functionality demonstrated!",
            type = "success",
            duration = 3
        })
    end)
    
    homeTab:CreateButton("Show Welcome Message", function()
        UI:CreateNotification({
            title = "Welcome!",
            text = "Thanks for using Professional Script Hub with enhanced features!",
            type = "success",
            duration = 4
        })
    end)
    
    homeTab:CreateButton("Hide Interface", function()
        UI:Hide()
        UI:CreateNotification({
            title = "Interface Hidden",
            text = "Click the toggle UI to show the interface again",
            type = "info",
            duration = 3
        })
    end)
    
    -- Scripts Tab
    scriptsTab:CreateLabel("Available Scripts")
    scriptsTab:CreateLabel("All scripts are now in draggable windows!")
    
    scriptsTab:CreateButton("Universal ESP", function()
        UI:CreateNotification({
            title = "ESP Loaded",
            text = "Universal ESP has been activated!",
            type = "success",
            duration = 3
        })
        -- Your ESP script here
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
                text = "Auto farm has been enabled!",
                type = "success",
                duration = 2
            })
            -- Your auto farm logic here
            print("Auto farm enabled")
        else
            UI:CreateNotification({
                title = "Auto Farm",
                text = "Auto farm has been disabled",
                type = "info",
                duration = 2
            })
            print("Auto farm disabled")
        end
    end)
    
    local speedSlider = scriptsTab:CreateSlider("Walk Speed", 16, 100, 16, function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end)
    
    -- Settings Tab
    settingsTab:CreateLabel("Theme Settings")
    settingsTab:CreateLabel("Choose your preferred theme:")
    
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
    
    local uiScaleSlider = settingsTab:CreateSlider("UI Scale", 50, 150, 100, function(value)
        print("UI Scale:", value .. "%")
        -- You could implement UI scaling here
    end)
    
    -- Premium Tab
    premiumTab:CreateLabel("Premium Features")
    premiumTab:CreateLabel("Unlock exclusive scripts and enhanced functionality!")
    
    premiumTab:CreateButton("Premium Script 1", function()
        UI:CreateNotification({
            title = "Premium Feature",
            text = "Premium Script 1 has been executed!",
            type = "success",
            duration = 3
        })
        -- Your premium script here
    end)
    
    premiumTab:CreateButton("Premium Script 2", function()
        UI:CreateNotification({
            title = "Premium Feature", 
            text = "Premium Script 2 has been executed!",
            type = "success",
            duration = 3
        })
        -- Your premium script here
    end)
    
    premiumTab:CreateButton("Advanced Features", function()
        -- Create a second window to demonstrate multiple draggable windows
        local advancedWindow = UI:CreateWindow("Advanced Features", UDim2.new(0, 400, 0, 300))
        local advancedTab = advancedWindow:CreateTab("Advanced", "🚀")
        
        advancedTab:CreateLabel("This is a second draggable window!")
        advancedTab:CreateLabel("You can have multiple windows open at once.")
        
        advancedTab:CreateButton("Close This Window", function()
            advancedWindow.Frame:Destroy()
        end)
        
        UI:CreateNotification({
            title = "Advanced Window",
            text = "Created a second draggable window!",
            type = "success",
            duration = 3
        })
    end)
    
    premiumTab:CreateButton("Get Premium", function()
        if setclipboard then
            setclipboard("https://discord.gg/your-discord")
            UI:CreateNotification({
                title = "Premium Info",
                text = "Discord link copied! Join for premium access.",
                type = "info",
                duration = 4
            })
        else
            UI:CreateNotification({
                title = "Premium Info",
                text = "Join our Discord: discord.gg/your-discord",
                type = "info",
                duration = 5
            })
        end
    end)
    
    -- Show welcome notification
    UI:CreateNotification({
        title = "Professional Script Hub Loaded",
        text = "Enhanced version with draggable windows and toggle UI!",
        type = "success",
        duration = 5
    })
    
    -- Demonstrate toggle UI after a delay
    task.wait(3)
    UI:CreateNotification({
        title = "Toggle UI Available",
        text = "Use the UI button on the left to show/hide the interface!",
        type = "info",
        duration = 4
    })
end

-- Start the application
-- Uncomment the next line to use the key system
-- createKeySystem()

-- Or start directly with the main interface
createMainInterface()

-- Print success message
print("🚀 Professional Script Hub Enhanced loaded successfully!")
print("📖 Version: " .. ProfessionalUI.Version)
print("👨‍💻 Created by: " .. ProfessionalUI.Author)
print("🎮 Features: Draggable windows, Toggle UI, Enhanced UX")
