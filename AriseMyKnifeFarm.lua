local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Arise Hub - My Knife Farm | Made by AriseCheats",
   LoadingTitle = "AriseCheats - My Knife Farm",
   LoadingSubtitle = "By AriseCheats",
   ScriptID = "sid_cv1mabsvivxv", 
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KnifeFarmConfig",
      FileName = "MainConfig"
   },
   KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local RarityTab = Window:CreateTab("Rarities", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Variables
local player = game:GetService("Players").LocalPlayer
local myPlot = nil
local selectedSwordRarity = {}
local selectedMutationRarity = {}
local autoRollEnabled = false 
local autoBuyEnabled = false
local autoSellEnabled = false
local sellInterval = 60 

-- Plot Detection Logic
local function assignMyPlot()
    local function clean(str) return str:gsub("%W", ""):lower() end
    local myCleanName = clean(player.Name)
    local myCleanDisplayName = clean(player.DisplayName)
    
    for i = 1, 8 do
        local plotName = "Plot_" .. i
        local plotFolder = workspace.Plots:FindFirstChild(plotName)
        if plotFolder then
            local nameplate = plotFolder:FindFirstChild("Plot_Models") 
                and plotFolder.Plot_Models:FindFirstChild("BaseModel") 
                and plotFolder.Plot_Models.BaseModel:FindFirstChild("BillBoardC")
            
            if nameplate then
                local textLabel = nameplate.Nameplate.SurfaceGui:FindFirstChild("NameOf")
                if textLabel then
                    local cleanLabel = clean(textLabel.Text)
                    if string.find(cleanLabel, myCleanName) or string.find(cleanLabel, myCleanDisplayName) then
                        myPlot = plotFolder
                        break
                    end
                end
            end
        end
    end
end

assignMyPlot()
if not myPlot then myPlot = workspace.Plots.Plot_1 end

-- References
local baseModel = myPlot.Plot_Models.BaseModel
local conveyor = baseModel.PackConveyor
local spawnClick = baseModel.ButtonModel.PacketClick.ClickDetector
local BuyCaseRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Game"):WaitForChild("CaseTriggered")
local boxPrompt = baseModel.BoxStand.ProximityPrompt
local pickupCFrame = baseModel.BoxStand.CFrame * CFrame.new(0, 3, 0)
local sellCFrame = baseModel.SellButton.SellP.CFrame * CFrame.new(0, 10, 0)

-- Helper Functions
local function isMatch(selectedTable, value)
    if not selectedTable or next(selectedTable) == nil then return true end
    value = tostring(value):lower()
    for k, v in pairs(selectedTable) do
        if v == true and tostring(k):lower() == value then return true end
    end
    return false
end

-- Sections
local StatusSection = MainTab:CreateSection("Status")
local StatusLabel = MainTab:CreateLabel("Status: Idle")
local SellTimerLabel = MainTab:CreateLabel("Next Sell In: --:--")

-- Auto Roll Logic
task.spawn(function()
    local folder = conveyor.SpawnedCase
    folder.ChildAdded:Connect(function(child)
        if not autoRollEnabled then return end
        task.spawn(function()
            task.wait(0.01)
            local rLabel = child:FindFirstChild("Rarity", true)
            local mLabel = child:FindFirstChild("EventRarity", true)
            if rLabel and mLabel then
                local timeout = 0
                while (rLabel.Text == "" or rLabel.Text == "Label") and timeout < 100 do
                    if not autoRollEnabled then return end 
                    task.wait(0.02)
                    timeout = timeout + 1
                end
                local curR = rLabel.Text
                local curM = mLabel.Text
                if curM == "" or curM == "Label" then curM = "Normal" end

                if isMatch(selectedSwordRarity, curR) and isMatch(selectedMutationRarity, curM) then
                    if autoBuyEnabled then
                        task.wait(0.08)
                        BuyCaseRemote:FireServer()
                        StatusLabel:SetText("Last Bought: " .. curM .. " " .. curR)
                    else
                        autoRollEnabled = false
                        StatusLabel:SetText("Stopped At: " .. curM .. " " .. curR)
                        Rayfield:Notify({Title = "Match Found!", Content = "Stopped on " .. curM .. " " .. curR, Duration = 5})
                    end
                end
            end
        end)
    end)
end)

-- Main Controls
MainTab:CreateSection("Controls")

MainTab:CreateToggle({
   Name = "Auto Spawn Cases",
   CurrentValue = false,
   Callback = function(Value)
      autoRollEnabled = Value
      if autoRollEnabled then
          StatusLabel:SetText("Status: High-Speed Rolling...")
          task.spawn(function()
              while autoRollEnabled do
                  -- Check if button exists
                  if spawnClick then
                      -- Try standard fireclickdetector first
                      if fireclickdetector then
                          fireclickdetector(spawnClick)
                      else
                          -- Fallback: Directly interact with the object
                          -- Note: This works on most high-end executors
                          spawnClick:Connect() 
                      end
                  else
                      warn("Arise Hub: Spawn button not found!")
                      StatusLabel:SetText("Status: Error - Button Not Found")
                  end
                  
                  -- Adjusted wait for better stability
                  task.wait(0.1) 
              end
          end)
      else
          StatusLabel:SetText("Status: Idle")
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Buy Selected Cases",
   CurrentValue = false,
   Callback = function(Value)
      autoBuyEnabled = Value
   end,
})

MainTab:CreateButton({
   Name = "Spin Wheel",
   Callback = function()
      game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Rewards"):WaitForChild("SpinRewards"):FireServer()
   end,
})

MainTab:CreateSection("Auto Sell")

MainTab:CreateToggle({
   Name = "Auto Sell Knives",
   CurrentValue = false,
   Callback = function(Value)
        autoSellEnabled = Value
        if autoSellEnabled then
            task.spawn(function()
                while autoSellEnabled do
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local returnPos = hrp.CFrame
                        hrp.CFrame = pickupCFrame
                        task.wait(0.3)
                        
                        local pickupTimeout = 0
                        while autoSellEnabled and not char:FindFirstChild("OpenBox") and pickupTimeout < 50 do
                            fireproximityprompt(boxPrompt)
                            task.wait(0.1)
                            pickupTimeout = pickupTimeout + 1
                        end
                        
                        if char:FindFirstChild("OpenBox") then
                            hrp.CFrame = sellCFrame
                            task.wait(0.5)
                        end
                        hrp.CFrame = returnPos
                    end
                    
                    local timeLeft = sellInterval
                    while timeLeft > 0 and autoSellEnabled do
                        SellTimerLabel:SetText(string.format("Next Sell In: %02d:%02d", math.floor(timeLeft/60), timeLeft%60))
                        task.wait(1)
                        timeLeft = timeLeft - 1
                    end
                end
                SellTimerLabel:SetText("Next Sell In: --:--")
            end)
        end
   end,
})

MainTab:CreateDropdown({
   Name = "Sell Interval (Minutes)",
   Options = {"1", "5", "10", "20"},
   CurrentOption = "1",
   Callback = function(Option)
      sellInterval = tonumber(Option) * 60
   end,
})

-- Rarity Tab
RarityTab:CreateSection("Sword Rarities")
local rarities = {"Common", "Rare", "Epic", "Elite", "Legendary", "Mythic", "Secret", "Limited", "Exclusive", "Timeless", "Godly", "Soul", "Fruit", "Ninja", "Historical", "Shadow", "Frost", "Demon", "Arsenal"}
for _, r in ipairs(rarities) do
    RarityTab:CreateToggle({
        Name = r,
        CurrentValue = false,
        Callback = function(v) selectedSwordRarity[r] = v end
    })
end

RarityTab:CreateSection("Mutations")
local mutations = {"Rusty", "Normal", "Golden", "Space", "Blood", "Dark", "Candy", "Rainbow", "Emerald", "Blue Gem"}
for _, m in ipairs(mutations) do
    RarityTab:CreateToggle({
        Name = m,
        CurrentValue = false,
        Callback = function(v) selectedMutationRarity[m] = v end
    })
end

-- Misc Tab
MiscTab:CreateButton({
   Name = "Load Anti-AFK",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/imisury/antiafk/refs/heads/main/antiafk"))()
      Rayfield:Notify({Title = "Anti-AFK", Content = "Loaded Successfully!", Duration = 5})
   end,
})

MiscTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})
