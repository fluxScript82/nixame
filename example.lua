-- Load Roblox services
local UserInputService = game:GetService("UserInputService")

-- Load your UI library from GitHub
local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source.lua"))()

-- Utils: Either define Utils or require from your UI library
local Utils = ProfessionalUI.Utils or {} -- Adjust as needed!

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
function createMainInterface()
    -- Create main window (universally draggable!)
    local mainWindow = UI:CreateWindow("Universal Script Hub", UDim2.new(0, 650, 0, 450))
    
    -- Create tabs
    local homeTab = mainWindow:CreateTab("Home", "🏠")
    local scriptsTab = mainWindow:CreateTab("Scripts", "📜")
    local settingsTab = mainWindow:CreateTab("Settings", "⚙️")
    local mobileTab = mainWindow:CreateTab("Mobile", "📱")
    
    -- Home Tab
    homeTab:CreateLabel("lcome to Nixam Script Hub!")
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
        local titleBar = mainWindow.TitleBar
        if Utils.Tween then
            local originalColor = titleBar.BackgroundColor3
            Utils.Tween(titleBar, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.3)
            task.wait(0.5)
            Utils.Tween(titleBar, {BackgroundColor3 = originalColor}, 0.3)
        end
    end)

    homeTab:CreateButton("Center All Windows", function()
        for _, window in ipairs(UI.Windows) do
            if window.Frame then
                local windowWidth = window.Size.X.Offset
                local windowHeight = window.Size.Y.Offset
                if Utils.Tween then
                    Utils.Tween(window.Frame, {
                        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
                    }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                else
                    window.Frame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
                end
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
    
   local autoFarmToggle = homeTab:CreateToggle("Auto Farm", false, function(value)
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
    
    scriptsTab:CreateToggle("Auto Farm", false, function(value)
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
end

-- MAIN ENTRYPOINT
if UI.CreateKeySystem then
    createKeySystem()
else
    createMainInterface()
end
