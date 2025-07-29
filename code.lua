-- find exploit (xeno, etc) and list it as UserExploit
local UserExploit = identifyexecutor()

-- say script is loading

game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "Script loading...",
Text = "Loading on " .. tostring(UserExploit),
Duration = 5 
})

wait(7)

-- say who made the script

game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "Script Loaded Sucessfully",
Text = "Made by YOnikosYT & BlushyFemboy", 

Button1 = "Yes Daddy",
Button2 = "Yes Mommy",
Duration = 30 
})

-- #AD for misery please buy :3

print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
print("Why use " .. tostring(UserExploit))
print("Get the best & cheapest executor #AD")
print("get misery now! #AD")
print("https://getmisery.cc")
print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")

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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/prospecting.lua", true))()
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

        [79657240466394] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/agreed69-scripts/open-src-scripts/refs/heads/main/Container%20RNG.lua",true))()
    end, -- Container RNG

        [79546208627805] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", true))()
    end, -- 99 nights in the forest

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
        
}

local placeId = game.PlaceId

if scripts[placeId] then
    pcall(scripts[placeId])
else
    game.Players.LocalPlayer:Kick("❌ Unsupported game. No script available for this PlaceId: " .. placeId)
end

-- change da name

getgenv().name = "-> https://getmisery.cc <-"


local Plr = game.Players.LocalPlayer
for Index, Value in next, game:GetDescendants() do 
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text,Plr.Name) 
        if has then 
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end)
    end
end

game.DescendantAdded:Connect(function(Value)
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text,Plr.Name)
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end)
        if has then 
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end
        
    end
end)
