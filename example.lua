--[[
    Professional UI Library - Loadstring Example
    
    This demonstrates how to use the library when loaded via loadstring
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
    -- Create main window
    local mainWindow = UI:CreateWindow("Professional Script Hub", UDim2.new(0, 650, 0, 450))
    
    -- Create tabs
    local homeTab = mainWindow:CreateTab("Home", "🏠")
    local scriptsTab = mainWindow:CreateTab("Scripts", "📜")
    local settingsTab = mainWindow:CreateTab("Settings", "⚙️")
    local premiumTab = mainWindow:CreateTab("Premium", "⭐")
    
    -- Home Tab
    homeTab:CreateLabel("Welcome to Professional Script Hub!")
    homeTab:CreateLabel("Your premium scripting solution for Roblox")
    
    homeTab:CreateButton("Show Welcome Message", function()
        UI:CreateNotification({
            title = "Welcome!",
            text = "Thanks for using Professional Script Hub. Enjoy premium features!",
            type = "success",
            duration = 4
        })
    end)
    
    homeTab:CreateButton("Check Status", function()
        UI:CreateNotification({
            title = "System Status",
            text = "All systems operational. Ready for scripting!",
            type = "info",
            duration = 3
        })
    end)
    
    -- Scripts Tab
    scriptsTab:CreateLabel("Available Scripts")
    
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
        local speedEnabled = false
        speedEnabled = not speedEnabled
        
        if speedEnabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
            UI:CreateNotification({
                title = "Speed Hack",
                text = "Speed increased to 50!",
                type = "success",
                duration = 2
            })
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            UI:CreateNotification({
                title = "Speed Hack",
                text = "Speed reset to normal",
                type = "info",
                duration = 2
            })
        end
    end)
    
    scriptsTab:CreateButton("Jump Power", function()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
        UI:CreateNotification({
            title = "Jump Power",
            text = "Jump power increased to 100!",
            type = "success",
            duration = 2
        })
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
    
    -- Settings Tab
    settingsTab:CreateLabel("Theme Settings")
    
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
    
    settingsTab:CreateLabel("Script Settings")
    
    local notificationsToggle = settingsTab:CreateToggle("Enable Notifications", true, function(value)
        print("Notifications:", value and "enabled" or "disabled")
    end)
    
    local autoExecuteToggle = settingsTab:CreateToggle("Auto Execute on Join", false, function(value)
        print("Auto execute:", value and "enabled" or "disabled")
    end)
    
    -- Premium Tab
    premiumTab:CreateLabel("Premium Features")
    premiumTab:CreateLabel("Unlock exclusive scripts and features!")
    
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
        text = "All features are now available. Welcome to the premium experience!",
        type = "success",
        duration = 5
    })
end

-- Start the application
-- Uncomment the next line to use the key system
-- createKeySystem()

-- Or start directly with the main interface
createMainInterface()

-- Print success message
print("🚀 Professional Script Hub loaded successfully!")
print("📖 Version: " .. ProfessionalUI.Version)
print("👨‍💻 Created by: " .. ProfessionalUI.Author)
