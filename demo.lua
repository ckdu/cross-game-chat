-- Don't share your custom URL/Encryption key with unauthorized users.
getgenv().cross_settings = {
	myRoles = {"Testing", "User"}, -- Set your roles here.
	myColor = Color3.fromRGB(255, 255, 255), -- Color of your chats. If your first role is "RGB", your chats will be rainbow for others.
	RGB_ENABLED = true, -- Set to false if you don't want rainbow chats.
	-- Everyone in the chat must have the same values below.
	WS_URL = "ws://aim.red:33850",
	ENCRYPTION_KEY = "cZsjReVwG48ADvjf7rUkGb8LzJPsC2P#"
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/xxaim/cross-game-chat/master/client.lua"))() -- Load client.