#!/bin/bash
set -e

echo "🧠 iPerf3 Alpine VM Creator for Proxmox"

# Prompt for user inputs
read -p "🔢 Enter VM ID: " VMID
read -p "📛 Enter VM Name: " VMNAME
read -p "💾 Enter Storage Name (e.g., local-lvm): " STORAGE
read -p "🔌 Enter Network Bridge (e.g., vmbr0): " BRIDGE

echo "🌐 Network Configuration:"
select NETTYPE in "DHCP" "Static"; do
    case $NETTYPE in
        DHCP ) IP_MODE="dhcp"; break;;
        Static ) 
            read -p "🖥️ Enter Static IP Address (e.g., 192.168.1.100/24): " STATIC_IP
            read -p "🚪 Enter Gateway IP: " GATEWAY
            read -p "🧭 Enter DNS Server IP: " DNS
            IP_MODE="static"
            break;;
    esac
done

read -p "🔧 Enter Network Interface (eth0, ens18, etc.): " IFACE

# Download Alpine ISO if not present
ISO_URL="https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-standard-3.19.1-x86_64.iso"
ISO_FILE="/var/lib/vz/template/iso/alpine-standard-3.19.1-x86_64.iso"
if [ ! -f "$ISO_FILE" ]; then
    echo "⬇️  Downloading Alpine ISO..."
    wget "$ISO_URL" -O "$ISO_FILE"
fi

# Create the VM
echo "🛠️  Creating VM $VMID..."
qm create $VMID --name $VMNAME --memory 512 --net0 virtio,bridge=$BRIDGE --cores 1 --ostype l26
qm set $VMID --ide2 $STORAGE:cloudinit
qm set $VMID --boot order=ide2
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --cdrom $STORAGE:iso/alpine-standard-3.19.1-x86_64.iso
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:10,format=qcow2

# Add autostart
qm set $VMID --onboot 1

# Prepare post-install script
cat <<EOF > /var/lib/vz/snippets/iperf3-post-install.sh
#!/bin/sh
setup-alpine -f
apk add iperf3
echo "@reboot iperf3 -s &" | crontab -
clear
IP=\$(ip -4 addr show $IFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "
Welcome to your iPerf3 Server!
 IP Address: \$IP
 --------------------------
 Run from any client to test:
   iperf3 -c \$IP
-------------------------------
iperf3 server is actively listening...
"
EOF

chmod +x /var/lib/vz/snippets/iperf3-post-install.sh
echo "✅ VM $VMID created. Boot it, run the post-install script, and enjoy iPerf3."
