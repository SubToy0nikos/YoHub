local placeScripts = {
    [17574618959] = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Memeboiyot/SyntaxRebornOfficial/main/SyntaxReborn"))()', -- just a baseplate
    [18668065416] = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/bluelockrivalsscript.lua"))()', -- blue lock rivals
    [126884695634066] = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()', -- gag
    [16732694052] = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()', -- fisch
    [placeid] = comingsoon,
    [placeid] = comingsoon
}

local currentPlaceId = game.PlaceId

if placeScripts[currentPlaceId] then
    print("Executing script for Place ID " .. currentPlaceId)
    placeScripts[currentPlaceId]()
else
    print("Not in a valid game. Kicking player.")
    game:GetService("Players").LocalPlayer:Kick("Not Supported Game.")
end
