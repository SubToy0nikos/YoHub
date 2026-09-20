local SCRIPT_URL = "https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/DrivingEmpire.lua?token=GHSAT0AAAAAAEHJNVQRC2FMB6MPCHANTWRU2VP7S3Q" -- Paste your raw script URL here once finalized

-- Global Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Vehicle & Security Automator",
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "Arise Auto System",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VehicleSecurityAutomator",
        FileName = "VehicleAndSecuritySettings"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Create Tabs
local FarmTab = Window:CreateTab("Farm Section", 4483362458)
local ArrestTab = Window:CreateTab("Auto Arrest", 4483362458)
local DeliveryTab = Window:CreateTab("Auto Delivery", 4483362458)

--------------------------------------------------------------------------------
-- AUTO RE-EXECUTION UTILITY
--------------------------------------------------------------------------------

local function QueueScriptOnTeleport()
    local queueFunction = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

    if queueFunction then
        if SCRIPT_URL ~= "" then
            queueFunction([[
                repeat task.wait() until game:IsLoaded()
                loadstring(game:HttpGet("]] .. SCRIPT_URL .. [["))()
            ]])
        else
            queueFunction([[
                repeat task.wait() until game:IsLoaded()
                loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
            ]])
        end
    end
end

--------------------------------------------------------------------------------
-- SECTION 1: VEHICLE FARM AUTOMATOR
--------------------------------------------------------------------------------

local LastNotif = 0
local BaseStartPos = Vector3.new(-671.058349609375, 13.784324645996094, 4921.57373046875)
local BaseEndPos = Vector3.new(-248.86361694335938, 13.784261703491211, 2882.43505859375)

local function GetCurrentVehicle()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        return char.Humanoid.SeatPart.Parent
    end
    return workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
end

local function GetWaypoints()
    local yOffset = 0.5
    return BaseStartPos + Vector3.new(0, yOffset, 0), BaseEndPos + Vector3.new(0, yOffset, 0)
end

local function InitialTP(targetPos, targetLookAt)
    local car = GetCurrentVehicle()
    if car and car.PrimaryPart then
        car.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
        car.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
        car:SetPrimaryPartCFrame(CFrame.new(targetPos, targetLookAt))
    end
end

local function TurnAround(targetDirection)
    local car = GetCurrentVehicle()
    if not car or not car.PrimaryPart then return end

    local primaryPart = car.PrimaryPart
    primaryPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity * 0.1

    local attachment = Instance.new("Attachment")
    attachment.Parent = primaryPart

    local alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.Attachment0 = attachment
    alignOrientation.MaxTorque = 2000000
    alignOrientation.Responsiveness = 80
    alignOrientation.CFrame = primaryPart.CFrame
    alignOrientation.Parent = primaryPart

    local targetCFrame = CFrame.new(primaryPart.Position, primaryPart.Position + targetDirection)
    local tween = TweenService:Create(alignOrientation, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = targetCFrame
    })
    
    tween:Play()
    tween.Completed:Wait()

    primaryPart.AssemblyAngularVelocity = Vector3.zero
    alignOrientation:Destroy()
    attachment:Destroy()
end

local function FastVelocityDrive(targetPos)
    local car = GetCurrentVehicle()
    if not car or not car.PrimaryPart then return end

    local primaryPart = car.PrimaryPart
    local attachment = Instance.new("Attachment")
    attachment.Parent = primaryPart

    local alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.Attachment0 = attachment
    alignOrientation.MaxTorque = 1500000
    alignOrientation.Responsiveness = 60
    alignOrientation.CFrame = primaryPart.CFrame
    alignOrientation.Parent = primaryPart

    local speed = Rayfield.Flags["SpeedSlider"] and Rayfield.Flags["SpeedSlider"].CurrentValue or 300
    local distance = (primaryPart.Position - targetPos).Magnitude

    while distance > 15 and Rayfield.Flags["DriveToggle"] and Rayfield.Flags["DriveToggle"].CurrentValue do
        RunService.Heartbeat:Wait()
        local currentPos = primaryPart.Position
        local moveDirection = (targetPos - currentPos).Unit
        
        primaryPart.AssemblyLinearVelocity = Vector3.new(
            moveDirection.X * speed,
            -10,
            moveDirection.Z * speed
        )

        alignOrientation.CFrame = CFrame.new(currentPos, currentPos + moveDirection)
        primaryPart.AssemblyAngularVelocity = primaryPart.AssemblyAngularVelocity * Vector3.new(0, 1, 0)
        distance = (primaryPart.Position - targetPos).Magnitude
    end

    alignOrientation:Destroy()
    attachment:Destroy()
end

-- Farm Driving Loop
task.spawn(function()
    local isFirstRun = true
    while true do
        task.wait()
        local isDriveActive = Rayfield.Flags["DriveToggle"] and Rayfield.Flags["DriveToggle"].CurrentValue
        if isDriveActive then
            local car = GetCurrentVehicle()
            if not car then
                if tick() - LastNotif > 5 then
                    LastNotif = tick()
                    Rayfield:Notify({
                        Title = "Vehicle Automator",
                        Content = "Please Enter A Vehicle!",
                        Duration = 3,
                        Image = 4483362458
                    })
                end
            else
                local startPos, endPos = GetWaypoints()

                if isFirstRun then
                    InitialTP(startPos, endPos)
                    isFirstRun = false
                end

                FastVelocityDrive(endPos)
                
                if Rayfield.Flags["DriveToggle"] and Rayfield.Flags["DriveToggle"].CurrentValue then
                    local returnDir = (startPos - car.PrimaryPart.Position).Unit
                    TurnAround(returnDir)

                    FastVelocityDrive(startPos)

                    if Rayfield.Flags["DriveToggle"] and Rayfield.Flags["DriveToggle"].CurrentValue then
                        local forwardDir = (endPos - car.PrimaryPart.Position).Unit
                        TurnAround(forwardDir)
                    end
                end
            end
        else
            isFirstRun = true
        end
    end
end)

-- Farm UI Elements
FarmTab:CreateToggle({
    Name = "Drive",
    CurrentValue = false,
    Flag = "DriveToggle",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Farm Active",
                Content = "Starting continuous drive loop...",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

FarmTab:CreateSlider({
    Name = "Speed",
    Range = {50, 500},
    Increment = 5,
    Suffix = " Speed",
    CurrentValue = 300,
    Flag = "SpeedSlider",
    Callback = function(Value) end,
})

--------------------------------------------------------------------------------
-- SECTION 2: AUTO ARREST SYSTEM & UTILITIES
--------------------------------------------------------------------------------

local Remotes, JobsConstants
pcall(function()
    Remotes = require(ReplicatedStorage.Modules.Shared.Remotes)
    JobsConstants = require(ReplicatedStorage.Modules.Shared.Jobs.JobsConstants)
end)

local CHECK_INTERVAL = 0.5
local ARREST_COOLDOWN = 0.1
local TIME_UNTIL_SERVERHOP = 10

local lastArrestTime = 0
local noCriminalTime = 0
local hasStartedJob = false
local arrestCount = 0
local counterFileName = "auto_arrest_counter.txt"

local function loadArrestCount()
    if not readfile then return 0 end
    local success, data = pcall(function()
        return readfile(counterFileName)
    end)
    if success and data and tonumber(data) then
        return tonumber(data)
    end
    return 0
end

local function saveArrestCount()
    if not writefile then return end
    pcall(function()
        writefile(counterFileName, tostring(arrestCount))
    end)
end

arrestCount = loadArrestCount()

local ArrestParagraph = ArrestTab:CreateParagraph({
    Title = "Arrest Statistics",
    Content = "Total Arrests: " .. tostring(arrestCount)
})

local function updateStatusText()
    if ArrestParagraph then
        ArrestParagraph:Set({
            Title = "Arrest Statistics",
            Content = "Total Arrests: " .. tostring(arrestCount)
        })
    end
end

pcall(function()
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if remotesFolder then
        local notifyEvent = remotesFolder:FindFirstChild("Notify")
        if notifyEvent then
            notifyEvent.OnClientEvent:Connect(function(message)
                if type(message) == "string" and string.lower(message):find("you arrested", 1, true) then
                    arrestCount = arrestCount + 1
                    saveArrestCount()
                    updateStatusText()
                end
            end)
        end
    end
end)

local function isSecurityOfficer()
    return LocalPlayer:GetAttribute("JobId") == "Security"
end

local function startSecurityJob()
    if hasStartedJob or not JobsConstants or not Remotes then return end
    pcall(function()
        Remotes.fireServer(JobsConstants.Remotes.RequestStartJobSession, JobsConstants.JobIds.Security)
        hasStartedJob = true
    end)
end

local function leaveSecurityJob()
    if not JobsConstants or not Remotes then return end
    pcall(function()
        Remotes.fireServer(JobsConstants.Remotes.RequestEndJobSession)
        hasStartedJob = false
    end)
end

local function getCriminals()
    local criminals = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player:GetAttribute("JobId") == "Criminal" and player ~= LocalPlayer and player.Character then
            table.insert(criminals, player)
        end
    end
    return criminals
end

local function serverHop()
    Rayfield:Notify({
        Title = "Server Hop",
        Content = "Queueing script & searching for new server...",
        Duration = 3,
        Image = 4483362458
    })

    QueueScriptOnTeleport()

    pcall(function()
        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
        local body = game:HttpGet(url)
        local data = HttpService:JSONDecode(body)

        local validServers = {}
        for _, server in ipairs(data.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(validServers, server.id)
            end
        end

        if #validServers == 0 and data.nextPageCursor then
            local cursorUrl = url .. "&cursor=" .. data.nextPageCursor
            local cursorBody = game:HttpGet(cursorUrl)
            local cursorData = HttpService:JSONDecode(cursorBody)
            for _, server in ipairs(cursorData.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(validServers, server.id)
                end
            end
        end

        if #validServers > 0 then
            local chosenServer = validServers[math.random(1, #validServers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, chosenServer, LocalPlayer)
        else
            task.wait(10)
            serverHop()
        end
    end)
end

local function autoArrestLoop()
    local isArrestEnabled = Rayfield.Flags["AutoArrestToggle"] and Rayfield.Flags["AutoArrestToggle"].CurrentValue
    if not isArrestEnabled or not isSecurityOfficer() or not Remotes or not JobsConstants then return end

    local currentTime = tick()
    if currentTime - lastArrestTime < ARREST_COOLDOWN then return end

    local criminals = getCriminals()

    if #criminals == 0 then
        local isAutoHopActive = Rayfield.Flags["AutoHopToggle"] and Rayfield.Flags["AutoHopToggle"].CurrentValue
        if isAutoHopActive then
            noCriminalTime = noCriminalTime + CHECK_INTERVAL
            if noCriminalTime >= TIME_UNTIL_SERVERHOP then
                serverHop()
                noCriminalTime = 0
            end
        end
        return
    end

    noCriminalTime = 0
    local target = criminals[1]

    pcall(function()
        Remotes.fireServer(JobsConstants.Remotes.RequestArrestCriminal, target)
        lastArrestTime = currentTime
    end)
end

-- Auto Arrest Tab UI Controls
ArrestTab:CreateToggle({
    Name = "Enable Auto Arrest",
    CurrentValue = false,
    Flag = "AutoArrestToggle",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Arrest",
                Content = "Auto Arrest loop enabled.",
                Duration = 3,
                Image = 4483362458
            })
        else
            leaveSecurityJob()
            Rayfield:Notify({
                Title = "Auto Arrest",
                Content = "Auto Arrest disabled & left Security job.",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

ArrestTab:CreateToggle({
    Name = "Auto Server Hop (No Criminals)",
    CurrentValue = true,
    Flag = "AutoHopToggle",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Auto Server Hop",
            Content = Value and "Auto Hop enabled when no criminals are present." or "Auto Hop disabled.",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

ArrestTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Anti-AFK",
            Content = Value and "Anti-AFK is now Enabled." or "Anti-AFK is now Disabled.",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

ArrestTab:CreateButton({
    Name = "Server Hop Now",
    Callback = function()
        serverHop()
    end,
})

--------------------------------------------------------------------------------
-- SECTION 3: AUTO DELIVERY AUTOMATOR
--------------------------------------------------------------------------------

local delivery, deliveryUtil, vehiclesModule, vehicleUtilModule, tpGuardModule
pcall(function()
    delivery = require(ReplicatedStorage.Modules.Client.Jobs.Tasks.DeliveryJobTask)
    deliveryUtil = require(ReplicatedStorage.Modules.Shared.Jobs.Delivery.DeliveryUtil)
    vehiclesModule = require(ReplicatedStorage.Modules.Client.Vehicles.VehicleController)
    vehicleUtilModule = require(ReplicatedStorage.Modules.Shared.Vehicles.VehicleUtil)
    tpGuardModule = require(ReplicatedStorage.Modules.Client.Exploit.VehicleTeleportDetectionController)
end)

local function getDeliveryLoc(pos, skipLast)
    local loc, dist
    for _, v in ipairs(CollectionService:GetTagged('DeliveryLocation')) do
        if v:IsA('BasePart') and v.Parent then
            if not skipLast or not (deliveryUtil and deliveryUtil.IsLastDeliveryLocation(LocalPlayer, v)) then
                local d = (v.Position - pos).Magnitude
                if not dist or d < dist then loc, dist = v, d end
            end
        end
    end
    return loc
end

local hoverInstance

local function deliveryTeleport(cf)
    local char = LocalPlayer.Character
    if not char then return end

    local car = vehicleUtilModule and vehicleUtilModule.getPlayerData(LocalPlayer)
    local chassis = vehiclesModule and vehiclesModule.getActiveChassisController()

    if car and car.Model and car.WeightPart then
        if chassis then chassis.Teleporting = true end

        if tpGuardModule then tpGuardModule.AuthorizeNextTeleport() end
        car.Model.PrimaryPart = car.WeightPart
        car.Model:SetPrimaryPartCFrame(cf)
        car.WeightPart.Anchored = false
        if hoverInstance then hoverInstance:Destroy() end

        hoverInstance = Instance.new('BodyVelocity')
        hoverInstance.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        hoverInstance.Velocity = Vector3.zero
        hoverInstance.Parent = car.WeightPart

        for _, v in ipairs(car.Model:GetDescendants()) do
            if v:IsA('BasePart') then
                v.AssemblyLinearVelocity = Vector3.zero
                v.AssemblyAngularVelocity = Vector3.zero
            end
        end

        task.defer(function()
            if chassis then chassis.Teleporting = false end
        end)
    else
        char:PivotTo(cf)

        local hrp = char:FindFirstChild('HumanoidRootPart')
        if hrp then
            if hoverInstance then hoverInstance:Destroy() end

            hoverInstance = Instance.new('BodyVelocity')
            hoverInstance.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            hoverInstance.Velocity = Vector3.zero
            hoverInstance.Parent = hrp

            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not (Rayfield.Flags["AutoDeliveryToggle"] and Rayfield.Flags["AutoDeliveryToggle"].CurrentValue) then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    local hum = char and char:FindFirstChildOfClass('Humanoid')

    if hrp then hrp.Anchored = false end
    if hum and hoverInstance and hoverInstance.Parent == hrp then
        hum:ChangeState(Enum.HumanoidStateType.Freefall)
    end
end)

-- Delivery Loop
task.spawn(function()
    local curTarget, curLoc, curPhase, lastTick, lastFire, dropAt

    while true do
        task.wait(0.1)
        local isDeliveryEnabled = Rayfield.Flags["AutoDeliveryToggle"] and Rayfield.Flags["AutoDeliveryToggle"].CurrentValue
        
        if isDeliveryEnabled then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild('HumanoidRootPart')

            if hrp then
                if LocalPlayer:GetAttribute('JobId') ~= 'Delivery' then
                    if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("RequestStartJobSession") then
                        ReplicatedStorage.Remotes.RequestStartJobSession:FireServer('Delivery', 'deliveryHub')
                    end
                    curTarget, curLoc, curPhase, lastTick = nil, nil, nil, nil
                    task.wait(0.5)
                else
                    local state = delivery and delivery.GetCurrentDeliveryState()
                    local target, phase

                    if state then
                        lastTick = nil

                        local carried = state.ItemsCarried or 0
                        local cap = state.MaxCapacity or carried
                        local full = carried >= cap
                        local noMore = state.PackagesRemainingAtPickup == 0

                        if carried > 0 and (full or noMore) then
                            phase = 'drop'
                            dropAt = dropAt or tick() + 4.5

                            if tick() >= dropAt then
                                target = state.DestinationPosition
                            else
                                target = state.PickupPosition
                            end
                        else
                            dropAt = nil
                            phase = 'pickup'
                            target = state.PickupPosition
                        end
                    else
                        lastTick = lastTick or tick()

                        if tick() - lastTick > 0.25 then
                            local loc = getDeliveryLoc(hrp.Position, true) or getDeliveryLoc(hrp.Position)
                            phase = 'new'
                            target = loc and loc.Position
                        end
                    end

                    if target then
                        if target ~= curTarget or phase ~= curPhase then
                            deliveryTeleport(CFrame.new(target + Vector3.new(0, 3.5, 0)))
                            curTarget, curPhase = target, phase
                        end

                        local loc = getDeliveryLoc(target)

                        if loc and ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("DeliveryLocationInteracted") then
                            if loc ~= curLoc then
                                ReplicatedStorage.Remotes.DeliveryLocationInteracted:FireServer(loc)
                                curLoc, lastFire = loc, tick()
                            elseif tick() - lastFire > 1 then
                                ReplicatedStorage.Remotes.DeliveryLocationInteracted:FireServer(loc)
                                lastFire = tick()
                            end
                        end
                    end
                end
            end
        else
            curTarget, curLoc, curPhase, lastTick, lastFire, dropAt = nil, nil, nil, nil, nil, nil
            if hoverInstance then
                hoverInstance:Destroy()
                hoverInstance = nil
            end
        end
    end
end)

-- Delivery UI Elements
DeliveryTab:CreateToggle({
    Name = "Enable Auto Delivery",
    CurrentValue = false,
    Flag = "AutoDeliveryToggle",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto Delivery",
                Content = "Auto Delivery task loop started.",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Auto Delivery",
                Content = "Auto Delivery stopped.",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

--------------------------------------------------------------------------------
-- LOAD & BIND CONFIGURATION
--------------------------------------------------------------------------------

Rayfield:LoadConfiguration()

--------------------------------------------------------------------------------
-- BACKGROUND LOOPS & EVENT HANDLERS
--------------------------------------------------------------------------------

-- Auto Start Security Job Loop
task.spawn(function()
    while true do
        local isArrestEnabled = Rayfield.Flags["AutoArrestToggle"] and Rayfield.Flags["AutoArrestToggle"].CurrentValue
        if isArrestEnabled and not hasStartedJob then
            startSecurityJob()
        end
        task.wait(2)
    end
end)

-- Auto Arrest Action Loop
task.spawn(function()
    while true do
        autoArrestLoop()
        task.wait(CHECK_INTERVAL)
    end
end)

-- Anti-AFK Event Handler
LocalPlayer.Idled:Connect(function()
    local isAntiAFKOn = Rayfield.Flags["AntiAFKToggle"] and Rayfield.Flags["AntiAFKToggle"].CurrentValue
    if isAntiAFKOn then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(), Camera.CFrame)
    end
end)
