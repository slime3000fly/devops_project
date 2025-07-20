# Get sshadmin password form infisical instace
# Path to the token file
$tokenPath = ".\infisical_token"

# Read the token
if (Test-Path $tokenPath) {
    $serviceToken = Get-Content $tokenPath -Raw
} else {
    Write-Error "❌ Token file not found: $tokenPath"
    exit 1
}

# Download user password
# Base URL with query parameters
$baseUrl = "https://eu.infisical.com/api/v3/secrets/raw"
$queryParams = @{
    secretPath = "/"
    viewSecretValue = "true"
    workspaceSlug = "homelab-z7ns"
    environment = "dev"
}


# Build full URL with query string
$uri = $baseUrl + "?" + (($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&")

# Secret key to look for
$secretName = "sshadmin"

try {
    # Send GET request
    $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

    # Find the secret with secretKey = $secretName
    $secret = $response.secrets | Where-Object { $_.secretKey -eq $secretName }

    if ($null -eq $secret) {
        Write-Error "⚠️ Secret '$secretName' was not found."
        exit 1
    } 
} catch {
    Write-Error "❌ API error: $_"
}

$Username = "sshadmin"
$Password = ConvertTo-SecureString $secret.secretValue -AsPlainText -Force
$existingUser = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

Write-Host "test: $($secret.secretValue)"

if ($null -eq $existingUser) {
    Write-Host "user $Username doesn't exist create user."
    New-LocalUser -Name $Username -Password $Password -FullName "SSH Admin" -Description "Account for SSH access"
    Start-Sleep -Seconds 2
} else {
    Write-Host "user $Username exist update password."
    $existingUser | Set-LocalUser -Password $Password
}

# Get group name for Administrators
$adminGroup = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
$adminGroupName = $adminGroup.Translate([System.Security.Principal.NTAccount]).Value -replace "^.*\\"
$computerName = $env:COMPUTERNAME

# Check if user is in the group
$inGroup = Get-LocalGroupMember -Group $adminGroupName -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq "$computerName\$Username" }

if (-not $inGroup) {
    Write-Host "adding user $Username to group $adminGroupName."
    try {
        Add-LocalGroupMember -Group $adminGroupName -Member $Username
        Write-Host "Successfully added $Username to $adminGroupName."
    } catch {
        Write-Error "Failed to add user to group: $_"
    }
} else {
    Write-Host "user $Username is already part of the group $adminGroupName."
}

# 1. Download and install Python 3.13
$pythonInstallerUrl = "https://www.python.org/ftp/python/3.13.5/python-3.13.5-amd64.exe"
$pythonInstallerPath = "$env:TEMP\python-3.13.0-amd64.exe"

Write-Host "Downloading Python 3.13 installer..."
Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $pythonInstallerPath

Write-Host "Installing Python 3.13..."
Start-Process -FilePath $pythonInstallerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0" -Wait

# 2. Install and configure OpenSSH Server
Write-Host "Installing OpenSSH Server..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Write-Host "Starting and enabling sshd service..."
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# 3. Allow incoming SSH traffic on port 22
Write-Host "Adding firewall rule for SSH..."
New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "OpenSSH Server (TCP-In)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

Write-Host "Python 3.13 has been installed and SSH is enabled!"
Write-Host "You can now connect to: $env:COMPUTERNAME (IP: $(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike '*Loopback*'} | Select-Object -First 1 -ExpandProperty IPAddress))"

