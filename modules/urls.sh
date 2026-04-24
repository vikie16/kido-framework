#! /bin/bash

# --------------------------------
# URL Extraction
# --------------------------------

output_dir=$1

# Input files
live_file="$output_dir/live/live_hosts.txt"
live_https_file="$output_dir/live/live_https.txt"

# Output files
urlsdir=$output_dir/urls

# Sanity checks
if [ -z "$output_dir" ]; then
    echo "[!] Usage: urls.sh <output_dir>"
    exit 1
fi

if [ ! -f "$live_file" ]; then
    echo "Error!!!! Live_hosts.txt file not found..."
    exit 1
fi 

mkdir -p "$urlsdir"
echo "============================="
echo " URL Extraction "
echo "============================="
echo "[*] Collecting all URls from live hosts..."

# using GAU tool

echo "[*] Using GAU to fetch URLs..."
gau --subs < "$live_file" > "$urlsdir/urls_gau.txt"

# Using Katana to crawl URLs

echo "[*] Using Katana to crawl URLs..."
katana -list "$live_file" -silent -d 5 -kf -jc > "$urlsdir/urls_katana.txt"

# Using Wayback 

echo "[*] Fetching URLs from Wayback Machine..."

curl -s --connection-timeout 10  "http://web.archive.org/cdx/search/cdx?url=*.$domain&output=text&fl=original&collapse=urlkey" | grep "\.$domain" >> "$urlsdir/urls_wayback.txt"

# Hakrawler Tool

echo "[*] Runinng Hakrawler to fetch URLs..."
cat "$live_file" | hakrawler -silent -d 5 -plain | sort -u > "$urlsdir/urls_hakrawler.txt"
# Filter Katana urls

cat "$urlsdir"/urls_*.txt | sort -u > "$urlsdir/urls_raw.txt"

# Remove Unwanted files 

grep -Ev "\.(jpg|jpeg|png|gif|svg|css|woff|woff2|ttf|eot|ico|mp4|mp3|pdf)$" "$urlsdir/urls_raw.txt" > "$urlsdir/urls_clean.txt"

echo "[*] Total URLs collected : $(wc -l < "$urlsdir/urls_clean.txt")"

# Collect JS files
echo "[*] Extracting JavaScript files from the URLs..."

cat "$urlsdir/urls_raw.txt" | grep -E "\.js$" | sort -u > "$urlsdir/js_files.txt"