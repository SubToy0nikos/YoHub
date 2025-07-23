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
        print("Coming Soon...")
    end, -- prospecting

    [999999999] = function()
        print("Coming soon")
    end,
}

local placeId = game.PlaceId

if scripts[placeId] then
    pcall(scripts[placeId])
else
    game.Players.LocalPlayer:Kick("❌ Unsupported game. No script available for this PlaceId: " .. placeId)
end
