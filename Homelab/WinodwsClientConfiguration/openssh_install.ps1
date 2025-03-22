# Create a new user and set a password
$Username = "sshadmin"  # Username for the new user
$Password = ConvertTo-SecureString "SuperTajneHaslo" -AsPlainText -Force  # Secure password for the user (stored securely)
New-LocalUser -Name $Username -Password $Password -FullName "SSH Admin" -Description "Account for SSH access"  # Create a new local user

# Retrieve the administrator group name dynamically
$adminGroup = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")  # SID of the administrators group
$adminGroupName = $adminGroup.Translate([System.Security.Principal.NTAccount]).Value -replace "^.*\\"  # Convert SID to the group name
Write-Output "Adding user to the administrator group: $adminGroupName"  # Output the group name the user will be added to

# Add the user to the administrator group
Add-LocalGroupMember -Group $adminGroupName -Member $Username  # Add the new user to the administrators group

# Set WinRM service to start automatically with the system
Set-Service -Name winrm -StartupType Automatic  # Configure WinRM to start automatically with the system

# Check if WinRM is enabled and enable it if necessary
Enable-PSRemoting -Force  # Enables WinRM on the local computer, configures necessary firewall rules and services

# Configure firewall rules to allow WinRM connections
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any  # Firewall rule for WinRM connections over public networks
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-Domain -RemoteAddress Any  # Firewall rule for WinRM connections within the domain

# Check if WinRM service is running. If not, start it.
if ((Get-Service winrm).Status -ne 'Running') {
    Start-Service winrm  # Start WinRM service if it's not running
}

# Check the WinRM configuration
winrm quickconfig  # Check if WinRM is correctly configured on the system

# Check WinRM connection to a remote user
$hostname = "192.168.56.1"  # IP address or hostname of the remote system
$username = "nazwa_uzytkownika"  # Replace with the username to test connection
$password = "haslo"  # Replace with the password to test connection

# Create credentials for testing the connection
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force  # Create a secure password object
$credentials = New-Object System.Management.Automation.PSCredential ($username, $securePassword)  # Create credentials object

# Test WinRM connection to the remote system
Test-WsMan -ComputerName $hostname -Credential $credentials  # Test the WinRM connection using provided credentials
