# iPerf3 Alpine VM Light

This script helps you spin up a lightweight Alpine Linux VM with iPerf3 pre-configured as a server on Proxmox VE.

## Features
- Choose DHCP or static IP
- Automatically installs Alpine & iperf3
- Sets up iperf3 as a server on boot
- Shows IP address and usage instructions on the VM console

## Usage

On your Proxmox shell:
```bash
bash <(curl -sSL https://raw.githubusercontent.com/AmeelMD/iperf3-alpine-vm-light/main/setup.sh)
```

## Credits
Created with ❤️ and assistance from GPT (Rys).
