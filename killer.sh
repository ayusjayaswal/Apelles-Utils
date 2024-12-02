#!/bin/sh
target=$(ps -u $USER -o pid,comm --no-headers | dmenu -l 30 -sb '#fb4934' -shb '#fb4934' -shf '#780606' -nhf '#fb4934' -c)
if [ -z "$target" ]; then
    notify-send "No process selected."
    exit 0
fi
target_id=$(echo "$target" | awk '{print $1}')
target_name=$(echo "$target" | awk '{print $2}')
if kill "$target_id" 2>/dev/null; then
    notify-send "Killed process: $target_name (PID: $target_id)"
else
    notify-send "Failed to kill process: $target_name (PID: $target_id)"
fi
