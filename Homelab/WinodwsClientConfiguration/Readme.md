# README for OpenSSH Setup Script (EXE Version) - Administrator Privileges Required

This executable file is a compiled version of the original PowerShell script designed to automate the installation and configuration of OpenSSH on a Windows machine. The goal of this executable is to simplify the setup process so that a user only needs to run a single .exe file to configure everything needed for SSH access, ready to receive commands from Ansible. Note that this executable must be run as an administrator.
## Prerequisites

   -  Administrator privileges: The executable requires administrator rights to install and configure OpenSSH, create users, and modify firewall settings.
   - Windows operating system: This executable is designed for Windows environments.

## Features of the Executable

   - Install OpenSSH Client and Server: The executable installs both OpenSSH Client and Server if they are not already installed on the system.

   - Create a New User: A new local user (by default sshadmin) will be created. The password for this user has been changed from the previous SuperTajneHaslo to a more secure value. This user will be used for SSH access.

   - Add User to Administrator Group: The new user is automatically added to the local Administrators group to ensure they have full system access.

   - Start SSH Service: The SSH service (sshd) is started and set to start automatically with the system.

   - Configure Firewall Rules: Firewall rules are configured to allow inbound TCP connections on port 22 (default SSH port), ensuring that the system can accept SSH connections.

   - Retrieve Local IP Address: The executable will retrieve the local IP address of the machine for use in connection information.

   - Display Connection Information: After the setup is complete, the executable will display the user information, the local IP address, and the SSH connection string for remote access.

   - Ready for Ansible Commands: The machine will be fully configured to accept SSH commands from Ansible, enabling seamless automation.

## How to Use

   1. Run the EXE as Administrator:
        Right-click the .exe file and select Run as administrator. This is necessary to grant the executable the required system-level permissions.

   2. Ansible Integration: Once the executable completes, the machine will be ready to accept SSH connections. You can now use Ansible to manage the machine by connecting via SSH using the newly created user credentials.