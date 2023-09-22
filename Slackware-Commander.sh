#! /bin/bash

# Slackware-Commander Anagnostakis Ioannis <rizitis@gmail.com> Chania Greece 7/2023
# It is based on this work http://pclosmag.com/html/Issues/200910/page21.html
# rcstatus script is from https://www.linuxquestions.org/questions/slackware-14/how-can-i-check-the-system-running-services-534612/page2.html#post6410525
# Thank you very much.
# requires: gtkdialog and yad from SlackBuilds.org
# I found yad more stable than zenity. 
# Added GFS-tracker for Slackers with Gnome installation. (https://github.com/rizitis/GFS-tracker) #

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Encoding=UTF-8

FILE1=/etc/X11/xorg.conf
FILE2=/etc/fstab
FILE3=/etc/default/grub
FILE4=/etc/inittab
FILE5=/boot/efi/EFI/Slackware/elilo.conf
FILE6=/etc/rc.d/rc.local
FILE7=/etc/rc.d/rc.local.shutdown
FILE8=/etc/profile
FILE9=/etc/group
FILE10=/etc/sudoers
dir1=/usr/share/icons/Slackware-Commander/

export MAIN_DIALOG='
<window window_position="1" title="Slackware Commander">

<vbox>
  <hbox homogeneous="True">
    <frame>
    <hbox homogeneous="True">
      

      <vbox homogeneous="True">
        
        <pixmap>
            <input file>/usr/share/icons/Slackware-Commander/slackware_logo_med.png</input>
          </pixmap><text use-markup="true"><label>"<span color='"'white'"' font-family='"'purisa'"' weight='"'bold'"' size='"'large'"'><small>System Commander</small></span>"</label></text>
          
      </vbox>
    </hbox>
    </frame>
    
    
    
    
    
    
    <vbox>
    <frame Slackware Package Manager>

    <button>
          <label>Slackpkg Update</label>
          <action>rm /var/lock/slackpkg.* &</action>
          <action>xfce4-terminal -H -x  /usr/sbin/slackpkg update &</action>
          <input file>/usr/share/icons/Slackware-Commander/this-way-up-symbol-icon.png</input>
        </button> 
    
    <button>
         <input file>/usr/share/icons/Slackware-Commander/deep-water-icon.png</input>
          <label>Slackpkg Upgrade-all</label>
          <action>rm /var/lock/slackpkg.* &</action>
          <action>xfce4-terminal -H -x /usr/sbin/slackpkg upgrade-all &</action>
        </button>        
        
        <button>
          <input file>/usr/share/icons/Slackware-Commander/wow-icon.png</input>
          <label>Slackpkg Install-new</label>
          <action>rm /var/lock/slackpkg.* &</action>
          <action>xfce4-terminal -H -x slackpkg install-new &</action>
        </button>
        
        <button>
           <input file>/usr/share/icons/Slackware-Commander/project-work-icon.png</input>
          <label>Slackpkg new-config</label>
           <action>rm /var/lock/slackpkg.* &</action>
          <action>xfce4-terminal -H -x /usr/sbin/slackpkg new-config &</action>
        </button>     
     </frame>
   </vbox>   
    
   
    
    

    <vbox>
      <frame Slackpkg setup>        
         <button>
          <input file>/usr/share/icons/Slackware-Commander/silence-icon.png</input>
          <label>BLACKLIST </label>
          <action>xfce4-terminal -x nano /etc/slackpkg/blacklist &</action>
        </button> 
        <button>
        <input file>/usr/share/icons/Slackware-Commander/business-management-icon.png</input>
          <label>MIRRORS</label>
          <action>xfce4-terminal -x nano /etc/slackpkg/mirrors &</action>
        </button> 
        <button>
          <input file>/usr/share/icons/Slackware-Commander/carpenter-tools-icon.png</input>
          <label>Slackpkg.conf</label>
          <action>xfce4-terminal -x nano /etc/slackpkg/slackpkg.conf &</action>
        </button> 
        <button>
          <input file>/usr/share/icons/Slackware-Commander/downtime-arrow-icon.png</input>
          <label>ChangeLog</label>
          <action>cat /var/lib/slackpkg/ChangeLog.txt | yad --text-info --width=600 --height=600 --title $"ChangeLog" &</action>
        </button> 
        </frame>
      </vbox>
    </hbox>
    
    
    
    

    <frame Packages Commander>
    <hbox>
      <text> <label>Package:</label> </text>
      <entry><variable>VAR1</variable></entry>
    </hbox>

    <hbox>
        <button>
        <label>slackpkg install</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xfce4-terminal -H -x slackpkg install $VAR1 &</action>
      </button>
      
      <button>
        <label>slackpkg reinstall</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xfce4-terminal -H -x /usr/sbin/slackpkg reinstall $VAR1 &</action>
      </button>
      
      <button>
        <label>slackpkg search</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xfce4-terminal -H -x slackpkg search $VAR1 &</action>      
      </button>
      
      <button>
        <label>slackpkg remove</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xfce4-terminal -H -x slackpkg remove $VAR1 &</action>
      </button>
    
      <button>
        <label>Help</label>
        <action>$VAR1 --help | yad --text-info --width=600 --height=600 --title $"Help" &</action>
      </button>

      <button>
        <label>Whereis</label>
        <action>whereis $VAR1 | yad --text-info  --width=400 --height=20 --title $"Whereis" &</action>
      </button>

      <button>
        <label>Which</label>
        <action>which $VAR1 | yad --text-info --width=200 --height=200 --title $"Version" &</action>
      </button>

      <button>
        <label>Version</label>
        <action>$VAR1 --version | yad --text-info --width=200 --height=200 --title $"Version" &</action>
      </button>

      <button>
        <label>Manual</label>
        <action>man $VAR1 | yad --text-info --width=400 --height=500 --title $"Manual" &</action>
      </button>
    </hbox>
    </frame>
    
    
    <button>
          <input file>/usr/share/icons/Slackware-Commander/diy-do-it-yourself-icon.png</input>
          <label>slackpkg+.conf</label>
           <action>xfce4-terminal -x nano /etc/slackpkg/slackpkgplus.conf &</action>
          </button>
    <hbox homogeneous="True">    
    <frame Hardware Informations>
      <vbox>
        <button>
          <input file>/usr/share/icons/Slackware-Commander/process-icon.png</input>
          <label>CPU infos</label>
          <action>cat /proc/cpuinfo | yad --text-info  --width=700 --height=500 --title $"CPU infos" &</action>
        </button>

        <button>
          <input file>/usr/share/icons/Slackware-Commander/construction-hinge-icon.png</input>
          <label>Ethernet Interfaces</label>
          <action>ifconfig | yad --text-info  --width=700 --height=500 --title $"View an ethernet network interface" &</action>
        </button>

        <button>
          <input file>/usr/share/icons/Slackware-Commander/construction-hinges-icon.png</input>
          <label>Wireless Interfaces</label>
          <action>iwconfig | yad --text-info  --width=700 --height=500 --title $"Current wireless network interface" &</action>
        </button>

        <button>
          <input file>/usr/share/icons/Slackware-Commander/bolt-icon.png</input>
          <label>USB devices</label>
          <action>lsusb | yad --text-info  --width=700 --height=500 --title $"USB devices" &</action>
        </button>

        <button>
          <input file>/usr/share/icons/Slackware-Commander/configuration-icon.png</input>
          <label>inxi </label>
          <action>inxi -v 8 | yad --text-info  --width=700 --height=500 --title $"inxi" &</action>
        </button>

        <button>
          <input file>/usr/share/icons/Slackware-Commander/home-improvement-icon.png</input>
          <label> Block devices</label>
          <action>lsblk | yad --text-info  --width=700 --height=500 --title $"Block devices" &</action>
        </button>

        <button>
          <input file>/usr/share/icons/Slackware-Commander/settings-icon.png</input>
          <label>PCI devices</label>
          <action>lspci | yad --text-info  --width=700 --height=500 --title $"PCI devices" &</action>
        </button>
        
        
      </vbox>
    </frame>  
   
   
   
   
    <frame Package Managers>
      <vbox>
       <button>
       <input file>/usr/share/icons/Slackware-Commander/solution-thinking-icon.png</input>
          <label>sboui</label>
          <action>killall sboui &</action>
          <action>xfce4-terminal -H -x  sboui &</action>
          </button> 
        <hbox>
          <entry><variable>VAR3</variable></entry><pixmap>
            <input file>/usr/share/icons/Slackware-Commander/solution-strategy-icon.png</input>
          </pixmap>

          <menubar>
          <menu>
          <menuitem>
          <label>sbopkg update</label>
          <action>killall sbopkg &</action>
          <action>xfce4-terminal -H -x sbopkg -r &</action>          
          </menuitem>
          
          <menuitem>
          <label>sbopkg search for package</label>
          <action>killall sbopkg &</action>
          <action>sbopkg -g $VAR3 | yad --text-info  --width=200 --height=600 --title $"FILES" &</action>          
          </menuitem>
          
          <menuitem>
          <label>sbopkg view package files</label>
          <action>killall sbopkg &</action>
          <action>sbopkg -s $VAR3 | yad --text-info  --width=900 --height=600 --title $"FILES" &</action>          
          </menuitem>
          
          <menuitem>
          <label>sbopkg build package only</label>
          <action>killall sbopkg &</action>
          <action>xfce4-terminal -H -x sbopkg -b $VAR3 &</action>          
          </menuitem>
          
          <menuitem>
          <label>sbopkg install (sqg -p && sbopkg -k -i)</label>
          <action>killall sbopkg &</action>
          <action>sqg -p $VAR3 && xfce4-terminal -H -x sbopkg -k -i $VAR3 &</action>          
          </menuitem>
          
          <menuitem>
          <label>Display a list of installed SBo packages and potential updates (need some time)</label>
          <action>killall sbopkg &</action>
          <action>sbopkg -c -q | yad --text-info  --width=900 --height=600 --title $"FILES" &</action>          
          </menuitem>
                  
            <menuitem>
              <label>sbopkg blacklist</label>
              <action>killall sbopkg &</action>
              <action>xfce4-terminal -x nano /etc/sbopkg/blacklist &</action>
            </menuitem>

            <menuitem>
              <label>sbopkg.conf</label>
              <action>xfce4-terminal -x nano /etc/sbopkg/sbopkg.conf</action>
            </menuitem>

            <menuitem>
              <label>sbopkg manual</label>
              <action>man sbopkg | yad --text-info  --width=700 --height=500 --title $"sbopkg manual" &</action>
            </menuitem>

          <label>sbopkg</label>
          </menu>
          </menubar>
        </hbox>

        <hbox>
          <entry><variable>VAR4</variable></entry><pixmap>
            <input file>/usr/share/icons/Slackware-Commander/manager-icon.png</input>
          </pixmap>

          <menubar>
          <menu>
          
          <menuitem>
          <label>check-updates </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -c &</action>          
          </menuitem>
          
          <menuitem>
          <label>slpkg update </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -u &</action>          
          </menuitem>
          
          <menuitem>
          <label>slpkg Upgrade all the installed packages </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -U &</action>          
          </menuitem>
          
          <menuitem>
          <label>slpkg search slackbuilds </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -s $VAR4 &</action>          
          </menuitem>
          
          <menuitem>
          <label>Tracking the packages dependencies </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -t $VAR4 &</action>          
          </menuitem>
          
          <menuitem>
          <label>View package information </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -w $VAR4 &</action>          
          </menuitem>
          
          <menuitem>
          <label>slpkg build package only </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -by $VAR4 &</action>          
          </menuitem>
          
          <menuitem>
          <label>slpkg reinstall </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -iry $VAR4 &</action>          
          </menuitem>
          
          <menuitem>
          <label>slpkg install </label>
          <action>killall slpkg &</action>
          <action>xfce4-terminal -H -x slpkg -iy $VAR4 &</action>          
          </menuitem>
          
            <menuitem>
              <label>Edit repo.toml</label>
              <action>killall slpkg &</action>
              <action>xfce4-terminal -x nano /etc/slpkg/repositories.toml &</action>
            </menuitem>

            <menuitem>
              <label>Edit slpkg.toml</label>
              <action>killall slpkg &</action>
              <action>xfce4-terminal -x nano /etc/slpkg/slpkg.toml &</action>
            </menuitem>

              <menuitem>
              <label>Edit Blacklist</label>
              <action>killall slpkg &</action>
              <action>xfce4-terminal -x nano /etc/slpkg/blacklist.toml & </action>
            </menuitem>

            <menuitem>
              <label>slpkg manual</label>
              <action>man slpkg | yad --text-info  --width=700 --height=500 --title $"slpkg manual"  &</action>
            </menuitem>

            
          <label>slpkg</label>
          </menu>
          </menubar>
        </hbox>
       <button>
          <label>View dmesg messages</label>
          <action>dmesg | yad --text-info  --width=900 --height=700 --title $"View kernel messages" &</action>
        </button>

        
        <button>
          <label>Loaded modules</label>
         <action>lsmod | yad --text-info  --width=700 --height=500 --title $"View loaded modules" &</action>
        </button>

        <button>
          <label>Services</label>
          <action>xfce4-terminal -H -x /usr/local/bin/rcstatus &</action>
          </button>
          
          <button>
          <label>Terminal as root</label>
          <action>xfce4-terminal &</action>
        </button>

      </vbox>
    </frame>
    </hbox>   
    
       
    
    
    <hbox>
      <frame System Files>
        <hbox>
          <button><label>'"$FILE1"'</label><action>yad --title='"$FILE1"' --text-info --width 500 --height 400 --filename='"$FILE1"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/it-icon.png</input><action>xfce4-terminal -x nano '"$FILE1"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE2"'</label><action>yad --title='"$FILE2"' --text-info --width 500 --height 400 --filename='"$FILE2"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/service-tools-icon.png</input><action>xfce4-terminal -x nano '"$FILE2"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE3"'</label><action>yad --title='"$FILE3"' --text-info --width 500 --height 400 --filename='"$FILE3"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/scissor-icon.png</input><action>xfce4-terminal -x nano '"$FILE3"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE4"'</label><action>yad --title='"$FILE4"' --text-info --width 500 --height 400 --filename='"$FILE4"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/select-area-icon.png</input><action>xfce4-terminal -x nano '"$FILE4"' &</action></button>
        </hbox>
         <hbox>
          <button>
            <label>'"$FILE10"'</label>
            <action>yad --title='"$FILE10"' --text-info --width 500 --height 400 --filename='"$FILE10"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/myspace-icon.png</input>
            <action>xfce4-terminal -x nano '"$FILE10"' &</action>
          </button>
        </hbox>
      </frame>

      <frame>
        <hbox>
          <button><label>'"$FILE5"'</label><action>yad --title='"$FILE5"' --text-info --width 500 --height 400 --filename='"$FILE5"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/drill-icon.png</input><action>xfce4-terminal -x nano '"$FILE5"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE6"'</label><action>yad --title='"$FILE6"' --text-info --width 500 --height 400 --filename='"$FILE6"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/green-circle-icon.png</input><action>xfce4-terminal -x nano '"$FILE6"' &</action></button>
        </hbox>

        <hbox>
          <button>
            <label>'"$FILE7"'</label>
            <action>yad --title='"$FILE7"' --text-info --width 500 --height 400 --filename='"$FILE7"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/red-circle-icon.png</input>
            <action>xfce4-terminal -x nano '"$FILE7"' &</action>
          </button>

        </hbox>

        <hbox>
          <button>
            <label>'"$FILE8"'</label>
            <action>yad --title='"$FILE8"' --text-info --width 500 --height 400 --filename='"$FILE8"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/cruelty-free-sign-icon.png</input>
            <action>xfce4-terminal -x nano '"$FILE8"' &</action>
          </button>

        </hbox>
        <hbox>
          <button>
            <label>'"$FILE9"'</label>
            <action>yad --title='"$FILE9"' --text-info --width 500 --height 400 --filename='"$FILE9"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/share-group-member-icon.png</input>
            <action>xfce4-terminal -x nano '"$FILE9"' &</action>
          </button>

        </hbox>
      </frame>
    </hbox>

    
  </vbox>
  </window>
  '

  gtkdialog --program=MAIN_DIALOG
