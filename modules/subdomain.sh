#! /bin/bash


banner (){

echo -e "${RED} _  _____ ____   ___  ____    _   _   _ ____ ${RESET}"
echo -e "${RED}| |/ /_ _|  _ \ / _ \/ ___|  / \ | | | |  _ \ ${RESET}"
echo -e "${RED}| ' / | || | | | | | \___ \ / _ \| | | | |_) |${RESET}"
echo -e "${RED}| . \ | || |_| | |_| |___) / ___ \ |_| |  _ < ${RESET}"
echo -e "${RED}|_|\_\___|____/ \___/|____/_/   \_\___/|_| \_\ ${RESET}"
}


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
#*/echo "[*] Amass "
#amass enum -d "$domain" > "$subdir/amass.txt"
#
# Combine and sort unique subdomains

cat "$subdir/"*.txt | sort -u > "$subdir/all_subdomains.txt"

