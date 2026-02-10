#! /bin/bash


domain=$1
base_dir=$2

subdir="$base_dir/subdomains"
mkdir -p "$subdir"
echo "=============================="
echo "[*] Subdomain Enumeration for : $domain"
echo "=============================="

# Assetfinder tool
echo "[*] Assetfinder "
assetfinder --subs-only "$domain" > "$subdir/assetfinder.txt"

# Subfinder tool

echo "[*] Subfinder "
subfinder -d "$domain" -all -recursive -silent -o "$subdir/subfinder.txt"

# crt.sh

echo "[*] crt.sh "

curl -s https://crt.sh/\?q\=$domain\&output\=json | jq -r '.[].name_value' | grep -Po '(\w+\.\w+\.\w+)$' > "$subdir/crtsh.txt"

# Amass tool
echo "[*] Amass "
amass enum -d "$domain" > "$subdir/amass.txt"

# Chaos.txt
echo "[*] Chaos.txt "
chaos -d "$domain" -silent -o "$subdir/chaos.txt"
# Combine and sort unique subdomains

cat "$subdir/"*.txt | sort -u > "$subdir/all_subdomains.txt"

