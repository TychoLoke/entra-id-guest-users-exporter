# Entra ID Guest Users Exporter

[![Release](https://img.shields.io/github/v/release/TychoLoke/entra-id-guest-users-exporter)](https://github.com/TychoLoke/entra-id-guest-users-exporter/releases)
[![CI](https://img.shields.io/github/actions/workflow/status/TychoLoke/entra-id-guest-users-exporter/powershell-ci.yml?branch=main)](https://github.com/TychoLoke/entra-id-guest-users-exporter/actions/workflows/powershell-ci.yml)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This PowerShell script exports guest-user account and sign-in data from Microsoft Entra ID to CSV.

## What It Does

- Retrieves users where `userType eq 'Guest'`
- Exports display name, email, created date, last sign-in date, and age metrics
- Uses delegated Microsoft Graph access for user and audit data
- Bootstraps `PowerShellAdminHelpers` from `TychoLoke/powershell-admin-helpers` if needed

## Requirements

- PowerShell 7 recommended
- Permission to install PowerShell modules for the current user
- Delegated Microsoft Graph access to `User.Read.All` and `AuditLog.Read.All`
- Internet access the first time you run the script so it can bootstrap the shared helper module

## Usage

```powershell
.\Export-EntraID-GuestUsers.ps1 -OutputPath "C:\Temp\GuestUsers_LastSignIn.csv"
```

If you omit `-OutputPath`, the script writes to `GuestUsers_LastSignIn.csv` in the repo directory.

## Notes

- The script installs `Microsoft.Graph.Users` automatically if it is missing.
- This export is useful for guest access reviews, inactivity cleanup, and governance reporting.
- `Export-Csv` handles quoting automatically, so the script no longer relies on manual CSV escaping.

## License

This project is licensed under the MIT License.
