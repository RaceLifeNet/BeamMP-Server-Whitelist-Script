function onInit()
    print("Loading plugin done!")
    MP.RegisterEvent("onPlayerConnecting", "onPlayerConnecting")
end

-- Function to load whitelist
function loadWhitelist()
    -- Read and parse the whitelist.json file
    local file = io.open("whitelist.json", "r")
    if not file then
        print("Error opening whitelist.json")
        return nil
    end

    local content = file:read("*all")
    file:close()

    local decodedContent = Util.JsonDecode(content)
    if not decodedContent or not decodedContent.whitelist then
        print("Error decoding whitelist")
        return nil
    end

    return decodedContent.whitelist
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
        end
    end

    if onList == false then
        MP.DropPlayer(playerID, "You are not on the whitelist")
        print("The player "..name.." was denied by whitelist")
    end
end
