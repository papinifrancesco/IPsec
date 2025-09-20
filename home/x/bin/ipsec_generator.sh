#!/bin/bash

# --- Functions ---

# Generate a random key using openssl or base64
generate_key() {
    if command -v openssl >/dev/null 2>&1; then
        openssl rand -base64 48
    else
        dd if=/dev/urandom bs=48 count=1 2>/dev/null | base64 -w 0
    fi
}

# --- Configuration ---

# Define the IP range
base_ip="10.10.254"
start=220
end=233

# Define the output file for PSK secrets
secrets_file="ipsec.secrets"

# --- Main Logic ---

# Create an array of IPs
ips=()
for ((i=start; i<=end; i++)); do
    ips+=("$base_ip.$i")
done

# Clear the secrets file to ensure it's fresh
> "$secrets_file"
echo "Initialized secrets file: $secrets_file"

# Generate the secrets and config files for each unique pair of IPs
for i in "${!ips[@]}"; do
    for j in "${!ips[@]}"; do
        # The condition (i < j) ensures we handle each pair only once
        if (( i < j )); then
            # Assign IPs to variables for better readability
            ip1="${ips[i]}"
            ip2="${ips[j]}"

            # 1. Generate the Pre-Shared Key and append it to the secrets file
            key=$(generate_key)
            echo "$ip1 $ip2 : PSK \"$key\"" >> "$secrets_file"

            # 2. Generate the corresponding .conf file for the connection
            conf_file="$ip1-$ip2.conf"
            conn_name="$ip1-$ip2"

            # Use a "here document" (cat <<EOF) to write the config content
            cat <<EOF > "$conf_file"
conn $conn_name
    left=$ip1
    right=$ip2
    authby=secret
    type=transport
    ike=aes256-sha2_512;modp2048
    esp=aes256-sha2_512
    dpddelay=5
    retransmit-timeout=30s
    dpdaction=restart
    auto=start
    keyingtries=%forever
    ikev2=insist
EOF
            echo "Generated config: $conf_file"
        fi
    done
done

echo "✅ All done. Secrets are in '$secrets_file' and connection configs are in the current directory."
