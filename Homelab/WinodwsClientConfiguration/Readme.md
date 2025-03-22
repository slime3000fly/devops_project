# README for WinRM Setup Script (EXE Version) - Administrator Privileges Required

This executable file is a compiled version of the original PowerShell (used: ) script designed to automate the configuration of WinRM (Windows Remote Management) on a Windows machine. The goal of this executable is to simplify the setup process so that a user only needs to run a single `.exe` file to configure everything needed for remote access through WinRM. Note that this executable must be run as an administrator.

## Prerequisites

   - **Administrator privileges:** The executable requires administrator rights to configure WinRM, create users, and modify firewall settings.
   - **Windows operating system:** This executable is designed for Windows environments.

## Features of the Executable

   - **Create a New User:** A new local user (by default `sshadmin`) will be created. The password for this user has been set to `SuperTajneHaslo`. This user will be used for remote access via WinRM.

   - **Add User to Administrator Group:** The new user is automatically added to the local Administrators group to ensure they have full system access.

   - **Configure WinRM:** The executable enables and configures Windows Remote Management (WinRM) for remote management of the machine.

   - **Set WinRM Service to Start Automatically:** The WinRM service is configured to start automatically with the system.

   - **Configure Firewall Rules for WinRM:** Firewall rules are set to allow inbound TCP connections on ports 5985 (HTTP) and 5986 (HTTPS) for WinRM, ensuring that the system can accept remote management connections.

   - **Test WinRM Connection:** The executable will attempt to test the WinRM connection using the provided credentials to ensure the configuration is correct.

   - **Ready for Ansible Automation:** Once configured, the machine will be ready to accept commands from Ansible via WinRM for seamless automation.

## How to Use

1. **Run the EXE as Administrator:**
   Right-click the `.exe` file and select **Run as administrator**. This is necessary to grant the executable the required system-level permissions.

2. **Wait for the Setup to Complete:** 
   The executable will configure WinRM, create the necessary user, modify firewall rules, and start the relevant services.

3. **Test the WinRM Connection:**
   Once the executable completes, you can test the connection to the machine using the WinRM credentials. This setup allows remote management via WinRM.

---

By following these steps, you can easily configure WinRM on your Windows machine and begin using it for automation with tools like Ansible. This setup ensures your system is ready for remote management and automation.
