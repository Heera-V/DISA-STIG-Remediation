<#
.SYNOPSIS
    Remediates Windows 11 DISA STIG WN11-CC-000040.

.DESCRIPTION
    Disables insecure SMB guest logons by configuring the
    Lanman Workstation security policy through the registry.

.NOTES
    Author          : Heera Verma
    GitHub          : https://github.com/Heera-V
    LinkedIn        : https://www.linkedin.com/in/heera-v
    Date Created    : 2026-11-27
    Last Modified   : 2026-11-27
    Version         : 1.0
    STIG-ID         : WN11-CC-000040
    Vulnerability ID: V-253360
    Severity        : CAT II (Medium)
    Tenable Audit ID: 1.116

.TESTED ON
    Date(s) Tested  : 2026-11-27
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.

    PS C:\> .\WN11-CC-000040.ps1
#>

$ErrorActionPreference = "Stop"

# DISA STIG required configuration
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
$valueName = "AllowInsecureGuestAuth"
$requiredValue = 0

try {
    # Verify administrator privileges
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    if (-not $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )) {
        throw "Administrator privileges are required."
    }

    Write-Host "Remediating STIG WN11-CC-000040..." -ForegroundColor Cyan

    # Create registry path if missing
    if (-not (Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Disable insecure SMB guest logons
    New-ItemProperty `
        -Path $registryPath `
        -Name $valueName `
        -PropertyType DWord `
        -Value $requiredValue `
        -Force | Out-Null

    # Verify registry value and type
    $actualValue = Get-ItemPropertyValue `
        -Path $registryPath `
        -Name $valueName

    $actualKind = (Get-Item -Path $registryPath).GetValueKind($valueName)

    Write-Host "`nVerification Results:" -ForegroundColor Cyan
    Write-Host "Registry Path : $registryPath"
    Write-Host "Value Name    : $valueName"
    Write-Host "Value Type    : $actualKind"
    Write-Host "Value Data    : $actualValue"

    if ($actualValue -ne $requiredValue -or
        $actualKind -ne [Microsoft.Win32.RegistryValueKind]::DWord) {
        throw "Remediation verification failed."
    }

    Write-Host "`nRemediation completed successfully." -ForegroundColor Green
    Write-Host "Insecure SMB guest logons are disabled by policy."
}
catch {
    Write-Host "`nRemediation FAILED: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
