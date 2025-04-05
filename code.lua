local placeScripts = {
    [17574618959] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Memeboiyot/SyntaxRebornOfficial/main/SyntaxReborn"))(), -- just a baseplate
    [18668065416] = loadstring(game:HttpGet("https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/bluelockrivalsscript.lua"))(), -- blue lock rivals
    [placeid] = comingsoon,
    [placeid] = comingsoon,
    [placeid] = comingsoon
}

local currentPlaceId = game.PlaceId

if placeScripts[currentPlaceId] then
    print("Executing script for Place ID " .. currentPlaceId)
else
    print("Not in a valid game. Kicking player.")
    game:GetService("Players").LocalPlayer:Kick("Not Supported Game.")
end
