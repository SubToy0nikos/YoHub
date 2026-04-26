local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()



local Window = Rayfield:CreateWindow({
   Name = "Arise Hub - Dive Down | Made by AriseCheats",
   LoadingTitle = "AriseCheats - Dive Down",
   LoadingSubtitle = "By AriseCheats",
   ScriptID = "sid_cv1mabsvivxv", 
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "AriseHubDiveDown"
   },
})


local Tab = Window:CreateTab("Main", "home")


local Section = Tab:CreateSection("Fishing")

local _G = {
    AutoCatch = false,
    AutoSell = false
}

local fishes = workspace.Game.Fishes
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

Tab:CreateToggle({
   Name = "Auto Catch",
   CurrentValue = false,
   Flag = "CatchFlag", 
   Callback = function(Value)
      _G.AutoCatch = Value
   end,
})

Tab:CreateToggle({
   Name = "Auto Sell",
   CurrentValue = false,
   Flag = "SellFlag", 
   Callback = function(Value)
      _G.AutoSell = Value
   end,
})

RunService.RenderStepped:Connect(function()
    if not (_G.AutoCatch or _G.AutoSell) then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    local highest = 0
    local highestFish = nil

    for _, fish in ipairs(fishes:GetChildren()) do
        local cash = fish:GetAttribute("CashPerSec")
        local owner = fish:GetAttribute("Owner")
        if cash and not owner and cash > highest then
            highest = cash
            highestFish = fish
        end
    end

    if highestFish then
        if _G.AutoCatch then
            rootPart.CFrame = highestFish:GetPivot()
            local prompt = highestFish.RootPart:FindFirstChild("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
        end

        if _G.AutoSell then
            local args = {
                buffer.fromstring("\003\001")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end
    end
end)

local Divider = Tab:CreateDivider()



local Button = Tab:CreateButton({
   Name = "Teleport To Aquarium",
   Callback = function()
   local args = {"Aquarium"} workspace:WaitForChild("Network"):WaitForChild("Teleport-RemoteEvent"):FireServer(unpack(args))
   wait(0.01)
   end,
})

local Button = Tab:CreateButton({
   Name = "Teleport To Shops",
   Callback = function()
   local args = {"Shops"} workspace:WaitForChild("Network"):WaitForChild("Teleport-RemoteEvent"):FireServer(unpack(args))
   wait(0.01)
   end,
})





Rayfield:LoadConfiguration()
