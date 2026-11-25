
<#
.SYNOPSIS
    This PowerShell script ensures that the Windows 11
    "Reset account lockout counter after" security policy
    is configured to 15 minutes.

    The script also configures the account lockout duration
    to 15 minutes to satisfy Windows policy dependencies.

    STIG-ID: WN11-AC-000015
    Vulnerability ID: V-253299
    Severity: CAT II (Medium)

.NOTES
    Author          : Heera Verma
    LinkedIn        : https://www.linkedin.com/in/heera-v
    GitHub          : https://github.com/Heera-V
    Date Created    : 2026-11-25
    Last Modified   : 2026-11-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000015
    Documentation   : https://www.stigviewer.com/stig/microsoft_windows_11/

.TESTED ON
    Date(s) Tested  : 2026-11-25
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.

    This script configures:
    - Account lockout duration: 15 minutes
    - Reset account lockout counter: 15 minutes

    Example syntax:
    PS C:\> .\WN11-AC-000015.ps1
#>

# =====================================================
# STIG Remediation: WN11-AC-000015
# =====================================================

# Define required configuration
$lockoutDuration = 15
$lockoutWindow = 15

# Verify administrator privileges
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    throw "Run PowerShell as Administrator."
}

# Configure account lockout duration
Write-Host "Setting account lockout duration to 15 minutes..."

& net.exe accounts "/lockoutduration:$lockoutDuration"

if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure account lockout duration."
}

# Configure account lockout counter reset period
Write-Host "Setting lockout observation window to 15 minutes..."

& net.exe accounts "/lockoutwindow:$lockoutWindow"

if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure lockout observation window."
}

# Display current security policy
Write-Host "`nCurrent Account Lockout Policy:" -ForegroundColor Cyan

& net.exe accounts

if ($LASTEXITCODE -ne 0) {
    throw "Failed to retrieve account lockout policy."
}

Write-Host "`nRemediation commands completed." -ForegroundColor Green
Write-Host "Verify both lockout values are set to 15 minutes."
