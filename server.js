const port = 33850	// Your port here
const http = require('http');
const WebSocket = require('ws');
const rateLimit = require('ws-rate-limit')('5s', 10)

const server = http.createServer();
const wss = new WebSocket.Server({ server });
var ips = []

wss.on('connection', function connection(ws, req) {
  rateLimit(ws);
  const ip = req.socket.remoteAddress;
  if (ips.includes(ip)) {
    ws.close();
    return;
  } else {
    ips.push(ip);
  }
  ws.on('message', function incoming(data) {
    if (data.length > 1000) { return; }
    wss.clients.forEach(function each(client) {
      if (client !== ws && client.readyState === WebSocket.OPEN) {
      	client.send(data);
      }
    });
  });
  ws.on('close', function close() {
    ips = ips.filter(item => item !== ip)
  });
});

server.listen(port);