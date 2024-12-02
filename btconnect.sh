#!/bin/sh
#!/bin/bash

select=$(bluetoothctl devices | awk '{ $1=$2=""; print substr($0, 3) }' | dmenu -l 10 -c -p "Select a device:")
if [[ -z "$select" ]]; then
    notify-send "No device selected"
    exit 1
fi
MAC=$(bluetoothctl devices | grep -i "$select" | awk '{print $2}')

if [[ -z "$MAC" ]]; then
    notify-send "Failed to find MAC address for $select"
    exit 1
fi

connect=$(bluetoothctl info "$MAC" | grep "Connected:" | awk '{print $2}')

if [[ "$connect" == "no" ]]; then
    notify-send "Attempting to connect to $select"
    bluetoothctl connect "$MAC" && notify-send "Successfully connected to $select" || notify-send "Failed to connect to $select"
elif [[ "$connect" == "yes" ]]; then
    notify-send "Attempting to disconnect from $select"
    bluetoothctl disconnect "$MAC" && notify-send "Successfully disconnected from $select" || notify-send "Failed to disconnect from $select"
else
    notify-send "Unexpected connection status for $select"
fi
