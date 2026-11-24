# Useful Bash scripts

## 1. rename_idats.sh
This script takes as input a txt file with the following format:

```text
206064560028	Array Info.Sentrix ID	Array Info.Sentrix Position
CEP_C1.v12_13R08C01	206150350001	R08C01
CEP_C1.v12_28R10C01	206184860044	R10C01
CEP_C1.v12_9R10C01	206076980080	R10C01
CEP_C13.v11_13R10C01	206150350001	R10C01
```
and renames .idat files in specified folders (column 2) with the names in column 1 based on ID codes in column 3.

This script was made to rename idat files for submission into EGA.

How to run:

"Dry run" to see how the samples will be renames (does not rename yet)
```text
./rename_idats.sh sample_names.txt 
```

Actual run where the script renames the files:
```text
./rename_idats.sh sample_names.txt  --apply
```
## 2. extract_names.sh

This script loop over all files in the folder and writes a tsv file with the file name and corresponding md5 sum from the matched .md5 file.

Usage:
```text
./make_md5_table.sh /path/to/folder
```

If no folder is supplied, the current directory is used.
Inside the script you need to specify the file name that you want the script to loop over, for example fastq.gz.md5.

