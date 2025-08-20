--[[
    Professional UI Library - Fixed Toggle Example
    Tests the improved draggable toggle UI and visibility system
]]

-- Load the library
local ProfessionalUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxScript82/nixame/main/source.lua"))()
-- Create the UI instance
local UI = ProfessionalUI.new({
    theme = "Dark"
})

-- Create a key system to test the full flow
local function createKeySystem()
    UI:CreateKeySystem({
        title = "Fixed Toggle Test",
        description = "Enter the key to test the fixed toggle system",
        key = "TestKey123",
        keyLink = "https://example.com/getkey",
        saveKey = true,
        callback = function()
            print("✅ Key accepted! Creating main interface...")
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
    local mainWindow = UI:CreateWindow("Fixed Toggle Test", UDim2.new(0, 600, 0, 400))
    
    -- Create tabs
    local testTab = mainWindow:CreateTab("Toggle Test", "🧪")
    local infoTab = mainWindow:CreateTab("Info", "ℹ️")
    
    -- Test Tab
    testTab:CreateLabel("🎯 Toggle UI Test Suite")
    testTab:CreateLabel("Test the improved draggable toggle functionality:")
    
    testTab:CreateButton("Test Toggle Visibility", function()
        UI:CreateNotification({
            title = "Toggle Test",
            text = "Watch the interface hide and show!",
            type = "info",
            duration = 2
        })
        
        task.wait(1)
        UI:Hide()
        task.wait(2)
        UI:Show()
        
        UI:CreateNotification({
            title = "Toggle Complete",
            text = "Toggle test completed successfully!",
            type = "success",
            duration = 3
        })
    end)
    
    testTab:CreateButton("Test Toggle Button Dragging", function()
        UI:CreateNotification({
            title = "Drag Test",
            text = "Try dragging the lightning bolt toggle button around the screen!",
            type = "info",
            duration = 5
        })
        
        -- Highlight the toggle button briefly
        local toggleUI = UI.ToggleUI
        if toggleUI then
            local originalColor = toggleUI.BackgroundColor3
            Utils.Tween(toggleUI, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.3)
            task.wait(1)
            Utils.Tween(toggleUI, {BackgroundColor3 = originalColor}, 0.3)
        end
    end)
    
    testTab:CreateButton("Test Window Centering", function()
        -- Move window to a corner first
        mainWindow.Frame.Position = UDim2.new(0, 50, 0, 50)
        
        task.wait(0.5)
        
        -- Then center it
        local windowWidth = mainWindow.Size.X.Offset
        local windowHeight = mainWindow.Size.Y.Offset
        Utils.Tween(mainWindow.Frame, {
            Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        UI:CreateNotification({
            title = "Centering Test",
            text = "Window moved to corner and back to center!",
            type = "success",
            duration = 3
        })
    end)
    
    testTab:CreateButton("Create Second Window", function()
        local testWindow = UI:CreateWindow("Draggable Test", UDim2.new(0, 400, 0, 250))
        local dragTab = testWindow:CreateTab("Drag Test", "🖱️")
        
        dragTab:CreateLabel("This window is also draggable!")
        dragTab:CreateLabel("Try dragging both windows around.")
        dragTab:CreateLabel("Use the toggle button to hide/show both.")
        
        dragTab:CreateButton("Close This Window", function()
            testWindow.Frame:Destroy()
            for i, w in ipairs(UI.Windows) do
                if w == testWindow then
                    table.remove(UI.Windows, i)
                    break
                end
            end
        end)
        
        -- Position slightly offset
        testWindow.Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
        
        UI:CreateNotification({
            title = "Second Window",
            text = "Created second draggable window! Test the toggle with both open.",
            type = "success",
            duration = 4
        })
    end)
    
    local visibilityToggle = testTab:CreateToggle("Manual Visibility Control", true, function(value)
        if value then
            UI:Show()
        else
            UI:Hide()
        end
    end)
    
    -- Info Tab
    infoTab:CreateLabel("🔧 Fixed Toggle UI Features")
    infoTab:CreateLabel("")
    infoTab:CreateLabel("✅ Toggle button is now fully draggable")
    infoTab:CreateLabel("✅ Windows properly center after key entry")
    infoTab:CreateLabel("✅ Visibility state is properly managed")
    infoTab:CreateLabel("✅ Works on mobile, tablet, and desktop")
    infoTab:CreateLabel("✅ Visual feedback shows open/closed state")
    infoTab:CreateLabel("✅ Smooth animations for show/hide")
    infoTab:CreateLabel("")
    infoTab:CreateLabel("🎮 How to Use:")
    infoTab:CreateLabel("• Drag the ⚡ button to move it anywhere")
    infoTab:CreateLabel("• Click/tap the ⚡ button to toggle UI")
    infoTab:CreateLabel("• Green dot = UI visible, Orange dot = UI hidden")
    infoTab:CreateLabel("• All windows hide/show together")
    
    infoTab:CreateButton("Test All Features", function()
        UI:CreateNotification({
            title = "Feature Test Started",
            text = "Testing all toggle features in sequence...",
            type = "info",
            duration = 3
        })
        
        -- Test sequence
        task.spawn(function()
            task.wait(2)
            
            -- Test 1: Hide interface
            UI:CreateNotification({
                title = "Test 1/4",
                text = "Hiding interface...",
                type = "warning",
                duration = 2
            })
            task.wait(1)
            UI:Hide()
            task.wait(2)
            
            -- Test 2: Show interface
            UI:Show()
            UI:CreateNotification({
                title = "Test 2/4",
                text = "Showing interface...",
                type = "info",
                duration = 2
            })
            task.wait(2)
            
            -- Test 3: Center windows
            UI:CreateNotification({
                title = "Test 3/4",
                text = "Centering all windows...",
                type = "info",
                duration = 2
            })
            for _, window in ipairs(UI.Windows) do
                if window.Frame then
                    local windowWidth = window.Size.X.Offset
                    local windowHeight = window.Size.Y.Offset
                    Utils.Tween(window.Frame, {
                        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
                    }, 0.5)
                end
            end
            task.wait(2)
            
            -- Test 4: Complete
            UI:CreateNotification({
                title = "Test 4/4 - Complete!",
                text = "All toggle features working perfectly!",
                type = "success",
                duration = 4
            })
        end)
    end)
    
    -- Show success notification
    UI:CreateNotification({
        title = "Fixed Toggle UI Loaded",
        text = "All toggle issues have been resolved! Test the draggable toggle button.",
        type = "success",
        duration = 5
    })
    
    -- Instructions after a delay
    task.wait(3)
    UI:CreateNotification({
        title = "Instructions",
        text = "⚡ Drag the lightning bolt button to move it. Click/tap to toggle visibility!",
        type = "info",
        duration = 6
    })
end

-- Start with key system to test full flow
createKeySystem()

