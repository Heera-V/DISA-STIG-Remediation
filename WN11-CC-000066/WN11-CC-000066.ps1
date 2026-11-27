
<#
.SYNOPSIS
    Remediates Windows 11 DISA STIG WN11-CC-000066.

    Enables inclusion of command-line arguments in
    process creation audit events (Event ID 4688).

    STIG-ID: WN11-CC-000066
    Vulnerability ID: V-253367
    Severity: CAT II (Medium)

.NOTES
    Author          : Heera Verma
    LinkedIn        : https://www.linkedin.com/in/heera-v
    GitHub          : https://github.com/Heera-V
    Date Created    : 2026-11-27
    Last Modified   : 2026-11-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000066
    Documentation   : https://www.cyber.mil/stigs/

.TESTED ON
    Date(s) Tested  :
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.

    PS C:\> .\WN11-CC-000066.ps1
#>

# ================================================
# STIG Remediation: WN11-CC-000066
# ================================================

$ErrorActionPreference = "Stop"

# Define required configuration
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
$valueName = "ProcessCreationIncludeCmdLine_Enabled"
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

# Create registry path if missing
if (-not (Test-Path -Path $registryPath)) {
    Write-Host "Creating missing registry key..."
    New-Item -Path $registryPath -Force | Out-Null
}

# Enable command-line logging
Write-Host "Enabling command-line logging for process creation..."

New-ItemProperty `
    -Path $registryPath `
    -Name $valueName `
    -PropertyType DWord `
    -Value $requiredValue `
    -Force | Out-Null

# Verify configuration
Write-Host "`nVerifying registry configuration..." -ForegroundColor Cyan

$result = Get-ItemProperty `
    -Path $registryPath `
    -Name $valueName

if ($result.$valueName -ne $requiredValue) {
    throw "Remediation failed. Incorrect registry value."
}

Write-Host "Registry Path: $registryPath"
Write-Host "Value Name: $valueName"
Write-Host "Value Data: $($result.$valueName)"

Write-Host "`nRemediation completed successfully." -ForegroundColor Green
Write-Host "Command-line inclusion is enabled by policy."
Write-Host "Audit Process Creation must also be enabled to generate Event ID 4688."
