**In the year 2025, everything was written from scratch, a minimal and *KISS*
Qt6 gui is now what we have** 

That means prefferent OS for Slackware-Commander is `Slackware(64)-Current with QT6 and qmake6`

##  Installation

> Install all required from Ponce/SBo<br>
> Assume you have a full Slackware installation and you use `slpkg`:

1.  `slpkg -i yq jq chafa figlet BeautifulSoup4 ttkbootstrap`
2.  Download latest `scdm-version.tar.gz` release from [here](https://github.com/rizitis/Slackware-Commander/releases)
3.  Extract tarball and cd in `scmd.SlackBuild` folder.
4.  Open terminal and command:
- `pip install -r requirements.txt`
- ` su -c "bash scmd.SlackBuild"`
5.  When SlackBuild finish, you may install output package using `upgradepkg --install-new...`

- - -
**Note**: Slackware-Commander has only runtime dependencies in a full Slackware64-current installation:
- `slpkg` as dependency for **sbofinder**.
- `yq  jq  chafa` as dependencies for **cptn**.
- `figlet` as dependency for **inxifetch**.
- `PyQt6` *(pip install)*, `BeautifulSoup4, ttkbootstrap` as dependencies for some of the python scripts.

So if you dont need or like some of SLackware-Commander tools then you dont need their deps also.

- - -
## Usage:
`man scmd` and `cptn -h` will help you.

- `cptn make-db -a` is a very importand command for create a database that will be used by cptn tools.


![Image](https://github.com/user-attachments/assets/38488f3b-e0d7-4be1-93e0-d6179095752d)

- - -
 ![image](./Slackware-Commander-GuiApps.png)

- - -
https://github.com/user-attachments/assets/67420fc8-a792-4012-b104-6584577a3508

---

##  ![image](./slakfinder.png)

---

https://github.com/user-attachments/assets/445239df-40c3-4221-a04e-105bb2da6fc3

---

https://github.com/user-attachments/assets/318980c2-5aed-4a37-9723-5937e4d44cf1

---

## ![image](./conraidfinder.png)

---

Slackware™ is a [trademark](http://www.slackware.com/trademark/trademark.php) of Patrick Volkerding. 

Icons are from:<br>
[uxwing](https://uxwing.com/license/)<br>
![](https://uxwing.com/wp-content/themes/uxwing/images/logo.svg)<br>
https://uxwing.com/ <br>

And [DALL·E](https://chatgpt.com/g/g-2fkFE8rbu-dall-e)


Thank you, thank you, thank you!


- - -
```
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

---
Patrick J. Volkerding
# volkerdi@slackware.com
```

