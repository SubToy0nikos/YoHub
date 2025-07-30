local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer

-- Global variables for spam
local lastCommand = nil
local isSpamming = false
local spamCooldown = 0.1 -- Interval between repeats in seconds

-- Rainbow text for header
local function rainbowText(label)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 127, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 130, 238))
    })
    gradient.Rotation = 90
    gradient.Parent = label

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Parent = label

    RunService.Heartbeat:Connect(function()
        gradient.Offset += Vector2.new(0.005, 0)
        if gradient.Offset.X >= 1 then
            gradient.Offset = Vector2.new(-1, 0)
        end
    end)
end

-- Initial version selection screen
local SelectionGUI = Instance.new("ScreenGui")
SelectionGUI.Name = "VersionSelection"
SelectionGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SelectionGUI.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = SelectionGUI
--don't skid this made by yonikos on youtube

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame
--don't skid this made by yonikos on youtube

local Title = Instance.new("TextLabel")
Title.Text = "YoHub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame
rainbowText(Title)
--don't skid this made by yonikos on youtube

local function createSelectionButton(yPos, text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 300, 0, 80)
    button.Position = UDim2.new(0.5, -150, 0, yPos)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 20
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.AutoButtonColor = false
    button.Parent = MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 2
    stroke.Parent = button

    UICorner:Clone().Parent = button
    return button
end

local PCButton = createSelectionButton(100, "PC Version 🖥️")
local MobileButton = createSelectionButton(200, "Mobile Version 📱")

--don't skid this made by yonikos on youtube
local function createMainGUI(isMobile)
    SelectionGUI:Destroy()

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "YoHub"
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.Parent = player:WaitForChild("PlayerGui")

    local buttonWidth = isMobile and 200 or 260
    local buttonHeight = isMobile and 35 or 40
    local frameHeight = isMobile and 350 or 300

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, isMobile and 250 or 300, 0, frameHeight)
    MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MainFrame.Position = UDim2.new(0.5, isMobile and -125 or -150, 0.5, -frameHeight/2)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Selectable = true
    MainFrame.Parent = GUI

    UICorner:Clone().Parent = MainFrame

--don't skid this made by yonikos on youtube
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    local inputType = isMobile and Enum.UserInputType.Touch or Enum.UserInputType.MouseButton1

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == inputType then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == (isMobile and Enum.UserInputType.Touch or Enum.UserInputType.MouseMovement) then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

--don't skid this made by yonikos on youtube
    local function createButton(yPos, text)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
        button.Position = UDim2.new(0.5, -buttonWidth/2, 0, yPos)
        button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.GothamBold
        button.TextSize = isMobile and 14 or 16
        button.AutoButtonColor = false

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.new(1, 1, 1)
        stroke.Thickness = 1
        stroke.Parent = button

        UICorner:Clone().Parent = button
        button.Parent = MainFrame

        button.Activated:Connect(function()
            if isMobile then
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.7
                }):Play()
                task.wait(0.1)
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.5
                }):Play()
            end
        end)

        return button
    end

    -- Create buttons
    local buttons = {
        createButton(60, "💨 /fart"),
        createButton(110, "💀 /dead"),
        createButton(160, "🪑 /sit"),
        createButton(210, "🪢 /ragdoll"),
        createButton(260, "🔄 Spam Last Command")
    }

    -- Function to show warning
    local function showWarning(text)
        local warningLabel = Instance.new("TextLabel")
        warningLabel.Text = text
        warningLabel.Size = UDim2.new(0, 250, 0, 40)
        warningLabel.Position = UDim2.new(0.5, -125, 0.5, -20)
        warningLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        warningLabel.TextColor3 = Color3.new(1, 1, 1)
        warningLabel.Font = Enum.Font.GothamBold
        warningLabel.TextSize = 14
        warningLabel.Parent = MainFrame

        task.delay(3, function()
            warningLabel:Destroy()
        end)
    end

--don't skid this made by yonikos on youtube
    local EmojiLabel = Instance.new("TextLabel")
    EmojiLabel.Name = "EmojiSpin"
    EmojiLabel.Text = "🎬"
    EmojiLabel.TextSize = 30
    EmojiLabel.Size = UDim2.new(0, 40, 0, 40)
    EmojiLabel.Position = UDim2.new(0.5, -20, 1, isMobile and -60 or -70)
    EmojiLabel.BackgroundTransparency = 1
    EmojiLabel.Font = Enum.Font.GothamBold
    EmojiLabel.Parent = MainFrame

--don't skid this made by yonikos on youtube
    local creatorText = Instance.new("TextLabel")
    creatorText.Text = "made by yonikosyt"
    creatorText.TextSize = 14
    creatorText.TextColor3 = Color3.new(1, 1, 1)
    creatorText.Size = UDim2.new(1, 0, 0, 20)
    creatorText.Position = UDim2.new(0, 0, 1, isMobile and -40 or -30)
    creatorText.BackgroundTransparency = 1
    creatorText.Font = Enum.Font.GothamBold
    creatorText.Parent = MainFrame

    -- Emoji animation
    local spinSpeed = isMobile and 1.5 or 2
    RunService.Heartbeat:Connect(function(delta)
        EmojiLabel.Rotation = (EmojiLabel.Rotation + spinSpeed) % 360

        if not isMobile then
            local scale = math.abs(math.sin(tick() * 3)) * 0.2 + 0.8
            EmojiLabel.Size = UDim2.new(0, 40 * scale, 0, 40 * scale)
            EmojiLabel.Position = UDim2.new(0.5, -20 * scale, 1, -60 * scale)
        end
    end)

--don't skid this made by yonikos on youtube
    local function sendChatMessage(command)
        task.spawn(function()
            local success, err = pcall(function()
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    local channel = TextChatService.TextChannels.RBXGeneral
                    if channel then
                        channel:SendAsync(command)
                    end
                else
                    player:Chat(command)
                end
            end)

            if not success then
                warn("Error sending message:", err)
            end
        end)
    end

    -- Command handlers
    local function handleCommand(command)
        lastCommand = command
        sendChatMessage(command)
    end

    buttons[1].Activated:Connect(function()
        handleCommand("/fart")
    end)

    buttons[2].Activated:Connect(function()
        handleCommand("/dead")
    end)

    buttons[3].Activated:Connect(function()
        handleCommand("/sit")
    end)

    buttons[4].Activated:Connect(function()
        handleCommand("/ragdoll")
    end)

--don't skid this made by yonikos on youtube
    buttons[5].Activated:Connect(function()
        if not lastCommand then
            showWarning("Press any command first!")
            return
        end

        isSpamming = not isSpamming

        if isSpamming then
            buttons[5].BackgroundColor3 = Color3.new(0.4, 0, 0)
            while isSpamming and task.wait(spamCooldown) do
                sendChatMessage(lastCommand)
            end
            buttons[5].BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        end
    end)

--don't skid this made by yonikos on youtube
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            character = player.Character
        end)
    end)

--don't skid this made by yonikos on youtube
    showWarning("Press a command first, then use spam!")
end

PCButton.Activated:Connect(function()
    createMainGUI(false)
end)

MobileButton.Activated:Connect(function()
    createMainGUI(true)
end)

