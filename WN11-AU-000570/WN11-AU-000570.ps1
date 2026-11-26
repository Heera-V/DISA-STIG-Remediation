
<#
.SYNOPSIS
    This PowerShell script ensures that Windows 11
    audits failed Detailed File Share access attempts.

    The script enables Failure auditing for the
    "Detailed File Share" audit subcategory.

    STIG-ID: WN11-AU-000570
    Vulnerability ID: V-253347
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
    STIG-ID         : WN11-AU-000570
    Documentation   : https://www.cyber.mil/stigs/

.TESTED ON
    Date(s) Tested  :
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.

    Example syntax:
    PS C:\> .\WN11-AU-000570.ps1
#>

# ================================================
# STIG Remediation: WN11-AU-000570
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

# Enable Failure auditing for Detailed File Share
Write-Host "Enabling Detailed File Share Failure auditing..."

& auditpol.exe /set /subcategory:"Detailed File Share" /failure:enable

if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure Detailed File Share auditing."
}

# Display current audit policy
Write-Host "`nCurrent Detailed File Share Audit Policy:" `
    -ForegroundColor Cyan

& auditpol.exe /get /subcategory:"Detailed File Share"

if ($LASTEXITCODE -ne 0) {
    throw "Failed to retrieve Detailed File Share audit policy."
}

Write-Host "`nRemediation commands completed." `
    -ForegroundColor Green

Write-Host "Verify the audit setting includes Failure."
