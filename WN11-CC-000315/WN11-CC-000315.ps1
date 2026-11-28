<#
.SYNOPSIS
    Remediates Windows 11 DISA STIG WN11-CC-000315.

.DESCRIPTION
    Disables the Windows Installer policy "Always install
    with elevated privileges" to reduce privilege
    escalation risk.

.NOTES
    Author          : Heera Verma
    GitHub          : https://github.com/Heera-V
    LinkedIn        : https://www.linkedin.com/in/heera-v
    Date Created    : 2026-11-27
    Last Modified   : 2026-11-27
    Version         : 1.0
    STIG-ID         : WN11-CC-000315
    Vulnerability ID: V-253411
    Severity        : CAT I (High)
    Tenable Audit ID: 1.168

.TESTED ON
    Date(s) Tested  : 2026-11-27
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.

    PS C:\> .\WN11-CC-000315.ps1
#>

$ErrorActionPreference = "Stop"

# DISA STIG required configuration
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$valueName = "AlwaysInstallElevated"
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

    Write-Host "Remediating STIG WN11-CC-000315..." -ForegroundColor Cyan

    # Create the registry path if it does not exist
    if (-not (Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Disable elevated Windows Installer privileges
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
    Write-Host "Windows Installer elevated privileges are disabled by policy."
}
catch {
    Write-Host "`nRemediation FAILED: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
