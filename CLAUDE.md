# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build

```bash
# Full single-file publish (Release x64, self-contained)
dotnet publish HNSOFTEDUAuth/HNSOFTEDUAuth.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:PublishReadyToRun=true -p:IncludeNativeLibrariesForSelfExtract=true -p:DebugType=None -p:DebugSymbols=false -o "dist"

# Or use the build scripts:
powershell -NoProfile -ExecutionPolicy Bypass -File "Build.ps1"
# or: Build.bat / Build_Project.bat
```

There are no tests or linters in this project.

## Architecture

This is a .NET 10.0 WPF desktop app that bypasses HNSOFTEDU campus network authentication by silently injecting a static IP, DNS redirection, and high-priority routes on the active WiFi adapter — all while the Windows settings UI still shows "automatic" (DHCP).

### Core logic

- **`NetworkManager.ActivateInvisibleAuth()`** — the main flow:
  1. Calls `AddIPAddress` (iphlpapi.dll) to add a random `10.160.153.x` IP without triggering the settings UI
  2. Uses `Add-DnsClientNrptRule` to silently redirect DNS to `10.199.199.199` (auth server) and `114.114.114.114` (backup)
  3. Injects static routes: gateway `10.160.153.254` metric 1, plus a host route for the DNS server
  4. `Cleanup()` reverses all of the above; `DeepRepair()` additionally resets the adapter to DHCP via netsh

### Dead / unused code

- **`VpnEngine.cs`** — Wintun-based VPN tunnel. Referenced by the project but never instantiated. `WriteToTun()` has an empty body; `ReadFromTun()` uses raw sockets but the Wintun driver integration is incomplete. Do not invest time here unless there is a clear requirement.
- **`WintunNative.cs`** — P/Invoke declarations for `wintun.dll`. Only consumed by `VpnEngine`.

### Solution structure quirk

`HnEduAuth.slnx` references `src/HnEduAuth.Service/HnEduAuth.Service.csproj` and `src/HnEduAuth.UI/HnEduAuth.UI.csproj`, neither of which exist. The `src/HnEduAuth.Driver/` directory has only VS workspace metadata, no source files. The actual code lives entirely in `HNSOFTEDUAuth/HNSOFTEDUAuth.csproj`.

### Remote version enforcement

On activation, the app polls 3 CDN mirrors of a GitHub-hosted `config.json` (one per minute, sequential). If any mirror reports `status=active` with a `version` higher than the hardcoded `CurrentAppVersion`, the app terminates with a "please update" dialog. If all 3 mirrors fail or report inactive status, the app also terminates. This means the remote config has kill-switch authority over all running instances.

### Dependencies

- .NET 10.0 SDK (for development)
- Windows x64
- Admin privileges (required at runtime — commands are executed with `Verb = "runas"`)
- No NuGet packages beyond the WPF/WindowsDesktop SDK
