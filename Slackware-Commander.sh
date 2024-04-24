#! /bin/bash

# Slackware-Commander Anagnostakis Ioannis <rizitis@gmail.com> Chania Greece 2023-2024
# It is based on this work http://pclosmag.com/html/Issues/200910/page21.html
# rcstatus script is from https://www.linuxquestions.org/questions/slackware-14/how-can-i-check-the-system-running-services-534612/page2.html#post6410525
# Thank you very much.



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
          </pixmap><text use-markup="true"><label>"<span color='"'white'"' font-family='"'purisa'"' weight='"'bold'"' size='"'large'"'><small>SYSTEM UPDATE</small></span>"</label></text>
          
      </vbox>
    </hbox>
    </frame>
    
    
    
    
    
    
    <vbox>
    <frame Slackware Package Manager>

    <button>
          <label>Slackpkg Update</label>
          <action>rm /var/lock/slackpkg.* &</action>
          <action>xterm -hold -e  /usr/sbin/slackpkg update &</action>
          <input file>/usr/share/icons/Slackware-Commander/this-way-up-symbol-icon.png</input>
        </button> 
    
    <button>
         <input file>/usr/share/icons/Slackware-Commander/deep-water-icon.png</input>
          <label>Slackpkg Upgrade-all</label>
          <action>rm /var/lock/slackpkg.* &</action>
          <action>xterm -hold -e /usr/sbin/slackpkg upgrade-all &</action>
        </button>        
        
        <button>
          <input file>/usr/share/icons/Slackware-Commander/wow-icon.png</input>
          <label>Slackpkg Install-new</label>
          <action>rm /var/lock/slackpkg.* &</action>
          <action>xterm -hold -e slackpkg install-new &</action>
        </button>
        
        <button>
           <input file>/usr/share/icons/Slackware-Commander/project-work-icon.png</input>
          <label>Slackpkg new-config</label>
           <action>rm /var/lock/slackpkg.* &</action>
          <action>xterm -hold -e /usr/sbin/slackpkg new-config &</action>
        </button>     
     </frame>
   </vbox>   
    
   
    
    

    <vbox>
      <frame Slackpkg setup>        
         <button>
          <input file>/usr/share/icons/Slackware-Commander/silence-icon.png</input>
          <label>BLACKLIST </label>
          <action>xterm -e nano /etc/slackpkg/blacklist &</action>
        </button> 
        <button>
        <input file>/usr/share/icons/Slackware-Commander/business-management-icon.png</input>
          <label>MIRRORS</label>
          <action>xterm -e nano /etc/slackpkg/mirrors &</action>
        </button> 
        <button>
          <input file>/usr/share/icons/Slackware-Commander/carpenter-tools-icon.png</input>
          <label>Slackpkg.conf</label>
          <action>xterm -e nano /etc/slackpkg/slackpkg.conf &</action>
        </button> 
        <button>
          <input file>/usr/share/icons/Slackware-Commander/downtime-arrow-icon.png</input>
          <label>ChangeLog</label>
          <action>cat /var/lib/slackpkg/ChangeLog.txt | yad --text-info --width=600 --height=600 --title $"ChangeLog" &</action>
        </button> 
        </frame>
      </vbox>
    </hbox>
    
    <button>
          <input file>/usr/share/icons/Slackware-Commander/diy-do-it-yourself-icon.png</input>
          <label>slackpkg+.conf</label>
           <action>xterm -e nano /etc/slackpkg/slackpkgplus.conf &</action>
          </button>
    
    

    <frame Packages Commander>
    <hbox>
      <text> <label>Package:</label> </text>
      <entry><variable>VAR1</variable></entry>
    </hbox>

    <hbox>
      <button>
        <label>slackpkg install</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xterm -hold -e slackpkg install $VAR1 &</action>
      </button>
      
      <button>
        <label>slackpkg reinstall</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xterm -hold -e /usr/sbin/slackpkg reinstall $VAR1 &</action>
      </button>
      
      <button>
        <label>slackpkg search</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xterm -hold -e slackpkg search $VAR1 &</action>      
      </button>
      
      <button>
        <label>slackpkg remove</label>
        <action>rm /var/lock/slackpkg.* &</action>
        <action>xterm -hold -e slackpkg remove $VAR1 &</action>
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
          <input file>/usr/share/icons/Slackware-Commander/toolbox-icon.png</input>
          <label>MORE TOOLS</label>
          <action>bash SLCMD2.sh &</action>
          </button>    


    
  </vbox>
  </window>
  '

  gtkdialog --program=MAIN_DIALOG
