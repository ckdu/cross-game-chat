# Cross-Game Chat
Encrypted websocket cross-game chat with an invite-to-server feature. Only works on Synapse X.

## Features
- **Server inviting/joining:** You can easily invite people to join your game server.
- **In-line:** No annoying external GUI's. The messages appear in the default chat.
- **Uses websocket:** For more efficiency, faster bidirectional data transmitting, instead of having to constantly request the server.
- **Client-sided AES-256 encryption:** As long as you don't share the encryption key, no one can see the messages being transmitted, not even the server, as everything is encrypted on the client, and decrypted on other clients.
- **Anti message logging:** The messages you send are never transmitted to the game server. Meaning those with message loggers (.Chatted) will not be able to see your messages.
- **Anti lua injection:** Security measure to prevent people from injecting lua code with their messages.
- **Roles and colors.**
- **Toggable rainbow chat.**

## Showcase
#### Click below to watch on YouTube
[![Showcase](https://i.imgur.com/bWxjAZz.png)](https://www.youtube.com/watch?v=svyqZINPZ54 "Showcase")

## How to test it:
1. Load `demo.lua` in your editor.
2. Change your color/role settings as you'd like.
3. Run it.

To toggle sending, chat "!c" or "!chat".

To invite people to your server, chat "!invite".

To join an invite you received, chat "!join".

## How to setup your own private chat:
> Note: This should work with any platform supporting Node.JS apps, but for simplicity, this example will use an Ubuntu VPS.
#### Server Setup
1. Get an Ubuntu VPS (Virtual Private Server).
2. [Optional] Get a domain name and point it to your VPS (Steps depend on your domain registrar/VPS provider).
3. Connect to your VPS with SSH.
4. Run `sudo apt update && sudo apt upgrade` and enter `Y` if asked.
5. Run `sudo apt install nodejs && sudo apt install npm` and enter `Y` if asked.
6. [Optional] `cd` to a directory where you'd like to install the server app.
7. Run `wget https://raw.githubusercontent.com/xxaim/cross-game-chat/master/server.js`.
8. [Optional] Run `nano server.js` and edit the port.
9. Run `npm install ws http`.
10. Run `nohup node server.js &`, and close your SSH connection.
#### Client Setup
1. Open `demo.lua`.
2. Replace the value for `getgenv().WS_URL` with `"ws://YOUR_URL_OR_VPS_IP_HERE:YOUR_PORT"`. The default port, if you didn't edit it, is `17584`.
3. Generate or enter a strong encryption key, and set it as the value for `getgenv().ENCRYPTION_KEY`. This is a password that you share with authorized users.
4. Save the file and share it to whoever you want in your chat. Users may edit the other settings as they'd like.

## Credits
	Main Script: Aim
	Colors, Roles, etc: 7n7o
	Chat hook: Riptxde
