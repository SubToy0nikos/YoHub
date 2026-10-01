local MemesenseLib = {}
MemesenseLib.__index = MemesenseLib

-- Services
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Memesense Exact Theme Palette
local Theme = {
    Background = Color3.fromRGB(15, 15, 17),
    Sidebar = Color3.fromRGB(18, 18, 20),
    CardBg = Color3.fromRGB(22, 22, 25),
    ElementBg = Color3.fromRGB(28, 28, 32),
    AccentRed = Color3.fromRGB(225, 30, 60),
    TextMain = Color3.fromRGB(235, 235, 240),
    TextMuted = Color3.fromRGB(120, 120, 128),
    Border = Color3.fromRGB(35, 35, 40)
}

function MemesenseLib.new(options)
    options = options or {}
    local windowTitle = options.Name or "MemeSense UI"
    local keySystem = options.KeySystem or false
    local validKeys = options.Key or {}
    local keySettings = options.KeySettings or {}
    local discordInvite = options.Discord or ""

    local self = setmetatable({}, MemesenseLib)

    -- ScreenGui Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = windowTitle .. "_Gui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = (gethui and gethui()) or CoreGui

    self.Gui = screenGui
    self.Options = options
    self.Tabs = {}

    -- Handle Key System (Fetch from Raw Link or Local)
    if keySystem then
        local verified = self:_initKeySystem(validKeys, keySettings, discordInvite)
        if not verified then return nil end
    end

    -- Main Outer Window
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 720, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -360, 0.5, -240)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local outerBorder = Instance.new("UIStroke")
    outerBorder.Color = Theme.Border
    outerBorder.Thickness = 1
    outerBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    outerBorder.Parent = mainFrame

    -- Top Header Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundColor3 = Theme.Background
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame

    -- Custom Name / MemeSense Logo
    local logoLabel = Instance.new("TextLabel")
    logoLabel.Size = UDim2.new(0, 220, 1, 0)
    logoLabel.Position = UDim2.new(0, 15, 0, 0)
    logoLabel.BackgroundTransparency = 1
    logoLabel.RichText = true
    logoLabel.Text = "<font color=\"rgb(225,30,60)\">" .. windowTitle .. "</font>"
    logoLabel.Font = Enum.Font.GothamBold
    logoLabel.TextSize = 18
    logoLabel.TextXAlignment = Enum.TextXAlignment.Left
    logoLabel.Parent = topBar

    -- Top Right Controls Area
    local topControls = Instance.new("Frame")
    topControls.Size = UDim2.new(1, -240, 1, 0)
    topControls.Position = UDim2.new(0, 230, 0, 0)
    topControls.BackgroundTransparency = 1
    topControls.Parent = topBar

    local topList = Instance.new("UIListLayout")
    topList.FillDirection = Enum.FillDirection.Horizontal
    topList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    topList.VerticalAlignment = Enum.VerticalAlignment.Center
    topList.Padding = UDim.new(0, 10)
    topList.Parent = topControls

    -- Discord Button
    if discordInvite ~= "" then
        local discordBtn = Instance.new("TextButton")
        discordBtn.Size = UDim2.new(0, 100, 0, 26)
        discordBtn.BackgroundColor3 = Theme.ElementBg
        discordBtn.BorderSizePixel = 0
        discordBtn.Text = "Join Discord"
        discordBtn.TextColor3 = Theme.TextMain
        discordBtn.Font = Enum.Font.GothamSemibold
        discordBtn.TextSize = 11
        discordBtn.Parent = topControls

        discordBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("https://discord.gg/" .. discordInvite)
                self:Notify("Discord", "Discord link copied to clipboard!")
            end
        end)
    end

    -- Sidebar (Left Nav)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 160, 1, -45)
    sidebar.Position = UDim2.new(0, 0, 0, 45)
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    local sidebarList = Instance.new("UIListLayout")
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Padding = UDim.new(0, 2)
    sidebarList.Parent = sidebar

    -- Content Container
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -165, 1, -50)
    contentArea.Position = UDim2.new(0, 165, 0, 45)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    self.MainFrame = mainFrame
    self.Sidebar = sidebar
    self.ContentArea = contentArea
    self.TopControls = topControls

    self:_makeDraggable(mainFrame, topBar)

    if options.LoadingTitle then
        self:Notify(options.LoadingTitle, options.LoadingSubtitle or "Loaded successfully!")
    end

    return self
end

-- Key System with Raw URL Fetching Support
function MemesenseLib:_initKeySystem(validKeys, keySettings, discordInvite)
    local authenticated = false
    local fetchedKeys = {}

    if keySettings and keySettings.KeyUrl then
        task.spawn(function()
            local success, response = pcall(function()
                return game:HttpGet(keySettings.KeyUrl)
            end)

            if success and response then
                for line in string.gmatch(response, "[^\r\n]+") do
                    local trimmedKey = string.gsub(line, "^%s*(.-)%s*$", "%1")
                    if trimmedKey ~= "" then
                        table.insert(fetchedKeys, trimmedKey)
                    end
                end
            end
        end)
    end

    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "KeySystem"
    keyFrame.Size = UDim2.new(0, 360, 0, 220)
    keyFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
    keyFrame.BackgroundColor3 = Theme.Background
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = self.Gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Parent = keyFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Key System Required"
    title.TextColor3 = Theme.AccentRed
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = keyFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.85, 0, 0, 35)
    textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    textBox.BackgroundColor3 = Theme.ElementBg
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = "Enter Key Here..."
    textBox.Text = ""
    textBox.TextColor3 = Theme.TextMain
    textBox.Font = Enum.Font.GothamSemibold
    textBox.TextSize = 13
    textBox.Parent = keyFrame

    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0.4, 0, 0, 32)
    submitBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
    submitBtn.BackgroundColor3 = Theme.AccentRed
    submitBtn.BorderSizePixel = 0
    submitBtn.Text = "Submit Key"
    submitBtn.TextColor3 = Theme.TextMain
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 12
    submitBtn.Parent = keyFrame

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0.4, 0, 0, 32)
    getKeyBtn.Position = UDim2.new(0.525, 0, 0.6, 0)
    getKeyBtn.BackgroundColor3 = Theme.ElementBg
    getKeyBtn.BorderSizePixel = 0
    getKeyBtn.Text = "Get Key Link"
    getKeyBtn.TextColor3 = Theme.TextMuted
    getKeyBtn.Font = Enum.Font.GothamSemibold
    getKeyBtn.TextSize = 11
    getKeyBtn.Parent = keyFrame

    getKeyBtn.MouseButton1Click:Connect(function()
        local getLink = (keySettings and keySettings.GetKeyLink) or ("https://discord.gg/" .. discordInvite)
        if setclipboard and getLink ~= "" then
            setclipboard(getLink)
            getKeyBtn.Text = "Copied Link!"
            task.wait(1.5)
            getKeyBtn.Text = "Get Key Link"
        end
    end)

    submitBtn.MouseButton1Click:Connect(function()
        local inputKey = string.gsub(textBox.Text, "^%s*(.-)%s*$", "%1")
        local isKeyValid = false

        if type(validKeys) == "table" then
            for _, k in ipairs(validKeys) do
                if inputKey == k then isKeyValid = true break end
            end
        elseif type(validKeys) == "string" and inputKey == validKeys then
            isKeyValid = true
        end

        if not isKeyValid and #fetchedKeys > 0 then
            for _, onlineKey in ipairs(fetchedKeys) do
                if inputKey == onlineKey then isKeyValid = true break end
            end
        end

        if isKeyValid then
            authenticated = true
            keyFrame:Destroy()
        else
            textBox.Text = ""
            textBox.PlaceholderText = "Invalid Key! Try Again."
        end
    end)

    repeat task.wait(0.1) until authenticated
    return true
end

-- Rayfield Notification Component
function MemesenseLib:Notify(titleText, contentText)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 240, 0, 60)
    notif.Position = UDim2.new(1, 10, 1, -70)
    notif.BackgroundColor3 = Theme.CardBg
    notif.BorderSizePixel = 0
    notif.Parent = self.Gui

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Theme.AccentRed
    nStroke.Thickness = 1
    nStroke.Parent = notif

    local nTitle = Instance.new("TextLabel")
    nTitle.Size = UDim2.new(1, -10, 0, 20)
    nTitle.Position = UDim2.new(0, 10, 0, 5)
    nTitle.BackgroundTransparency = 1
    nTitle.Text = titleText
    nTitle.TextColor3 = Theme.AccentRed
    nTitle.Font = Enum.Font.GothamBold
    nTitle.TextSize = 12
    nTitle.TextXAlignment = Enum.TextXAlignment.Left
    nTitle.Parent = notif

    local nDesc = Instance.new("TextLabel")
    nDesc.Size = UDim2.new(1, -10, 0, 30)
    nDesc.Position = UDim2.new(0, 10, 0, 25)
    nDesc.BackgroundTransparency = 1
    nDesc.Text = contentText
    nDesc.TextColor3 = Theme.TextMain
    nDesc.Font = Enum.Font.GothamSemibold
    nDesc.TextSize = 11
    nDesc.TextWrapped = true
    nDesc.TextXAlignment = Enum.TextXAlignment.Left
    nDesc.Parent = notif

    notif:TweenPosition(UDim2.new(1, -250, 1, -70), "Out", "Quad", 0.3, true)

    task.delay(3, function()
        notif:TweenPosition(UDim2.new(1, 10, 1, -70), "In", "Quad", 0.3, true, function()
            notif:Destroy()
        end)
    end)
end

function MemesenseLib:_makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- Create Sidebar Tab
function MemesenseLib:CreateTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 34)
    tabBtn.BackgroundColor3 = Theme.Sidebar
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "    " .. name
    tabBtn.TextColor3 = Theme.TextMuted
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = self.Sidebar

    local activeIndicator = Instance.new("Frame")
    activeIndicator.Size = UDim2.new(0, 3, 0.6, 0)
    activeIndicator.Position = UDim2.new(0, 0, 0.2, 0)
    activeIndicator.BackgroundColor3 = Theme.AccentRed
    activeIndicator.BorderSizePixel = 0
    activeIndicator.Visible = false
    activeIndicator.Parent = tabBtn

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = self.ContentArea

    local leftCol = Instance.new("ScrollingFrame")
    leftCol.Size = UDim2.new(0.5, -5, 1, 0)
    leftCol.BackgroundTransparency = 1
    leftCol.ScrollBarThickness = 2
    leftCol.Parent = tabFrame

    local rightCol = Instance.new("ScrollingFrame")
    rightCol.Size = UDim2.new(0.5, -5, 1, 0)
    rightCol.Position = UDim2.new(0.5, 5, 0, 0)
    rightCol.BackgroundTransparency = 1
    rightCol.ScrollBarThickness = 2
    rightCol.Parent = tabFrame

    local leftList = Instance.new("UIListLayout")
    leftList.Padding = UDim.new(0, 15)
    leftList.Parent = leftCol

    local rightList = Instance.new("UIListLayout")
    rightList.Padding = UDim.new(0, 15)
    rightList.Parent = rightCol

    local tabData = { Button = tabBtn, Frame = tabFrame, Indicator = activeIndicator }
    table.insert(self.Tabs, tabData)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
            t.Indicator.Visible = false
            t.Button.TextColor3 = Theme.TextMuted
        end
        tabFrame.Visible = true
        activeIndicator.Visible = true
        tabBtn.TextColor3 = Theme.TextMain
    end)

    if #self.Tabs == 1 then
        tabFrame.Visible = true
        activeIndicator.Visible = true
        tabBtn.TextColor3 = Theme.TextMain
    end

    local ColumnMethods = {}

    function ColumnMethods:CreateSection(headerTitle, side)
        local parentCol = (side and side:lower() == "right") and rightCol or leftCol

        local sectionContainer = Instance.new("Frame")
        sectionContainer.Size = UDim2.new(1, -10, 0, 30)
        sectionContainer.BackgroundTransparency = 1
        sectionContainer.Parent = parentCol

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 20)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = headerTitle
        titleLabel.TextColor3 = Theme.TextMuted
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        titleLabel.Parent = sectionContainer

        local elementList = Instance.new("UIListLayout")
        elementList.Padding = UDim.new(0, 8)
        elementList.SortOrder = Enum.SortOrder.LayoutOrder
        elementList.Parent = sectionContainer

        elementList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sectionContainer.Size = UDim2.new(1, -10, 0, elementList.AbsoluteContentSize.Y + 10)
        end)

        local ElementMethods = {}

        -- Checkbox / Toggle
        function ElementMethods:AddCheckbox(label, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 20)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = sectionContainer

            local box = Instance.new("TextButton")
            box.Size = UDim2.new(0, 16, 0, 16)
            box.Position = UDim2.new(0, 0, 0.5, -8)
            box.BackgroundColor3 = default and Theme.AccentRed or Theme.ElementBg
            box.BorderSizePixel = 0
            box.Text = default and "✓" or ""
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.Font = Enum.Font.GothamBold
            box.TextSize = 11
            box.Parent = toggleFrame

            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, -25, 1, 0)
            txt.Position = UDim2.new(0, 24, 0, 0)
            txt.BackgroundTransparency = 1
            txt.Text = label
            txt.TextColor3 = default and Theme.TextMain or Theme.TextMuted
            txt.Font = Enum.Font.GothamSemibold
            txt.TextSize = 12
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.Parent = toggleFrame

            local active = default or false
            box.MouseButton1Click:Connect(function()
                active = not active
                box.BackgroundColor3 = active and Theme.AccentRed or Theme.ElementBg
                box.Text = active and "✓" or ""
                txt.TextColor3 = active and Theme.TextMain or Theme.TextMuted
                if callback then callback(active) end
            end)
        end

        -- Slider
        function ElementMethods:AddSlider(label, min, max, default, suffix, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 36)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = sectionContainer

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.6, 0, 0, 18)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = label
            nameLabel.TextColor3 = Theme.TextMain
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = sliderFrame

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0.4, 0, 0, 18)
            valLabel.Position = UDim2.new(0.6, 0, 0, 0)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default) .. (suffix or "")
            valLabel.TextColor3 = Theme.TextMain
            valLabel.Font = Enum.Font.GothamSemibold
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = sliderFrame

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 4)
            track.Position = UDim2.new(0, 0, 0, 24)
            track.BackgroundColor3 = Theme.ElementBg
            track.BorderSizePixel = 0
            track.Parent = sliderFrame

            local fill = Instance.new("Frame")
            local initPct = math.clamp((default - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(initPct, 0, 1, 0)
            fill.BackgroundColor3 = Theme.TextMuted
            fill.BorderSizePixel = 0
            fill.Parent = track

            local dragging = false
            local function update(input)
                local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pct)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                valLabel.Text = (value == 0 and "disabled" or tostring(value) .. (suffix or ""))
                if callback then callback(value) end
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
        end

        return ElementMethods
    end

    return ColumnMethods
end

return MemesenseLib
