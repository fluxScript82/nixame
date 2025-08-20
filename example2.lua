-- Example usage of the Professional UI Library
-- This would be loaded via: local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/refs/heads/main/source2.lua"))()

local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/refs/heads/main/source2.lua"))()

-- Create Key System (optional)
local keySystem = ProfessionalUI:CreateKeySystem({
    Title = "Professional UI - Key System",
    Description = "Enter your key to access the UI",
    Key = "ProfessionalUI2024",
    KeyLink = "https://example.com/getkey",
    Callback = function()
        print("Key accepted! Loading main UI...")
        
        -- Create main window after key verification
        local Window = ProfessionalUI:CreateWindow({
            Title = "Professional UI Library",
            Size = Vector2.new(600, 400),
            Theme = "Dark",
            Draggable = true
        })
        
        -- Create Main Tab
        local MainTab = Window:CreateTab({
            Name = "Main",
            Icon = nil
        })
        
        -- Add elements to Main tab
        MainTab:CreateLabel({
            Text = "Welcome to Professional UI Library!"
        })
        
        MainTab:CreateButton({
            Text = "Test Button",
            Callback = function()
                print("Button clicked!")
            end
        })
        
        MainTab:CreateToggle({
            Text = "Auto Farm",
            Default = false,
            Callback = function(value)
                print("Auto Farm:", value)
            end
        })
        
        MainTab:CreateSlider({
            Text = "Walk Speed",
            Min = 16,
            Max = 100,
            Default = 16,
            Callback = function(value)
                print("Walk Speed:", value)
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                end
            end
        })
        
        MainTab:CreateDropdown({
            Text = "Teleport Location",
            Options = {"Spawn", "Shop", "Boss Arena", "Secret Area"},
            Default = "Spawn",
            Callback = function(option)
                print("Selected location:", option)
            end
        })
        
        MainTab:CreateTextbox({
            Text = "Player Name",
            PlaceholderText = "Enter player name...",
            Default = "",
            Callback = function(text)
                print("Player name entered:", text)
            end
        })
        
        -- Create Settings Tab
        local SettingsTab = Window:CreateTab({
            Name = "Settings"
        })
        
        SettingsTab:CreateLabel({
            Text = "UI Settings"
        })
        
        SettingsTab:CreateToggle({
            Text = "Show Notifications",
            Default = true,
            Callback = function(value)
                print("Show Notifications:", value)
            end
        })
        
        SettingsTab:CreateSlider({
            Text = "UI Scale",
            Min = 50,
            Max = 150,
            Default = 100,
            Callback = function(value)
                print("UI Scale:", value)
            end
        })
        
        -- Create Combat Tab
        local CombatTab = Window:CreateTab({
            Name = "Combat"
        })
        
        CombatTab:CreateToggle({
            Text = "Auto Attack",
            Default = false,
            Callback = function(value)
                print("Auto Attack:", value)
            end
        })
        
        CombatTab:CreateToggle({
            Text = "Auto Block",
            Default = false,
            Callback = function(value)
                print("Auto Block:", value)
            end
        })
        
        CombatTab:CreateSlider({
            Text = "Attack Range",
            Min = 5,
            Max = 50,
            Default = 10,
            Callback = function(value)
                print("Attack Range:", value)
            end
        })
        
        CombatTab:CreateDropdown({
            Text = "Combat Style",
            Options = {"Aggressive", "Defensive", "Balanced"},
            Default = "Balanced",
            Callback = function(option)
                print("Combat Style:", option)
            end
        })
    end
})

-- If you want to skip the key system, uncomment the code below and comment out the key system above:
--[[
local Window = ProfessionalUI:CreateWindow({
    Title = "Professional UI Library",
    Size = Vector2.new(600, 400),
    Theme = "Dark",
    Draggable = true
})

local MainTab = Window:CreateTab({
    Name = "Main"
})

MainTab:CreateButton({
    Text = "Test Button",
    Callback = function()
        print("Hello World!")
    end
})
--]]
