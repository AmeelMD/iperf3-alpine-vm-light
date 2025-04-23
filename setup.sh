#!/bin/bash

echo "🧠 Welcome to the iperf3 Alpine VM Setup Wizard!"

# Prompt for VM info
read -p "Enter VM ID (e.g., 900): " VMID
read -p "Enter VM Name (e.g., iperf3-test): " VMNAME
read -p "Enter Storage (e.g., local-lvm): " STORAGE
read -p "Enter Network Bridge (e.g., vmbr0): " BRIDGE

# Ask for IP mode
read -p "Use DHCP? (y/n): " USE_DHCP
if [[ "$USE_DHCP" == "n" ]]; then
    read -p "Static IP Address (e.g., 192.168.1.100/24): " STATIC_IP
    read -p "Gateway IP (e.g., 192.168.1.1): " GATEWAY
    read -p "DNS (e.g., 1.1.1.1): " DNS
fi

echo "📦 Downloading Alpine ISO..."
wget -O alpine-standard.iso https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-standard-3.19.1-x86_64.iso

echo "📁 Creating VM $VMID - $VMNAME..."
qm create $VMID --name $VMNAME --memory 512 --cores 1 --net0 virtio,bridge=$BRIDGE     --boot order=cdrom --serial0 socket --vga std

qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:4
qm set $VMID --ide2 $STORAGE:cloudinit
qm importdisk $VMID alpine-standard.iso $STORAGE
qm set $VMID --cdrom $STORAGE:vm-$VMID-disk-1
qm set $VMID --agent enabled=1
qm set $VMID --autostart 1

echo "📂 Copying post-install script to VM folder..."
mkdir -p /var/lib/vz/snippets
cp post-install.sh /var/lib/vz/snippets/post-install.sh

echo "✅ VM created! Start the VM and manually install Alpine, then run:"
echo "   sh /root/post-install.sh"
