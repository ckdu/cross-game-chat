--[[ ~ Credits ~
	Main Script: Aim
	Colors & Roles: 7n7o
	Chat hook: Riptxde
--]]

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local enabled = false

function encrypt(msg)
	return syn.crypt.encrypt(msg, ENCRYPTION_KEY)
end

function decrypt(msg)
	return syn.crypt.decrypt(msg, ENCRYPTION_KEY)
end

if not syn_checkcaller then error'Unsupported exploit.' end
if not WS_URL then error'Set the required global variables.' end
local socket = syn.websocket.connect(WS_URL)

local StarterGui = game:GetService("StarterGui")
local LP = game:GetService("Players").LocalPlayer

getProperties = {
	Color = Color3.fromRGB(255,255,0); 
	Font = Enum.Font.SourceSansBold;
	TextSize = 18;
}

sendProperties = {
	Color = myColor; 
	Font = Enum.Font.SourceSansBold;
	TextSize = 18;
}

function toTable(s)
    if not s:find '^%s*{' then return nil end
    if s:find '[^\'"%w_]function[^\'"%w_]' then
        return nil
    end
    s = 'return '..s
    local chunk = loadstring(s,'tbl','t',{})
    if not chunk then return nil end
    local ok,ret = pcall(chunk)
    if ok then return ret
    else
        return nil
    end
end

function getMessage(enc)
	if enc == "Connected" then
		return enc
	end
	local message = toTable(decrypt(enc))
	return message
end

function sendMessage(Message)
	socket:Send(encrypt(Message))
end

function invite()
	Server = tostring(game.PlaceId)..":"..tostring(game.JobId)
	sendMessage("{Server = '"..Server.."', Name = 'SERVER',Roles = {}, Message = '"..LP.Name.." has invited you to join their server! Type !join to join.', Color = Color3.fromRGB(255, 255, 0)}")
end

local ServerToJoin = ""
function join()
	lol = ServerToJoin:split":"
	game:GetService("TeleportService"):TeleportToPlaceInstance(tonumber(lol[1]), lol[2], LP)
end

function constructRoles(r)
	local a = ""
	for i, v in pairs(r) do
		a = a.."["..v.."] "
	end
	return a
end

function tostringr(r)
	local a = "{"
	for i, v in pairs(r) do
		a = a.."'"..v.."', "
	end
	return a:sub(1, #a-2).."}"
end

function chat(msg)
	if enabled then
		sendProperties.Text = construct({Name =tostring(LP.Name),Roles = myRoles, Message = msg, Color = tostring(myColor)})
		StarterGui:SetCore("ChatMakeSystemMessage", sendProperties)
		sendMessage("{Name = '"..tostring(LP.Name).."',Roles = "..tostringr(myRoles)..", Message = '"..msg.."', Color = Color3.new("..tostring(myColor)..")}")
	end
end

function construct(messageTbl)
	if messageTbl.Server then
		ServerToJoin = messageTbl.Server
	end
	local endm = ""
	endm = endm..constructRoles(messageTbl.Roles)
	endm = endm.."["..messageTbl.Name.."]: "
	endm = endm..messageTbl.Message
	getProperties.Color = messageTbl.Color
	return endm
end

local lastmessage = {}
socket.OnMessage:Connect(function(msg)
	lastmessage = getMessage(msg)
	if not lastmessage then return end
	if type(lastmessage) == "string" then
		getProperties.Text = "Connected"
	else
		getProperties.Text = construct(lastmessage)
	end
	StarterGui:SetCore("ChatMakeSystemMessage", getProperties)
end)

sendMessage("{Name = 'SERVER',Roles = {}, Message = '"..LP.Name.." has joined the chat!', Color = Color3.fromRGB(255, 255, 0)}")
getProperties.Color = Color3.fromRGB(255, 255, 0)
getProperties.Text = "[SERVER] Say !c or !chat to toggle sending, and !invite to invite people to this server."
StarterGui:SetCore("ChatMakeSystemMessage", getProperties)

local scroller = LP:FindFirstChild("PlayerGui").Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller
scroller.ChildAdded:Connect(function(frame)
	if RGB_ENABLED then
		pcall(function()
		    if frame.TextLabel.Text == construct(lastmessage) then
		    	if lastmessage.Roles[1] == "RGB" then
		            spawn(function()
		                function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end
						counter = 0
						while wait(0.1) do
							frame.TextLabel.TextColor3 = Color3.fromHSV(zigzag(counter),1,1)
							counter = counter + 0.01
						end
					end)
				end
			end
		end)
	end
end)

function toggle()
	enabled = not enabled
	if enabled then
		getProperties.Color = Color3.fromRGB(0, 230, 0)
		getProperties.Text = "[SERVER] Sending Enabled"
	else
		getProperties.Color = Color3.fromRGB(230, 0, 0)
		getProperties.Text = "[SERVER] Sending Disabled"
	end
	StarterGui:SetCore("ChatMakeSystemMessage", getProperties)
end

local CBar, CRemote, Connected = LP['PlayerGui']:WaitForChild('Chat')['Frame'].ChatBarParentFrame['Frame'].BoxFrame['Frame'].ChatBar, game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents['SayMessageRequest'], {}

local HookChat = function(Bar)
    coroutine.wrap(function()
        if not table.find(Connected,Bar) then
            local Connect = Bar['FocusLost']:Connect(function(Enter)
                if Enter ~= false and Bar['Text'] ~= '' then
                    local Message = Bar['Text']
                    Bar['Text'] = '';
                    if Message == "!c" or Message == "!chat" then
                    	toggle()
					elseif Message == "!invite" then
						invite()
					elseif Message == "!join" then
						join()
					elseif enabled then
						chat(Message)
					else
                    	game:GetService('Players'):Chat(Message); CRemote:FireServer(Message,'All')
                    end
                end
            end)
            Connected[#Connected+1] = Bar; Bar['AncestryChanged']:Wait(); Connect:Disconnect()
        end
    end)()
end

HookChat(CBar); local BindHook = Instance.new('BindableEvent')

local MT = getrawmetatable(game); local NC = MT.__namecall; setreadonly(MT, false)

MT.__namecall = newcclosure(function(...)
    local Method, Args = getnamecallmethod(), {...}
    if rawequal(tostring(Args[1]),'ChatBarFocusChanged') and rawequal(Args[2],true) then 
        if LP['PlayerGui']:FindFirstChild('Chat') then
            BindHook:Fire()
        end
    end
    return NC(...)
end)

BindHook['Event']:Connect(function()
    CBar = LP['PlayerGui'].Chat['Frame'].ChatBarParentFrame['Frame'].BoxFrame['Frame'].ChatBar
    HookChat(CBar)
end)