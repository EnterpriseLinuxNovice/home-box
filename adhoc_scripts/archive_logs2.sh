#!/usr/bin/env bash

# This script compresses and archives application logs that fill up
# quickly. Some logs include /data/app_error.log and /data/app_message.log

applog=("/data/app_error.log" "/data/app_message.log")
logdest="/data/log"
date_str=$(date +%F)
actions_log="${logdest}/archive_log.log"

# Ensure archive log file and destination directory exist
archive_log_check() {
    mkdir -p "$logdest"
    [[ -e "$actions_log" ]] || touch "$actions_log"
}

# Check if logs exist and then evaluate size
check_logs() {
    for log in "${applog[@]}"; do
        if [[ -e "$log" ]]; then
            check_usage "$log"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S'): $log does NOT exist. Skipping..." >> "$actions_log"
        fi
    done
}

# Check if log is larger than 1GB and archive if true
check_usage() {
    local log_file="$1"
    size=$(du -sh "$log_file" | awk '{print $1}')
    num=${size%[A-Za-z]}
    unit=${size: -1}

    if [[ "$unit" == "G" && $(echo "$num > 1" | bc -l) -eq 1 ]]; then
        archive_name="${logdest}/$(basename "$log_file" .log)_${date_str}.tar.gz"
        tar -czf "$archive_name" "$log_file" && rm -f "$log_file"
        echo "$(date '+%Y-%m-%d %H:%M:%S'): Archived $log_file to $archive_name" >> "$actions_log"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $log_file is under 1GB. No archive needed." >> "$actions_log"
    fi
}

# Run main
archive_log_check
check_logs

