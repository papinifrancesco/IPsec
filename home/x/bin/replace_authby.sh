#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (using sudo)." >&2
    exit 1
fi

# Check if /etc/ipsec.d/ directory exists
if [ ! -d "/etc/ipsec.d/" ]; then
    echo "Directory /etc/ipsec.d/ does not exist." >&2
    exit 1
fi

# Find and process .conf files
find /etc/ipsec.d/ -maxdepth 1 -name '*.conf' -type f | while read -r file; do
    echo "Processing file: $file"
    # Create backup and perform replacement
    sed -i.bak 's/authby=rsasig/authby=secret/g' "$file"
done

echo "All .conf files in /etc/ipsec.d/ have been processed."
