# Windows 11 DISA STIG Remediation

Hands-on Windows 11 security hardening portfolio demonstrating DISA STIG compliance assessment, manual Group Policy / Registry remediation, rollback verification, PowerShell automation, and independent Tenable Vulnerability Management rescanning.

## Completed Remediations

| # | STIG | Focus |
|---|---|---|
| 1 | [WN11-AC-000015](WN11-AC-000015/) | Account lockout counter reset |
| 2 | [WN11-AU-000570](WN11-AU-000570/) | Audit Detailed File Share failures |
| 3 | [WN11-AU-000054](WN11-AU-000054/) | Audit Account Lockout failures |
| 4 | [WN11-CC-000275](WN11-CC-000275/) | Disable Remote Desktop drive redirection |
| 5 | [WN11-CC-000066](WN11-CC-000066/) | Include command line in process creation events |
| 6 | [WN11-CC-000330](WN11-CC-000330/) | Disable WinRM Client Basic authentication |

**Progress:** 6 of 10 technical remediations completed. For STIG #6, evidence screenshot uploads are still pending.

## Methodology

1. Scan Windows 11 VM and capture initial Tenable FAILED finding.
2. Inspect policy or registry state and manually remediate.
3. Rescan and verify Tenable PASSED.
4. Restore baseline configuration and confirm Tenable FAILED.
5. Execute a repeatable PowerShell 5.1 remediation script as Administrator.
6. Verify final Tenable PASSED and document the evidence.

## Tools

Windows 11 · Local Group Policy Editor · PowerShell 5.1 · Windows Registry · Tenable Vulnerability Management

## Author

**Heera Verma** · [GitHub Profile](https://github.com/Heera-V) · [LinkedIn](https://www.linkedin.com/in/heera-v)
