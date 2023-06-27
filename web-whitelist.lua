function onInit()
    print("Loading plugin done!")
    MP.RegisterEvent("onPlayerConnecting", "onPlayerConnecting")
end

-- Function to load whitelist from API endpoint
function loadWhitelist()
    local http = require("socket.http")
    local url = "https://api.bot.race-life.net/api/beammp-whitelist"
    local response = http.request(url)

    if response then
        local decodedContent = Util.JsonDecode(response)
        if decodedContent then
            return decodedContent
        else
            print("Error decoding whitelist")
        end
    else
        print("Error loading whitelist from API endpoint")
    end

    return nil
end

function onPlayerConnecting(playerID)
    print("Player connecting: " .. tostring(playerID)) -- check if playerID is nil

    local whitelist = loadWhitelist()

    if not whitelist then
        print("Whitelist is not loaded")
        return
    end

    local name = MP.GetPlayerName(playerID)
    print("Player name: " .. tostring(name)) -- check if name is nil

    local onList = false

    for index, value in ipairs(whitelist) do
        if name == value then
            onList = true
            break
        end
    end

    if onList == false then
        MP.DropPlayer(playerID, "You are not on the whitelist")
        print("The player "..name.." was denied by whitelist")
    end
end
