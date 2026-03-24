#!/bin/bash

set -e

FILE="sig.conf"

if [[ ! -f "$FILE" ]];
then
echo "Error: $FILE does not exist !"
exit 1
fi

# -------------------------------
# 1. Take Inputs
# -------------------------------

read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
read -p "Enter Scale [MID/HIGH/LOW]: " scale
read -p "Enter View [Auction/Bid]: " view
read -p "Enter Count [single digit number]: " count

# -------------------------------
# 2. Validation
# -------------------------------

# Validate Component
if [[ "$component" != "INGESTOR" && "$component" != "JOINER" && "$component" != "WRANGLER" && "$component" != "VALIDATOR" ]]; then
    echo "Invalid Component Name"
    exit 1
fi

# Validate Scale
if [[ "$scale" != "MID" && "$scale" != "HIGH" && "$scale" != "LOW" ]]; then
    echo "Invalid Scale"
    exit 1
fi

# Validate View
if [[ "$view" != "Auction" && "$view" != "Bid" ]]; then
    echo "Invalid View"
    exit 1
fi

# Validate Count (single digit)
if ! [[ "$count" =~ ^[0-9]$ ]]; then
    echo "Count must be a single digit number"
    exit 1
fi

# -------------------------------
# 3. Map View to actual value
# -------------------------------

if [[ "$view" == "Auction" ]]; then
    view_value="vdopiasample"
else
    view_value="vdopiasample-bid"
fi

# -------------------------------
# 4. Build new line
# -------------------------------

new_line="$view_value ; $scale ; $component ; ETL ; vdopia-etl= $count"

# -------------------------------
# 5. Check if component exists in file
# -------------------------------

if ! grep -q "$component" "$FILE"; then
    echo "No matching component found in $FILE"
    exit 1
fi

# -------------------------------
# 6. Replace only one matching line
# -------------------------------

updated=false

while IFS= read -r line; do
    if [[ "$line" == *"$component"* && "$updated" = false ]]; then
        echo "$new_line"
        updated=true
    else
        echo "$line"
    fi
done < "$FILE" > temp.conf

mv temp.conf "$FILE"
cp "$FILE" "$FILE.bak"

if [[ "$updated" = true ]]; then
    echo " File updated successfully!"
    echo " Backup created: $FILE.bak"
else
    echo " No matching line updated!"
    exit 1
fi

