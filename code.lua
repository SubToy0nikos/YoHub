-- load like lua armor

local Modules = {
    Colors =  {
        ["Green"] = "0,255,0", 
        ["Cyan"] = "33, 161, 163",
        ["White"] = "255,255,255",
		["Pink"] = "255, 102, 153",
    },
    Services = {
        RunService = game:GetService("RunService"),
        CoreGui = game:GetService("CoreGui")
    }
}

Modules.ChangeColor = function() 
    local Loop;
    Loop = Modules.Services.RunService.Heartbeat:Connect(function()
        local success,err = pcall(function()
            for index,label in pairs(Modules.Services.CoreGui:FindFirstChild("DevConsoleMaster"):GetDescendants()) do 
                if label:IsA("TextLabel") then 
                    label.RichText = true 
                end 
            end 
        end)

        if not success then 
            warn(`A error occured {err}`)
            Loop:Disconnect()
        end 
    end)
end

Modules.LoadingBar = function(watermark,color, delay,loadingsymbol)
    delay = delay or 0.1 

    local Text = watermark..tostring(math.random(500,20000))

    print(Text)

    local loadingLabel = nil
    local progress = ""

    repeat task.wait()
        for index,label in pairs(Modules.Services.CoreGui:FindFirstChild("DevConsoleMaster"):GetDescendants()) do 
             if label:IsA("TextLabel") and string.find(label.Text:lower(),Text:lower()) then 
                loadingLabel = label 
				break
            end 
        end 
    until loadingLabel

    local start = os.time()

    for i = 1, 50 do
        progress = progress .. loadingsymbol
        loadingLabel.Text = string.format("<font color='rgb(%s)' size='15'>[%s] [%d%% loaded] %s</font>", Modules.Colors["White"],watermark, i*2, progress)
        task.wait(delay)
    end

    loadingLabel.Text = string.format("<font color='rgb(%s)' size='15'>[%s] Successfully loaded in %ds</font>", Modules.Colors[color],watermark, os.time() - start)
end

Modules.ChangeColor()

Modules.LoadingBar("YoHub","Pink", 0.5,"#")
-- tells me if you're cheating with 4 dots :3
pcall(function()
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("....")
end)

-- finds executor
local UserExploit = identifyexecutor()

-- loading notif
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script loading...",
        Text = "Loading on " .. tostring(UserExploit),
        Duration = 5 
    })
end)

wait(7)

-- show who made the script
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Loaded Successfully",
        Text = "Made by YOnikosYT & BlushyFemboy", 
        Button1 = "Yes Daddy",
        Button2 = "Yes Mommy",
        Duration = 30 
    })
end)

-- if using misery then send a thanks msg
if tostring(UserExploit) == "Misery" then
    print("❤️A huge thanks from Arman and YOnikosYT❤️")
else
    -- #AD
    -- PLEASE BUY MISERY ITS THE CHEAPEST & BEST EXECUTOR #AD
    local function printAd()
        print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
        print("Why use " .. tostring(UserExploit))
        print("Get the best & cheapest executor #AD")
        print("get misery now! #AD")
        print("https://getmisery.cc")
        print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
    end

    printAd()

    -- send ad every 300 seconds (5 mins)
    task.spawn(function()
        while true do
            wait(300)
            printAd()
        end
    end)
end




-- scripts

local scripts = {
    [17574618959] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Memeboiyot/SyntaxRebornOfficial/main/SyntaxReborn"))()
    end, -- just a baseplate

    [18668065416] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/bluelockrivalsscript.lua"))()
    end, -- blue lock

    [126884695634066] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end, -- gag

    [16732694052] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end, -- fisch

    [129827112113663] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/Prospecting"))()
    end, -- prospecting

    [76455837887178] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CupPink/scripts/main/Loader.lua"))()
    end, -- Dig It

    [17126500142] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/Xse6Vadu"))()
    end, -- abyss miner

    [91232956735357] = function()
        loadstring(game:HttpGet("https://gitlab.com/RobloxiaUntilDawn/robloxia-until-dawn/-/raw/main/Loader?ref_type=heads"))()
    end, -- my pet rock
    
        [18667984660] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CaseohCASEOH/aabbaaii/refs/heads/main/SCRIPTT"))()
    end, -- flex your ping and fps

        [119031451367172] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/studsimulator.lua"))()
    end, -- stud simulator

        [107892466314467] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/growacryptofarm.lua"))()
    end, -- grow a crypto farm

        [2753915549] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AdelOnTheTop/Adel-Hub/main/Main.lua"))()
    end, -- blox fruits

        [109983668079237] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/m00ndiety/Steal-a-brainrot/refs/heads/main/Steal-a-Brainrot'))()
    end, -- steal a brainrot

	[96342491571673] = function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/m00ndiety/Steal-a-brainrot/refs/heads/main/Steal-a-Brainrot'))()
    end,

        [79657240466394] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/agreed69-scripts/open-src-scripts/refs/heads/main/Container%20RNG.lua",true))()
    end, -- Container RNG

        [79546208627805] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/99nightsinforest.lua", true))()
    end, -- 99 nights in the forest Hub
		
	[126509999114328] = function(parameters)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/99nightsinforest.lua", true))()
    end, -- 99 nights in the forest GAME

        [11156779721] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()
    end, -- the survival game

        [6872265039] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()
    end, -- bedwars

        [103889808775700] = function()
        loadstring(game:HttpGet("https://ashlabs.me/api/game?name=Cut-Grass.lua", true))()
    end, -- cut grass

        [16159871483] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/buckshotmayhem.lua", true))()
    end, -- buckshot mayhem

        [5991163185] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/spraypaint.lua", true))()
    end, -- spary paint

        [662417684] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/KaizerQuasar/Project-Quasar/main/Lucky-Lucky.lua"))()
    end,

        [86584030422286] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/prisonline.lua"))()
    end, -- prison line

        [83516970175863] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/everystepyougetolder.lua", true))()
    end, -- every step you get older

        [119055906651998] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/Loader.lua"))()
    end, -- fast food simulator

        [80399355300227] = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/ScriptsForDays/91678a587ab894f341bb4e47296bf030/raw/c90b1b4f8c25aadae75e8d7611bc7701416fa59d/UPD2-SEIZE"))()
    end, -- S.E.I.Z.E

        [13822889] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DevKron/Kron_Hub/refs/heads/main/version_1.0'))()
    end, -- lumber tycoon 2

        [11708967881] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/YeetAFriend"))()
    end, -- yeet a friend

        [4872321990] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/islands.lua",true))()
    end, -- Islands

        [7305309231] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/TaxiBoss.lua"))()
    end, -- taxi boss

	[81440632616906] = function()
		loadstring(game:HttpGet("https://scripts.yonikos.xyz/webdav/scripts/NullptrCracked.lua"))()
     end, -- dig to earths core

	[85896571713843] = function()
		loadstring(game:HttpGet("https://scripts.yonikos.xyz/webdav/scripts/NullptrCracked.lua"))()
	end, -- BGSI

	[108616176683580] = function()
		loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\115\99\114\105\112\116\115\46\121\111\110\105\107\111\115\46\120\121\122\47\119\101\98\100\97\118\47\111\98\102\47\72\101\97\118\101\110\76\105\110\101\46\108\117\97"))()
	end,
        
}

local placeId = game.PlaceId

if scripts[placeId] then
    pcall(scripts[placeId])
else
    game.Players.LocalPlayer:Kick("❌ Unsupported game. No script available for this PlaceId: " .. placeId)
end

-- change da name

local function escapeRichText(str)
    return str
        :gsub("&", "&amp;")
        :gsub("<", "&lt;")
        :gsub(">", "&gt;")
end

if tostring(UserExploit) == "Misery" then
    print("❤️Thanks For Using Misery❤️")
else
    getgenv().name = escapeRichText("-> https://getmisery.cc <-")

    local Plr = game.Players.LocalPlayer
    local playerName = Plr.Name
    local replacement = getgenv().name

    local function replaceName(label)
        if label.Text:find(playerName) then
            label.Text = label.Text:gsub(playerName, replacement)
        end

        label:GetPropertyChangedSignal("Text"):Connect(function()
            if label.Text:find(playerName) then
                label.Text = label.Text:gsub(playerName, replacement)
            end
        end)
    end

    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("TextLabel") then
            obj.RichText = true
            replaceName(obj)
        end
    end

    game.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextLabel") then
            obj.RichText = true
            replaceName(obj)
        end
    end)
end
