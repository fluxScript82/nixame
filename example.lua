-- Example usage of the UI Library

local UILibrary = require(https://raw.githubusercontent.com/fluxScript82/nixame/refs/heads/main/source.lua)

-- Create the UI Library instance
local UI = UILibrary.new({
    theme = "Dark" -- Options: "Dark", "Light", "Blue"
})

-- Create a key system (optional)
local keySystem = UI:CreateKeySystem({
    title = "My Script Key System",
    description = "Please enter your key to access the script",
    key = "MySecretKey123",
    keyLink = "https://example.com/getkey",
    callback = function()
        print("Key accepted! Loading main UI...")
        createMainUI()
    end,
    closeCallback = function()
        print("Key system closed")
    end
})

function createMainUI()
    -- Create main window
    local window = UI:CreateWindow({
        title = "Advanced UI Library",
        size = UDim2.new(0, 600, 0, 400)
    })
    
    -- Create tabs
    local mainTab = window:CreateTab("Main", "🏠")
    local settingsTab = window:CreateTab("Settings", "⚙️")
    local aboutTab = window:CreateTab("About", "ℹ️")
    
    -- Main tab elements
    mainTab:CreateLabel("Welcome to the Advanced UI Library!")
    
    mainTab:CreateButton("Test Button", function()
        UI:CreateNotification({
            title = "Button Clicked",
            text = "You clicked the test button!",
            type = "success",
            duration = 3
        })
    end)
    
    local toggle = mainTab:CreateToggle("Enable Feature", false, function(value)
        print("Toggle value:", value)
    end)
    
    local slider = mainTab:CreateSlider("Speed", 1, 100, 50, function(value)
        print("Slider value:", value)
    end)
    
    local dropdown = mainTab:CreateDropdown("Select Option", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(value)
        print("Selected:", value)
    end)
    
    local textbox = mainTab:CreateTextbox("Enter Text", "Type something...", function(text, enterPressed)
        if enterPressed then
            print("Text entered:", text)
        end
    end)
    
    -- Settings tab elements
    settingsTab:CreateLabel("Theme Settings")
    
    settingsTab:CreateButton("Dark Theme", function()
        UI:SetTheme("Dark")
    end)
    
    settingsTab:CreateButton("Light Theme", function()
        UI:SetTheme("Light")
    end)
    
    settingsTab:CreateButton("Blue Theme", function()
        UI:SetTheme("Blue")
    end)
    
    settingsTab:CreateButton("Custom Theme", function()
        UI:CreateCustomTheme("Custom", {
            Background = Color3.fromRGB(20, 20, 30),
            Surface = Color3.fromRGB(30, 30, 40),
            Primary = Color3.fromRGB(255, 100, 150),
            Secondary = Color3.fromRGB(40, 40, 50),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(200, 200, 200),
            Success = Color3.fromRGB(100, 255, 100),
            Warning = Color3.fromRGB(255, 255, 100),
            Error = Color3.fromRGB(255, 100, 100),
            Border = Color3.fromRGB(60, 60, 70)
        })
        UI:SetTheme("Custom")
    end)
    
    -- About tab elements
    aboutTab:CreateLabel("Advanced Roblox UI Library")
    aboutTab:CreateLabel("Version: 2.0")
    aboutTab:CreateLabel("Features:")
    aboutTab:CreateLabel("• Modular and lightweight")
    aboutTab:CreateLabel("• Smooth animations")
    aboutTab:CreateLabel("• Multiple themes")
    aboutTab:CreateLabel("• Automatic scaling")
    aboutTab:CreateLabel("• Key system support")
    aboutTab:CreateButton("Show Notification", function()
        UI:CreateNotification({
            title = "Test Notification",
            text = "This is a test notification from the About tab!",
            type = "info",
            duration = 5
        })
    end)
    
    -- Show welcome notification
    UI:CreateNotification({
        title = "Welcome!",
        text = "UI Library loaded successfully. Enjoy using the advanced features!",
        type = "success",
        duration = 4
    })
end

-- If no key system is needed, create the main UI directly
-- createMainUI()
