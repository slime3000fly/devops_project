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

# Import root CA certificate to Trusted Root Certification Authorities store
$rootCAPath = "..\ssl_certs\raspberrypi.crt"

if (Test-Path $rootCAPath) {
    try {
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
        $cert.Import($rootCAPath)

        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "LocalMachine")
        $store.Open("ReadWrite")
        $store.Add($cert)
        $store.Close()

        Write-Output "✅ Root CA certificate imported to Trusted Root Certification Authorities store."
    } catch {
        Write-Error "❌ Failed to import root CA certificate: $_"
    }
} else {
    Write-Error "❌ Root CA certificate file not found: $rootCAPath"
}

# Base URL with query parameters
$baseUrl = "https://eu.infisical.com/api/v3/secrets/raw"
$queryParams = @{
    secretPath = "/"
    viewSecretValue = "true"
    expandSecretReferences = "false"
    recursive = "false"
    include_imports = "false"
}

# Build full URL with query string
$uri = $baseUrl + "?" + (($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&")

# HTTP headers
$headers = @{
    "Authorization" = "Bearer $serviceToken"
}

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

# Create a new user and set a password
$Username = "sshadmin"  # Username for the new user
$Password = ConvertTo-SecureString $secret.secretValue -AsPlainText -Force  # Secure password for the user (stored securely)
 Sprawdź, czy użytkownik już istnieje
$existingUser = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

if ($null -eq $existingUser) {
    Write-Output "✅ user '$Username' doesn't exist – create user."
    New-LocalUser -Name $Username -Password $Password -FullName "SSH Admin" -Description "Account for SSH access"
} else {
    Write-Output "ℹ️ user '$Username' exist – update password."
    $existingUser | Set-LocalUser -Password $Password
}

# check if user is in adminstrator group
$adminGroup = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
$adminGroupName = $adminGroup.Translate([System.Security.Principal.NTAccount]).Value -replace "^.*\\"

if (-not (Get-LocalGroupMember -Group $adminGroupName -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $Username })) {
    Write-Output "🔒 Dodaję użytkownika '$Username' do grupy $adminGroupName."
    Add-LocalGroupMember -Group $adminGroupName -Member $Username
} else {
    Write-Output "✅ Użytkownik '$Username' już jest członkiem grupy $adminGroupName."
}

# Set WinRM service to start automatically with the system
Set-Service -Name winrm -StartupType Automatic  # Configure WinRM to start automatically with the system

# Check if WinRM is enabled and enable it if necessary
Enable-PSRemoting -Force  # Enables WinRM on the local computer, configures necessary firewall rules and services

# Configure firewall rules to allow WinRM connections
New-NetFirewallRule -DisplayName "WinRM Public" -Name "WinRM-HTTP-In-TCP-PUBLIC" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow

# Add WinRM to env path... Windows :)
$currentPath = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine)
if ($currentPath -notlike "*WindowsPowerShell\v1.0*") {
    [System.Environment]::SetEnvironmentVariable('PATH', "$currentPath;C:\Windows\System32\WindowsPowerShell\v1.0", [System.EnvironmentVariableTarget]::Machine)
}

# Check WinRM connection to a remote user
$hostname = "localhost"  # IP address or hostname of the remote system

# Turn on Basic authentiaction
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Create credentials for testing the connection
$credentials = New-Object System.Management.Automation.PSCredential ($Username, $Password)  # Create credentials object

# Test WinRM connection to the remote system
Test-WsMan -ComputerName $hostname -Credential $credentials -Authentication Default # Test the WinRM connection using provided credentials