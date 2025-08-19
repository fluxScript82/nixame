--[[
    Nixam UI Library for Roblox Executors
    Features:
    - Section, tabs, Buttons, sliders, dropdowns, toggles, labels, text inputs
    - Themes and customization
    - Notifications system with 5-minute reminders
    - Mini UI that can be opened and closed
    - Key system for authentication
]]

local TweenService = game:GetService("TweenService")

local DEFAULT_THEME = {
    Background = Color3.fromRGB(25,25,25),
    Accent = Color3.fromRGB(55,110,255),
    Foreground = Color3.fromRGB(200,200,200),
    Section = Color3.fromRGB(40,40,40),
    Button = Color3.fromRGB(40,60,120),
    ToggleOn = Color3.fromRGB(55,110,255),
    ToggleOff = Color3.fromRGB(80,80,80),
    Slider = Color3.fromRGB(80,80,80),
    Dropdown = Color3.fromRGB(50,50,50),
    Input = Color3.fromRGB(60,60,60),
    Notification = Color3.fromRGB(55,110,255)
}

local Nixam = {}
Nixam.__index = Nixam

-- UTILITY
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- KEY SYSTEM
function Nixam:PromptKey(correctKey, callback)
    local cover = create("Frame", {
        Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.5, Parent = self.ScreenGui, ZIndex = 999
    })
    local box = create("Frame", {
        Size = UDim2.new(0,300,0,150), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = self.Theme.Section, Parent = cover, ZIndex = 1000
    })
    local lbl = create("TextLabel", {
        Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1, Text = "Enter Key to Access Nixam UI",
        Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = self.Theme.Accent, Parent = box, ZIndex = 1001
    })
    local input = create("TextBox", {
        Size = UDim2.new(0.8,0,0,35), Position = UDim2.new(0.1,0,0.45,0), PlaceholderText = "Enter Key...",
        Font = Enum.Font.GothamSemibold, TextSize = 16, TextColor3 = self.Theme.Foreground,
        BackgroundColor3 = self.Theme.Input, BorderSizePixel = 0, Parent = box, ZIndex = 1001
    })
    local btn = create("TextButton", {
        Size = UDim2.new(0.6,0,0,30), Position = UDim2.new(0.2,0,0.75,0), Text = "Submit",
        Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.new(1,1,1),
        BackgroundColor3 = self.Theme.Accent, BorderSizePixel = 0, Parent = box, ZIndex = 1001
    })
    btn.MouseButton1Click:Connect(function()
        if input.Text == correctKey then
            cover:Destroy()
            if callback then callback(true) end
        else
            lbl.Text = "Incorrect Key! Try again."
            lbl.TextColor3 = Color3.fromRGB(255,80,80)
        end
    end)
end

-- THEME SYSTEM
function Nixam:SetTheme(themeTable)
    for k,v in pairs(themeTable) do
        if self.Theme[k] then
            self.Theme[k] = v
        end
    end
end

-- NOTIFICATION SYSTEM
function Nixam:Notify(msg, duration)
    duration = duration or 5
    local notif = create("Frame", {
        Size = UDim2.new(0,250,0,50), Position = UDim2.new(1,10,0.9,0), AnchorPoint = Vector2.new(1,0),
        BackgroundColor3 = self.Theme.Notification, BackgroundTransparency = 0, Parent = self.ScreenGui, ZIndex = 300
    })
    local txt = create("TextLabel", {
        Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = msg, Font = Enum.Font.GothamSemibold,
        TextSize = 16, TextColor3 = Color3.new(1,1,1), Parent = notif, ZIndex = 301
    })
    tween(notif, {Position = UDim2.new(1,-10,0.9,0)}, 0.3)
    task.spawn(function()
        wait(duration)
        tween(notif, {Position = UDim2.new(1,250,0.9,0)}, 0.3)
        wait(0.4)
        notif:Destroy()
    end)
end

function Nixam:Start5MinReminder(text)
    task.spawn(function()
        while true do
            self:Notify(text or "5 minute reminder!", 4)
            wait(300)
        end
    end)
end

-- MINI UI
function Nixam:ToggleMini(state)
    self.MiniUI.Visible = state
end

function Nixam:CreateMiniUI()
    local mini = create("Frame", {
        Name = "MiniUI",
        Size = UDim2.new(0, 120, 0, 40),
        Position = UDim2.new(1, -130, 1, -50),
        AnchorPoint = Vector2.new(0,1),
        BackgroundColor3 = self.Theme.Section,
        Visible = false,
        Parent = self.ScreenGui,
        ZIndex = 200
    })
    local openBtn = create("TextButton", {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        Text = "Open UI",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = self.Theme.Accent,
        Parent = mini,
        ZIndex = 201
    })
    openBtn.MouseButton1Click:Connect(function()
        self.MainUI.Visible = true
        mini.Visible = false
    end)
    self.MiniUI = mini
end

-- MAIN UI CONSTRUCTION
function Nixam:Init(title)
    self.ScreenGui = create("ScreenGui", { Name = "NixamUI", ResetOnSpawn = false, Parent = game:GetService("CoreGui") })
    self.Theme = table.clone(DEFAULT_THEME)
    -- Main UI
    self.MainUI = create("Frame", {
        Name = "MainUI",
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        Parent = self.ScreenGui,
        ZIndex = 100
    })
    create("UICorner", { CornerRadius = UDim.new(0,10), Parent = self.MainUI })
    -- Title Bar
    local titleBar = create("Frame", {
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = self.Theme.Section,
        BorderSizePixel = 0,
        Parent = self.MainUI,
        ZIndex = 101
    })
    local titleLbl = create("TextLabel", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = title or "Nixam UI",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = self.Theme.Accent,
        Parent = titleBar,
        ZIndex = 102
    })
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0,32,1,0), Position = UDim2.new(1,-36,0,0),
        BackgroundTransparency = 1, Text = "✕", Font = Enum.Font.GothamBold, TextSize = 20,
        TextColor3 = self.Theme.Accent, Parent = titleBar, ZIndex = 103
    })
    closeBtn.MouseButton1Click:Connect(function()
        self.MainUI.Visible = false
        self.MiniUI.Visible = true
    end)
    -- Tabs
    self.Tabs = {}
    self.TabHolder = create("Frame", {
        Size = UDim2.new(0, 120, 1, -36),
        Position = UDim2.new(0,0,0,36),
        BackgroundColor3 = self.Theme.Section,
        BorderSizePixel = 0,
        Parent = self.MainUI,
        ZIndex = 110
    })
    local tabList = create("UIListLayout", { Parent = self.TabHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,4) })
    self.ContentFrame = create("Frame", {
        Size = UDim2.new(1, -130, 1, -46),
        Position = UDim2.new(0,130,0,42),
        BackgroundTransparency = 1,
        Parent = self.MainUI,
        ZIndex = 120
    })
    self:CreateMiniUI()
    return self
end

-- TABS & SECTIONS
function Nixam:AddTab(tabName)
    local tabBtn = create("TextButton", {
        Size = UDim2.new(1, -8, 0, 32),
        BackgroundColor3 = self.Theme.Button,
        Text = tabName,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = self.Theme.Accent,
        Parent = self.TabHolder,
        ZIndex = 111
    })
    local tabFrame = create("Frame", {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentFrame,
        ZIndex = 121
    })
    local secList = create("UIListLayout", { Parent = tabFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,8) })
    self.Tabs[tabName] = {Button = tabBtn, Frame = tabFrame, Sections = {}}
    tabBtn.MouseButton1Click:Connect(function()
        for name,tab in pairs(self.Tabs) do
            tab.Frame.Visible = false
            tab.Button.BackgroundColor3 = self.Theme.Button
        end
        tabFrame.Visible = true
        tabBtn.BackgroundColor3 = self.Theme.Accent
    end)
    if not self.CurrentTab then
        tabFrame.Visible = true
        tabBtn.BackgroundColor3 = self.Theme.Accent
        self.CurrentTab = tabName
    end
    return setmetatable({
        AddSection = function(_, secName)
            return self:AddSection(tabName, secName)
        end
    }, {__index = self.Tabs[tabName]})
end

function Nixam:AddSection(tabName, secName)
    local tab = self.Tabs[tabName]
    assert(tab, "Tab does not exist")
    local sec = create("Frame", {
        Size = UDim2.new(1, -10, 0, 44),
        BackgroundColor3 = self.Theme.Section,
        BorderSizePixel = 0,
        Parent = tab.Frame,
        ZIndex = 122
    })
    local secLbl = create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 20),
        Position = UDim2.new(0,4,0,4),
        BackgroundTransparency = 1,
        Text = secName,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = self.Theme.Accent,
        Parent = sec,
        ZIndex = 123
    })
    local compList = create("UIListLayout", { Parent = sec, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,2) })
    tab.Sections[secName] = sec
    return setmetatable({
        AddButton = function(_, txt, cb)
            return Nixam.AddButton(self, sec, txt, cb)
        end,
        AddSlider = function(_, txt, min, max, def, cb)
            return Nixam.AddSlider(self, sec, txt, min, max, def, cb)
        end,
        AddDropdown = function(_, txt, options, cb)
            return Nixam.AddDropdown(self, sec, txt, options, cb)
        end,
        AddToggle = function(_, txt, def, cb)
            return Nixam.AddToggle(self, sec, txt, def, cb)
        end,
        AddLabel = function(_, txt)
            return Nixam.AddLabel(self, sec, txt)
        end,
        AddInput = function(_, txt, cb)
            return Nixam.AddInput(self, sec, txt, cb)
        end
    }, {__index = sec})
end

-- COMPONENTS
function Nixam.AddButton(self, parent, txt, cb)
    local btn = create("TextButton", {
        Size = UDim2.new(1, -8, 0, 30),
        Position = UDim2.new(0,4,0,0),
        BackgroundColor3 = self.Theme.Button,
        Text = txt,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = Color3.new(1,1,1),
        Parent = parent,
        ZIndex = 130
    })
    btn.MouseButton1Click:Connect(cb)
    return btn
end

function Nixam.AddSlider(self, parent, txt, min, max, def, cb)
    local frame = create("Frame", {
        Size = UDim2.new(1, -8, 0, 34),
        Position = UDim2.new(0,4,0,0),
        BackgroundTransparency = 1,
        Parent = parent,
        ZIndex = 140
    })
    local lbl = create("TextLabel", {
        Size = UDim2.new(0.55,0,1,0),
        Text = string.format("%s: %d", txt, def),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = self.Theme.Foreground,
        Parent = frame,
        ZIndex = 141
    })
    local sliderBar = create("Frame", {
        Size = UDim2.new(0.35,0,0,8),
        Position = UDim2.new(0.6,0,0.5,-4),
        BackgroundColor3 = self.Theme.Slider,
        BorderSizePixel = 0,
        Parent = frame,
        ZIndex = 142
    })
    local sliderFill = create("Frame", {
        Size = UDim2.new((def-min)/(max-min),0,1,0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Parent = sliderBar,
        ZIndex = 143
    })
    local dragging = false
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X,0,1)
            sliderFill.Size = UDim2.new(pos,0,1,0)
            local val = math.floor(min + (max-min)*pos)
            lbl.Text = string.format("%s: %d", txt, val)
            cb(val)
        end
    end)
    return frame
end

function Nixam.AddDropdown(self, parent, txt, options, cb)
    local frame = create("Frame", {
        Size = UDim2.new(1, -8, 0, 32),
        Position = UDim2.new(0,4,0,0),
        BackgroundTransparency = 1,
        Parent = parent,
        ZIndex = 150
    })
    local lbl = create("TextLabel", {
        Size = UDim2.new(0.4,0,1,0),
        Text = txt,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = self.Theme.Foreground,
        Parent = frame,
        ZIndex = 151
    })
    local box = create("TextButton", {
        Size = UDim2.new(0.58,0,1,0),
        Position = UDim2.new(0.42,0,0,0),
        Text = options[1],
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = self.Theme.Accent,
        BackgroundColor3 = self.Theme.Dropdown,
        BorderSizePixel = 0,
        Parent = frame,
        ZIndex = 152
    })
    local open = false
    local dropFrame
    box.MouseButton1Click:Connect(function()
        if open then if dropFrame then dropFrame:Destroy() end open = false return end
        open = true
        dropFrame = create("Frame", {
            Size = UDim2.new(1,0,0,#options*26),
            Position = UDim2.new(0,0,1,0),
            BackgroundColor3 = self.Theme.Dropdown,
            BorderSizePixel = 0,
            Parent = frame,
            ZIndex = 153
        })
        for i,opt in ipairs(options) do
            local optBtn = create("TextButton", {
                Size = UDim2.new(1,0,0,26),
                Position = UDim2.new(0,0,0,(i-1)*26),
                Text = opt,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.Foreground,
                BackgroundTransparency = 1,
                Parent = dropFrame,
                ZIndex = 154
            })
            optBtn.MouseButton1Click:Connect(function()
                box.Text = opt
                cb(opt)
                dropFrame:Destroy()
                open = false
            end)
        end
    end)
    return frame
end

function Nixam.AddToggle(self, parent, txt, def, cb)
    local frame = create("Frame", {
        Size = UDim2.new(1, -8, 0, 28),
        Position = UDim2.new(0,4,0,0),
        BackgroundTransparency = 1,
        Parent = parent,
        ZIndex = 160
    })
    local lbl = create("TextLabel", {
        Size = UDim2.new(0.7,0,1,0),
        Text = txt,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = self.Theme.Foreground,
        Parent = frame,
        ZIndex = 161
    })
    local box = create("TextButton", {
        Size = UDim2.new(0,24,0,24), Position = UDim2.new(1,-28,0.5,-12),
        BackgroundColor3 = def and self.Theme.ToggleOn or self.Theme.ToggleOff,
        BorderSizePixel = 0,
        Text = "",
        Parent = frame,
        ZIndex = 162
    })
    local toggled = def
    box.MouseButton1Click:Connect(function()
        toggled = not toggled
        box.BackgroundColor3 = toggled and self.Theme.ToggleOn or self.Theme.ToggleOff
        cb(toggled)
    end)
    return frame
end

function Nixam.AddLabel(self, parent, txt)
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 22),
        Position = UDim2.new(0,4,0,0),
        BackgroundTransparency = 1,
        Text = txt,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = self.Theme.Foreground,
        Parent = parent,
        ZIndex = 170
    })
    return lbl
end

function Nixam.AddInput(self, parent, txt, cb)
    local frame = create("Frame", {
        Size = UDim2.new(1, -8, 0, 28),
        Position = UDim2.new(0,4,0,0),
        BackgroundTransparency = 1,
        Parent = parent,
        ZIndex = 180
    })
    local lbl = create("TextLabel", {
        Size = UDim2.new(0.45,0,1,0),
        Text = txt,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = self.Theme.Foreground,
        Parent = frame,
        ZIndex = 181
    })
    local box = create("TextBox", {
        Size = UDim2.new(0.5,0,1,0),
        Position = UDim2.new(0.48,0,0,0),
        PlaceholderText = "Type...",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = self.Theme.Accent,
        BackgroundColor3 = self.Theme.Input,
        BorderSizePixel = 0,
        Parent = frame,
        ZIndex = 182
    })
    box.FocusLost:Connect(function(enter)
        if enter then
            cb(box.Text)
        end
    end)
    return frame
end

-- UI TOGGLE KEYBIND (F4 by default)
function Nixam:BindToggleKey(key)
    key = key or Enum.KeyCode.F4
    game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == key then
            self.MainUI.Visible = not self.MainUI.Visible
            self.MiniUI.Visible = not self.MainUI.Visible
        end
    end)
end

-- LIBRARY ENTRY POINT
function Nixam.new(title)
    local self = setmetatable({}, Nixam)
    self:Init(title or "Nixam UI")
    self:BindToggleKey()
    return self
end

return Nixam
