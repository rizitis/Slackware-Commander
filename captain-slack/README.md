# Captain-Slack (cptn)

![Captain-Slack](./Captain-Slack.png)

> We're living the future so the present is our past.

---

## Install

- required:`yq`, `chafa` and `jq`, from SBo
* **DO NOT** Download source.tar.gz from release it will not work. Please Download **zip** file from latest branch.
- Unzip zip file and change in folder.
* As root run `bash cptn.SlackBuild`
- Finally `upgradepkg --install-new /tmp/cptn*.tlz`

Alternative method (unstable):
1. `git clone https://github.com/rizitis/captain-slack.git`
2. `cd captain-slack && sudo bash cptn.SlackBuild`
3. `sudo upgradepkg --install-new /tmp/cptn*.tlz`
4. `sudo rm /tmp/cptn*.tlz`

**NOTE:** main README.md as main branch it self, is the develop branch. 
<br> Some informations or commands may not exist yet for latest cptn release zip files.<br>
Please read **release version branch README.md** for valid infos.

---

### Uninstall

As root `removepkg cptn`

--- 

### Usage:

If you install Captain-Slack the first thing you must do is create data-base for packages and libraries:<p>

**create db**

1. `cptn make-db -a` (as root) Will create a full database of all installed packages and libraries (need some time...)
2. `cptn make-db -p` (as root) The same but only for packages
3. `cptn make-db -l` (as root) The same but only for libraries and their deps...

---
For print informations about your current system use:<p>

**print infos**
1. `cptn info <package-name>` Will print info for the package
2. `cptn info <package-name>` the same if its a library (the **.so** extension not needed)
3. `cptn open-libs` or `cptn open-pkgs` Defauld text editor will open  the yaml file for installed libraries or packages (only for read)
3. `cptn open-logs` Default file manager will open `/var/log/captain-slack` folder for read files.
4. `cptn clear-logs` Delete all *.log files from `/var/log/captain-slack` folder.
---
To print informations about running services or status of a services or restart a service:<p>

**services**

1. `cptn serv-status <rc.service-name>` (as root) Will print service status info
2. `cptn restart-serv`   (as root) Will print all rc.services and ask user to chose which need restart
3. `cptn show-servs` (as root) Will export in terminal all services and their status.

---
To find and use fast mirrors as for your location from mirrorlist:<p>

**mirrors and weather forcast**

1. `cptn mirrors` (as root) Will check all active slackware mirrorlist servers and print top 5 (default) faster for your location.
   - `cptn mirrors -1` Using flag `-1` will print only the faster
   - `cptn mirrors -[1..9]` Valid flags numbers are from 1 to 9. (if not -N flag set, then default is top 5 mirrors)
2. `cptn weather` Will print in terminal next days weather forcast for you :D *(assume you are not under vpn)*
---

#### Videos:
[![asciicast](https://asciinema.org/a/1jhy9rCHTXx0q8oClxxVQz0uC.svg)](https://asciinema.org/a/1jhy9rCHTXx0q8oClxxVQz0uC)
---
[![asciicast](https://asciinema.org/a/9GcocpN3UshAcZJ2uLZFoSBTT.svg)](https://asciinema.org/a/9GcocpN3UshAcZJ2uLZFoSBTT)
---

#### ScreenShots
![info](./info.png)
---
![weather](./weather.png)
---

#### Examples.yaml
1. [libraries](./libraries_dependencies.yaml)
2. [packages](./packages.yaml)
3. [executable_dependencies](./app_dependencies.yaml)



#### TODO
- `cptn make coffee`
- `fix bugs`

---

#### LATEST NEWS
*If you build using [AthOS](https://github.com/rizitis/PLASMA_WORLD) (athos) build system, **cptn info** cmd will print dependencies informations also*:
![AthOS](./athos.png)

*update*:<br>
After [conraid](https://github.com/conraid/SlackBuilds/issues/37) suggestions I made some changes. Now `cptn info` command will read also his build as we both storing a slack-required file in `/usr/doc/$PRGNAM-$VERSION/` folder and things are more easy and more proper discribed ;)<br>
If you also have local builds is a good choice to include a slack-required file in the same folder.<br>
- *slack-required* format is:
```
foo
foo1
foo-do
etc...
```

For your SlackBuilds from SBo-ponce you must add this line in SlackBuild:
`grep "^REQUIRES=" $CWD/$PRGNAM.info | sed 's/^REQUIRES="//;s/"$//' | tr ' ' '\n' >  "$PKG"/usr/doc/"$PRGNAM-$VERSION"/slack-required`

> If you are in Slackware-current and using slpkg you can use my [fork](https://github.com/rizitis/slackbuilds-current) of [ponce repo](https://github.com/Ponce/slackbuilds).
> This fork has all SlackBuild patched for slack-required and more... But you use it at your **own risk**.

This is the edit in all SlackBuilds:
```
cd $PKG
if [ -f $CWD/slack-required ]; then cat $CWD/slack-required > $PKG/install/slack-required; fi
if [ -f $CWD/slack-required ]; then cat $CWD/slack-required > $PKG/usr/doc/$PRGNAM-$VERSION/slack-required; fi
if [ -f $CWD/dependees-on ]; then cat $CWD/dependees-on > $PKG/usr/doc/$PRGNAM-$VERSION/dependees-on; fi
/sbin/makepkg -l y -c n $OUTPUT/$PRGNAM-$VERSION-$ARCH-$BUILD$TAG.$PKGTYPE
if [ -f $CWD/slack-required ]; then cp $CWD/slack-required  $OUTPUT/$PRGNAM-$VERSION-$ARCH-$BUILD$TAG.dep; fi
```
> READ [disclaimer](https://github.com/rizitis/slackbuilds-current#disclaimer) first!
> Original SlackBuilds Maintainers or SlackBuilds.org or Ponce **has no responsibility** about this fork!


