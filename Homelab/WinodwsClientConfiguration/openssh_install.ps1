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
New-NetFirewallRule -DisplayName "WinRM Public" -Name "WinRM-HTTP-In-TCP-PUBLIC" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow
New-NetFirewallRule -DisplayName "WinRM Domain" -Name "WinRM-HTTP-In-TCP-Domain" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

# Add WinRM to env path... Windows :)
$env:PATH += ";C:\Windows\System32" 
# Check if WinRM service is running. If not, start it.
if ((Get-Service winrm).Status -ne 'Running') {
    Start-Service winrm  # Start WinRM service if it's not running
}

# Check the WinRM configuration
winrm quickconfig  # Check if WinRM is correctly configured on the system

# Check WinRM connection to a remote user
$hostname = "localhost"  # IP address or hostname of the remote system

# Turn on Basic authentiaction
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Create credentials for testing the connection
$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force  # Create a secure password object
$credentials = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)  # Create credentials object

# Add trusted host
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "192.168.101.20" -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "localhost" -Force

# Test WinRM connection to the remote system
Test-WsMan -ComputerName $hostname -Credential $credentials -Authentication Default # Test the WinRM connection using provided credentials
