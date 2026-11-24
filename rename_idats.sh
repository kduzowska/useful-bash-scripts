#!/usr/bin/env bash

# Usage:
#   ./rename_idats.sh sample_mapping.txt

# Dry run only:
#   ./rename_idats.sh sample_mapping.txt

# Actually rename files:
#   ./rename_idats.sh sample_mapping.txt --apply

# Expected directory structure:

#   .
#   ├── sample_mapping.txt
#   ├── 206064560028/
#   │   ├── 206064560028_R01C02_Grn.idat
#   │   └── 206064560028_R01C02_Red.idat
#   ├── 206150350001/
#   │   └── ...
#   └── ...

set -u

mapping_file="$1"
apply="${2:-}"

if [ ! -f "$mapping_file" ]; then
    echo "ERROR: Mapping file not found: $mapping_file"
    exit 1
fi

if [ "$apply" = "--apply" ]; then
    echo "Renaming files..."
else
    echo "DRY RUN - no files will be renamed."
    echo "Run with --apply to perform the renaming."
fi

echo

# Parse rows where:
#   column 1 = new sample name
#   column 2 = Sentrix ID / folder
#   column 3 = position, e.g. R01C02
#
# This awk command also ignores header lines automatically.
awk '
{
    # Remove Markdown-style "|" characters if present
    gsub(/\|/, " ")

    # Look for:
    # sample_name   numeric_folder   RxxCxx
    for (i = 1; i <= NF-2; i++) {
        if ($(i+1) ~ /^[0-9]+$/ && $(i+2) ~ /^R[0-9]+C[0-9]+$/) {
            print $i "\t" $(i+1) "\t" $(i+2)
            break
        }
    }
}
' "$mapping_file" |
while IFS=$'\t' read -r sample_name folder position
do
    for channel in Grn Red
    do
        old_file="${folder}/${folder}_${position}_${channel}.idat"
        new_file="${folder}/${sample_name}_${channel}.idat"

        if [ ! -f "$old_file" ]; then
            echo "NOT FOUND: $old_file"
            continue
        fi

        if [ -e "$new_file" ]; then
            echo "SKIPPING: destination already exists:"
            echo "  $new_file"
            continue
        fi

        if [ "$apply" = "--apply" ]; then
            echo "RENAMING:"
            echo "  $old_file"
            echo "  -> $new_file"
            mv "$old_file" "$new_file"
        else
            echo "WOULD RENAME:"
            echo "  $old_file"
            echo "  -> $new_file"
        fi
    done
done