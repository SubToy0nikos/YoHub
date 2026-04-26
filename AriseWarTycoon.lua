if not game:IsLoaded() then game.Loaded:Wait(); end;
local SCRIPT_ID = "AriseHubWarTycoon"
if getgenv()[SCRIPT_ID] then
    pcall(getgenv()[SCRIPT_ID].Cleanup)
end
local cloneref = cloneref or function(i: Instance) return i; end;
local clonefunction = clonefunction or function(f: (...any) -> (...any)) return f; end;
local newcclosure = newcclosure or clonefunction;

local RS = cloneref(game:GetService("ReplicatedStorage"));
local Players = cloneref(game:GetService("Players"));
local UIS = cloneref(game:GetService("UserInputService"));
local RunService = cloneref(game:GetService("RunService"));
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer;
local cam = workspace.CurrentCamera;
local CONFIG_FILE = "AriseHubWarTycoon.json"
local function SaveConfig()
    local cfg = {
        hitboxEnabled = getgenv().hitboxEnabled,
        hitboxSize = getgenv().hitboxSize,
        antiShield = getgenv().antiShield
    }
    writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
end

local function LoadConfig()
    if isfile(CONFIG_FILE) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if success then
            getgenv().hitboxEnabled = data.hitboxEnabled
            getgenv().hitboxSize = data.hitboxSize
            getgenv().antiShield = data.antiShield
        end
    end
end
getgenv().silentAimEnabled = true
getgenv().friendCheck = true
getgenv().espEnabled = true
getgenv().showNames = true
getgenv().showDist = true
getgenv().tracersEnabled = true
getgenv().showFov = true
getgenv().fov = 300
getgenv().hitboxEnabled = false
getgenv().hitboxSize = 2
getgenv().antiShield = false
getgenv().selectedTeleportTarget = "None"
LoadConfig()
local Connections = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false
local ESP_Objects = {}
local function CreateESP(target: Player)
    local components = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    for _, txt in pairs({components.Name, components.Distance}) do
        txt.Size = 14; txt.Center = true; txt.Outline = false; txt.Font = 2
    end
    ESP_Objects[target] = components
end

local function RemoveESP(target: Player)
    if ESP_Objects[target] then
        for _, obj in pairs(ESP_Objects[target]) do pcall(function() obj:Remove() end) end
        ESP_Objects[target] = nil
    end
end
local getTarget = function(origin: Vector3)
    local cPart, cDistance = nil, getgenv().fov or 300;
    for _, player in next, Players:GetPlayers() do
        if player == plr then continue; end;
        if getgenv().friendCheck and plr:IsFriendsWith(player.UserId) then continue; end;
        local char = player.Character;
        if not char or (char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0) then continue; end;
        local tPart = char:FindFirstChild("Head") or char.PrimaryPart;
        if not tPart then continue; end;
        local pos, onScreen = cam:WorldToViewportPoint(tPart.Position);
        if not onScreen then continue; end;
        local distance = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude;
        if distance < cDistance then cPart = tPart; cDistance = distance; end;
    end;
    return cPart;
end;
if not getgenv().Hooked then
    local s, ac = pcall(require, RS.BulletFireSystem.FastCastRedux.ActiveCast);
    if s then
        local old; old = clonefunction(hookfunction(rawget(ac, "new"), newcclosure(function(_, origin, __, ___, ...)
            if getgenv().silentAimEnabled then
                local c = getTarget(origin)
                if c then
                    local dir = c.Position - origin
                    return old(_, origin, dir, dir.Unit * 9e9, ...)
                end
            end
            return old(_, origin, __, ___, ...);
        end)))
        getgenv().Hooked = true
    end
end
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Arise Hub - War Tycoon | Made by AriseCheats",
   LoadingTitle = "AriseCheats - Loading Persistent Config",
   ScriptID = "sid_cv1mabsvivxv",
   ConfigurationSaving = { Enabled = false }
})
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({Name = "Silent Aim", CurrentValue = true, Callback = function(V) getgenv().silentAimEnabled = V end})
CombatTab:CreateToggle({Name = "Anti Riot Shield", CurrentValue = getgenv().antiShield, Callback = function(V) getgenv().antiShield = V; SaveConfig() end})
CombatTab:CreateToggle({Name = "Friend Check", CurrentValue = true, Callback = function(V) getgenv().friendCheck = V end})
CombatTab:CreateSlider({Name = "FOV Radius", Range = {0, 1000}, Increment = 10, CurrentValue = 300, Callback = function(V) getgenv().fov = V end})
CombatTab:CreateSection("Visual Head Expander")
CombatTab:CreateToggle({Name = "Glow Head Expander", CurrentValue = getgenv().hitboxEnabled, Callback = function(V) getgenv().hitboxEnabled = V; SaveConfig() end})
CombatTab:CreateSlider({Name = "Head size", Range = {1, 50}, Increment = 1, CurrentValue = getgenv().hitboxSize, Callback = function(V) getgenv().hitboxSize = V; SaveConfig() end})
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
VisualsTab:CreateToggle({Name = "Show FOV Circle", CurrentValue = true, Callback = function(V) getgenv().showFov = V end})
VisualsTab:CreateSection("ESP Options")
VisualsTab:CreateToggle({Name = "Enable Boxes", CurrentValue = true, Callback = function(V) getgenv().espEnabled = V end})
VisualsTab:CreateToggle({Name = "Show Names", CurrentValue = true, Callback = function(V) getgenv().showNames = V end})
VisualsTab:CreateToggle({Name = "Show Distance", CurrentValue = true, Callback = function(V) getgenv().showDist = V end})
VisualsTab:CreateToggle({Name = "Show Tracers", CurrentValue = true, Callback = function(V) getgenv().tracersEnabled = V end})
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateSection("Teleport System")

local PlayerDropdown = MiscTab:CreateDropdown({
    Name = "Select Person",
    Options = {"None"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(Option)
        getgenv().selectedTeleportTarget = Option[1]
    end,
})

local function ForceRefreshList()
    local names = {"None"}
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= plr then table.insert(names, v.Name) end
    end
    PlayerDropdown:Refresh(names, true)
    PlayerDropdown:Set({"None"})
end

MiscTab:CreateButton({
    Name = "Refresh People",
    Callback = function()
        ForceRefreshList()
        Rayfield:Notify({Title = "Server Fetch", Content = "Found " .. (#Players:GetPlayers() - 1) .. " players.", Duration = 2})
    end,
})

MiscTab:CreateButton({
    Name = "Teleport Now",
    Callback = function()
        local targetName = getgenv().selectedTeleportTarget
        if not targetName or targetName == "None" then return end
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end,
})

--// Main Runtime Loop
table.insert(Connections, RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = getgenv().showFov or false
    FOVCircle.Radius = getgenv().fov or 300
    FOVCircle.Position = UIS:GetMouseLocation()
    local currentLock = getTarget(cam.CFrame.Position)
    
    for _, player in next, Players:GetPlayers() do
        if player == plr then continue end;
        local char = player.Character
        if char then
            if getgenv().antiShield then
                local s = char:FindFirstChild("SRiot Shield") or char:FindFirstChild("SRiotShield")
                if s then s:Destroy() end
            end

            local head = char:FindFirstChild("Head")
            if head then
                if getgenv().hitboxEnabled and not (getgenv().friendCheck and plr:IsFriendsWith(player.UserId)) then
                    local s = getgenv().hitboxSize
                    head.Size = Vector3.new(s, s, s)
                    head.Color = Color3.fromRGB(255, 0, 0)
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                    head.CanTouch = false
                    head.Massless = true
                    head.CastShadow = false
                    head.Transparency = 0
                    local m = head:FindFirstChildOfClass("SpecialMesh")
                    if m then m.Scale = Vector3.new(s, s, s) end
                else
                    if head.Material == Enum.Material.Neon then
                        head.Size = Vector3.new(1.2, 1.2, 1.2)
                        head.Material = Enum.Material.Plastic
                        head.Massless = false
                        head.CastShadow = true
                        local m = head:FindFirstChildOfClass("SpecialMesh")
                        if m then m.Scale = Vector3.new(1, 1, 1) end
                    end
                end
            end
        end

        if not ESP_Objects[player] then CreateESP(player) end;
        local d = ESP_Objects[player]
        local isVis = false
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local hrp, headPart = char.HumanoidRootPart, char.Head
            local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                isVis = true
                local isFriend = plr:IsFriendsWith(player.UserId)
                local color = (currentLock and currentLock:IsDescendantOf(char)) and Color3.new(0,1,0) or (isFriend and Color3.fromRGB(255, 215, 0) or Color3.new(1,1,1))
                local hPos, lPos = cam:WorldToViewportPoint(headPart.Position + Vector3.new(0, 0.5, 0)), cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local h, w = math.abs(hPos.Y - lPos.Y), math.abs(hPos.Y - lPos.Y) / 1.5
                d.Box.Visible = getgenv().espEnabled; d.Box.Size = Vector2.new(w, h); d.Box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2); d.Box.Color = color
                d.Tracer.Visible = getgenv().tracersEnabled; d.Tracer.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y); d.Tracer.To = Vector2.new(pos.X, pos.Y + h/2); d.Tracer.Color = color
                d.Name.Visible = getgenv().showNames; d.Name.Text = player.DisplayName; d.Name.Position = Vector2.new(pos.X, pos.Y - (h/2) - 15); d.Name.Color = color
                d.Distance.Visible = getgenv().showDist; d.Distance.Text = math.floor((cam.CFrame.Position - hrp.Position).Magnitude) .. " Studs"; d.Distance.Position = Vector2.new(pos.X, pos.Y + (h/2) + 5); d.Distance.Color = color
            end
        end
        if not isVis then for _, obj in pairs(d) do obj.Visible = false end end
    end
end))

table.insert(Connections, Players.PlayerRemoving:Connect(RemoveESP))

getgenv()[SCRIPT_ID] = {
    Cleanup = function()
        pcall(function() Rayfield:Destroy() end)
        pcall(function() FOVCircle:Remove() end)
        for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
        for p, _ in pairs(ESP_Objects) do RemoveESP(p) end
    end
}

task.delay(1, ForceRefreshList)
