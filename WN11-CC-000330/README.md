# WN11-CC-000330 — Disable WinRM Client Basic Authentication

## Overview

This Windows 11 DISA STIG lab demonstrates identifying a failed security configuration, applying a manual Group Policy fix, verifying compliance with Tenable, restoring the original setting, and completing an automated remediation with PowerShell 5.1.

| Field | Details |
|---|---|
| STIG ID | **WN11-CC-000330** |
| Vulnerability ID | V-253416 |
| Tenable Audit ID | **1.173** |
| Severity | CAT I (High) |
| Configuration | WinRM Client — Allow Basic authentication |
| Required state | **Disabled** |
| Test environment | Windows 11 VM, 10.0.0.6 |
| Verification date | November 27, 2026 |
| Final result | **PASSED** in Tenable |

## Security Risk

Windows Remote Management (WinRM) supports remote administration. Allowing Basic authentication for the WinRM *client* can expose reusable credentials if traffic is sent without appropriate encryption. Explicitly disabling the option strengthens remote management authentication policy and reduces the risk of credential compromise.

This policy applies to the **WinRM client**, not the separately configurable WinRM service.

## Initial Finding — FAILED

The initial Tenable compliance scan reported **FAILED** for audit **1.173 / WN11-CC-000330** on the Windows 11 VM.

In Local Group Policy Editor, the policy was **Not Configured**, whereas the STIG requires an explicit **Disabled** state.

**Navigation:**

`Computer Configuration > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Client > Allow Basic authentication`

## Manual Remediation — PASSED

1. Open `gpedit.msc` as an administrator.
2. Navigate to **WinRM Client → Allow Basic authentication**.
3. Change the policy from **Not Configured** to **Disabled**.
4. Select **Apply**, then **OK**.
5. Rerun Tenable scan `STIG-Scan-HV` and filter by `WN11-CC-000330`.

**Result:** Tenable **PASSED** at **3:49 PM**, November 27, 2026.

## Rollback Validation — FAILED

To prove the remediation was reversible and that the policy change affected compliance, the configuration was restored to **Not Configured**. A subsequent Tenable scan returned **FAILED** at **4:10 PM**, November 27, 2026.

## PowerShell Automated Remediation

**[View the complete PowerShell script](WN11-CC-000330.ps1)**

The script is intended for **Windows PowerShell 5.1**, running with administrative privileges. It:

1. Validates administrator rights.
2. Creates the required registry key if it does not exist.
3. Writes the WinRM client policy as a `REG_DWORD` with value `0`.
4. Reads back the value **and** registry type.
5. Reports success only after verification, otherwise exits with an error.

### Registry configuration

| Registry setting | Required value |
|---|---|
| Path | `HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client` |
| Name | `AllowBasic` |
| Type | `REG_DWORD` |
| Data | `0` (Disabled) |

Core operation:

```powershell
New-ItemProperty `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" `
    -Name "AllowBasic" `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null
```

The administrator-run script reported `AllowBasic`, `DWord`, and `0`, followed by **Remediation completed successfully**.

## Final Compliance Verification — PASSED

Following PowerShell remediation, the Tenable audit reported **PASSED** on **November 27, 2026, 4:56 PM**.

| Stage | Configuration | Tenable outcome |
|---|---|---|
| Initial assessment | Not Configured | **FAILED** |
| Manual Group Policy remediation | Disabled | **PASSED** |
| Rollback | Not Configured | **FAILED** |
| Automated PowerShell remediation | `AllowBasic = 0` (`REG_DWORD`) | **PASSED** |

## Evidence Screenshots

Seven screenshots were captured for this exercise. The image files are **pending upload** to this directory's `Screenshots/` folder; once available, the following links will become active:

| Evidence | File |
|---|---|
| Initial finding | `Screenshots/Tenable-Failed.png` |
| Original Group Policy | `Screenshots/GroupPolicy-Before.png` |
| Manual policy remediation | `Screenshots/GroupPolicy-Manual-Remediation.png` |
| Tenable pass after manual remediation | `Screenshots/Tenable-Passed-Manual-Remediation.png` |
| Tenable failure after rollback | `Screenshots/Tenable-Rollback-Failed.png` |
| PowerShell script execution | `Screenshots/PowerShell-Remediation.png` |
| Final Tenable pass | `Screenshots/Tenable-Passed-Powershell.png` |

## Skills Demonstrated

- DISA STIG security hardening and compliance analysis
- WinRM authentication configuration
- Windows Local Group Policy administration
- Windows Registry policy management
- PowerShell scripting, error handling, and validation
- Manual remediation and rollback testing
- Tenable Vulnerability Management scanning
- Evidence collection and technical documentation

## Author

**Heera Verma** — [GitHub](https://github.com/Heera-V) · [LinkedIn](https://www.linkedin.com/in/heera-v)
