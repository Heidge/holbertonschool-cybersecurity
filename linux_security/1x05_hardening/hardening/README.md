# 🛡️ Linux Hardening Framework

A modular and automated security hardening script designed for Debian-based systems. This framework enforces strict security policies across identity management, networking, SSH access, and system maintenance.

## ✨ Features

The framework is organized into four major security domains:

### 1. 🆔 Identity & Access Management
- **Password Policy**: Enforces a 12-character minimum length, 4-class complexity (uppercase, lowercase, digits, special), and a 90-day maximum age.
- **Account Lockout**: Configures `pam_faillock` to lock accounts for 30 minutes after 5 failed login attempts.
- **User Cleanup**: Automatically removes non-privileged users (UID > 1000) not belonging to administrative groups (`sudo` or `wheel`).
- **Root Security**: Locks the root password to disable direct login, forcing the use of `sudo`.

### 2. 🌐 Network Hardening
- **Firewall Rules**: Generates a custom rule set in `/etc/hardening/firewall.rules`.
- **Port Management**: Standardizes traffic for SSH (22), HTTP (80), and HTTPS (443).
- **Kernel Security**: Disables IP forwarding and ignores ICMP echo requests (Ping) via `sysctl` parameters.

### 3. 🔑 SSH Hardening
- Disables password-based authentication in favor of **Public Key Authentication**.
- Explicitly forbids `root` login via SSH.
- Implements automated syntax validation using `sshd -t` before applying changes.

### 4. ⚙️ System Maintenance
- **Package Management**: Automates repository updates and security patches.
- **Bloatware Removal**: Purges insecure legacy protocols (telnet, ftp, netcat).
- **Security Tooling**: Installs and initializes `auditd` and `fail2ban`.

## 📁 Project Structure

```
├── harden.sh              # 🚀 Main execution entry point
├── config/
│   └── harden.cfg         # ⚙️ Configuration variables and file paths
├── lib/
│   ├── identity.sh        # 👤 Identity, PAM, and User functions
│   ├── network.sh         # 🌐 Firewall and Kernel functions
│   ├── ssh.sh             # 🔑 SSH configuration functions
│   ├── system.sh          # 📦 Update and Package functions
│   └── utils.sh           # 🛠️ Logging and Audit Report functions
└── audit_report.txt       # 📜 Compliance report generated after run
```

## 🛠️ Usage

### Prerequisites
- **OS**: Debian or Ubuntu.
- **Privileges**: The script must be executed as **root**.

### Running the Script
1. Clone the repository to your server.
2. Grant execution permissions: `chmod +x harden.sh`
3. Execute the hardening process: `sudo ./harden.sh`

## 📊 Audit & Compliance

Upon completion, the framework generates a summary report named `audit_report.txt` in the current directory. This report includes:
- A detailed summary of applied changes.
- Specific counts (e.g., number of unauthorized users removed).
- Final compliance status (**PASS** or **FAIL**).

Detailed JSON logs are maintained in `/var/log/hardening.log` for SIEM integration.

## ⚠️ Critical Warnings
- **SSH Access**: Ensure you have a working SSH Public Key configured before running. Password authentication will be disabled, which could lead to lockout.
- **User Management**: The cleanup function deletes accounts not in administrative groups. Verify your group memberships with the `id` command before proceeding.
