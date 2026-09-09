#!/bin/bash

# URL of the source CSV file, stored as a variable so it's easy to update
# if the data source ever changes, rather than editing it inline.
URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# Directory and file path for the Extract stage.
# EDPATH = folder where the raw downloaded file will live.
# EFPATH = full path to the raw file itself, inside that folder.
EDPATH="/mnt/c/Users/godwi/Desktop/cde/raw/"
EFPATH="/mnt/c/Users/godwi/Desktop/cde/raw/etl.csv"

# Directory and file path for the Transform stage.
# TDPATH  = folder where transformed files will live.
# TTFPATH = intermediate file, after the column rename but before column selection.
# TFPATH  = final transformed file, after both rename and column selection.
TDPATH="/mnt/c/Users/godwi/Desktop/cde/transformed"
TTFPATH="/mnt/c/Users/godwi/Desktop/cde/transformed/tf.csv"
TFPATH="/mnt/c/Users/godwi/Desktop/cde/transformed/2023_year_finance.csv"


# Directotry and file path for load
# GDPATH = folder where the final gold-layer file will live.
# GFPATH = full path to the final loaded file itself.
GDPATH="/mnt/c/Users/godwi/Desktop/cde/gold/"
GFPATH="/mnt/c/Users/godwi/Desktop/cde/gold/gf.csv"

## ---------------- EXTRACT ----------------

# Ensure the raw/ folder exists (creates it if missing, does nothing if it
# already exists, so this is safe to run every time the script runs).
mkdir -p $EDPATH
wget -O  $EFPATH $URL


# Confirm the download actually succeeded by checking the file exists.
# This is the script's own verification step, independent of wget's own
if [ -f $EFPATH ]; then
    echo "suceess"
else
    echo "failure"
fi

# ---------------- TRANSFORM ----------------

# Ensure the transformed/ folder exists before writing any output into it.
mkdir -p $TDPATH

# Rename the column header 'Variable_code' to 'variable_code'.
# Reads from the raw file (EFPATH) and writes the renamed result into a
# separate intermediate file (TTFPATH), leaving the raw file untouched.
sed  's/Variable_code/variable_code/' $EFPATH > $TTFPATH

# Select only the columns: year, Value, Units, variable_code.
# Uses FPAT (instead of a plain comma split) so that any field wrapped in
# quotes — which may contain a comma as part of its actual text — is
# treated as a single field rather than being incorrectly split in two.
# OFS="," ensures the output stays comma-separated, matching CSV format.
gawk -v OFS="," -v FPAT='[^,]*|"[^"]*"' '{print $1, $5, $6, $9}' $TTFPATH > $TFPATH

# ---------------- LOAD ----------------
# Ensure the gold/ folder exists before copying the final file into it.
mkdir -p $GDPATH

# Copy the fully transformed file into the gold folder as the final
# deliverable output of the pipeline.
cp $TFPATH $GFPATH

# Confirm the file was successfully loaded into the gold folder.
if [ -f $GFPATH  ]; then
    echo "success"
else
    echo "failure"
fi