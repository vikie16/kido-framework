#! /bin/bash


################
#### Color Outputs ####

RESET='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'    
################

banner (){

echo -e "${RED} _  _____ ____   ___  ____    _   _   _ ____ ${RESET}"
echo -e "${RED}| |/ /_ _|  _ \ / _ \/ ___|  / \ | | | |  _ \ ${RESET}"
echo -e "${RED}| ' / | || | | | | | \___ \ / _ \| | | | |_) |${RESET}"
echo -e "${RED}| . \ | || |_| | |_| |___) / ___ \ |_| |  _ < ${RESET}"
echo -e "${RED}|_|\_\___|____/ \___/|____/_/   \_\___/|_| \_\\\ ${RESET}"

echo -e "${GREEN}                                -Created by: Kaiser${RESET}"
}
 
banner

show_help() {
    echo "usage: ./recon.sh -d <target.com>"
    echo 
    echo "Options:"
    echo " -d Target Domain"
    echo " -h Show help Message"
    echo 
    echo "Example:"
    echo " ./recon.sh -d target.com"
}

while getopts d:h flag
do 
    case "${flag}" in
        d) domain=${OPTARG};;
        h) show_help; exit 0;;
    esac
done

if [ -z "$domain" ]; then
    echo "Usage: ./recon.sh -d <target.com>"
    exit 1
fi

output_dir="output/$domain"
# create output directory
mkdir -p "$output_dir"

# create sub directorys
mkdir -p "$output_dir/subdomains"
mkdir -p "$output_dir/live"
mkdir -p "$output_dir/urls"
mkdir -p "$output_dir/params"

# ---------------------------------
# Run Modules
# ---------------------------------

echo "[*] Phase 1: Subdomain Enumeration..." 
bash modules/subdomain.sh "$domain" "$output_dir"

echo "[*] Phase 2: Live Subdomain Check..."
bash modules/livecheck.sh "$output_dir"

echo "[*] Phase 3: URL Extraction..."
bash modules/urls.sh "$output_dir"

echo "[*] phase 4: Parameter Analysis..."
bash modules/params.sh "$output_dir"

echo "[*] Recon Completed. Results saved in $output_dir"
