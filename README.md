Prefferent OS for Slackware-Commander is a full installation of Slackware(64)-Current with preinstalled:

>  `PyQt6 , jq  qmake6 gfortran`

##  Installation

> Build and Install all required from Ponce/SBo<br>
> Assume you have a full Slackware installation and you use `slpkg`:

1.  `slpkg install  yq  chafa figlet BeautifulSoup4 ttkbootstrap`
2. As root: ` bash scmd.SlackBuild`
3.  When SlackBuild finish, you may install output package using `upgradepkg --install-new...`

For sbopkg you can use `scmd.sqf`

- - -
**Note**: Slackware-Commander in a full a full Slackware current installation has only runtime dependencies:
- `yq chafa` as dependencies for **cptn**.
- `figlet` as dependency for **inxifetch**.
-  `BeautifulSoup4, ttkbootstrap` as dependencies for some of the python scripts.

If you dont need or you dont like some of Slackware-Commander tools then you dont need their deps also.

**Note** Scripts are installed in `/usr/local/bin` as it should be btw...

>

---
## Building Slackware Commander in Docker (Forgejo CI)

### Prerequisites

- A Forgejo account with access to a Slackware runner
- Fork of this repository

### Important Notes

> **This build workflow is designed exclusively for Slackware-current (x86_64).**
> It will not work on Slackware 15.0 or any other version.

> **All external dependencies are automatically built from source** using the
> [Ponce/slackbuilds](https://github.com/Ponce/slackbuilds) repository, which
> tracks Slackware-current. This means every dependency listed in `scmd.dep`
> will be compiled inside the Docker container before building `scmd` itself in a magic way ;)

### How to trigger a build

1. Go to your forked repository on Forgejo
2. Click **Actions** tab
3. Click **Run workflow**
4. Fill in the inputs:
   - `package_name`: `scmd` (default)
   - `version`: `8.0.0` (default)
   - `build_deps`: leave as default unless you need extra packages
   - `upload_artifact`: `true` to download the built `.txz`
5. Click **Run workflow**

### What happens

The workflow runs inside a Slackware current Docker container
(`registry.slackware.nl/slackware/slackware-builder:current`) and performs
the following steps:

1. Installs runtime dependencies (`libuv`, X11, OpenGL, dbus, fontconfig, etc.)
2. Checks out your repository
3. Fetches the CI helper (`slk-ci.sh`) from the Slackware forge
4. Installs build dependencies defined in `build_deps`
5. Resolves all external dependencies from `scmd.dep` and builds them from
   source using the [Ponce/slackbuilds](https://github.com/Ponce/slackbuilds)
   repository
6. Builds the package using `scmd.SlackBuild`
7. Verifies the installed version matches the expected version
8. Uploads the built `.txz` as a workflow artifact (if `upload_artifact` is `true`)

### Downloading the built package

After a successful build:

1. Go to **Actions** → select the completed run
2. Scroll down to **Artifacts**
3. Download `scmd-8.0.0-slackware-current-x86_64`

The artifact contains the ready-to-install `scmd-8.0.0-x86_64-1_SC.txz` package.

### Installing

```bash
installpkg scmd-8.0.0-x86_64-1_SC.txz
```

- - -
## Usage:
`man scmd` and `cptn -h` will help you.

- `cptn make-db -a` is a very importand command for create a database that will be used by cptn tools.


---

Slackware™ is a [trademark](http://www.slackware.com/trademark/trademark.php) of Patrick Volkerding. 

---

Icons are from:<br>

[uxwing](https://uxwing.com/license/) 

And [DALL·E](https://chatgpt.com/g/g-2fkFE8rbu-dall-e)


Thank you, thank you, thank you!


- - -
Standard Slackware-current disclaimer follows...
<details>
Standard disclaimer follows... putting this back since some folks forgot ;-)

Welcome to Slackware-current!

*** upgradepkg aaa_glibc-solibs before other      ***
*** packages. Take care not to miss new packages: ***
*** upgradepkg --install-new  is (as always) the  ***
*** safest approach.                              ***

Slackware-current is a snapshot of the active Slackware development tree.
It is intended to give developers (and other Linux gurus) a chance to test
out the latest packages for Slackware. The feedback we get will allow us
to make the next stable release better than ever.

See the ChangeLog.txt for a list of changes in Slackware-current.

Please note that the code in this directory is unstable. It might be 
inconsistent about which version of the Linux kernel is required, could be
incomplete because it's in the process of being uploaded, or might not work
for other reasons. In most cases, we know about these things and are working
to correct them, but still -- feel free to point out the bugs.

Production use is AT YOUR OWN RISK and is not recommended.

Security is NOT GUARANTEED. In -current, forward progress often takes
priority. Security fixes take time and resources, and would often have to
be done more than once. It's more efficient to build the system and secure
it as time permits and/or the development cycle nears completion.

We do not promise to issue security advisories for Slackware-current.

Slackware-current might DELETE FILES WITHOUT WARNING when packages are
upgraded. (If, for example, a directory location is replaced by a symbolic
link to a new location.) Upgrade packages carefully. Examine incoming
updates first if your machine's data is not expendable. Again, we do not
recommend using Slackware-current to store or process valuable data.
It is a system in testing, not one that is ready to go (though often it does
work just fine... BUT DON'T COUNT ON IT) 

#include BSD license warranty disclaimer here...

Enjoy! :)

Patrick J. Volkerding
`volkerdi@slackware.com`
</details>
