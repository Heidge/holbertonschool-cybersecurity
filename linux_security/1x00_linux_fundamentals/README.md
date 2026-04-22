# Linux Fundamentals & Security Baseline

## Requirements

### General
- All scripts will be tested on Kali Linux, ParrotOS, or Ubuntu 22.04+
- Allowed editors: `vi`, `vim`, `emacs`, `nano`
- A `README.md` file at the root of the project directory is mandatory
- All your files should end with a new line

### Bash Scripting
- All scripts must be executable (`chmod +x`)
- The first line of all your files should be exactly `#!/bin/bash`
- All your scripts should be exactly **two lines long** (`wc -l file` should print 2)
- Pipes and logical operators are encouraged
- Scripts must produce clean output (no debug messages unless specified)

---

## Tasks

### 0. Who Dis?

#### Instructions
* **Create** a local script `0-its_me.sh` that prints the effective username.
* **Make** it executable and **test** it locally.
* **Transfer** it to the Target Machine using `scp`.
* **Execute** it remotely using `ssh`.
* **Copy** the flag printed in `0-flag.txt` on the remote machine.
* **Download** `0-flag.txt` back to your local machine using `scp`.

### 1. The Needle in the Haystack

#### Instructions
* **Write** a script `1-find_complex.sh` that finds and displays the full path of the file passed as argument (`$1`).
* **Ignore** "Permission denied" errors by redirecting `stderr`.
* **Constraint:** Use a single `find` command.

### 2. Content Mining

#### Instructions
* **Write** a script `2-grep_secrets.sh`. It must recursively search for the string `password =` inside the directory passed as argument (`$1`).
* **Ignore** "Permission denied" errors by redirecting `stderr`.
* **Output** only the filename (not the content line).

### 3. The Piping Logic

#### Instructions
* **Write** a script `3-stats.sh`.
* **List** all files in the directory passed as argument (`$1`).
* **Extract** the owner column, **sort** and **count** the occurrences.
* **Display** the top user.

### 4. The SUID Audit

#### Instructions
* **Write** a script `4-suid_hunter.sh`.
* **Find** all files in the directory passed as argument (`$1`) that have the **SUID** bit set.

### 5. The Immortal File

#### Instructions
* **Write** a script `5-unlock.sh` targeting the file passed as argument (`$1`).
* **Remove** the immutable attribute from the file.
* **Delete** the file.

### 6. The Collaboration Folder

#### Instructions
* **Write** a script `6-setup_shared.sh` to apply this configuration to the directory `$1`:
* **Group Ownership:** Owned by group `$2`.
* **Collaboration:** Members of the group can write.
* **Inheritance (SGID):** Any new file created inside must automatically belong to the group.
* **Protection (Sticky Bit):** Users can only delete their own files, not files created by colleagues.

### 7. The Audit Gateway

#### Instructions
* **Write** a script `7-audit_gateway.sh`.
* **Create** a root-owned wrapper command `/usr/local/bin/audit-read-secret` that prints only `/var/www/html/secret_config.php`.
* **Allow** user `$1` to run that wrapper via `sudo` without password.
* **Security:** Your configuration must not allow reading arbitrary files (no user-controlled path).

### 8. The Log Creation Policy

#### Instructions
* **Write** a script `8-log_policy.sh` for the directory `$1`.
* **Enforce** policy: group ownership is `$2`, uses **SGID**, and is not world-accessible.
* **Install** a `logrotate` policy at `/etc/logrotate.d/app` so rotated/new logs are created as `root:$2` with mode `0640`.
