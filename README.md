# CDE Git & Linux Assignment

A small data engineering project demonstrating a Bash based ETL pipeline,
automated scheduling with cron, a general-purpose file-organizing script,
and version control with Git.

## Project Structure

```
cde/
├── script.sh # Main ETL script (Extract, Transform, Load)
├── mover_script.sh # Moves CSV/JSON files into a single folder
├── .gitignore # Excludes generated/log files from version control
├── raw/ # Extract stage output (downloaded CSV)
├── transformed/ # Transform stage output (renamed + column-selected CSV)
├── gold/ # Load stage output (final deliverable file)
├── source_files/ # Sample files used to test mover_script.sh
└── json_and_csv/ # Destination folder for moved CSV/JSON files

```
## Part 1: ETL Script (`script.sh`)

This script downloads a public dataset, transforms it, and loads the result
into a final "gold" folder.

**Extract**
- Downloads the Annual Enterprise Survey CSV from stats.govt.nz
- Saves it into `raw/etl.csv`
- Confirms the download succeeded by checking the file exists

**Transform**
- Renames the column `Variable_code` to `variable_code`
- Selects only the columns: `year, Value, Units, variable_code`
- Uses `awk` with a custom `FPAT` (rather than `cut`) to correctly handle
  fields that contain commas inside quoted text — a plain comma-split would
  silently corrupt any row where a category description contains a comma
- Saves the result into `transformed/2023_year_finance.csv`

**Load**
- Copies the final transformed file into `gold/gf.csv`
- Confirms the file exists after copying

**Run it manually:**
```bash
bash script.sh
```

## Part 2: Scheduling with Cron

The ETL script is scheduled to run automatically every day at midnight:

00 00 * * * /mnt/c/Users/godwi/Desktop/cde/script.sh >> /mnt/c/Users/godwi/Desktop/cde/cron.log 2>&1


- `00 00 * * *` — runs at minute 0, hour 0, every day
- Output (both normal messages and any errors) is appended to `cron.log`
  for troubleshooting, rather than being lost or emailed
- `cron.log` itself is excluded from version control via `.gitignore`,
  since it's generated output, not source material

To view or edit the schedule: `crontab -e`
To list active cron jobs: `crontab -l`

## Part 3: File Mover Script (`mover_script.sh`) 

A general-purpose script that finds every `.csv` and `.json` file inside
`source_files/` and moves it into `json_and_csv/`, leaving other file types
untouched.

**How it works:**
- `find` searches for files matching each extension pattern (`*.csv`, `*.json`)
- Since a plain pipe only passes text, and `mv` can't read filenames from a
  pipe directly, `xargs -I {}` is used to convert each found filename into
  a proper argument for `mv`

**Run it manually:**
```bash
bash mover_script.sh
```

## Part 4: Version Control

This project is tracked with Git and hosted on GitHub.

- Generated/log files (`cron.log`) are excluded via `.gitignore`
- Setup commands used:
```bash
  git init
  git add .
  git commit -m "Initial commit"
  git remote add origin <repo-url>
  git push origin main
```
## How to Run

Follow these steps to run the full project from scratch.

**1. Clone the repository**
```bash
git clone https://github.com/Nosakharey/cde_git-linux-assigment.git
cd cde_git-linux-assigment
```

**2. Make the scripts executable**
```bash
chmod +x script.sh
chmod +x mover_script.sh
```

**3. Run the ETL pipeline**
```bash
bash script.sh
```
This will:
- Create `raw/`, `transformed/`, and `gold/` folders (if they don't already exist)
- Download the source CSV into `raw/etl.csv`
- Transform it and save the result into `transformed/2023_year_finance.csv`
- Load the final file into `gold/gf.csv`
- Print a success/failure message after each stage

**4. Run the file-mover script**
```bash
bash mover_script.sh
```
This will:
- Create `source_files/` and `json_and_csv/` folders (if they don't already exist)
- Generate a few sample `.csv`, `.json`, and `.txt` files for demonstration
- Move only the `.csv` and `.json` files into `json_and_csv/`, leaving the `.txt` file behind

**5. (Optional) Schedule the ETL script to run daily**
```bash
crontab -e
```
Add the following line, replacing the path with your own script's absolute path:

00 00 * * * /absolute/path/to/script.sh >> /absolute/path/to/cron.log 2>&1

Verify it was added:
```bash
crontab -l
```


## Requirements

- Bash
- `wget`, `sed`, `gawk` (GNU awk, for `FPAT` support), `find`, `xargs`
- Cron (for scheduling)