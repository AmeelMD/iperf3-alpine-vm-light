#!/bin/sh
echo "📦 Installing iperf3 and qemu-guest-agent..."
apk update
apk add iperf3 qemu-guest-agent

echo "🔧 Enabling guest agent..."
rc-update add qemu-guest-agent
rc-service qemu-guest-agent start

echo "⚙️ Setting up iperf3 server to run at boot..."
echo '#!/bin/sh' > /etc/local.d/iperf3-server.start
echo 'iperf3 -s -D' >> /etc/local.d/iperf3-server.start
chmod +x /etc/local.d/iperf3-server.start
rc-update add local

# Welcome message on tty1
echo "" >> /etc/motd
echo "Welcome to your iPerf3 Server!" >> /etc/motd
echo "" >> /etc/motd
echo " Run this from a client machine:" >> /etc/motd
echo "   iperf3 -c <this-server-ip>" >> /etc/motd
echo "" >> /etc/motd
echo "📡 To check IP, run: ip a" >> /etc/motd

echo "✅ Setup complete."
