local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Be A Streamer! | Arise Hub",
   LoadingTitle = "Streaming Automation",
   LoadingSubtitle = "By AriseCheats",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BeAStreamer",
      FileName = "Config"
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Automation", "cast") 

local state = {
    infMoney = false,
    autoCollect = false,
    autoRebirth = false,
    waitSpeed = 0.1
}

local RS = game:GetService("ReplicatedStorage")
local StreamingEvent = RS:WaitForChild("StreamingEvent")
local TutorialFunnel = RS:WaitForChild("TutorialFunnel")
local GetMailBox = RS:WaitForChild("GetMailBox")
local RebirthRemote = RS:WaitForChild("Rebirth")

local StreamSection = MainTab:CreateSection("Streaming & Cash")

MainTab:CreateToggle({
   Name = "Inf Money (When streaming)",
   CurrentValue = false,
   Flag = "InfMoney",
   Callback = function(Value)
      state.infMoney = Value
      if state.infMoney then
         task.spawn(function()
            while state.infMoney do
               StreamingEvent:FireServer("Responded")
               StreamingEvent:FireServer("segmentStreamed")
               TutorialFunnel:FireServer("RespondedToChatter")
               task.wait(state.waitSpeed)
            end
         end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Collect Money (Mailbox)",
   CurrentValue = false,
   Flag = "AutoCollect",
   Callback = function(Value)
      state.autoCollect = Value
      if state.autoCollect then
         task.spawn(function()
            while state.autoCollect do
               GetMailBox:FireServer()
               task.wait(state.waitSpeed)
            end
         end)
      end
   end,
})

local ProgressionSection = MainTab:CreateSection("Progression")

MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
      state.autoRebirth = Value
      if state.autoRebirth then
         task.spawn(function()
            while state.autoRebirth do
               RebirthRemote:FireServer()
               task.wait(1)
            end
         end)
      end
   end,
})

local SettingsSection = MainTab:CreateSection("Anti-Kick Settings")

MainTab:CreateSlider({
   Name = "Remote Delay (Speed)",
   Info = "Lower is faster, but might cause Sus Activity kicks.",
   Min = 0.01,
   Max = 1,
   Default = 0.1,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 0.01,
   ValueName = "Seconds",
   Callback = function(Value)
      state.waitSpeed = Value
   end,
})
