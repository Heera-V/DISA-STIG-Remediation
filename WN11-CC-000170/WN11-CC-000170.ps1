<#
.SYNOPSIS
    Remediates Windows 11 DISA STIG WN11-CC-000170.

.DESCRIPTION
    Enables the Allow Microsoft accounts to be optional policy
    for supported packaged Microsoft Store applications.

.NOTES
    Author          : Heera Verma
    GitHub          : https://github.com/Heera-V
    LinkedIn        : https://www.linkedin.com/in/heera-v
    Date Created    : 2026-11-27
    Last Modified   : 2026-11-27
    Version         : 1.0
    STIG-ID         : WN11-CC-000170
    Vulnerability ID: V-253384
    Severity        : CAT III (Low)
    Tenable Audit ID: 1.141
    Documentation   : https://www.cyber.mil/stigs/

.TESTED ON
    Date(s) Tested  : 2026-11-27
    Tested By       : Heera Verma
    Systems Tested  : Windows 11 VM
    PowerShell Ver. : 5.1

.USAGE
    Run Windows PowerShell as Administrator.
    PS C:\> .\WN11-CC-000170.ps1
#>

$ErrorActionPreference = "Stop"

# Required DISA STIG configuration
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "MSAOptional"
$requiredValue = 1

try {
    # Verify administrator privileges
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    if (-not $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )) {
        throw "Administrator privileges are required."
    }

    Write-Host "Remediating STIG WN11-CC-000170..." -ForegroundColor Cyan

    # Create registry path if missing
    if (-not (Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Enable Microsoft accounts to be optional
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
    Write-Host "Microsoft accounts are now optional for supported apps."
}
catch {
    Write-Host "`nRemediation FAILED: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
