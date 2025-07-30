-- don't skid this made by @yonikosyt on youtube
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- don't skid this made by @yonikosyt on youtube
local blockHitRemote = ReplicatedStorage:WaitForChild("rbxts_include")
	:WaitForChild("node_modules"):WaitForChild("@rbxts")
	:WaitForChild("net"):WaitForChild("out")
	:WaitForChild("_NetManaged"):WaitForChild("CLIENT_BLOCK_HIT_REQUEST")

-- don't skid this made by @yonikosyt on youtube
local autoTree = false
local autoStone = false
local autoIron = false
local autoCoal = false
local autoGold = false
local autoElectrite = false
local running = true

-- don't skid this made by @yonikosyt on youtube
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoHitGUI"
gui.ResetOnSpawn = false
-- don't skid this made by @yonikosyt on youtube

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
-- don't skid this made by @yonikosyt on youtube

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "Auto Hit Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
-- don't skid this made by @yonikosyt on youtube

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
-- don't skid this made by @yonikosyt on youtube

local function createButton(text, posY, color)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Text = text
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end
-- don't skid this made by @yonikosyt on youtube

local treeBtn = createButton("Auto Tree: OFF", 40, Color3.fromRGB(100, 50, 50))
local stoneBtn = createButton("Auto Stone: OFF", 80, Color3.fromRGB(50, 50, 100))
local ironBtn = createButton("Auto Iron: OFF", 120, Color3.fromRGB(50, 50, 100))
local coalBtn = createButton("Auto Coal: OFF", 160, Color3.fromRGB(50, 50, 100))
local goldBtn = createButton("Auto Gold: OFF", 200, Color3.fromRGB(50, 50, 100))
local electriteBtn = createButton("Auto Electrite: OFF", 240, Color3.fromRGB(50, 50, 100))

-- don't skid this made by @yonikosyt on youtube
local function findRockHitPart(block)
	local colBoxes = block:FindFirstChild("CollisionBoxes")
	if colBoxes then
		for _, part in ipairs(colBoxes:GetChildren()) do
			if part:IsA("BasePart") then
				return part
			end
		end
	end
	if block:IsA("BasePart") then
		return block
	end
	return nil
end
-- don't skid this made by @yonikosyt on youtube

local function getNearestTree()
	local minDist, nearestTree = 30, nil
	local islands = workspace:FindFirstChild("Islands")
	if not islands then return nil end
-- don't skid this made by @yonikosyt on youtube

	for _, island in ipairs(islands:GetChildren()) do
		local blocks = island:FindFirstChild("Blocks")
		if blocks then
			for _, block in blocks:GetChildren() do
				if block.Name:lower():find("tree") then
					local hive = block:FindFirstChild("HiveLocations")
					if hive and hive:FindFirstChild("Part") then
						local dist = (hrp.Position - block.Position).Magnitude
						if dist < minDist then
							minDist, nearestTree = dist, block
						end
					end
				end
			end
		end
	end
	return nearestTree
end
-- don't skid this made by @yonikosyt on youtube

local function getNearestBlockByName(namePrefix)
	local minDist, nearestBlock, nearestHitPart = 30, nil, nil

	local function check(container)
		for _, block in ipairs(container:GetChildren()) do
			if block.Name:lower():sub(1, #namePrefix) == namePrefix then
				local hitPart = findRockHitPart(block)
				if hitPart then
					local dist = (hrp.Position - hitPart.Position).Magnitude
					if dist < minDist then
						minDist, nearestBlock, nearestHitPart = dist, block, hitPart
					end
				end
			end
		end
	end
-- don't skid this made by @yonikosyt on youtube

	local islands = workspace:FindFirstChild("Islands")
	if islands then
		for _, island in ipairs(islands:GetChildren()) do
			local blocks = island:FindFirstChild("Blocks")
			if blocks then check(blocks) end
		end
	end
-- don't skid this made by @yonikosyt on youtube

	local wild = workspace:FindFirstChild("WildernessBlocks")
	if wild then check(wild) end

	return nearestBlock, nearestHitPart
end

-- don't skid this made by @yonikosyt on youtube
task.spawn(function()
	while running do
		if autoTree then
			local tree = getNearestTree()
			if tree then
				local hivePart = tree:FindFirstChild("HiveLocations"):FindFirstChild("Part")
				if hivePart then
					blockHitRemote:InvokeServer({
						xkpOrfvithbzcvKundjsvoamBnpkqBsXm = "\a\240\159\164\163\240\159\164\161\a\n\a\n\a\nkyaxebDphmkcyha",
						part = hivePart,
						norm = Vector3.new(0, 1, 0),
						block = tree,
						pos = hivePart.Position
					})
				end
			end
		end

		for name, enabled in pairs({
			rockstone = autoStone,
			rockiron = autoIron,
			rockcoal = autoCoal,
			rockgold = autoGold,
			rockelectrite = autoElectrite,
		}) do
			if enabled then
				local block, hitPart = getNearestBlockByName(name)
				if block and hitPart then
					blockHitRemote:InvokeServer({
						xkpOrfvithbzcvKundjsvoamBnpkqBsXm = "\a\240\159\164\163\240\159\164\161\a\n\a\n\a\nkyaxebDphmkcyha",
						part = hitPart,
						norm = Vector3.new(0, 1, 0),
						block = block,
						pos = hitPart.Position,
					})
				end
			end
		end

		task.wait(0.1)
	end
end)

-- don't skid this made by @yonikosyt on youtube
treeBtn.MouseButton1Click:Connect(function()
	autoTree = not autoTree
	treeBtn.Text = autoTree and "Auto Tree: ON" or "Auto Tree: OFF"
	treeBtn.BackgroundColor3 = autoTree and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 50, 50)
end)

stoneBtn.MouseButton1Click:Connect(function()
	autoStone = not autoStone
	stoneBtn.Text = autoStone and "Auto Stone: ON" or "Auto Stone: OFF"
	stoneBtn.BackgroundColor3 = autoStone and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 100)
end)

ironBtn.MouseButton1Click:Connect(function()
	autoIron = not autoIron
	ironBtn.Text = autoIron and "Auto Iron: ON" or "Auto Iron: OFF"
	ironBtn.BackgroundColor3 = autoIron and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 100)
end)

coalBtn.MouseButton1Click:Connect(function()
	autoCoal = not autoCoal
	coalBtn.Text = autoCoal and "Auto Coal: ON" or "Auto Coal: OFF"
	coalBtn.BackgroundColor3 = autoCoal and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 100)
end)

goldBtn.MouseButton1Click:Connect(function()
	autoGold = not autoGold
	goldBtn.Text = autoGold and "Auto Gold: ON" or "Auto Gold: OFF"
	goldBtn.BackgroundColor3 = autoGold and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 100)
end)

electriteBtn.MouseButton1Click:Connect(function()
	autoElectrite = not autoElectrite
	electriteBtn.Text = autoElectrite and "Auto Electrite: ON" or "Auto Electrite: OFF"
	electriteBtn.BackgroundColor3 = autoElectrite and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 100)
end)

closeBtn.MouseButton1Click:Connect(function()
	running = false
	gui:Destroy()
end)
-- don't skid this made by @yonikosyt on youtube
