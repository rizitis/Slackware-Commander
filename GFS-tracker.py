#!/usr/bin/python3

#  PROJECT: gnome-info-collect
#  FILE:    client/client.py
#  LICENCE: GPLv3+
#
#  Copyright 2022 vstanek <vstanek@redhat.com>
#
#====Modified by rizitis for SysVinit Slackware====#
#=================*****7/2023*****===================#
# You can use that script for statistics or improve your Gnome installation in your Slackware system
# No uploads, only output in terminal...if you want to share it.

import os
import pwd
import subprocess
import re
import json
import hashlib
import locale

if "gnome" not in os.environ.get("XDG_CURRENT_DESKTOP", "").lower():
    print("This tool must be run from a GNOME desktop.")
    from sys import exit
    exit(1)

import gi

gi.require_version('AccountsService', '1.0')
from gi.repository import GLib, Gio, AccountsService

try:
    gi.require_version('Goa', '1.0')
    from gi.repository import Goa
    HAVE_GOA = True
except (ValueError, ImportError):
    HAVE_GOA = False

# Older GNOME (<41) compatibility
try:
    gi.require_version('Malcontent', '0')
    from gi.repository import Malcontent
    HAVE_MALCONTENT = True
except (ValueError, ImportError):
    HAVE_MALCONTENT = False

# ~ User application data directory and status file
USER_DIR = GLib.get_user_data_dir()
APP_DIR = os.path.join(USER_DIR, 'gnome-info-collect')
STATUS_FILE = os.path.join(APP_DIR, 'uploaded')


class GCollector():
    """Class housing methods for collecting information for the
    gnome-info-collect project.
    """

    def __init__(self):
        self.data = dict()

    def collect_data(self) -> dict:
        """Collects data and returns it in a dictionary"""

        self._get_hw_os_info()
        self._get_display_info()
        self._get_locale_info()
        self._get_flatpak_info()
        self._get_installed_apps()
        self._get_favourited_apps()
        self._get_online_accounts()
        self._get_sharing_settings()
        self._get_workspaces_status()
        self._get_number_of_users()
        self._get_default_browser()
        self._get_enabled_extensions()

        return self.data

    def _get_enabled_extensions(self):
        enabled_extensions_list = []

        ge = Gio.DBusProxy.new_for_bus_sync(
            Gio.BusType.SESSION,
            Gio.DBusProxyFlags.NONE,
            None,
            "org.gnome.Shell",
            "/org/gnome/Shell",
            "org.gnome.Shell.Extensions",
            None,
        )
        ext_objects, = ge.call_sync(
            "ListExtensions",
            None,
            Gio.DBusCallFlags.NONE,
            -1,
            None,
        ).unpack()
        for obj in ext_objects.values():
            try:
                if obj["state"] == 1.0:
                    enabled_extensions_list.append(obj["uuid"])
            except KeyError:
                pass

        self.data["Enabled extensions"] = enabled_extensions_list
    
    def _get_default_browser(self):
        self.data["Default browser"] = Gio.AppInfo.get_default_for_type(
            "x-scheme-handler/https", False
        ).get_display_name()

    
    def _get_number_of_users(self):
        count = len(AccountsService.UserManager.get_default().list_users())
        self.data["Number of users"] = count
    
    def _get_workspaces_status(self):
        mutter_settings = Gio.Settings(schema_id="org.gnome.mutter")

        # Workspaces only on primary display
        workspaces_primary = mutter_settings.get_value(
            "workspaces-only-on-primary"
        )
        self.data["Workspaces only on primary"] = bool(workspaces_primary)

        # Dynamic workspaces
        workspaces_dynamic = mutter_settings.get_value(
            "dynamic-workspaces"
        )
        self.data["Workspaces dynamic"] = bool(workspaces_dynamic)
    
    def _get_hw_os_info(self):
        print("Inside _get_hw_os_info()...")
        try:
            # For Slackware, use /etc/slackware-version to get OS info
            with open('/etc/slackware-version', 'r') as f:
                os_info = f.read().strip()
            self.data["Operating System"] = os_info

            # Use uname to get hardware info
            hw_info = subprocess.run(['uname', '-m'], capture_output=True, text=True, timeout=10).stdout.strip()
            self.data["Hardware Model"] = hw_info

            # Use uname -pi to get both hardware info and processor architecture
            hw_arch_info = subprocess.run(['uname', '-pi'], capture_output=True, text=True, timeout=10).stdout.strip()
            self.data["Hardware Architecture"] = hw_arch_info

            # Use gnome-shell to get GNOME version
            gnome_version_output = subprocess.run(
                ["gnome-shell", "--version"],
                capture_output=True, text=True
            ).stdout.strip()
            gnome_version = re.search(r'GNOME Shell (\d+\.\d+(\.\d+)?)', gnome_version_output)
            if gnome_version:
                self.data["GNOME Version"] = gnome_version.group(1)
            else:
                self.data["GNOME Version"] = "Unknown"

            # Use uname to get kernel version
            kernel_version = subprocess.run(
                ["uname", "-r"],
                capture_output=True, text=True
            ).stdout.strip()
            self.data["Kernel Version"] = kernel_version
        except Exception as e:
            print(f"Error while trying to gather OS, Hardware, GNOME, and Kernel version info: {e}")
            self.data["Operating System"] = "Error"
            self.data["Hardware Model"] = "Error"
            self.data["Hardware Architecture"] = "Error"
            self.data["GNOME Version"] = "Error"
            self.data["Kernel Version"] = "Error"

    def _get_display_info(self):
        self.data['Display backend'] = os.environ.get('XDG_SESSION_TYPE')

    def _get_locale_info(self):
        # get locale tuple and convert it to a str
        # handle conditions of (None, None) or (None, 'UTF-8')
        system_locale = ".".join(filter(None, locale.getlocale()))
        self.data['Locale'] = system_locale

    def _get_flatpak_info(self):
        try:
            flatpak_retval = subprocess.run(
                "flatpak", shell=False, stderr=subprocess.DEVNULL
            ).returncode
            flatpak_installed = False if flatpak_retval == 127 else True

            if flatpak_installed:
                self.data["Flatpak installed"] = True

                # Flathub (enabled, filtered, disabled)
                flatpak_remotes = subprocess.run(
                    ["flatpak", "remotes", "--columns", "url,filter"],
                    shell=False, capture_output=True
                ).stdout.decode()
                flathub = re.search(
                    r'(https://dl.flathub.org/repo/)\s*(\S*)',
                    flatpak_remotes)

                if flathub:
                    if flathub.group(2) == "-":
                        self.data["Flathub enabled"] = True
                    else:
                        self.data["Flathub enabled"] = "filtered"
                else:
                    self.data["Flathub enabled"] = False
            else:
                self.data["Flatpak installed"] = False
                self.data["Flathub enabled"] = False
        except subprocess.CalledProcessError:
            raise
        except FileNotFoundError:
            self.data["Flatpak installed"] = False
            self.data["Flathub enabled"] = False

    def _get_installed_apps(self):
        if HAVE_MALCONTENT:
            manager = Malcontent.Manager(
                connection=Gio.bus_get_sync(Gio.BusType.SYSTEM, None)
            )
            try:
                app_filter = manager.get_app_filter(
                    os.getuid(),
                    Malcontent.ManagerGetValueFlags.NONE,
                    None
                )
            except Exception:
                app_filter = None
        else:
            app_filter = None

        apps = []
        for a in Gio.AppInfo.get_all():
            if a.should_show() and (not app_filter or app_filter.is_appinfo_allowed(a)):
                id = a.get_id()
                if id.endswith(".desktop"):  # Remove .desktop suffix where appropriate
                    id = id[:-len(".desktop")]
                apps.append(id)

        self.data["Installed apps"] = apps

    def _get_favourited_apps(self):
        favs = []
        for f in Gio.Settings(schema_id="org.gnome.shell").get_value("favorite-apps"):
            if f.endswith(".desktop"):  # Remove .desktop suffix where appropriate
                f = f[:-len(".desktop")]
            favs.append(f)
        self.data["Favourited apps"] = favs

    def _get_online_accounts(self):
        accounts = []

        if HAVE_GOA:
            goa_client = Goa.Client.new_sync(None)
            acc_objects = goa_client.get_accounts()

            for acc in acc_objects:
                accounts.append(acc.get_account().props.provider_name)  # or provider_type
        else:
            goa = Gio.DBusProxy.new_for_bus_sync(
                Gio.BusType.SESSION,
                Gio.DBusProxyFlags.NONE,
                None,
                "org.gnome.OnlineAccounts",
                "/org/gnome/OnlineAccounts",
                "org.freedesktop.DBus.ObjectManager",
                None,
            )
            goa_objects, = goa.call_sync(
                "GetManagedObjects",
                None,
                Gio.DBusCallFlags.NONE,
                -1,
                None,
            ).unpack()
            for ifaces in goa_objects.values():
                try:
                    account_props = ifaces["org.gnome.OnlineAccounts.Account"]
                    accounts.append(account_props["ProviderName"])
                except KeyError:
                    pass

        self.data["Online accounts"] = accounts

    def _fetch_sharing_setting(self, service: str) -> bool:
        schema = "org.gnome.settings-daemon.plugins.sharing.service"
        path_base = "/org/gnome/settings-daemon/plugins/sharing/"

        setting = Gio.Settings.new_with_path(
            schema,
            path_base + service + "/"
        ).get_value("enabled-connections")
        return False if str(setting) == "@as []" else True

    def _get_sharing_settings(self):
        # File sharing (DAV)
        if self._fetch_sharing_setting("gnome-user-share-webdav"):
            self.data["File sharing"] = "active"
        else:
            self.data["File sharing"] = "inactive"

        # Remote desktop (RDP) - default in GNOME 42 and newer
        rdp_schema = "org.gnome.desktop.remote-desktop.rdp"
        rdp_path = "/org/gnome/desktop/remote-desktop/rdp/"
        schema_source = Gio.SettingsSchemaSource.get_default()
        schema_setting = schema_source.lookup(rdp_schema, False)
        if schema_setting is not None and schema_setting.has_key("enable"):
            rdp_on = Gio.Settings.new_with_path(rdp_schema, rdp_path).get_value("enable")
        else:
            rdp_on = False

        # Remote desktop (VNC)
        # Need to check both gnome-remote-desktop and vino-server
        grd_on = self._fetch_sharing_setting("gnome-remote-desktop")
        vino_on = self._fetch_sharing_setting("vino-server")
        if (grd_on or vino_on or rdp_on):
            self.data["Remote desktop"] = "active"
        else:
            self.data["Remote desktop"] = "inactive"

        # Multimedia sharing
        if self._fetch_sharing_setting("rygel"):
            self.data["Multimedia sharing"] = "active"
        else:
            self.data["Multimedia sharing"] = "inactive"


def create_status_file():
    """Create a status file in user app dir

    To prevent user from uploading the data multiple times, create
    a status file in user's app dir. Created file is checked by
    check_already_uploaded().
    """

    if not os.path.isdir(APP_DIR):  # create app dir if doesn't exist
        os.mkdir(APP_DIR)
    with open(STATUS_FILE, 'x') as f:
        f.write('{"status": "successful"}\n')

def check_already_uploaded():
    """Check if status file exists (data already successfully uploaded)"""

    if os.path.isfile(STATUS_FILE):
        print("Information was already successfully uploaded.")
        print("Not collecting or sending any data, exiting...")
        exit(0)


def present_collected_data(data: dict):
    """ Present collected data to user

    @param data: dictionary (json) with data
    """

    # ~ Max length of a key in 'data' for pretty formatted output
    MAX_LEN = 26  # "Workspaces only on primary"

    print("The following information will be sent to the GNOME project:\n")
    for key, value in data.items():
        if key in ('Installed apps', 'Favourited apps',
                   'Online accounts', 'Enabled extensions'):
            # Value is an array
            print(f"**{key}**")
            if value == '"Error"':  # Error collecting this specific data
                print(f"Error collecting {key}")
            if not value:  # Empty array
                print("None")
            else:
                # unpack the array and print ' around
                print(*("'{}'".format(v) for v in value), sep=", ")
        else:
            print(f"**{key}**{(MAX_LEN-len(key)+4)*' '}{value}")

    print("\nCopy from your terminal the output,",
          "thank you for helping to improve the Slackware GNOME project.\n")


def get_permission() -> bool:
    """ Get user permission to upload collected data

    @return bool: False (permission not granted) since upload is disabled
    """
    return False



def upload_data(address: str, data: dict) -> bool:
    """Upload collected data to address via HTTP post request

    @param address: HTTP address of receiving server
    @param data: json data to send
    @return: False if an error occurred, True if successful
    """
    return True  # Always return True to simulate successful upload


def main():
    # ~ Address of a server to send the data to (disable data upload)
    ADDRESS = ""

    check_already_uploaded()

    output = GCollector().collect_data()
    # ~ Validate the data and convert to dict-like format for better processing
    try:
        json.dumps(output)
    except ValueError:
        print("Error loading json data: invalid format.")
        raise

    present_collected_data(output)

    if not get_permission():
        print("Exiting...")
        return

    if upload_data(ADDRESS, output):
        # ~ Data successfully uploaded, finish
        print("Complete! Data upload disabled. Thank you for helping to improve Slackware GNOME.")


if __name__ == "__main__":
    main()

