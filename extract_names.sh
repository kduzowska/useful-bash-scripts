# This script loop over all files in the folder and writes a tsv file with the file name and corresponding md5 sum from the matched .md5 file.

#!/usr/bin/env bash

# Usage:
#   ./make_md5_table.sh /path/to/folder
#
# If no folder is supplied, the current directory is used.

DIR="${1:-.}"
OUTPUT="${DIR}/md5_names.tsv"

# Write header
printf "filename\tmd5\n" > "$OUTPUT"

# Go through all .fastq.gz.md5 files
for md5file in "$DIR"/*.fastq.gz.md5; do

    # Skip if no matching files were found
    [ -e "$md5file" ] || continue

    # Get just the filename, without the directory
    md5_basename=$(basename "$md5file")

    # Remove the .md5 suffix
    fastq_name="${md5_basename%.md5}"

    # Extract the MD5 checksum.
    # This works for files containing either:
    #   d41d8cd98f00b204e9800998ecf8427e
    #
    # or:
    #   d41d8cd98f00b204e9800998ecf8427e  filename.fastq.gz
    md5sum=$(awk 'NF {print $1; exit}' "$md5file")

    # Write one row
    printf "%s\t%s\n" "$fastq_name" "$md5sum" >> "$OUTPUT"

done

echo "Created: $OUTPUT"