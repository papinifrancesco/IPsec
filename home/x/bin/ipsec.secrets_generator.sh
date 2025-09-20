#!/bin/bash

# Generate a random key using openssl or base64
generate_key() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -base64 48
  else
    dd if=/dev/urandom bs=48 count=1 2>/dev/null | base64 -w 0
  fi
}

# Define the IP range
base_ip="10.0.0"
start=1
end=3

# Create an array of IPs
ips=()
for ((i=start; i<=end; i++)); do
    ips+=("$base_ip.$i")
done

# Generate the secrets file
for i in "${!ips[@]}"; do
    for j in "${!ips[@]}"; do
        if (( i < j )); then
            key=$(generate_key)
            echo "${ips[i]} ${ips[j]} : PSK \"$key\""
        fi
    done
done
