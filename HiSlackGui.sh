#! /bin/bash

# Hikari Slackware Gui (HiSlackGui) Anagnostakis Ioannis <rizitis@gmail.com> Chania Greece 4/2023
# 
# It is based on this work http://pclosmag.com/html/Issues/200910/page21.html
# rcstatus script is from https://www.linuxquestions.org/questions/slackware-14/how-can-i-check-the-system-running-services-534612/page2.html#post6410525
# Thank you very much.
# requires: gtkdialog, zenity. From SlackBuilds.org

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

dotconf=$(whoami)
echo $dotconf
WHO=$dotconf 
dir1=/usr/share/icons/Slackware-Commander/


export MAIN_DIALOG='
<window window_position="1" title="Hikari Slackware Gui">

<vbox>
  <hbox homogeneous="True">
    <frame Hikari Slackware Gui>
    <hbox homogeneous="True">
      

      <vbox homogeneous="True">
        
        <pixmap>
            <input file>/boot/grub/themes/darkmatter/icons/slackware.png</input>
          </pixmap><text use-markup="true"><label>"<span color='"'black'"' font-family='"'purisa'"' weight='"'bold'"' size='"'large'"'><small>HiSlackGui</small></span>"</label></text>
          
      <button>
          <label>Open Terminal</label>
          <action>xfce4-terminal &</action>
          <input file>/usr/share/icons/elementary-xfce/apps/32/org.xfce.terminalemulator.png</input>
        </button> 
    
    <button>
         <input file>/usr/share/icons/oxygen/base/32x32/apps/internet-web-browser.png</input>
          <label>Open Browser</label>
          <action>xdg-open https://www.linuxquestions.org/questions/slackware-14/ &</action>
        </button>        
        
        <button>
          <input file>/usr/share/icons/elementary-xfce/apps/32/org.xfce.thunar.png</input>
          <label>FileManager</label>
          <action>thunar &</action>
        </button>
        
        <button>
           <input file>/usr/share/icons/hicolor/24x24/apps/thunderbird.png</input>
          <label>Thunderbird</label>
           <action>/usr/bin/thunderbird &</action>
        </button>    
        
        <button>
           <input file>/home/omen/.config/discord/tray.png</input>
          <label>Discord</label>
           <action>/usr/bin/discord &</action>         
        </button> 
        
           <button>
           <input file>/usr/share/icons/elementary-xfce/apps/32/org.gnome.gedit.png</input>
          <label>Text EDITOR</label>
           <action>/usr/bin/gedit &</action>         
        </button> 
          
          <button>
          <label>VLC</label>
          <action>/usr/bin/vlc &</action>
          <input file>/usr/share/icons/hicolor/32x32/apps/vlc.png</input>
        </button>
          
      </vbox>
    </hbox>
    </frame>    
    </hbox>
    
    
    
    

    <frame Apps Commander>
    <hbox>
      <entry><variable>VAR1</variable></entry>
    </hbox>

    <hbox>
        <button>
        <label>Run App</label>
        <input file>/usr/share/icons/elementary-xfce/apps/32/org.xfce.panel.launcher.png</input><action>which $VAR1 | bash &</action>
      </button>            
                        
    </hbox>
    </frame>
    
    
    <frame Terminal Apps>
    <hbox>
      <entry><variable>VAR2</variable></entry>
    </hbox>

    <hbox>
        <button>
        <label>Terminal Apps</label>
        <input file>/usr/share/icons/oxygen/base/16x16/actions/gtk-execute.png</input><action>xfce4-terminal -H -x $VAR2 &</action>
      </button>            
                        
    </hbox>
    </frame>
    
    
    <frame Optimus GPU>
    <hbox>
      <entry><variable>VAR3</variable></entry>
    </hbox>

    <hbox>
        <button>
        <label>Nvidia-prime_run</label>
        <input file>/usr/share/icons/oxygen/base/22x22/apps/utilities-system-monitor.png</input><action>__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia $VAR3 &</action>
      </button>            
                        
    </hbox>
    </frame>
   
    
   

<frame>
    
    <hbox>
        <button>
        <label>Slack Commander</label><input file>file/usr/share/icons/oxygen/base/22x22/actions/run-build-install-root.png</input>
        <action>kdesu /usr/local/bin/Slackware-Commander.sh &</action>
      </button>            
                        
    </hbox>
    </frame>


<hbox>    
    <menubar>
    <menu>
    <menuitem>
              <label>read ~/.../hikari.conf</label>
              <action>zenity --title= $"Hikari keys" --text-info --width 900 --height 600 --filename=/home/'"$WHO"'/.config/hikari/hikari.conf &</action>
            </menuitem>

            
                   
          <menuitem>
              <label>edit ~/.../hikari.conf</label>
              <action>xfce4-terminal  -x nano /home/'"$WHO"'/.config/hikari/hikari.conf &</action>
            </menuitem>

            
          <label>Hikari keys</label>
          </menu>
          
          </menubar>
          
          
          <menubar>
    <menu>
    <menuitem>
              <label>Power OFF</label>
              <action>sudo shutdown -h now &</action>
            </menuitem>

            
                   
          <menuitem>
              <label>Log Out</label>
              <action>killall hikari</action>
            </menuitem>

            
          <label>Log Out</label>
          </menu>
          
          </menubar>
          
              </hbox>       
    
  </vbox>
  </window>
  '

  gtkdialog --program=MAIN_DIALOG
