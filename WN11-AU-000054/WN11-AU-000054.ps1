
<#
.SYNOPSIS
    This PowerShell script ensures that Windows 11
    audits failed account lockout events.

    The script enables Failure auditing for the
    "Account Lockout" audit subcategory while
    preserving existing Success auditing.

    STIG-ID: WN11-AU-000054
    Vulnerability ID: V-253313
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
    STIG-ID         : WN11-AU-000054
    Documentation   : https://www.cyber.mil/stigs/

.TESTED ON
    Date(s) Tested  : 2026-11-25
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.

    Example syntax:
    PS C:\> .\WN11-AU-000054.ps1
#>

# ================================================
# STIG Remediation: WN11-AU-000054
# ================================================

# Verify administrator privileges
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    throw "Run PowerShell as Administrator."
}

# Enable Failure auditing for Account Lockout
Write-Host "Enabling Account Lockout Failure auditing..."

& auditpol.exe /set /subcategory:"Account Lockout" /failure:enable

if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure Account Lockout auditing."
}

# Display current audit policy
Write-Host "`nCurrent Account Lockout Audit Policy:" -ForegroundColor Cyan

& auditpol.exe /get /subcategory:"Account Lockout"

if ($LASTEXITCODE -ne 0) {
    throw "Failed to retrieve Account Lockout audit policy."
}

Write-Host "`nRemediation commands completed." -ForegroundColor Green
Write-Host "Verify the audit setting includes Failure."
