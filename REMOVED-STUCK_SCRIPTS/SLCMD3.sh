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
FILE7=/etc/rc.d/rc.local_shutdown
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
            <input file>/usr/share/icons/Slackware-Commander/slackware_whitelogo_med.png</input>
          </pixmap><text use-markup="true"><label>"<span color='"'blue'"' font-family='"'purisa'"' weight='"'bold'"' size='"'large'"'><small>SOME MORE </small></span>"</label></text><text use-markup="true"><label>"<span color='"'blue'"' font-family='"'purisa'"' weight='"'bold'"' size='"'large'"'><small>TOOLS</small></span>"</label></text>

      </vbox>
    </hbox>
    </frame>
</hbox>

<hbox>
     <entry><variable>VAR2</variable></entry>
   <button>
      <input file>/usr/share/icons/Slackware-Commander/dimension-3d-icon.png</input>
      <label>Find package`s deps</label>
      <action>konsole --hold -e curl -sSL https://raw.githubusercontent.com/gapan/slackware-deps/15.0/$VAR2.dep &</action>
</button>
</hbox>

    <button>
          <input file>/usr/share/icons/Slackware-Commander/alert-icon.png</input>
          <label>Weather-Forcast</label>
           <action>konsole --hold -e /usr/local/bin/weather_forcast &</action>
          </button>
    <hbox>
         <entry><variable>VAR1</variable></entry>
       <button>
          <input file>/usr/share/icons/Slackware-Commander/solution-thinking-icon.png</input>
          <label>Isnum?</label>
          <action>konsole --hold -e /usr/local/bin/isnum $VAR1 &</action>
    </button>
    </hbox>


    <button>
         <input file>/usr/share/icons/Slackware-Commander/it-icon-1.png</input>
          <label>Print Slackware Release Version</label>
           <action>konsole --hold -e /usr/local/bin/print_version &</action>
          </button>

    <button>
         <input file>/usr/share/icons/Slackware-Commander/online-community-icon.png</input>
          <label>slack-revert</label>
           <action>konsole --hold -e slack-revert &</action>
          </button>
<button>
         <input file>/usr/share/icons/Slackware-Commander/project-work-icon.png</input>
          <label>SBKS (Slack Buld Kernel Script)</label>
           <action>konsole --hold -e SBKS &</action>
          </button>

  </vbox>
  </window>
  '

  gtkdialog --program=MAIN_DIALOG
