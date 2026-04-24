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

curl -s -H "User-Agent: Mozilla/5.0" "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> "$subdir/crtsh.txt"

# Amass tool
# 
echo "[*] Amass "
# amass enum -d "$domain" > "$subdir/amass.txt"

# Chaos.txt
echo "[*] Chaos.txt "
chaos -d "$domain" -silent -o "$subdir/chaos.txt"

# Findomain Tool
echo "[*] Findomain "
findomain -t "$domain" -q | sort -u "$subdir/findomain.txt"


# Combine and sort unique subdomains

cat "$subdir/"*.txt | sort -u > "$subdir/all_subdomains.txt"

