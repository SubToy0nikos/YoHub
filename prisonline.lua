--don't skid this made by yonikos on youtube
local coreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = coreGui

--don't skid this made by yonikos on youtube
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 175)  -- Width: 200px, Height: 400px
frame.Position = UDim2.new(0.5, -100, 0.5, -200)  -- Centered on the screen
frame.BackgroundColor3 = Color3.fromRGB(61, 175, 210)  -- Green color
frame.ZIndex = 10  -- Set ZIndex to ensure it's on top
frame.Parent = screenGui

--don't skid this made by yonikos on youtube
local sean = Instance.new("Frame")
sean.Size = UDim2.new(1, 0, 0, 30)  -- Full width, height: 30px
sean.Position = UDim2.new(0, 0, 0, 0)  -- Positioned at the top of the Frame
sean.BackgroundColor3 = Color3.fromRGB(54, 153, 183)  -- Dark green color
sean.ZIndex = 11  -- Set ZIndex to ensure it's on top of the Frame
sean.Parent = frame

--don't skid this made by yonikos on youtube
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)  -- Full width and height of sean
textLabel.Position = UDim2.new(0, 0, 0, 0)  -- Position at the top of the sean
textLabel.BackgroundTransparency = 1  -- Make background transparent
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color
textLabel.Text = "💀 PRISON LINE 💀"
textLabel.TextScaled = true  -- Scale text to fit the label
textLabel.Font = Enum.Font.Cartoon  -- Set font to Cartoon
textLabel.ZIndex = 12  -- Set ZIndex to ensure it's on top of the sean
textLabel.Parent = sean

--don't skid this made by yonikos on youtube
local function createButton(text, positionY, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 40)  -- Width: 180px, Height: 40px (reduced size)
    button.Position = UDim2.new(0.5, -90, 0, positionY)  -- Centered within the Frame, with positionY as offset
    button.BackgroundColor3 = Color3.fromRGB(41, 125, 150)  -- Darker green color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color
    button.Text = text  -- Button text
    button.TextScaled = true  -- Scale text to fit the button
    button.Font = Enum.Font.Cartoon  -- Set font to Cartoon
    button.TextWrapped = true  -- Wrap text if it overflows
    button.ZIndex = 12  -- Set ZIndex to ensure it's on top of the sean
    button.Parent = frame
    button.MouseButton1Click:Connect(callback)
    return button
end

--don't skid this made by yonikos on youtube
createButton("FREE AUTO CUT", 40, function()
    loadstring(game:HttpGet("https://pastefy.app/ai6KHo37/raw"))()
end)

createButton("IY", 90, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

--don't skid this made by yonikos on youtube
local bottomTextLabel = Instance.new("TextLabel")
bottomTextLabel.Size = UDim2.new(1, 0, 0, 30)  -- Full width, height: 30px
bottomTextLabel.Position = UDim2.new(0, 0, 1, -30)  -- Positioned at the bottom of the Frame
bottomTextLabel.BackgroundTransparency = 1  -- Transparent background
bottomTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color
bottomTextLabel.Text = "made by YOnikosYT & BlushyFemboy"  -- Footer text
bottomTextLabel.TextScaled = true  -- Scale text to fit the label
bottomTextLabel.Font = Enum.Font.Cartoon  -- Set font to Cartoon
bottomTextLabel.ZIndex = 12  -- Ensure it is on top of the background
bottomTextLabel.Parent = frame

--don't skid this made by yonikos on youtube
local dragging = false
local dragInput, startPos, framePos

--don't skid this made by yonikos on youtube
local function onInputBegin(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragInput = input
        startPos = input.Position
        framePos = frame.Position
--don't skid this made by yonikos on youtube

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

--don't skid this made by yonikos on youtube
local function onInputChange(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        frame.Position = UDim2.new(
            framePos.X.Scale, framePos.X.Offset + delta.X,
            framePos.Y.Scale, framePos.Y.Offset + delta.Y
        )
    end
end

--don't skid this made by yonikos on youtube
sean.InputBegan:Connect(onInputBegin)
sean.InputChanged:Connect(onInputChange)
game:GetService("UserInputService").InputChanged:Connect(onInputChange)
