
# WN11-CC-000275 — Do Not Allow Drive Redirection

## Overview

Windows 11 DISA STIG remediation using PowerShell automation
and Tenable Vulnerability Management.

**STIG ID:** WN11-CC-000275  
**Tenable Audit ID:** 1.160  
**Severity:** CAT II (Medium)

## Remediation Status

- Initial Tenable scan: FAILED
- Manual registry remediation: PASSED
- Registry rollback: FAILED
- Automated PowerShell remediation: PASSED

## Configuration

Registry Path:
`HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services`

Required DWORD:
`fDisableCdm = 1`

Full documentation and screenshots will be added.
