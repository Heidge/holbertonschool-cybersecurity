# The Shell Operations: IO, Redirections & Filters

## Requirements

### General
- All scripts will be tested on Kali Linux, ParrotOS, or Ubuntu 22.04+
- Allowed editors: `vi`, `vim`, `emacs`, `nano`
- A `README.md` file at the root of the project directory is **mandatory**
- All your files should end with a new line

### Bash Scripting
- All scripts must be executable (`chmod +x`)
- The first line of all your files should be exactly `#!/bin/bash`
- All your scripts should be exactly **two lines long** (`wc -l file` should print 2)
- Pipes and logical operators are encouraged
- Scripts must produce **clean output** (no debug messages unless specified)

### Workflow Requirements
- Scripts must be developed **locally** on your machine
- Scripts must be deployed to the target using `scp`
- Scripts must be executed on the remote machine using `ssh <user>@<host>`

---

## Tasks

### 0. The Global Redirector

#### Instructions
* **Write** a script `0-logging.sh` that redirects **all** stdout and stderr to a file named `execution.log` (passed as `$1`).
* **Echo** three messages: "Starting Task" (to stdout), "Doing Work" (to stdout), and "Error: Work Failed" (to stderr).

### 1. No Temp Files

#### Instructions
* **Write** a script `1-compare.sh` that compares the current order of usernames in `/etc/passwd` (`$1`) against the sorted order using **process substitution**.
* **Output** nothing if already sorted; output the `diff` if not sorted.

### 2. The Mass Processor

#### Instructions
* **Write** a script `2-mass_rename.sh` that finds all `*.log` files in the current directory and renames each one to `*.log.old`. 
* **Test** your script in `/var/log/app` (passed as `$1`).

### 3. The Anonymizer

#### Instructions
* **Write** a script `3-anonymize.sh` that accepts a filename as argument (`$1`).
* **Replace** any valid IPv4 address with the string `[REDACTED_IP]`.
* **Output** the result to stdout without modifying the original file.

### 4. The Advanced Filter

#### Instructions
* **Write** a script `4-heavy_files.sh` that lists files in the current directory.
* **Output** only the filenames of files larger than 1024 bytes.

### 5. The User Cleaner

#### Instructions
* **Write** a script `5-cleanup.sh` that reads `/opt/hr/to_delete.txt` (`$1`) line by line.
* **Check** if the user exists (using `id`).
* **If yes:** lock the account and print `User <username> locked`.
* **If no:** print `User <username> not found`.
* *Note: This specific script can span multiple lines.*

### 6. The Port Waiter

#### Instructions
* **Write** a script `6-wait_for.sh` that uses an `until` loop to check if port 80 is listening on `localhost` (`$1`).
* **Print** `Waiting...` every second while waiting.
* **Print** `Service UP!` and exit once the port is available.

### 7. The Log Rotator

#### Instructions
* **Write** a script `7-rotate.sh` that accepts a directory path as argument (`$1`).
* **Verify** the argument is a valid directory; if not, exit with code `1`.
* **Create** a `backups/` subdirectory inside it if it doesn't exist.
* **For each** `.log` file: if larger than 1KB, compress it (`gzip`) and move it to `backups/`. Otherwise, print `Skipping small file: <filename>`.
