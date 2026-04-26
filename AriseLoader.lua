local scriptMap = {
    [4639625707] = "test"--,
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
