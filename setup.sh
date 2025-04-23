#!/bin/bash

echo "🧠 Welcome to the iperf3 Alpine VM Setup Wizard!"

read -p "Enter VM ID (e.g., 900): " VMID
read -p "Enter VM Name (e.g., iperf3-test): " VMNAME
read -p "Enter Storage (e.g., local-lvm): " STORAGE
read -p "Enter Network Bridge (e.g., vmbr0): " BRIDGE

read -p "Use DHCP? (y/n): " USE_DHCP
if [[ "$USE_DHCP" == "n" ]]; then
    read -p "Static IP Address (e.g., 192.168.1.100/24): " STATIC_IP
    read -p "Gateway IP (e.g., 192.168.1.1): " GATEWAY
    read -p "DNS (e.g., 1.1.1.1): " DNS
fi

echo "📦 Downloading Alpine ISO..."
wget -O alpine-standard.iso https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-standard-3.19.1-x86_64.iso

echo "📁 Creating VM $VMID - $VMNAME..."
qm create $VMID --name $VMNAME --memory 512 --cores 1 --net0 virtio,bridge=$BRIDGE --agent enabled=1 --autostart 1 --vga std --scsihw virtio-scsi-pci
qm set $VMID --scsi0 $STORAGE:4

echo "📄 Importing Alpine ISO..."
qm set $VMID --ide2 $STORAGE:iso-alpine,media=cdrom
qm importdisk $VMID alpine-standard.iso $STORAGE --format qcow2

echo "🔧 Setting boot order..."
qm set $VMID --boot order=scsi0

echo "📂 Post-install script will be downloaded manually inside the VM."
echo ""
echo "✅ VM created! Start the VM and manually install Alpine, then run inside Alpine:"
echo ""
echo "   curl -o /root/post-install.sh https://raw.githubusercontent.com/AmeelMD/iperf3-alpine-vm-light/main/post-install.sh"
echo "   chmod +x /root/post-install.sh && sh /root/post-install.sh"
