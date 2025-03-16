# 1. Install OpenSSH Client and Server
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
$sshState = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

if ($sshState.State -eq "Installed") {
    Write-Output "OpenSSH Client is installed."
} else {
    Write-Output "Error occurred during installation."
}

# 2. Create a new user and set a password
$Username = "sshadmin"
$Password = ConvertTo-SecureString "SuperTajneHaslo" -AsPlainText -Force
New-LocalUser -Name $Username -Password $Password -FullName "SSH Admin" -Description "Account for SSH access"

# 3. Retrieve the administrator group name dynamically
$adminGroup = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
$adminGroupName = $adminGroup.Translate([System.Security.Principal.NTAccount]).Value -replace "^.*\\"
Write-Output "Adding user to the administrator group: $adminGroupName"

# 4. Add the user to the administrator group
Add-LocalGroupMember -Group $adminGroupName -Member $Username

# 5. Start and configure the SSH service
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# 6. Configure the firewall rule for SSH
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' already exists."
}

# 7. Ensure port 22 is open in the firewall
New-NetFirewallRule -Name "OpenSSH" -DisplayName "OpenSSH Server" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# 8. Retrieve the local IP address
$localIP = (Get-NetIPAddress | Where-Object AddressFamily -eq 'IPv4' | Where-Object InterfaceAlias -NotLike '*Loopback*' | Select-Object -ExpandProperty IPAddress)[0]

# 9. Display connection information
Write-Output "User $Username has been created and added to the $adminGroupName group."
Write-Output "SSH is enabled. You can connect using: ssh $Username@$localIP"

# 10. Wait for user input before exiting
Read-Host -Prompt "Press Enter to exit"
