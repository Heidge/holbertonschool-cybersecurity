# Linux Capstone: Hardening Automation

## Requirements

### General
- All scripts will be tested on Kali Linux, ParrotOS, or Ubuntu 22.04+
- Allowed editors: `vi`, `vim`, `emacs`, `nano`
- A `README.md` file at the root of the project directory is **mandatory**
- All your files should end with a new line

### Bash Scripting
- All scripts must be executable (`chmod +x`)
- The first line of all your files should be exactly `#!/bin/bash`
- Scripts must enforce running as root and exit immediately if not
- All your files should end with a new line
- Pipes and logical operators are encouraged
- Scripts must produce **clean output** (no debug messages unless specified)

### Architecture Requirements
- **Modular design**: Monolithic scripts are forbidden.
- **Configuration separation**: No hardcoded values in logic files.
- **Logging**: All actions must be logged with timestamps.
- **Idempotence**: Scripts must be safe to run repeatedly

---

## Tasks

### 0. Engineering Standards & Architecture

#### Goal
Establish the architecture of a production-grade automation engine.

#### Context
A security tool must be maintainable and safe. Before writing any security logic you must establish the architecture of your automation engine.

In professional engineering "monolithic" scripts are considered technical debt. They are hard to read, hard to debug and dangerous to update. By splitting your code into Libraries (logic) and Configuration (data) you create a tool that can be safely maintained by a team.

#### Requirement
Your project must use a modular architecture. Monolithic scripts are strictly forbidden.

#### Specifications
1. Entry Point
	- The main script must be named harden.sh

2. Configuration

	- Critical variables (SSH_PORT,ALLOWED_SSH_USERS, etc.) must be isolated in config/harden.cfg
	- No hardcoded values in logic files

3. Libraries

	- Business logic must be split into separate files in a lib/ directory
	- Example: lib/network.sh, lib/ssh.sh, lib/identity.sh, lib/system.sh

4. Logging

	- Every action (modification, success, error) must be logged with log() to /var/log/hardening.log
	- All log entries must include timestamps
	- Your first log must be "Hardening framework initialized"

5. Fail-Safe

	- The script must check if it is running as root
	- Exit immediately with an error if not root

### 1. The Hardening Policy

#### Goal
Implement the STIG-2024 (Security Technical Implementation Guide) through automated configuration.

#### Context
A "Policy" is a document written in plain English by the Security Team that defines the rules a server must follow to be considered secure. 
For instance, while the Policy says: *"Passwords must be strong"*, your job as a DevOps Engineer is to translate that into technical commands (e.g., editing `/etc/pam.d/common-password`).

#### Requirement
Your implementation must be **idempotent**. Running the script multiple times must result in the same state without breaking the system or duplicating configuration lines.

#### Specifications

**1. Network Domain**
| Rule ID | Description |
| :--- | :--- |
| **N-01** | **Firewall Policy**: Define a file with default policy: Deny Incoming / Allow Outgoing. |
| **N-02** | **Ports**: Only SSH (custom port from config) and HTTP/HTTPS allowed (based on `ALLOW_HTTP`, `ALLOW_HTTPS`). |
| **N-03** | **Kernel**: Disable IP forwarding and ignore ICMP echo requests (ping). |

* **Firewall Storage**: Rules must be stored in `/etc/hardening/firewall.rules`.
* **Kernel Hardening**: Parameters must be defined persistently in `/etc/sysctl.conf` (runtime-only configuration via `sysctl -w` is forbidden).



**2. SSH Domain**
| Rule ID | Description |
| :--- | :--- |
| **S-01** | **Authentication**: Disable password-based auth. Enable public key authentication. |
| **S-02** | **Root Access**: Set `PermitRootLogin no` to prevent direct root access. |

* **Note**: Ensure the `sshd_config` is correctly parsed. In this lab, focus on file integrity; daemon restart is not mandatory.

**3. Identity Domain**
| Rule ID | Description |
| :--- | :--- |
| **I-01** | **Password Policy**: Min length 12 (`PASS_MIN_LEN`), enforce complexity (upper, lower, digit, special), max age 90 days (`PASS_MAX_DAYS`). |
| **I-02** | **Lockout**: Lock account after 5 failed login attempts (`FAIL_LOCK_ATTEMPTS`). |
| **I-03** | **Cleanup**: Delete users with UID > 1000 who are NOT in `sudo` or `wheel` groups. |
| **I-04** | **Root Account**: Lock root password (disable password-based root login). |



**4. System Domain**
| Rule ID | Description |
| :--- | :--- |
| **H-01** | **Updates**: Update repositories and upgrade packages non-interactively. |
| **H-02** | **Bloatware**: Uninstall insecure legacy tools: `telnet`, `ftp`, `netcat-traditional`. |
| **H-03** | **Tools**: Install security auditing and protection tools: `auditd` and `fail2ban`. |

### 2. Audit & Verification

#### Goal
Generate definitive proof of compliance and system state.

#### Context
A security tool that works silently is dangerous. Auditors require evidence, and Operations teams need visibility. You must provide a clear "paper trail" showing that the hardening policy was applied correctly and which specific modifications were made.

#### Requirement
At the conclusion of the execution, `harden.sh` must generate a comprehensive summary report reflecting the final state of the system.

#### Specifications

**1. Report Location**
- The summary must be saved as `audit_report.txt` in the script's working directory.

**2. Content & Metrics**
- **Action Log**: List all critical changes (SSH port migration, firewall policy generation, package management).
- **Quantifiable Data**: Include precise counts for automated cleanups (e.g., *"3 unauthorized users removed"*).
- **Environment Context**: The report must start with a high-visibility header including the current system timestamp.

**3. Error Handling & Logging Levels**
Your reporting logic must distinguish between different types of events using standard log levels:
- `[INFO]`: Successful changes or state verifications.
- `[WARN]`: Non-critical issues or skipped steps (e.g., package already up to date).
- `[ERROR]`: Critical failures in applying a specific rule.

#### Example Output Structure
```text
===============================================
 HARDENING AUDIT REPORT - 2026-04-30 14:32:01
===============================================

[INFO] Hardening procedure completed successfully.
[INFO] SSH configured on port 2222.
[INFO] Firewall policy created: ports 2222, 80, 443 ALLOWED.
[INFO] 3 unauthorized users removed: guest, temp, test.
[INFO] Installed: auditd, fail2ban.
[INFO] Removed: telnet, ftp, netcat-traditional.
[WARN] Package updates skipped (already up to date).

===============================================
 COMPLIANCE STATUS: PASS
===============================================
