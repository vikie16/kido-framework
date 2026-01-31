#! /bin/bash

## =============================
## Live Host Check 
## =============================

output_dir=$1
# Input from subdomain
subdomain_file="$output_dir/subdomains/all_subdomains.txt"

# Output directory for live domains
live_dir="$output_dir/live"

if [ ! -f "$subdomain_file" ]; then
    echo "Subdomain.txt file not found: $subdomain_file"
    exit 1
fi

echo "============================="
echo " Live Host Check "
echo "============================="
echo "[*] Scanning for live hosts..."

# using httpx tool to check live hosts

httpx -l "$subdomain_file" -sc -silent -title -td -fr | tee "$live_dir/httpx_raw.txt"

#  Extract live domains 

cut -d ' ' -f1 "$live_dir/httpx_raw.txt" > "$live_dir/live_hosts.txt"
# Extract Dead domains

grep -vxF -f "$live_dir/live_hosts.txt" "$subdomain_file" > "$live_dir/dead_hosts.txt"

# Split Http and Https

grep "^http://" "$live_dir/live_hosts.txt" > "$live_dir/live_http.txt"
grep "^https://" "$live_dir/live_hosts.txt" > "$live_dir/live_https.txt"

# -------------------------------------
# Summary
# -------------------------------------

echo "[!!!] Live subdomains: $(wc -l < "$live_dir/live_hosts.txt")"
echo "[!!!] Dead subdomains: $(wc -l < "$live_dir/dead_hosts.txt")"