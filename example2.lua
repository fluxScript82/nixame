-- WORKING EXAMPLE - Copy this exact code to test
-- This should work in any Roblox executor

local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source2.lua"))()

-- Simple test without key system first
local Window = ProfessionalUI:CreateWindow({
    Title = "Professional UI v3.0 - Working!",
    Size = Vector2.new(500, 350),
    Theme = "Dark",
    Draggable = true,
    MinimizeToTray = true
})

-- Create a test tab
local MainTab = Window:CreateTab({
    Name = "Main"
})

-- Add some test elements
MainTab:CreateLabel({
    Text = "✅ Professional UI v3.0 is working!"
})

MainTab:CreateButton({
    Text = "Test Button",
    Callback = function()
        print("Button clicked! UI is working perfectly!")
    end
})

MainTab:CreateToggle({
    Text = "Test Toggle",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

-- Create another tab
local SettingsTab = Window:CreateTab({
    Name = "Settings"
})

SettingsTab:CreateLabel({
    Text = "Settings Tab - Everything works!"
})

SettingsTab:CreateButton({
    Text = "Print Message",
    Callback = function()
        print("Settings button works!")
    end
})

print("🎉 Professional UI v3.0 loaded successfully!")

-- Uncomment below to test with key system
--[[
local keySystem = ProfessionalUI:CreateKeySystem({
    Title = "Professional UI v3.0",
    Description = "Enter key to access the UI",
    Key = "test123",
    KeyLink = "https://example.com/key",
    Theme = "Dark",
    Callback = function()
        print("Key accepted! Loading main UI...")
        -- Put your main UI code here
    end
})
--]]
