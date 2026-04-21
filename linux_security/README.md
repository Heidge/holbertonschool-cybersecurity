# Linux Security

This directory contains all the Holberton Cybersecurity projects that provided my training in Linux security. Each sub-directory represents a specific project covering a fundamental Linux security concept.

The scripts were developed in a local **Kali Linux** environment and deployed via `scp` into a container simulating the server targeted by the security measures.

Each project was approached with an **Infrastructure as Code (IaC)** mindset.

## Project Structure

Each directory includes:
* **A README file:** Detailing the specific tasks to be completed.
* **Captured Flags:** Proof of success within the container generated after a script's execution.
* **Source Code:** All automation scripts and configuration files.

---

## Projects List

| Project Name | Description | Link |
| :--- | :--- | :--- |
| **Automation Security** | Monitoring services, ports, and file integrity. | [View Project](./1x04_security_automation) |
| **User Management** | Hardening user access and permissions. | [View Project](#) |
| **Network Hardening** | Firewall configuration and traffic control. | [View Project](#) |
| **System Auditing** | Logging, monitoring, and forensic basics. | [View Project](#) |

> [!TIP]
> All scripts are designed to be idempotent and follow security best practices for automated hardening.
