# Security Automation

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

### Critical Constraints
- **Idempotence:** The script must be safe to run multiple times without breaking anything.
- **Privileges:** The script runs as `root` via systemd.
- **No hardcoding:** Service names, file paths, and ports must come from the config file.

### Workflow Requirements
- Scripts must be developed **locally** on your machine.
- Scripts must be deployed to the target using `scp`.
- Scripts must be executed on the remote machine using `ssh <user>@<host>`.

---

## Tasks

### 0. Configuration Loader

#### Instructions
* **Create** a configuration file `sentinel.conf` containing:
    * `SERVICES=("ssh" "cron")`
    * `FILES_TO_WATCH=("/etc/passwd" "/etc/ssh/sshd_config")`
* **Write** a script `sentinel.sh` that sources this config file safely.
* **Exit** with an error if the config file is missing and validate that required variables are defined.

### 1. The Service Healer

#### Instructions
* **Create** a function `check_services` that loops through the `SERVICES` array.
* **Check** if each service is running using `pgrep -f`.
* **Logic:**
    * If active: Log `OK: <service> is running`.
    * If not running: Start it using `eval` and log `FIXED: Restarted <service>` (or log an error if it fails).

### 2. The Integrity Checker

#### Instructions
* **Create** a function `check_integrity` that calculates the MD5 hash for each file in `FILES_TO_WATCH`.
* **Compare** it against a corresponding golden copy hash.
* **Logic:**
    * If hashes match: Log `OK: <file> integrity verified`.
    * If hashes differ: Overwrite the live file with the golden copy and log `FIXED: Restored <file>`.

### 3. The Port Whitelist

#### Instructions
* **Add** `ALLOWED_PORTS=("22" "80")` to your config.
* **Create** a function `check_ports` that lists all listening TCP ports and compares them against the whitelist.
* **Logic:**
    * If port is in whitelist: Do nothing.
    * If port is NOT in whitelist: Kill the process holding that port and log `ALERT: Killed rogue process on port <port>`.

### 4. The JSON Logger

#### Instructions
* **Create** a function `log` that generates a JSON entry appended to `/var/log/sentinel.log`.
* **Format:** Must include `timestamp` (ISO 8601), `component` (SERVICE, INTEGRITY, PORT), `target`, `status` (OK, FIXED, ALERT), and `details`.

### 5. The Service Unit

#### Instructions
* **Create** a systemd service file `sentinel.service`.
* **Configuration:** Set `Type=oneshot`, point `ExecStart` to the full path of your script, and set `User=root`.

### 6. The Timer Unit

#### Instructions
* **Create** a systemd timer file `sentinel.timer` that triggers the service every 5 minutes and starts at boot.
* **Create** a setup script `setup_persistence.sh` to:
    * Copy unit files to `/etc/systemd/system/`.
    * Reload the systemd daemon.
    * Enable and start the timer.
