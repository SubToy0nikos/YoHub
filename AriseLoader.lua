local scriptMap = {
    [4639625707] = "https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/AriseWarTycoon.lua",
    [131756752872026] = "https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/AriseDiveDown.lua",
    [125003919504672] = "https://raw.githubusercontent.com/SubToy0nikos/YoHub/refs/heads/main/AriseMyKnifeFarm.lua"
}
local targetScriptUrl = scriptMap[game.PlaceId]
if targetScriptUrl then
    print("Match found for Place: " .. game.PlaceId)
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(targetScriptUrl))()
    end)
  
    if not success then 
        warn("Failed to load script for this game: " .. tostring(err)) 
    end
else
    print("No script assigned for Place ID: " .. game.PlaceId)
end
