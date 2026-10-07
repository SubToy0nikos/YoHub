local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

task.spawn(function()
    local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Info"):WaitForChild("Notification")
    while true do
        if Remote and Remote.OnClientEvent then
            firesignal(Remote.OnClientEvent, table.unpack({
                [1] = "Script made by Arise Cheats!",
                [2] = Color3.new(1, 0.933333, 0.72549),
                [3] = "",
            }))
        end
        task.wait(5)
    end
end)

local Window = Rayfield:CreateWindow({
   Name = "Arise Hub - Prospecting| Made by AriseCheats",
   LoadingTitle = "AriseCheats - Prospecting",
   LoadingSubtitle = "By AriseCheats",
   ScriptID = "sid_cv1mabsvivxv", 
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ProspectingConfig",
      FileName = "MainConfig"
   },
   KeySystem = false
})

local Tab = Window:CreateTab("Auto-Farm", 4483362458)

local collectCords = nil
local waterCords = nil
local autoFarmEnabled = false
local autoSellEnabled = false
local autoSellWhenFullEnabled = false
local sellCFrame = CFrame.new(-8.515495300292969, 25.052936553955078, 61.49698257446289)

local function getPanTool()
    local player = game.Players.LocalPlayer
    local charactersFolder = workspace:FindFirstChild("Characters")
    if not charactersFolder then return nil end

    local char = charactersFolder:FindFirstChild(player.Name)
    if not char then return nil end

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and string.find(child.Name, "Pan") then
            return child
        end
    end
    return nil
end

local function getPanProgress()
    local player = game.Players.LocalPlayer
    local fillTextObj = player:FindFirstChild("PlayerGui")
        and player.PlayerGui:FindFirstChild("ToolUI")
        and player.PlayerGui.ToolUI:FindFirstChild("FillingPan")
        and player.PlayerGui.ToolUI.FillingPan:FindFirstChild("FillText")

    if fillTextObj and fillTextObj:IsA("TextLabel") then
        local text = fillTextObj.Text
        local currentStr, maxStr = string.match(text, "([%d%.]+)%s*/%s*([%d%.]+)")
        
        if currentStr and maxStr then
            return tonumber(currentStr), tonumber(maxStr)
        end
    end
    return nil, nil
end

local function isInventoryFull()
    local player = game.Players.LocalPlayer
    local invSpaceObj = player:FindFirstChild("PlayerGui")
        and player.PlayerGui:FindFirstChild("ToolUI")
        and player.PlayerGui.ToolUI:FindFirstChild("FillingPan")
        and player.PlayerGui.ToolUI.FillingPan:FindFirstChild("InventorySpace")

    if invSpaceObj and (invSpaceObj:IsA("TextLabel") or invSpaceObj:IsA("TextBox")) then
        local text = invSpaceObj.Text
        local currentStr, maxStr = string.match(text, "([%d%.]+)%s*/%s*([%d%.]+)")
        
        if currentStr and maxStr then
            local currentVal = tonumber(currentStr)
            local maxVal = tonumber(maxStr)
            if currentVal and maxVal and currentVal >= maxVal then
                return true
            end
        end
    end
    return false
end

local function performSell()
    local sellRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") 
        and game.ReplicatedStorage.Remotes:FindFirstChild("Shop") 
        and game.ReplicatedStorage.Remotes.Shop:FindFirstChild("SellAll")

    if sellRemote and sellRemote:IsA("RemoteFunction") then
        sellRemote:InvokeServer()
    end
end

Tab:CreateSection("Auto-farm")

Tab:CreateButton({
   Name = "Set Collect Location",
   Callback = function()
      local HRPRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if HRPRoot then
          collectCords = HRPRoot.CFrame
          Rayfield:Notify({
             Title = "Location Set",
             Content = "Collect location saved successfully!",
             Duration = 3,
          })
      end
   end,
})

Tab:CreateButton({
   Name = "Set Water Location",
   Callback = function()
      local HRPRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if HRPRoot then
          waterCords = HRPRoot.CFrame
          Rayfield:Notify({
             Title = "Location Set",
             Content = "Water location saved successfully!",
             Duration = 3,
          })
      end
   end,
})

Tab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      autoFarmEnabled = Value

      if autoFarmEnabled then
          if not collectCords or not waterCords then
              Rayfield:Notify({
                 Title = "Missing Locations",
                 Content = "Please set BOTH Collect and Water locations first!",
                 Duration = 4,
              })
              return
          end

          task.spawn(function()
              while autoFarmEnabled do
                  local player = game.Players.LocalPlayer
                  local char = player.Character
                  local HRPRoot = char and char:FindFirstChild("HumanoidRootPart")

                  if HRPRoot then
                      if autoSellWhenFullEnabled and isInventoryFull() then
                          Rayfield:Notify({
                             Title = "Inventory Full",
                             Content = "Teleporting to shop to sell...",
                             Duration = 3,
                          })
                          HRPRoot.CFrame = sellCFrame
                          task.wait(0.3)
                          performSell()
                          task.wait(0.5)
                      end

                      if autoFarmEnabled then
                          HRPRoot.CFrame = collectCords

                          local panTool = getPanTool()
                          if panTool then
                              local collectScript = panTool:FindFirstChild("Scripts") and panTool.Scripts:FindFirstChild("Collect")
                              if collectScript and collectScript:IsA("RemoteFunction") then
                                  collectScript:InvokeServer(table.unpack({ [1] = 1, [2] = false }))
                              end
                          end

                          local currentVal, maxVal = getPanProgress()
                          if currentVal and maxVal and currentVal >= maxVal then
                              Rayfield:Notify({
                                 Title = "Pan Full",
                                 Content = "Teleporting to water to wash...",
                                 Duration = 2,
                              })

                              HRPRoot.CFrame = waterCords
                              task.wait(0.2)

                              panTool = getPanTool()
                              if panTool then
                                  local panScript = panTool:FindFirstChild("Scripts") and panTool.Scripts:FindFirstChild("Pan")
                                  if panScript and panScript:IsA("RemoteFunction") then
                                      panScript:InvokeServer()
                                  end
                              end

                              while autoFarmEnabled do
                                  panTool = getPanTool()
                                  if panTool then
                                      local shakeScript = panTool:FindFirstChild("Scripts") and panTool.Scripts:FindFirstChild("Shake")
                                      if shakeScript and shakeScript:IsA("RemoteEvent") then
                                          shakeScript:FireServer()
                                      end
                                  end

                                  local cVal = getPanProgress()
                                  if cVal and cVal <= 0 then
                                      Rayfield:Notify({
                                         Title = "Pan Empty",
                                         Content = "Returning to collecting...",
                                         Duration = 2,
                                      })
                                      break
                                  end

                                  task.wait(0.1)
                              end

                              if autoSellWhenFullEnabled and isInventoryFull() then
                                  Rayfield:Notify({
                                     Title = "Inventory Full",
                                     Content = "Teleporting to shop to sell...",
                                     Duration = 3,
                                  })
                                  HRPRoot.CFrame = sellCFrame
                                  task.wait(0.3)
                                  performSell()
                                  task.wait(0.5)
                              end
                          end
                      end
                  end

                  task.wait(0.1)
              end
          end)
      end
   end,
})

Tab:CreateToggle({
   Name = "Auto-sell When full",
   CurrentValue = false,
   Flag = "AutoSellWhenFullToggle",
   Callback = function(Value)
      autoSellWhenFullEnabled = Value
   end,
})

Tab:CreateSection("Other")

Tab:CreateToggle({
   Name = "Auto-sell",
   CurrentValue = false,
   Flag = "AutoSellToggle",
   Callback = function(Value)
      autoSellEnabled = Value

      if autoSellEnabled then
          task.spawn(function()
              while autoSellEnabled do
                  performSell()
                  task.wait(1)
              end
          end)
      end
   end,
})
