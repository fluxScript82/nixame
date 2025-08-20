-- Example usage of Professional UI Library v3.0
-- Load with: local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source.lua"))()

local ProfessionalUI = require(script.Parent.ProfessionalUI_v3) -- For testing

-- Create enhanced key system
local keySystem = ProfessionalUI:CreateKeySystem({
    Title = "Professional UI v3.0",
    Subtitle = "Advanced Authentication",
    Description = "Enter your premium access key to unlock all features",
    Key = "ProfessionalUI_v3_2024",
    KeyLink = "https://example.com/getkey-v3",
    Theme = "Dark", -- Can be "Dark", "Light", or "Purple"
    Callback = function()
        print("🔓 Access granted! Loading Professional UI v3.0...")
        
        -- Create main window with enhanced features
        local Window = ProfessionalUI:CreateWindow({
            Title = "Professional UI Library v3.0",
            Size = Vector2.new(700, 500),
            Theme = "Dark",
            Draggable = true,
            MinimizeToTray = true
        })
        
        -- Create Main Tab
        local MainTab = Window:CreateTab({
            Name = "🏠 Main",
            Icon = nil
        })
        
        MainTab:CreateButton({
            Text = "🚀 Launch Feature",
            Callback = function()
                print("Feature launched!")
            end
        })
        
        -- Create Combat Tab
        local CombatTab = Window:CreateTab({
            Name = "⚔️ Combat"
        })
        
        -- Create Settings Tab
        local SettingsTab = Window:CreateTab({
            Name = "⚙️ Settings"
        })
        
        -- Create Info Tab
        local InfoTab = Window:CreateTab({
            Name = "ℹ️ Info"
        })
        
        print("✅ Professional UI v3.0 loaded successfully!")
    end
})

-- Alternative: Skip key system and load directly
--[[
local Window = ProfessionalUI:CreateWindow({
    Title = "Professional UI v3.0 - Direct Access",
    Size = Vector2.new(650, 450),
    Theme = "Purple", -- Try different themes!
    Draggable = true,
    MinimizeToTray = true
})

local TestTab = Window:CreateTab({
    Name = "Test Tab"
})

TestTab:CreateButton({
    Text = "Test Button",
    Callback = function()
        print("Hello from Professional UI v3.0!")
    end
})
--]]
