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
          </pixmap><text use-markup="true"><label>"<span color='"'white'"' font-family='"'purisa'"' weight='"'bold'"' size='"'large'"'><small>SYSTEM INFORMATIONS and CONFS</small></span>"</label></text>
          
      </vbox>
    </hbox>
    </frame>
    
    
    
    
    
    
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

        
      </vbox>
    
   
    
    

    <vbox>
      
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
          <action>xterm -hold -e /usr/local/bin/rcstatus &</action>
          </button>
          
          <button>
          <label>Terminal as root</label>
          <action>xterm &</action>
        </button>

      </vbox>
    </hbox>
    
    <button>
          <label>whoRyou?</label>
           <action>xterm -hold -e /usr/local/bin/whoRyou &</action>
          </button>    
    
    

    <hbox>
      <frame System Files>
        <hbox>
          <button><label>'"$FILE1"'</label><action>yad --title='"$FILE1"' --text-info --width 500 --height 400 --filename='"$FILE1"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/it-icon.png</input><action>xterm -e nano '"$FILE1"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE2"'</label><action>yad --title='"$FILE2"' --text-info --width 500 --height 400 --filename='"$FILE2"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/service-tools-icon.png</input><action>xterm -e nano '"$FILE2"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE3"'</label><action>yad --title='"$FILE3"' --text-info --width 500 --height 400 --filename='"$FILE3"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/scissor-icon.png</input><action>xterm -e nano '"$FILE3"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE4"'</label><action>yad --title='"$FILE4"' --text-info --width 500 --height 400 --filename='"$FILE4"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/select-area-icon.png</input><action>xterm -e nano '"$FILE4"' &</action></button>
        </hbox>
         <hbox>
          <button>
            <label>'"$FILE10"'</label>
            <action>yad --title='"$FILE10"' --text-info --width 500 --height 400 --filename='"$FILE10"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/myspace-icon.png</input>
            <action>xterm -e nano '"$FILE10"' &</action>
          </button>
        </hbox>
      </frame>

      <frame>
        <hbox>
          <button><label>'"$FILE5"'</label><action>yad --title='"$FILE5"' --text-info --width 500 --height 400 --filename='"$FILE5"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/drill-icon.png</input><action>xterm -e nano '"$FILE5"' &</action></button>
        </hbox>

        <hbox>
          <button><label>'"$FILE6"'</label><action>yad --title='"$FILE6"' --text-info --width 500 --height 400 --filename='"$FILE6"' &</action></button>
          <button><input file>/usr/share/icons/Slackware-Commander/green-circle-icon.png</input><action>xterm -e nano '"$FILE6"' &</action></button>
        </hbox>

        <hbox>
          <button>
            <label>'"$FILE7"'</label>
            <action>yad --title='"$FILE7"' --text-info --width 500 --height 400 --filename='"$FILE7"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/red-circle-icon.png</input>
            <action>xterm -e nano '"$FILE7"' &</action>
          </button>

        </hbox>

        <hbox>
          <button>
            <label>'"$FILE8"'</label>
            <action>yad --title='"$FILE8"' --text-info --width 500 --height 400 --filename='"$FILE8"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/cruelty-free-sign-icon.png</input>
            <action>xterm -e nano '"$FILE8"' &</action>
          </button>

        </hbox>
        <hbox>
          <button>
            <label>'"$FILE9"'</label>
            <action>yad --title='"$FILE9"' --text-info --width 500 --height 400 --filename='"$FILE9"' &</action>
          </button>

          <button>
            <input file>/usr/share/icons/Slackware-Commander/share-group-member-icon.png</input>
            <action>xterm -e nano '"$FILE9"' &</action>
          </button>

        </hbox>
      </frame>
    </hbox>
<button>
          <label>SBKS (SLACK BUILD KERNEL SCRIPT)</label>
           <action>bash SBKS &</action>
          </button>    
    
  </vbox>
  </window>
  '

  gtkdialog --program=MAIN_DIALOG
