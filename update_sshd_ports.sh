#!/bin/bash

# Function to display help message
show_help() {
  echo -e "Usage: $0 [port1 port2 ...]"
  echo -e "Example: $0 22 2222"
  echo -e "Specify one or more ports to configure SSHD to listen on.\n"
}

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "🚫 This script must be run as root"
  exit 1
fi

# Check if no arguments were provided
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Create a timestamped backup of the original sshd_config file
timestamp=$(date +"%Y%m%d%H%M%S")
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak_$timestamp
echo -e "🔒 Backup of sshd_config created at /etc/ssh/sshd_config.bak_$timestamp"

# Remove existing 'Port' entries from the config file
sed -i '/^Port /d' /etc/ssh/sshd_config
echo -e "🧹 Existing Port entries removed."

# Add new port entries from the script arguments
for port in "$@"; do
  echo "Port $port" >> /etc/ssh/sshd_config
done
echo -e "🔧 New Port entries added for: $*"

# Restart the SSHD service to apply changes
if systemctl restart sshd.service; then
  echo -e "✅ SSHD has been successfully restarted and is now listening on ports: $*"
else
  echo -e "❌ Failed to restart SSHD. Check your configuration."
fi
