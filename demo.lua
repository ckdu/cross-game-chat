-- Don't share the URL/Encryption key with unauthorized users.
getgenv().WS_URL = "ws://aim.red:33850"
getgenv().ENCRYPTION_KEY = "cZsjReVwG48ADvjf7rUkGb8LzJPsC2P#"
-- Everyone in the chat must have the same values above ^

getgenv().RGB_ENABLED = true -- Set to false if you don't want rainbow chats.
getgenv().myRoles = {"Change", "Roles"} -- Set your roles here.
getgenv().myColor = Color3.fromRGB(255, 255, 255) -- Color of your chats. If your first role is "RGB", your chats will be rainbow for others.

loadstring(game:HttpGet("https://raw.githubusercontent.com/xxaim/cross-game-chat/master/client.lua"))() -- Load client.