--[[
    Example usage of the Professional UI Library
    Load via: local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/refs/heads/main/source2.lua"))()
]]

local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/refs/heads/main/source2.lua"))()
if not ProfessionalUI then
    warn("Failed to load Professional UI Library.")
    return
end

-- Key System (Optional)
ProfessionalUI:CreateKeySystem({
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
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
                end
            end
        })

        MainTab:CreateDropdown({
            Text = "Teleport Location",
            Options = {"Spawn", "Shop", "Boss Arena", "Secret Area"},
            Default = "Spawn",
            Callback = function(option)
                print("Selected location:", option)
                -- Add teleport functionality here if needed
            end
        })

    end
})
