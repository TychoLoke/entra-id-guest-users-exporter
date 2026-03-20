<#
.SYNOPSIS
    Export guest users from Microsoft Entra ID (Azure AD) with detailed information, such as last login and account creation dates.

.DESCRIPTION
    This script connects to Microsoft Graph API to retrieve all guest users (`userType eq 'Guest'`) in Azure AD.
    It extracts the following information:
    - DisplayName (properly escaped if it contains commas or special characters)
    - Email
    - Account creation date
    - Days since account creation (if never logged in)
    - Last login date
    - Days since last login
    The results are exported to a user-specified CSV file.

.PARAMETER OutputPath
    The full file path where the CSV report will be saved.

.NOTES
    Version:        1.0.0
    Author:         Tycho Löke
    GitHub Repo:    https://github.com/TychoLoke/entra-id-guest-users-exporter

.REQUIREMENTS
    - Microsoft Graph PowerShell module (`Microsoft.Graph.Users`).
    - Microsoft Graph delegated permissions for `User.Read.All` and `AuditLog.Read.All`.
    - Internet access.

#>

[CmdletBinding()]
param(
    [string]$OutputPath = (Join-Path -Path $PSScriptRoot -ChildPath "GuestUsers_LastSignIn.csv")
)

$ErrorActionPreference = "Stop"

function Initialize-PowerShellAdminHelpers {
    $moduleName = "PowerShellAdminHelpers"

    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        $installerPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Install-PowerShellAdminHelpers.ps1"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TychoLoke/powershell-admin-helpers/main/Install-PowerShellAdminHelpers.ps1" -OutFile $installerPath
        & $installerPath
    }

    Import-Module -Name $moduleName -Force -ErrorAction Stop
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message" -ForegroundColor Cyan
}

Write-Log "Starting Guest User Export Script..."
Initialize-PowerShellAdminHelpers
Ensure-OutputDirectory -Path (Split-Path -Path $OutputPath -Parent)
Write-Log "File will be saved as: $OutputPath"
Ensure-Module -ModuleName Microsoft.Graph.Users

Write-Log "Connecting to Microsoft Graph API..."
try {
    Connect-GraphWithScopes -Scopes @("User.Read.All", "AuditLog.Read.All")
    Write-Log "Connected successfully to Microsoft Graph."
} catch {
    Write-Host "ERROR: Failed to connect to Microsoft Graph. Ensure you have the correct permissions." -ForegroundColor Red
    exit
}

# Fetch all guest users with additional properties
Write-Log "Retrieving guest users from Microsoft Entra ID (Azure AD)..."
try {
    $guestUsers = Get-MgUser -Filter "userType eq 'Guest'" -Property Id, DisplayName, Mail, SignInActivity, CreatedDateTime -All
    Write-Log "Retrieved $($guestUsers.Count) guest users."
} catch {
    Write-Host "ERROR: Failed to retrieve guest users. Ensure you have the necessary permissions." -ForegroundColor Red
    exit
}

# Initialize an array to store the results
$results = @()

# Get the current date for calculation
$today = Get-Date

Write-Log "Processing users and cleaning data..."
foreach ($user in $guestUsers) {
    $displayName = if ($user.DisplayName) {
        $user.DisplayName.Trim() -replace "\s+", " "
    } else {
        "Unknown Name"
    }

    $email = if ($user.Mail) {
        $user.Mail.Trim()
    } else {
        "No Email Provided"
    }

    $createdDate = $user.CreatedDateTime
    $lastSignInDate = $user.SignInActivity.LastSignInDateTime

    # Calculate days since last login or creation
    $daysSinceLastLogin = if ($lastSignInDate) {
        ($today - $lastSignInDate).Days
    } else {
        "Never Logged In"
    }

    $daysSinceCreation = if (!$lastSignInDate -and $createdDate) {
        ($today - $createdDate).Days
    } else {
        ""
    }

    # Add a clean record to the results array
    $results += [PSCustomObject]@{
        DisplayName        = $displayName
        Email              = $email
        CreatedDate        = if ($createdDate) { $createdDate.ToString("dd-MM-yyyy HH:mm") } else { "Unknown" }
        DaysSinceCreation  = if ($daysSinceCreation -ne "") { $daysSinceCreation } else { "N/A" }
        LastSignIn         = if ($lastSignInDate) { $lastSignInDate.ToString("dd-MM-yyyy HH:mm") } else { "Never Logged In" }
        DaysSinceLastLogin = $daysSinceLastLogin
    }
}

# Export results to CSV
Write-Log "Exporting data to CSV file..."
try {
    $results | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    Write-Log "Export completed successfully! File saved as: $OutputPath"
} catch {
    Write-Host "ERROR: Failed to save the CSV file. Check file permissions." -ForegroundColor Red
}

# Disconnect from Microsoft Graph
Write-Log "Disconnecting from Microsoft Graph API..."
if (Get-MgContext) {
    Disconnect-MgGraph
}
Write-Log "Script completed!"
