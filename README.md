# Sysauditgen

**Sysauditgen** is a bash script that performs a series of system security checks and generates a detailed report. It scans the system for potential security risks such as file permissions, world-writable directories, sudo access, active processes, and more. The script can be used to identify vulnerabilities and help with system hardening.

## Features

- **File Permission Checks**: Finds files with special permissions (SUID/SGID).
- **Writable Directories Check**: Lists directories that are world-writable, which could pose a security risk.
- **Interesting Files**: Searches for sensitive files like `.bash_history`, SSH keys, and more.
- **Writable Files in Critical Locations**: Identifies writable files in sensitive directories like `/tmp`, `/var`, and `/dev/shm`.
- **Compressed Files**: Lists readable compressed files (e.g., `.zip`, `.tar`, `.gz`, `.rar`).
- **Sudo Privileges**: Lists available `sudo` commands for the current user.
- **Crontab**: Shows current user's crontab entries.
- **Active Connections**: Displays active network connections.
- **Running Processes**: Lists running processes on the system.

## Installation

1. Clone this repository or download the script:
    ```bash
    git clone https://your-repository-url.git
    ```

2. Make the script executable:
    ```bash
    chmod +x Sysauditgen.sh
    ```

## Usage

To run the script, simply execute it in your terminal. You can use the following options:

### Run the script with the default behavior (prints to console):
```bash
./Sysauditgen.sh
