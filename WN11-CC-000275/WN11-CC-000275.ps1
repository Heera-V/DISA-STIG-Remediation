
<#
.SYNOPSIS
    This PowerShell script remediates Windows 11
    DISA STIG WN11-CC-000275.

    It prevents local drive redirection during
    Remote Desktop sessions by configuring the
    fDisableCdm registry policy value to 1.

.NOTES
    Author          : Heera Verma
    LinkedIn        : https://www.linkedin.com/in/heera-v
    GitHub          : https://github.com/Heera-V
    Date Created    : 2026-11-27
    Last Modified   : 2026-11-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000275

.TESTED ON
    Date(s) Tested  :
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.

    Example:
    PS C:\> .\WN11-CC-000275.ps1
#>

# ================================================
# STIG Remediation: WN11-CC-000275
# ================================================

$ErrorActionPreference = "Stop"

# Define registry configuration
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$valueName = "fDisableCdm"
$requiredValue = 1

# Verify administrator privileges
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    throw "Run PowerShell as Administrator."
}

# Create registry key if missing
if (-not (Test-Path -Path $registryPath)) {
    Write-Host "Creating missing registry key..."
    New-Item -Path $registryPath -Force | Out-Null
}

# Configure required registry value
Write-Host "Disabling Remote Desktop drive redirection..."

New-ItemProperty `
    -Path $registryPath `
    -Name $valueName `
    -Value $requiredValue `
    -PropertyType DWord `
    -Force | Out-Null

# Verify the registry configuration
Write-Host "`nVerifying registry configuration..." -ForegroundColor Cyan

$result = Get-ItemPropertyValue `
    -Path $registryPath `
    -Name $valueName

if ($result -ne $requiredValue) {
    throw "Remediation failed. Incorrect registry value."
}

Write-Host "Registry Path: $registryPath"
Write-Host "Value Name: $valueName"
Write-Host "Value Data: $result"

Write-Host "`nRemediation completed successfully." -ForegroundColor Green
Write-Host "Drive redirection is disabled by policy."
