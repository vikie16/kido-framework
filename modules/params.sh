#!/bin/bash

# --------------------------------
# Parameter Module
# --------------------------------

output_dir=$1

# input files
urls_file="$output_dir/urls/urls_clean.txt"

# output directory
params_dir="$output_dir/params"

# --------------------------------
# Sanity checks
# --------------------------------

if [ -z "$output_dir" ]; then
    echo "[!] Usage: params.sh <output_dir>"
    exit 1
fi

if [ ! -f "$urls_file" ]; then 
    echo "[!] Error: urls_clean.txt file not found at  $urls_file"
    exit 1
fi

# Create Output directory
mkdir -p "$params_dir"
echo "============================="
echo "[*] Starting Parameter analysis..."
echo
# --------------------------------
# Extract URLs with parameters
# --------------------------------

grep "=" "$urls_file" | sort -u > "$params_dir/urls_with_params.txt"

# --------------------------------
# Extract Parameters Names
# --------------------------------

cat "$params_dir/urls_with_params.txt" | sed 's/.*?//' | tr '&' '\n' | cut -d '=' -f1 | sort -u > "$params_dir/parameters_names.txt"

# --------------------------------
# Group Parameters bu endpoint
# --------------------------------

awk -F '?' '{print $1 " -> " $2}' "$params_dir/urls_with_params.txt" | sort -u > "$params_dir/params_by_endpoint.txt"

# --------------------------------
# IDOR candidate URLs
# --------------------------------

grep -Ei "(id|user|uid|account|accountid|profile|profileid|doc|file|number|member|memberid|client|clientid|customer|customerid|order|orderid|session|sessionid)" "$params_dir/urls_with_params.txt" | sort -u > "$params_dir/idor_candidates.txt"

# --------------------------------
# XSS candidate URLs
# --------------------------------

grep -Ei "(search|query|q|s|keyword|term|text|msg|message|comment|input|name|title|desc|description|body|content)" "$params_dir/urls_with_params.txt" | sort -u > "$params_dir/xss_candidates.txt"

# --------------------------------
# SQLi candidate URLs
# --------------------------------

grep -Ei "(id|user|uid|account|accountid|profile|profileid|doc|file|number|member|memberid|client|clientid|customer|customerid|order|orderid|session|sessionid)" "$params_dir/urls_with_params.txt" | sort -u > "$params_dir/sqli_candidates.txt"

# --------------------------------
# LFI candidate URLs
# --------------------------------

grep -Ei "(file|doc|document|path|page|template|tpl|include|inc|view|load)" "$params_dir/urls_with_params.txt" | sort -u > "$params_dir/lfi_candidates.txt"

# --------------------------------
# Open Redirect candidate URLs
# --------------------------------
grep -Ei "(url|redirect|next|dest|destination|redir|go|path|to)" "$params_dir/urls_with_params.txt" | sort -u > "$params_dir/open_redirect_candidates.txt"

# --------------------------------
# summary
# --------------------------------

echo ---
echo "[*] Parameter analysis completed."