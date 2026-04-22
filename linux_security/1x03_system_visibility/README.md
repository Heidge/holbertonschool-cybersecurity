# System Visibility

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

### Constraints
- **Allowed tools:** `ps`, `grep`, `awk`, `ss`, `lsof`, `kill`, `journalctl`, `dmesg`
- **Forbidden:** `htop` (learn the raw commands first), `killall` (be surgical, not broad)

### Workflow Requirements
- Scripts must be developed **locally** on your machine.
- Scripts must be deployed to the target using `scp`.
- Scripts must be executed on the remote machine using `ssh <user>@<host>`.

---

## Tasks

### 0. The CPU Hog

#### Instructions
* **Write** a script `0-hog.sh` that outputs the **PID** and **Command Name** of the process consuming the highest percentage of CPU.
* **Output format:** `PID COMMAND` (space-separated, single line).

### 1. The /proc Truth

#### Instructions
* **Write** a script `1-proc_env.sh` that takes a **PID** as argument (`$1`).
* **Read** `/proc/<PID>/environ` and replace null bytes with newlines to make the output human-readable.

### 2. The Zombie Hunter

#### Instructions
* **Write** a script `2-zombies.sh` that outputs the **PIDs** of all zombie processes (state `Z`), one per line.

### 3. The Family Tree

#### Instructions
* **Write** a script `3-parent.sh` that takes a **PID** as argument (`$1`).
* **Output** the **PPID** (Parent Process ID) of that process. The output should contain only the number, no headers.

### 4. The Polite Request

#### Instructions
* **Write** a script `4-term.sh` that takes a **PID** as argument (`$1`) and sends **SIGTERM** to that process.

### 5. The Terminator

#### Instructions
* **Write** a script `5-kill.sh` that takes a **PID** as argument (`$1`) and sends **SIGKILL** to that process.
* **Warning:** SIGKILL cannot be caught or ignored; the process gets no chance to clean up.

### 6. The Pause

#### Instructions
* **Write** a script `6-freeze.sh` that takes a **PID** as argument (`$1`) and sends **SIGSTOP** to pause the process completely.

### 7. The Listener

#### Instructions
* **Write** a script `7-listening.sh` that lists all **listening TCP sockets** on **IPv4**.
* **Output format:** Port numbers only, one per line, sorted numerically.

### 8. Port to PID

#### Instructions
* **Write** a script `8-who_listens.sh` that takes a **port number** as argument (`$1`).
* **Output** the **name of the process** listening on that port.

### 9. User to Process

#### Instructions
* **Write** a script `9-process_user.sh` that takes a **PID** as argument (`$1`).
* **Output** the **username** of the process owner.

### 10. The Time Machine

#### Instructions
* **Write** a script `10-recent_logs.sh` that prints all `sshd` log lines from the **last 30 minutes** using `/var/log/auth.log` (`$1`).
* **Output** full matching lines only.

### 11. The Kernel Ring

#### Instructions
* **Write** a script `11-kernel.sh` that searches for any line containing `segfault` in:
    * `/var/log/kern.log` (if it exists)
    * `/var/log/messages` (if it exists)
* **Output** the full matching lines.
