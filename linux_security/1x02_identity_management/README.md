# Identity & Access Management

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

### Privilege Requirements
- Most scripts require `sudo` to read `/etc/shadow` or modify system configurations.
- Test scripts on non-production systems first.

### Safety Warning
- When modifying SSH configuration, **ALWAYS** keep a second terminal open. If you lock yourself out, you'll need that session to fix the config.

### Workflow Requirements
- Scripts must be developed **locally** on your machine.
- Scripts must be deployed to the target using `scp`.
- Scripts must be executed on the remote machine using `ssh <user>@<host>`.

---

## Tasks

### 0. The Ghost User Hunter

#### Instructions
* **Write** a script `0-audit_uid.sh` that parses `/etc/passwd` (`$1`).
* **Identify** any account with UID `0` other than `root`.
* **Output** only the username(s) of those accounts.
* **Output** nothing if no unauthorized UID 0 accounts exist.

### 1. The Service Shells

#### Instructions
* **Write** a script `1-audit_shells.sh` that identifies all accounts with UID < 1000.
* **Filter** for those with a valid interactive shell (ending in `sh` or `bash`) in `/etc/passwd` (`$1`).
* **Exclude** `root` from the results and output only the usernames.

### 2. The Dangerous Groups

#### Instructions
* **Write** a script `2-audit_groups.sh` that identifies all standard users (UID ≥ 1000) in `/etc/passwd` (`$1`).
* **Check** if they belong to `disk`, `docker`, or `shadow`.
* **Output** results in format: `Username:GroupName`.

### 3. SSH Configuration

#### Instructions
* **Write** a script `3-harden_ssh.sh` that modifies `/etc/ssh/sshd_config` (`$1`) to enforce:
    * `PermitRootLogin no`
    * `PasswordAuthentication no`
    * `PubkeyAuthentication yes`
* **Safety requirement:** The script must validate the configuration with `sshd -t` before reloading. Only reload the SSH service if validation passes.
* *Note: This script can span multiple lines.*

### 4. Password Policy

#### Instructions
* **Write** a script `4-pw_policy.sh` that installs `libpam-pwquality` (`$1`) if not already present.
* **Configure** `/etc/pam.d/common-password` (`$2`) to require:
    * Minimum length: 12 characters.
    * Minimum character classes: 3 (uppercase, lowercase, digit, or special).
* *Note: This script can span multiple lines.*

### 5. Shadow Crypto Audit

#### Instructions
* **Write** a script `5-audit_crypto.sh` that reads `/etc/shadow` (`$1`).
* **Identify** accounts using MD5 hashing (`$1$`).
* **Output** only the usernames of affected accounts.

### 6. The Secure Onboarding

#### Instructions
* **Write** a script `6-onboard.sh` that accepts two arguments: `$1` (Username) and `$2` (SSH public key string).
* **Create** the user account and lock the password immediately.
* **Create** `~/.ssh/` with permissions `700` and `authorized_keys` with `600`.
* **Set** correct ownership on all created files and directories.

### 7. Least Privilege Sudo

#### Instructions
* **Write** a script `7-sudo_config.sh` that creates `/etc/sudoers.d/junior` allowing the `junior` (`$1`) user to run **only**:
    * `/usr/bin/systemctl restart apache2`
    * `/usr/bin/journalctl`
* **Requirements:** The user must enter their password (no `NOPASSWD`). Use `visudo -c` to validate the syntax.
* *Note: This script can span multiple lines.*
