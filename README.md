# iperf3-alpine-vm-light

This script builds a lightweight Alpine Linux VM on Proxmox with iperf3 server pre-installed.

## Features
- Installs Alpine 3.19
- Sets up iperf3 server to auto-start
- Enables QEMU Guest Agent
- Custom welcome message showing IP + usage instructions

## Usage

Run this from the Proxmox host:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/AmeelMD/iperf3-alpine-vm-light/main/setup.sh)
```

Then follow the prompts. After installing Alpine manually, run:

```bash
curl -o /root/post-install.sh https://raw.githubusercontent.com/AmeelMD/iperf3-alpine-vm-light/main/post-install.sh
chmod +x /root/post-install.sh && sh /root/post-install.sh
```
