Slackware-Commander — A Qt6 and kdialog-based menu for Slackware system administration.

Usage: `slackware-commander`

Slackware-Commander provides a simple Qt6-based GUI for managing Slackware system updates, packages, and configuration files. It acts as a graphical frontend for `slackpkg(+)` and includes additional system tools.

Features:
- Managing Slackware system updates and packages.
- Editing `slackpkg(+)` configuration files.
- Viewing change logs.
- Accessing additional system tools.

The `slackpkg_build` script allows you to download, edit, and rebuild an official Slackware package using official SlackBuilds; on Slackware stable, it optionally uses SalixOS’s unofficial dependency list.

The “More Tools” submenu (via kdialog) shows:
- CPU, GPU, monitors
- Sound cards & microphones
- RAM & ZRAM usage
- Wi-Fi & Ethernet connections

 
Additional tools included:

**Captain-Slack** (`cptn`)
A collection of Python/Bash scripts for system info, package management, service status, and weather.
Config: `/etc/captain-slack/`
Logs: `/var/log/captain-slack/`
DB: `/var/lib/captain-slack/`

Commands:
- `make-db [-a|-p|-l|-v]`: build database (recommended: `-v` for stable, `-a` for current)
- `info <pkg>`: show package/library details
- `open-libs` / `open-pkgs`: open YAML files
- `open-logs` / `clear-logs`
- `serv-status <svc>`, `restart-serv`, `show-servs`
- `mirrors [-1|-N]`: find fastest mirrors (default top 5)
- `weather`: local forecast

Example:
`cptn make-db -a && cptn info vim && cptn mirrors -1`

**soviewer**
Python3 GUI to view `.so` files from Slackware64-current’s ChangeLog. Run via `python3 soviewer`.

**slakfinder**
Local GUI version of SlackFinder — searches packages across repos, but does *not* download (security).

**inxifetch**
Modified `inxi` in `neofetch` style. Configurable via `/etc/inxifetch/inxifetch.conf`.
Examples: `inxifetch`, `inxifetch A`, `inxifetch xxrz`.

**isnum**
Precompiled FORTRAN script to validate numeric input: `isnum "$var"`.

**slack-revert**
Rollback tool: creates backup (`packages.txt` + `/etc.tar`) and restores from historical packages at https://slackware.uk/cumulative/. Use with caution ONLY if you know what your are doing.

**SBKS (Slack Build Kernel Script)**
Builds custom kernels without replacing official ones — ideal for NVIDIA driver users. Typical flow:
1. Switch to runlevel 3, uninstall NVIDIA drivers
2. Build old kernel with SBKS
3. Reboot → install full NVIDIA driver
4. Reboot → install modules only (`-K`)
5. Keep custom kernel; repeat after each official kernel update.

Notes:
- Follows KISS philosophy.
- Unofficial project — may contain bugs.
- Requires dependencies only for tools you use:
  - `kdialog` → for `SBKS`
  - `yq jq chafa` → for `cptn`
  - `figlet inxi` → for `inxifetch`
  - `PyQt6`, `BeautifulSoup4`, `ttkbootstrap` → for Python GUIs
- Run `man scmd` and `cptn -h` for help.
- Try to often run `cptn make-db -a` or `-v` after package upgrades or new installations.
- Some requires exists in Slackware-current stock installation.

See also: [GitHub Repository](https://github.com/rizitis/Slackware-Commander)
Author: Anagnostakis Ioannis<br>
Slackware™ is a trademark of Patrick Volkerding. <br>
Icons from uxwing.com and DALL·E.
