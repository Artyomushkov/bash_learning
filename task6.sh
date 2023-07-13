#!/bin/sh

echo "Current date and time: $(date)"
echo "User: $USER"
echo "Internal IP address: $(ipconfig getifaddr en0), hostname: $(hostname)"
echo "Public IP address: $(curl ifconfig.me 2>/dev/null)"
echo "MacOS version: $(sw_vers --productName) $(sw_vers --productVersion)"
echo "System uptime: $(uptime)"
echo "Space used: $(du -shg / 2>/dev/null | awk '{print $1;}') GB, free space: $(df -hg / | awk '{print $4;}' | sed -n 2p) GB"
echo "CPU info: $(top -l 2 | grep -E "^CPU" | sed -n 2p)"
echo "CPU cores number: $(sysctl -a | grep machdep.cpu | grep core_count | awk '{print $2;}'), CPU frequency: $(sysctl hw.cpufrequency | awk '{print $2;}')"
