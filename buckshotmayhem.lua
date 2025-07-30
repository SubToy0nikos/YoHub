local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--don't skid this made by yonikos on youtube
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BuckshotTracker"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

--don't skid this made by yonikos on youtube
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 310)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--don't skid this made by yonikos on youtube
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
--don't skid this made by yonikos on youtube

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Logo (ImageLabel with "R")
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 0, 30)
logo.Position = UDim2.new(0, 0, 0, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://YOUR_ASSET_ID" -- Replace with actual asset ID
logo.Parent = frame

-- Title label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 25)
title.Position = UDim2.new(0, 10, 0, 30)
title.Text = "Buckshot Calculator"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- UI Elements
local function createTextBox(posY, placeholder)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.9, 0, 0, 30)
	box.Position = UDim2.new(0.05, 0, 0, posY)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.TextScaled = true
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.ClearTextOnFocus = false
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end
--don't skid this made by yonikos on youtube

local liveInput = createTextBox(65, "Live Rounds")
local blankInput = createTextBox(105, "Blank Rounds")
liveInput.Parent = frame
blankInput.Parent = frame

-- Buttons
local function createButton(posY, text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.43, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, posY)
	btn.Text = text
	btn.TextScaled = true
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	return btn
end

local setBtn = createButton(145, "Set", Color3.fromRGB(0, 120, 60))
local blankBtn = createButton(190, "Blank", Color3.fromRGB(60, 60, 60))
local liveBtn = createButton(190, "Live", Color3.fromRGB(120, 30, 30))
liveBtn.Position = UDim2.new(0.52, 0, 0, 190)
local resetBtn = createButton(235, "Reset", Color3.fromRGB(0, 100, 50))
setBtn.Parent = frame
blankBtn.Parent = frame
liveBtn.Parent = frame
resetBtn.Parent = frame

-- Info label
local info = Instance.new("TextLabel")
info.Size = UDim2.new(0.9, 0, 0, 35)
info.Position = UDim2.new(0.05, 0, 0, 270)
info.Text = ""
info.TextScaled = true
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1, 1, 1)
info.Font = Enum.Font.Gotham
info.TextYAlignment = Enum.TextYAlignment.Top
info.Parent = frame

-- Credit label
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 220, 0, 20)
credit.Position = UDim2.new(0, 15, 0, 345)
credit.Text = "Made by yonikosyt"
credit.TextScaled = true
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.Font = Enum.Font.Gotham
credit.TextYAlignment = Enum.TextYAlignment.Center
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = screenGui

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(1, -60, 0, 10)
toggleBtn.Text = "👁"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 25)
toggleBtn.Parent = screenGui
--don't skid this made by yonikos on youtube

-- Toggle drag
local toggleDragging, toggleDragInput, toggleDragStart, toggleStartPos

local function updateToggle(input)
	local delta = input.Position - toggleDragStart
	toggleBtn.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
end

toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		toggleDragging = true
		toggleDragStart = input.Position
		toggleStartPos = toggleBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				toggleDragging = false
			end
		end)
	end
end)

toggleBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		toggleDragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == toggleDragInput and toggleDragging then
		updateToggle(input)
	end
end)
--don't skid this made by yonikos on youtube

-- Variables
local bulletData = {
	total = 0,
	live = 0,
	used = 0,
	liveUsed = 0,
	blankUsed = 0
}
local isVisible = true

-- Update function
local function updateInfo()
	local left = bulletData.total - bulletData.used
	local liveLeft = bulletData.live - bulletData.liveUsed
	local chance = left > 0 and (liveLeft / left) * 100 or 0
	info.Text = string.format(
		"Live: %d/%d | Blank: %d/%d\nChance: %.1f%%",
		liveLeft, bulletData.live,
		bulletData.total - bulletData.used - liveLeft,
		bulletData.blankUsed,
		chance
	)
end

-- Button connections
setBtn.MouseButton1Click:Connect(function()
	local liveCount = tonumber(liveInput.Text)
	local blankCount = tonumber(blankInput.Text)
	if not liveCount or not blankCount or liveCount < 0 or blankCount < 0 then
		info.Text = "Enter valid numbers!"
		return
	end

	bulletData.live = liveCount
	bulletData.total = liveCount + blankCount
	bulletData.used = 0
	bulletData.liveUsed = 0
	bulletData.blankUsed = 0

	liveInput.Visible = false
	blankInput.Visible = false
	setBtn.Visible = false
	blankBtn.Visible = true
	liveBtn.Visible = true
	resetBtn.Visible = true

	updateInfo()
end)

blankBtn.MouseButton1Click:Connect(function()
	bulletData.used += 1
	bulletData.blankUsed += 1
	updateInfo()
end)
--don't skid this made by yonikos on youtube

liveBtn.MouseButton1Click:Connect(function()
	bulletData.used += 1
	bulletData.liveUsed += 1
	updateInfo()
end)

resetBtn.MouseButton1Click:Connect(function()
	bulletData = {total = 0, live = 0, used = 0, liveUsed = 0, blankUsed = 0}
	liveInput.Visible = true
	blankInput.Visible = true
	setBtn.Visible = true
	blankBtn.Visible = false
	liveBtn.Visible = false
	resetBtn.Visible = false
	liveInput.Text = ""
	blankInput.Text = ""
	info.Text = ""
end)
--don't skid this made by yonikos on youtube

toggleBtn.MouseButton1Click:Connect(function()
	isVisible = not isVisible
	frame.Visible = isVisible
	toggleBtn.Text = isVisible and "👁" or "👁‍🗨"
end)
--don't skid this made by yonikos on youtube

RunService:BindToRenderStep("BuckshotTrackerUpdate", Enum.RenderPriority.Interface.Value, function()
	if frame.Visible then
		updateInfo()
	end
end)

